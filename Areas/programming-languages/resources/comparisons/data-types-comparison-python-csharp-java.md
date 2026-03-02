# Data Types Comparison: Python vs C# vs Java

## 1. Text

| Data Structure | Python | C# | Java |
|----------------|--------|-----|------|
| String | `str` | `string` / `String` | `String` |
| Character | `str` (length 1) | `char` | `char` |

### Explanation

**C# `string` vs `String`:**
- `string` is an alias for `System.String` (keyword)
- Functionally identical, style difference only
- Convention: `string` for variable declaration, `String.Format()` for static methods

**Immutability:**
- Strings are immutable in all three languages
- Modification creates a new object

**Python specifics:**
- No `char` type, uses `str` with length 1
- Single/double quotes both create strings

### Why Different?

> **Q: Why doesn't Python have a `char` type?**
> - Python philosophy: "There should be one obvious way to do it"
> - Simplicity over micro-optimization
> - *TODO: Research Python's design decision on character handling*

---

## 2. Numeric - Integer

| Size | Signed/Unsigned | Python | C# | Java |
|------|-----------------|--------|-----|------|
| 8-bit | Signed | `int` | `sbyte` | `byte` |
| 8-bit | Unsigned | `int` | `byte` | None |
| 16-bit | Signed | `int` | `short` | `short` |
| 16-bit | Unsigned | `int` | `ushort` | None (`char` as workaround) |
| 32-bit | Signed | `int` | `int` | `int` |
| 32-bit | Unsigned | `int` | `uint` | None |
| 64-bit | Signed | `int` | `long` | `long` |
| 64-bit | Unsigned | `int` | `ulong` | None |
| Arbitrary | - | `int` | `BigInteger` | `BigInteger` |

### Explanation

**Python `int`:**
- No size limit (arbitrary precision)
- Can handle infinitely large integers (memory permitting)
- Internally adjusts size as needed

**C# Integer Types:**
- `int` is alias for `System.Int32`
- `long` is alias for `System.Int64`
- Full unsigned type support

**Java specifics:**
- No unsigned types (unsigned operations added in Java 8+)
- `byte` is signed (-128 to 127)
- `char` is 16-bit unsigned but intended for characters

**Wrapper Classes (Boxing):**

| Primitive | C# Wrapper | Java Wrapper |
|-----------|------------|--------------|
| `int` | `Int32` (same) | `Integer` |
| `long` | `Int64` (same) | `Long` |
| `short` | `Int16` (same) | `Short` |
| `byte` | `Byte` (same) | `Byte` |

### Why Different?

> **Q: Why doesn't Java have unsigned types?**
> - James Gosling's design decision for simplicity
> - Reduce programmer errors from unsigned/signed confusion
> - *TODO: Research the Oak/Java design rationale*

> **Q: Why does Python have arbitrary precision `int` by default?**
> - "Batteries included" philosophy
> - No overflow errors for beginners
> - Trade-off: Performance vs. Safety
> - *TODO: How does CPython implement arbitrary precision internally?*

> **Q: Why is Java's `byte` signed while C#'s `byte` is unsigned?**
> - *TODO: Research historical context*

---

## 3. Numeric - Floating Point

| Precision | Python | C# | Java |
|-----------|--------|-----|------|
| 32-bit (Single) | None | `float` | `float` |
| 64-bit (Double) | `float` | `double` | `double` |
| High Precision | `decimal.Decimal` | `decimal` (128-bit) | `BigDecimal` |
| Complex | `complex` | `System.Numerics.Complex` | None (library) |

### Explanation

