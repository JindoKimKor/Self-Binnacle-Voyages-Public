# Domain-Oriented Design: Terminology Research

This document provides authoritative sources validating "Domain-Oriented" as an established software architecture terminology.

---

## Executive Summary

| Term | Definition | Source |
|------|------------|--------|
| **Domain-Oriented Design (DOD)** | DDD-inspired approach at system level without code-level constructs | van Ingen, Medium |
| **Domain-Oriented Microservice Architecture (DOMA)** | Collections of microservices organized by domains with layer-based dependencies | Uber Engineering |
| **Domain-Centric Architecture** | Architecture where domain is the center, dependencies inverted | Laso, Medium |

**Conclusion**: "Domain-Oriented" is a recognized, industry-adopted term distinct from "Domain-Driven Design."

---

## Source 1: Uber Engineering (DOMA)

### Citation

> Gluck, Adam. "Introducing Domain-Oriented Microservice Architecture." *Uber Engineering Blog*, July 23, 2020. https://www.uber.com/blog/microservice-architecture/

### Key Definitions

**Domain-Oriented Microservice Architecture (DOMA)** is Uber's generalized approach to managing ~2,200 microservices. Core concepts:

| Concept | Definition |
|---------|------------|
| **Domains** | Collections of related microservices grouped by logical functionality |
| **Layers** | Five-tier dependency hierarchy (Infrastructure → Business → Product → Presentation → Edge) |
| **Gateways** | Single entry points abstracting underlying domain services |

### Distinction from DDD

> "DOMA synthesizes established patterns—Domain-Driven Design, Clean Architecture, Service-Oriented Architecture—applied to distributed systems."

DOMA is **inspired by DDD** but applies domain concepts to **scaling challenges** at large organizations, incorporating **layer-based dependency management** absent from classical DDD.

### Relevance to Jenkins Architecture

| DOMA Concept | Jenkins Architecture Equivalent |
|--------------|--------------------------------|
| Domains | Unity/JavaScript/Deployment subdomains |
| Layers | 4-Layer (Entry → Orchestration → Service → Utility) |
| Gateways | Stage functions as entry points to services |

---

## Source 2: Domain-Oriented Design (DOD)

### Citation

> van Ingen, Kevin. "Domain-driven design (DDD) or just domain-oriented design (DOD)?" *Medium (CodeX)*, 2023. https://medium.com/codex/domain-driven-design-ddd-or-just-domain-oriented-design-dod-9098abecd456

### Key Definition

> "Domain-Oriented Design is a **minimalist approach** taking Domain-Driven implementation philosophy **without the code-level constructs**."

> "An approach that is DDD inspired on the **system level** (services, communication, and bounded context), without drawing people into code-level DDD thinking like aggregates."

### DOD vs DDD Comparison

| Aspect | Domain-Driven (DDD) | Domain-Oriented (DOD) |
|--------|---------------------|----------------------|
| **Scope** | Full methodology (strategic + tactical) | System/architecture level only |
| **Code Constructs** | Aggregates, Entities, Value Objects, Domain Events | Not required |
| **Learning Curve** | Steep | More accessible |
| **Applicability** | Complex business domains | Broader, including scripting/DevOps |

### DOD Advantages

> - "Easier for engineering teams to understand (DDD can be hard to learn)"
> - "Still retains DDD's architecture organization/architecture qualities"
> - "Easier to get accepted into your engineering community"

### DOD Disadvantages

> - "Missing code-level DDD constructs that codify business rules in an elegant way"
> - "Missing out on code-level constructs could potentially codify the domain language worse"

### Relevance to Jenkins Architecture

The Jenkins architecture implements **DOD characteristics**:

| DOD Principle | Jenkins Architecture Evidence |
|---------------|------------------------------|
| System-level domain organization | Unity/JavaScript subdomains |
| Bounded contexts | Git/Shell/SSH libraries |
| No Aggregates/Entities | Uses Maps and closures |
| No Value Objects | Uses primitive data structures |

---

## Source 3: Domain-Centric Architecture

### Citation

> Laso, Javiera. "What is domain-centric architecture?" *Medium*, 2023. https://javujavichi.medium.com/what-is-domain-centric-architecture-e030e609c401

### Key Insight

> "In the domain-centric architecture, the **dependencies are inverted** and the **domain is the center** of everything, for which the entities, use cases or business rules do not depend on technology or external agents."

This contrasts with traditional layered architecture where dependencies flow from presentation to persistence.

---

## Source 4: Enterprise Architecture Perspective

### Citation

> Contraste Europe. "Domain Oriented Architecture: Unleashing the power of co-creation in modern enterprise architecture." 2024. https://www.contraste.com/en/blog/domain-oriented-architecture-unleashing-power-co-creation-modern-enterprise-architecture

### Key Definition

> "The 'Domain Oriented Architecture' approach emphasises a **deep understanding of the different business domains** as a basis for guiding architecture choices."

---

## Terminology Comparison Matrix

| Term | Includes Tactical DDD? | Industry Adoption | Appropriate For |
|------|----------------------|-------------------|-----------------|
| Domain-Driven Design (DDD) | ✓ Yes (Aggregates, Entities, etc.) | High | Complex business applications |
| Domain-Oriented Design (DOD) | ✗ No | Growing | Microservices, DevOps |
| Domain-Oriented Microservice Architecture (DOMA) | ✗ No | Uber, adopted by others | Large-scale microservices |
| Domain-Centric Architecture | Varies | Moderate | Clean Architecture contexts |

---

## Recommendation for Portfolio/Resume

### Before (Potentially Inaccurate)

> "Designed domain-driven 4-layer architecture..."

### After (Accurate)

> "Designed domain-oriented 4-layer architecture..."

### Interview Talking Point

> "I implemented a Domain-Oriented architecture—applying DDD principles at the system level with bounded contexts (Git, Shell, SSH libraries) and subdomain separation (Unity, JavaScript), without the tactical patterns like Aggregates which weren't applicable to the Jenkins/Groovy scripting environment. This approach aligns with Uber's DOMA philosophy of organizing services around business domains while maintaining practical simplicity."

---

## References

1. Gluck, Adam. "Introducing Domain-Oriented Microservice Architecture." Uber Engineering Blog, July 23, 2020. https://www.uber.com/blog/microservice-architecture/

2. van Ingen, Kevin. "Domain-driven design (DDD) or just domain-oriented design (DOD)?" Medium (CodeX), 2023. https://medium.com/codex/domain-driven-design-ddd-or-just-domain-oriented-design-dod-9098abecd456

3. Laso, Javiera. "What is domain-centric architecture?" Medium, 2023. https://javujavichi.medium.com/what-is-domain-centric-architecture-e030e609c401

4. Contraste Europe. "Domain Oriented Architecture." 2024. https://www.contraste.com/en/blog/domain-oriented-architecture-unleashing-power-co-creation-modern-enterprise-architecture

5. GeeksforGeeks. "Domain-Oriented Microservice Architecture." https://www.geeksforgeeks.org/system-design/domain-oriented-microservice-architecture/
