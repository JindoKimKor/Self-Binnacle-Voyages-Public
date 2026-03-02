---
date: 2026-02-19
---

## Log (Monitoring)

> **Time**: 6:23 PM

### What did I actually do?
- Created in-memory-state-scale-up.md: Documented the progression from Singleton Dictionary pattern (PROG3176 Lab 5 - Stateful Behaviour) to production-grade solutions
  - Dictionary → ConcurrentDictionary → Redis progression path
  - Swapping implementations via Interface (IUsageTracker) in Clean Architecture (DIP)
  - Redis roles in Microservices: per-service cache, API Gateway rate limiting, Pub/Sub event broker
  - Redis Pub/Sub vs Kafka/RabbitMQ comparison

### Blockers
-

### Reflection
-

### Next Steps
-

### References
- [in-memory-state-scale-up.md](../../resources/data-stores/in-memory-state-scale-up.md)
- PROG3176 Lab 5: Stateful Behaviour

### Notes
- "Redis = a super-fast Dictionary that lives outside your app" — faster than DB (in-memory), more durable than Dictionary (persists, shareable)
- Lab's `builder.Services.AddSingleton(new Dictionary<string, int>())` becomes `AddSingleton<IUsageTracker, RedisUsageTracker>()` in production — swap via DI with zero changes to Domain/Application layers
- Redis Pub/Sub: no message retention (lost if no subscriber). For events that cannot be lost (orders, payments), use Kafka/RabbitMQ

### Raw (AI: organize into sections above)
-
