#!/usr/bin/env bash
# Usage: bash run.sh <step-name> <command...>
# Example: bash run.sh step2-identity az functionapp identity assign --name unity-ci-func ...
# Saves output to logbook/2026-03-09/resources/<step-name>.log

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STEP_NAME="$1"
shift

if [ -z "$STEP_NAME" ]; then
  echo "Usage: bash run.sh <step-name> <command...>"
  exit 1
fi

LOG_FILE="$SCRIPT_DIR/${STEP_NAME}.log"

echo "=== Command ===" | tee "$LOG_FILE"
echo "$@" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "=== Output ===" | tee -a "$LOG_FILE"
"$@" 2>&1 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "=== Saved to ${STEP_NAME}.log ==="
