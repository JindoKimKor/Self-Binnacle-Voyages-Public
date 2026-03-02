# Removing Sensitive Files from Git History with BFG

## Overview

Sensitive files committed to Git (e.g., resumes, passwords, API keys) remain in history even after adding them to `.gitignore`. BFG Repo-Cleaner lets you safely remove specific files from the entire git history.

## Why .gitignore Alone Is Not Enough

```
What .gitignore does:
- Ignores the file in future commits
- Has no effect on already-committed files

The problem:
- The file still exists in git history
- Anyone can check out a past commit and access the file
- In public repos, it can be found via GitHub search
```

---

## BFG vs git filter-branch

| Characteristic | BFG | git filter-branch |
|----------------|-----|-------------------|
| Speed | 10–720x faster | Slow (processes one commit at a time) |
| Ease of use | Simple commands | Complex syntax |
| Installation | Java + JAR file | Built into Git |
| HEAD protection | Protected by default | None |
| Maintenance status | Active | Deprecated (git filter-repo recommended) |

---

## Execution Process (Step-by-Step)

### Step 1: Create a Backup

```bash
# PowerShell (Windows)
Copy-Item -Path 'repo-folder' -Destination 'repo-folder-backup' -Recurse

# Or back up only history with git bundle
git bundle create "../repo-backup.bundle" --all
```

**Purpose**: Enables full recovery if something goes wrong

---

### Step 2: Download the BFG JAR

```bash
curl -L -o bfg.jar https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
```

**Requirement**: Java Runtime (OpenJDK recommended)

---

### Step 3: Run BFG

```bash
# Run from outside the repo folder
java -jar bfg.jar --delete-files "{file1.pdf,file2.pdf}" repo-folder
```

**What BFG does:**

```
1. Analyze the .git folder
   └─ Scan the tree structure of all commits

2. Identify files to delete
   └─ Determine which commits contain the specified files

3. Rewrite each commit (the key step!)
   ┌─────────────────────────────────────────────┐
   │ Before: commit abc123                       │
   │   ├─ file1.md                               │
   │   ├─ file2.md                               │
   │   └─ secret.pdf  ← to be deleted           │
   │                                             │
   │ After: commit def456 (new hash)             │
   │   ├─ file1.md                               │
   │   └─ file2.md    ← secret.pdf is gone      │
   └─────────────────────────────────────────────┘

4. Update references (refs)
   refs/heads/main: old_hash → new_hash
```

**Important**: When commit content changes, its hash changes too (a fundamental Git principle)

---

### Step 4: Git Cleanup

```bash
cd repo-folder
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**What each command does:**

```
┌─ reflog expire ─────────────────────────────────┐
│ Git keeps deleted objects as a safety net       │
│ (reflog = reference log, kept for 90 days by   │
│  default)                                       │
│                                                 │
│ --expire=now: Expire all records immediately    │
│ --all: Apply to all branches                    │
└─────────────────────────────────────────────────┘

┌─ gc (garbage collection) ───────────────────────┐
│ Delete git objects no longer referenced         │
│                                                 │
│ --prune=now: Clean up immediately (default is   │
│              2 weeks later)                     │
│ --aggressive: Compress and clean thoroughly     │
│                                                 │
│ Result: Old file blobs are physically deleted   │
│         from .git                               │
└─────────────────────────────────────────────────┘
```

---

### Step 5: Remove the File from HEAD (if needed)

BFG protects HEAD (the current state) by default. If the file still exists in the current commit:

```bash
# Remove the file from git tracking (keep it on disk)
git rm --cached "path/to/sensitive-file.pdf"

# Commit
git commit -m "chore: Remove sensitive files from tracking"
```

---

### Step 6: Force Push

```bash
git push --force
```

**What happens:**

```
Local:  main → new_hash (new history)
Remote: main → old_hash (old history)

Normal push: "rejected - non-fast-forward" (histories differ)
Force push: Overwrites remote history with local
```

**Warning**: If others have cloned or forked the repo, their repos are also affected

---

## Verification

```bash
# Confirm the file has been removed from history
git log --all --full-history -- "path/to/file.pdf"

# Attempt to access the file from a specific commit
git show old_commit_hash:path/to/file.pdf
# → "path does not exist" error = success
```

---

## Rollback (if something goes wrong)

```bash
# Restore from backup
rm -rf repo-folder
mv repo-folder-backup repo-folder
cd repo-folder
git push --force
```

---

## Key Concepts Summary

| Concept | Description |
|---------|-------------|
| **Git Object** | File content (blob), directory (tree), commit (commit) |
| **Commit Hash** | SHA-1 hash of content — changes when content changes |
| **Reflog** | Git's "undo" log (kept for 90 days by default) |
| **Force Push** | Forcibly overwrites remote history with local |
| **HEAD Protection** | BFG's safeguard that leaves the current state untouched |

---

## Final State Comparison

```
┌─ Before ────────────────────────────────────────┐
│ commit 1: Add resume.pdf      ← PDF present    │
│ commit 2: Update resume.pdf   ← PDF present    │
│ commit 3: Add transcript.pdf  ← PDF present    │
│ ...                                             │
│ HEAD: includes all PDF files                   │
└─────────────────────────────────────────────────┘

┌─ After ─────────────────────────────────────────┐
│ commit 1': Add resume.pdf     ← no PDF!        │
│ commit 2': Update resume.pdf  ← no PDF!        │
│ commit 3': Add transcript.pdf ← no PDF!        │
│ ...                                             │
│ HEAD: PDFs untracked (still exist on disk)     │
│                                                 │
│ ※ Commit messages preserved, only files removed│
└─────────────────────────────────────────────────┘
```

---

## References

- [BFG Repo-Cleaner Official Site](https://rtyley.github.io/bfg-repo-cleaner/)
- [Git - git-filter-branch Documentation](https://git-scm.com/docs/git-filter-branch)
- [GitHub - Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
