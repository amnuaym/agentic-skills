# Phase 1: Planning & Design

This phase establishes the architectural foundation before any code is written. The goal is to make deliberate, documented decisions that prevent costly rework later.

## Architecture Design

### Domain-Driven Design (DDD)

- Identify bounded contexts — each context owns its data and logic
- Define aggregate boundaries — what is the consistency boundary?
- Create a context map showing relationships between services (upstream/downstream, conformist, anti-corruption layer)
- Decide on ubiquitous language per context

### Service Decomposition

- Start with a modular monolith unless there's a clear reason to split
- Split criteria: independent deployment, different scaling needs, different team ownership, different data lifecycle
- Each service owns its domain module pattern: Model → Repository → Service → Handler
- Document service responsibilities and what they do NOT own

### FE-BE-DB Layering

- **Frontend**: SPA (React/Vue/Angular) or SSR — decide based on SEO needs, interactivity, team skills
- **Backend**: API layer (BFF pattern if multiple clients), domain services, data access
- **Database**: Schema design, indexing strategy, read/write separation if needed
- Clear separation: frontend never talks to DB directly, backend exposes only what frontend needs

### API Design

- **REST**: Use for standard CRUD operations, resource-oriented endpoints, external partner APIs
- **GraphQL**: Use when frontend needs flexible queries, aggregated data from multiple sources, or reduced over-fetching
- **Hybrid approach**: REST for mutations and simple reads, GraphQL for complex dashboard/reporting queries
- Versioning strategy: URL path (`/v1/`) vs. header-based
- Internal vs. external API boundaries: internal APIs can be less formal, external APIs need stability guarantees
- API documentation: OpenAPI spec for REST, schema-first for GraphQL

### Messaging & Event-Driven Architecture

- **When to use message queues**: Async workflows (email, notifications), decoupling services, handling spikes, long-running processes
- **Queue selection**: RabbitMQ (routing flexibility), Kafka (event log, replay), SQS (managed, simple)
- **Patterns**: Pub/sub for events, work queues for tasks, dead-letter queues for failures
- **Event sourcing**: Consider when audit trail is critical or when you need to rebuild state
- **CQRS**: Separate read and write models when query patterns differ significantly from write patterns
- Design for idempotency — consumers must handle duplicate messages safely

### Data Architecture

- Database-per-service vs. shared instance (shared instance acceptable for small teams, separate for scale)
- Cross-service references: use domain identifiers (codes, UUIDs) not foreign keys
- Consistency model: strong consistency within a service, eventual consistency between services
- Data ownership: one service is the source of truth for each entity

### Communication Patterns

- **Synchronous**: HTTP/REST or gRPC for request-response (simple, immediate feedback)
- **Asynchronous**: Message queues for fire-and-forget, event-driven reactions
- Timeouts: every sync call must have a timeout (5s default, adjust per use case)
- Retries: exponential backoff with jitter, max retry count
- Circuit breakers: prevent cascade failures when a downstream service is unhealthy
- Dead-letter queues: capture failed messages for investigation and replay

## Environment Strategy

### Environment Definitions

| Environment | Purpose | Data | Secrets | Infra |
|---|---|---|---|---|
| **Dev** | Local development, fast iteration | Seed/mock data | Local secrets file | Docker Compose, single machine |
| **UAT** | User acceptance testing, stakeholder demos | Synthetic realistic data | Separate secret store | Cloud or dedicated server |
| **Staging** | Pre-production validation, mirrors prod | Anonymized production data | Production-like secrets | Mirrors production infra |
| **Production** | Live system | Real data | Production secrets (rotated) | Full HA, monitoring, backups |

### What Differs Per Environment

- **Infrastructure sizing**: Dev is minimal, Prod is scaled
- **Data**: Dev uses seeds, UAT uses synthetic, Staging uses anonymized prod, Prod is real
- **Secrets**: Each environment has its own set, never shared
- **Feature flags**: Control what's enabled per environment
- **Monitoring**: Minimal in Dev, full observability in Prod
- **Access control**: Dev is open, Prod requires approvals

### Environment Parity

- Use the same container images across all environments (config differs, not code)
- Infrastructure as Code ensures environments are reproducible
- Minimize "works on my machine" by running the same Docker Compose locally that CI uses

## Infrastructure as Code

- Container orchestration: Docker Compose for Dev, Kubernetes/ECS for Prod
- Networking: service discovery, internal DNS, network policies
- Load balancing: reverse proxy (nginx/Traefik) or cloud LB
- All infrastructure changes go through code review (Terraform, Pulumi, CloudFormation)

## Scalability Considerations

- Design services to be stateless (session in external store, not in memory)
- Horizontal scaling: add more instances behind a load balancer
- Connection pooling: limit DB connections per instance, use pgBouncer if needed
- Caching layers: Redis/Memcached for hot data, CDN for static assets
- Queue-based load leveling: absorb traffic spikes with message queues, process at sustainable rate

## Deliverables (Exit Criteria for Phase 1)

- [ ] Architecture diagram (services, data flow, network topology)
- [ ] DDD context map
- [ ] API contracts (OpenAPI spec or GraphQL schema)
- [ ] Environment strategy document
- [ ] ADRs for: service split, API style, DB strategy, queue choice, auth approach
- [ ] Scalability approach documented