**Python `float`:**
- Actually 64-bit double precision (C's `double`)
- No 32-bit float

**C# `decimal`:**
- 128-bit, 28-29 significant digits
- For financial calculations (exact decimal)
- Slower but more accurate than `float`/`double`

**Java `BigDecimal`:**
- Arbitrary precision
- Financial calculation standard
- Object, so no operator overloading (use methods)

**Literal notation:**

| Type | C# | Java |
|------|-----|------|
| float | `3.14f` | `3.14f` |
| double | `3.14` or `3.14d` | `3.14` or `3.14d` |
| decimal | `3.14m` | N/A |

### Why Different?

> **Q: Why doesn't Python have a 32-bit float?**
> - Simplicity: one floating-point type covers most use cases
> - Memory optimization is less critical in Python's use cases
> - *TODO: NumPy provides float32 - why is it needed there?*

> **Q: Why does C# have `decimal` as a built-in type while Java uses `BigDecimal` class?**
> - C# designed later, learned from Java's pain points
> - Operator overloading in C# makes `decimal` more ergonomic
> - *TODO: Compare performance characteristics*

---

## 4. Boolean

| Data Structure | Python | C# | Java |
|----------------|--------|-----|------|
| Boolean | `bool` | `bool` | `boolean` |

### Explanation

**Values:**
- Python: `True`, `False` (capitalized)
- C#/Java: `true`, `false` (lowercase)

**Truthy/Falsy (Python only):**
- `0`, `""`, `[]`, `{}`, `None` → `False`
- Everything else → `True`
- C#/Java require explicit boolean in conditionals

**Size:**
- C#: 1 byte
- Java: JVM dependent (usually 1 byte)
- Python: object (larger)

### Why Different?

> **Q: Why does Python have truthy/falsy while C#/Java don't?**
> - Python's duck typing philosophy
> - C/C++ legacy influence on Python
> - C#/Java prioritize type safety over convenience
> - *TODO: What problems does explicit boolean prevent?*

> **Q: Why is Python's boolean capitalized (`True`/`False`)?**
> - *TODO: PEP or historical reason?*

---

## 5. Sequence - Array/List

| Characteristic | Python | C# | Java |
|----------------|--------|-----|------|
| Fixed-size Array | `array.array` | `T[]` | `T[]` |
| Dynamic Array | `list` | `List<T>` | `ArrayList<T>` |
| Immutable Sequence | `tuple` | `ValueTuple` / `Tuple<>` | None (Record, List.of()) |
| Linked List | `collections.deque` | `LinkedList<T>` | `LinkedList<T>` |

### Explanation

**Python `list`:**
- Heterogeneous (mixed types allowed)
- Dynamic sizing
- `[]` literal

**C# `List<T>` vs `T[]`:**
- `T[]`: fixed size, stack/heap
- `List<T>`: dynamic size, internally uses array
- Both homogeneous

**Java `ArrayList<T>` vs `T[]`:**
- Primitive array: `int[]` (fast)
- Generic: `ArrayList<Integer>` (requires boxing)

**Tuple comparison:**

| Feature | Python `tuple` | C# `ValueTuple` | C# `Tuple<>` |
|---------|----------------|-----------------|--------------|
| Mutable | No | No | No |
| Named elements | No (index only) | Yes | No |
| Value/Reference | Value | Value | Reference |
| Syntax | `(1, 2, 3)` | `(1, 2, 3)` | `Tuple.Create(1,2,3)` |

### Why Different?

> **Q: Why can Python lists hold mixed types while C#/Java require homogeneous types?**
> - Static vs Dynamic typing
> - Performance: homogeneous allows memory optimization
> - *TODO: How does Python's list store different types internally?*

> **Q: Why doesn't Java have built-in tuple support like Python/C#?**
> - Historical omission
> - Records (Java 14+) partially address this
> - *TODO: Why was tuple not prioritized in early Java?*

---

## 6. Sequence - Range/Iterator

| Data Structure | Python | C# | Java |
|----------------|--------|-----|------|
| Range | `range` | `Enumerable.Range()` | `IntStream.range()` |
| Iterator | `iter()` | `IEnumerator<T>` | `Iterator<T>` |
| Generator | `yield` | `yield return` | None (Stream as alternative) |

### Explanation

**Python `range`:**
- Lazy evaluation (memory efficient)
- `range(start, stop, step)`
- Immutable sequence

**C# `Enumerable.Range()`:**
- `Enumerable.Range(0, 10)` → 0~9
- Used with LINQ
- Returns `IEnumerable<int>`

**Java `IntStream.range()`:**
- `IntStream.range(0, 10)` → 0~9
- `IntStream.rangeClosed(0, 10)` → 0~10
- Part of Stream API

### Why Different?

> **Q: Why doesn't Java have generators (`yield`)?**
> - JVM bytecode limitations at the time
> - Stream API provides similar lazy evaluation
> - *TODO: Project Loom impact on this?*

---

## 7. Mapping

| Characteristic | Python | C# | Java |
|----------------|--------|-----|------|
| Hash Map | `dict` | `Dictionary<K,V>` | `HashMap<K,V>` |
| Ordered Map | `dict` (3.7+) | `OrderedDictionary` | `LinkedHashMap<K,V>` |
| Sorted Map | None (SortedContainers) | `SortedDictionary<K,V>` | `TreeMap<K,V>` |
| Concurrent Map | None (threading) | `ConcurrentDictionary<K,V>` | `ConcurrentHashMap<K,V>` |
| Immutable Map | `types.MappingProxyType` | `ImmutableDictionary<K,V>` | `Map.of()` (Java 9+) |

### Explanation

**Python `dict`:**
- Insertion order guaranteed since Python 3.7+
- `{}` literal
- Any hashable type can be a key

**C# `Dictionary<K,V>`:**
- Not alias for `System.Collections.Generic.Dictionary` (direct use)
- Order not guaranteed (may be preserved internally but not contractual)

**Java Map Interface:**
- `Map<K,V>` is an interface
- Choose implementation: `HashMap`, `TreeMap`, `LinkedHashMap`, etc.

### Why Different?

> **Q: Why did Python 3.7 make `dict` ordered by default?**
> - Implementation optimization (compact dict) happened to preserve order
> - CPython made it official in 3.7
> - *TODO: What was the compact dict optimization?*

> **Q: Why does Java separate Map interface from implementations while Python just has `dict`?**
> - Java's interface-based design philosophy
> - Dependency inversion principle
> - *TODO: Trade-offs of each approach?*

---

## 8. Set

| Characteristic | Python | C# | Java |
|----------------|--------|-----|------|
| Mutable Set | `set` | `HashSet<T>` | `HashSet<T>` |
| Immutable Set | `frozenset` | `ImmutableHashSet<T>` | `Set.of()` (Java 9+) |
| Sorted Set | None (SortedContainers) | `SortedSet<T>` | `TreeSet<T>` |

### Explanation

**Python `set` vs `frozenset`:**
- `set`: mutable, unhashable (can't be dict key)
- `frozenset`: immutable, hashable (can be dict key)

**C# `HashSet<T>`:**
- `Add()`, `Remove()`, `Contains()`
- Set operations: `UnionWith()`, `IntersectWith()`, `ExceptWith()`

**Java `HashSet<T>`:**
- Implements `Set` interface
- `add()`, `remove()`, `contains()`

### Why Different?

> **Q: Why does Python have `frozenset` as a separate type?**
> - Hashability requires immutability
> - Need immutable set to use as dict key or set element
> - *TODO: Why didn't C#/Java follow this pattern?*

---

## 9. Binary

| Data Structure | Python | C# | Java |
|----------------|--------|-----|------|
| Immutable Bytes | `bytes` | `ReadOnlySpan<byte>` | `byte[]` (not immutable) |
| Mutable Bytes | `bytearray` | `byte[]` | `byte[]` |
| Memory View | `memoryview` | `Span<T>` / `Memory<T>` | `ByteBuffer` |

### Explanation

**Python `bytes` vs `bytearray`:**
- `bytes`: immutable, `b"hello"` literal
- `bytearray`: mutable, `bytearray(b"hello")`

**C# `Span<T>` vs `Memory<T>`:**
- `Span<T>`: stack-only, faster
- `Memory<T>`: heap allowed, usable in async

**Java `ByteBuffer`:**
- Part of NIO
- Direct/Indirect buffer
- `allocate()`, `wrap()`, `flip()`, `clear()`

### Why Different?

> **Q: Why did C# introduce `Span<T>` and `Memory<T>`?**
> - High-performance scenarios without allocation
> - Game development, server performance
> - *TODO: Compare with Java's ByteBuffer performance*

---

## 10. Null/None

| Data Structure | Python | C# | Java |
|----------------|--------|-----|------|
| Null Value | `None` | `null` | `null` |
| Null Type | `NoneType` | Nullable reference | - |
| Nullable Value Type | N/A | `Nullable<T>` / `T?` | `Optional<T>` |

### Explanation

**Python `None`:**
- Singleton object
- Only instance of `NoneType`
- Check with `is None` (not ==)

**C# Nullable:**
- Value type: `int?` = `Nullable<int>`
- Reference type: C# 8.0+ nullable reference types
- `?.` (null-conditional), `??` (null-coalescing)

**Java `Optional<T>`:**
- Java 8+
- `Optional.of()`, `Optional.empty()`, `Optional.ofNullable()`
- Primitives: `OptionalInt`, `OptionalLong`, `OptionalDouble`

### Why Different?

> **Q: Why does Java use `Optional<T>` while C# uses `T?`?**
> - C# has value types, Java doesn't (primitives are special)
> - C# can make value types nullable with `Nullable<T>`
> - Java's `Optional` is a wrapper object
> - *TODO: Performance implications of each approach?*

> **Q: Why is Python's `None` a singleton?**
> - Memory efficiency
> - `is` comparison is faster than `==`
> - *TODO: How is singleton pattern implemented in CPython?*

---

## Quick Reference: Type Aliases

### C# Type Aliases

| Alias | .NET Type |
|-------|-----------|
| `bool` | `System.Boolean` |
| `byte` | `System.Byte` |
| `sbyte` | `System.SByte` |
| `short` | `System.Int16` |
| `int` | `System.Int32` |
| `long` | `System.Int64` |
| `float` | `System.Single` |
| `double` | `System.Double` |
| `decimal` | `System.Decimal` |
| `char` | `System.Char` |
| `string` | `System.String` |
| `object` | `System.Object` |

### Java Primitives vs Wrappers

| Primitive | Wrapper |
|-----------|---------|
| `boolean` | `Boolean` |
| `byte` | `Byte` |
| `short` | `Short` |
| `int` | `Integer` |
| `long` | `Long` |
| `float` | `Float` |
| `double` | `Double` |
| `char` | `Character` |
