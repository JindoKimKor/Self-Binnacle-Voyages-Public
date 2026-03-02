---
date: 2026-02-25
---

## Log (Monitoring)

### What did I actually do?
- Unknown: "anemic" — System Fundamentals 퀴즈에서 만남 ("Anemic Domain Model")
- Weak Recognition: "autonomy" — System Fundamentals 퀴즈에서 만남 — 대충 알것 같지만 정확히 기억 안 남
- Unknown: "linguistic" — System Fundamentals DDD 퀴즈에서 만남
- Weak Recognition: "advise against ~ing" — System Fundamentals 퀴즈에서 문장이 안 읽힘
- Unknown: "analogy" — System Fundamentals 퀴즈에서 만남
- Passive → Active: "cascading" — 읽으면 아는데 직접 쓸 때 안 떠오름
- Unknown: "agnostic" — System Fundamentals 퀴즈에서 만남 ("Infrastructure Agnostic")
- Passive → Active: "resilience" — 읽으면 아는데 직접 쓸 때 안 떠오름 ("system resilience")
- Weak Recognition: "business capability" — 개별 단어는 아는데 조합이 눈에 안 들어옴
- Passive → Active: "exemplifies" — 읽으면 아는데 직접 쓸 때 안 떠오름
- Weak Recognition: "underlying" — 대충 알겠는데 바로 떠오르지 않음
- Weak Recognition: "evolve" + "over time to ~" — 문장 구조가 안 읽힘
- Weak Recognition: "abstract away" — System Fundamentals 퀴즈에서 만남 — 개별 단어는 아는데 조합이 어색
- Weak Recognition: "invariants" — System Fundamentals DDD 퀴즈에서 만남 — 분명히 본 적 있는데 기억 안 남
- Passive → Active: "prevent X from ~ing" — 읽으면 아는데 직접 쓸 때 안 떠오름
- Passive → Active: "[statement] where [구체적 상황]" — 읽으면 아는데 직접 쓸 때 안 떠오름
- Weak Recognition: "advocates" — System Fundamentals DDD 해설에서 만남 — 분명히 많이 봤는데 기억 안 남
- Unknown: "fidelity" — System Fundamentals 퀴즈에서 만남 ("high fidelity to production")

### Blockers
-

