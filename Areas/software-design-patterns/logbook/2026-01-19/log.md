---
date: 2026-01-19
---

## Log (Monitoring)

### What did I actually do?
- Reviewed Polymorphism concepts in depth
- Created decision tree for choosing Interface vs Abstract Class vs Virtual/Override
- Created comparison table for OOP polymorphism implementations

### Blockers
- None

### Reflection
- Contract (behavior) vs Relationship (is-a) distinction is the key decision criteria for polymorphism
- "When to use" perspective is more practical than just knowing definitions

### Next Steps
- Apply this decision framework in actual coding practice
- Explore more design patterns that leverage polymorphism (Strategy, Template Method, etc.)

### References
- PROG3176 Distributed Applications Development course materials

### Notes
**Polymorphism**
- Concept: One type can behave in multiple forms
- Implementation: Interface, Abstract Class, Virtual/Override

```
Q1. Found a specific part of business logic where multiple things can be grouped as one?
└── Yes → Q2. How to group them?
    ├── By Contract (behavior) → Interface
    └── By Relationship (is-a) → Q3. Should subclasses be able to modify shared code?
        ├── No → Abstract Class
        └── Yes → Virtual/Override
```

**Comparison Table**
| Question | Interface | Abstract Class | Virtual/Override |
|----------|-----------|----------------|------------------|
| Only implementation-free Contract exists? | O | △* or X | X |
| Grouped under a common concept? | O | O | O |
| Shared implementation (common logic code) exists? | X | O or X* | O |
| Subclasses can extend implementation? (add methods) | - | O | O |
| Subclasses can modify implementation? (change shared code) | - | X | O |
| Can have Interface inside the parent class? | - | O | X |

> *Abstract Class marked as △ because without considering subclasses, it can have implementation-free Contract only<br>
> *Abstract Class can have subclasses with completely different implementations

- Abstract Class can have additional Interface externally → Can separate implementation and Contract<br>
- Virtual/Override can have Interface above externally → Can separate implementation and Contract

> Contract = "To do ~, give X and get Y back"
>
> Purpose (business logic): To do ~<br>
> Input: give X<br>
> Output: get Y back
>
> Example: "To process payment, give amount and get payment result back"

### Raw (AI: organize into sections above)
-