### Reflection
- **(Unknown) "anemic"**: 빈혈의, 허약한, 활기 없는. anemia(빈혈)→anemic. IT: "Anemic Domain Model" = 데이터만 있고 행동(behavior)이 없는 허약한 모델
- **(Weak Recognition) "autonomy"**: 자율성, 독립성. auto(스스로)+nomy(법/규칙)=스스로 규칙을 정하다. "service autonomy" = 서비스가 독립적으로 운영/배포/변경 가능한 상태
- **(Unknown) "linguistic"**: 언어의, 언어학적인. lingua(라틴어: 혀, 언어)→linguistic. linguistics=언어학. "linguistic boundary"=같은 용어가 같은 의미로 쓰이는 범위
- **(Weak Recognition) "advise against ~ing"**: ~하지 말라고 조언하다. advise to do(하라고) ≠ advise against doing(하지 말라고). 개별 단어는 아는데 조합이 안 읽힘
- **(Unknown) "analogy"**: 비유, 유사점. 하나를 다른 것에 빗대어 설명하는 것. "best analogy for X" = X에 대한 가장 적절한 비유
- **(Passive → Active) "cascading"**: 연쇄적인, 폭포처럼 쏟아지는. cascade(폭포)에서 유래. "cascading changes" = 하나 바뀌면 줄줄이 변경. CSS도 Cascading Style Sheets
- **(Unknown) "agnostic"**: 불가지론의 → IT: 특정 기술에 종속되지 않는. a(없다)+gnostic(아는). "infrastructure agnostic"=특정 인프라에 구애받지 않는. platform/vendor/language agnostic
- **(Passive → Active) "resilience"**: 복원력, 탄력성. re(다시)+silire(뛰다)=다시 튀어오르다. "system resilience"=장애 후 복구 능력. resilient(형용사)
- **(Weak Recognition) "business capability"**: 비즈니스 역량/능력. DDD에서 서비스 경계를 정하는 기준 — 기술이 아니라 비즈니스 도메인 단위로 나눈다
- **(Passive → Active) "exemplifies"**: ~의 좋은 예가 되다, 예시로 보여주다. example의 동사형. "best exemplifies" = 가장 잘 보여주는
- **(Weak Recognition) "underlying"**: 밑에 깔린, 근본적인. under(아래)+lying(놓여있는). "underlying code"=실제 구현 코드. "underlying issue"=근본 원인
- **(Weak Recognition) "evolve X over time to match Y"**: X를 시간에 걸쳐 점진적으로 변화시켜 Y에 맞추다. evolve=점진적으로 발전/변화시키다(evolution의 동사형). over time=시간이 지나면서
- **(Weak Recognition) "abstract away"**: 복잡한 세부사항을 숨겨서 신경 안 써도 되게 만들다. abstract(추상화하다)+away(치워버리다). "Containers abstract away the underlying host details"=컨테이너가 호스트 세부사항을 숨겨줌. IT에서 매우 자주 쓰이는 표현
- **(Weak Recognition) "invariants"**: 불변 조건, 항상 지켜져야 하는 규칙. in(not)+variant(변하는)=변하면 안 되는 것. DDD: 비즈니스 규칙이 어떤 상황에서도 깨지면 안 되는 조건. "protect its own invariants"=자신의 불변 조건을 스스로 보호하다
- **(Passive → Active) "prevent X from ~ing"**: X가 ~하는 것을 막다/방지하다. prevent+목적어+from+동명사 세트 구조. "prevents the rules from being bypassed"=규칙이 우회되는 것을 방지한다
- **(Passive → Active) "[statement] where [구체적 상황]"**: 추상적 개념 뒤에 where로 구체적 상황을 붙여 보충하는 패턴. where=장소가 아니라 "그게 뭐냐면". "high coupling where a single business change requires modifying every service"=높은 결합도, 즉 하나의 변경이 모든 서비스 수정을 요구하는 상황
- **(Weak Recognition) "advocates"**: 지지하다, 옹호하다, ~을 주장하다. ad(~를 향해)+voc(목소리)+ate=목소리를 내다. advocate for X=X를 지지. 명사: an advocate=지지자. "DDD advocates for the exact opposite"=DDD는 정반대를 주장한다
- **(Unknown) "fidelity"**: 충실도, 정확도, 원본에 얼마나 가까운지. fidel(라틴어: 충실한)+ity. hi-fi=high fidelity=고음질(원본에 충실한 재현). "high fidelity to production"=프로덕션 환경과 매우 가깝게 재현

### Next Steps
-

### References
-

### Notes
- Original context (System Fundamentals microservices quiz):
  > It leads to the 'Anemic Domain Model' by moving logic to the database layer.
  > It creates implicit coupling that prevents true service autonomy.
- Original context (System Fundamentals DDD quiz):
  > establish a linguistic and conceptual boundary where a specific model is defined and applicable
- Original context (System Fundamentals service boundaries quiz):
  > why does the provided material advise against splitting services based on technical layers
- Original context (System Fundamentals async communication quiz):
  > what is the best analogy for an 'Event'
- Original context (System Fundamentals boundary anti-patterns quiz):
  > a change in one component does not force cascading changes across the entire system
- Original context (System Fundamentals containerized development quiz):
  > What does the term 'Infrastructure Agnostic' mean
- Original context (System Fundamentals DDD service boundaries quiz):
  > how should service boundaries be defined to maximize system resilience
  > By business capability, ensuring each service aligns with a specific domain area
- Original context (System Fundamentals leaky boundaries quiz):
  > Which scenario best exemplifies the 'Leaky Boundaries' anti-pattern?
- Original context (System Fundamentals Ubiquitous Language quiz):
  > developers and domain experts use the same terms in both conversation and the underlying code
- Original context (System Fundamentals EF Core Migrations quiz):
  > To evolve the database schema over time to match changes made to the data models in code
- Original context (System Fundamentals Infrastructure Agnostic quiz):
  > Containers abstract away the underlying host details, allowing the focus to remain on the application logic.
- Original context (System Fundamentals DDD entities quiz):
  > To allow the domain model to protect its own invariants and enforce business rules internally.
  > Encapsulating logic within entities prevents the business rules from being bypassed or incorrectly applied by external services.
- Original context (System Fundamentals technical layers quiz):
  > Because technical layers lead to high coupling where a single business change requires modifying every service.
- Original context (System Fundamentals DDD entities 해설):
  > DDD actually advocates for the exact opposite.
- Original context (System Fundamentals development-environment-centric quiz):
  > containers allow developers to run the entire complex system locally with high fidelity to production.

### Raw (AI: organize into sections above)
-
