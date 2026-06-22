# Phase 2: Development & Quality

This phase focuses on building the system correctly — service components, testing at every layer, and keeping documentation current as the code evolves.

## Service Components

### Container Health & Dependencies

- Define startup order via `depends_on` with health checks (not just container start)
- Implement readiness probes: service reports ready only when DB connection is established and migrations are applied
- Implement liveness probes: service reports alive unless it's in an unrecoverable state
- Graceful shutdown: drain in-flight requests before stopping

### Secrets & Configuration Management

- Secrets injected at runtime (Docker secrets, Vault, cloud secret managers) — never in code or images
- Configuration hierarchy: defaults → config file → environment variables → secrets
- Per-environment config: same image, different config
- Validate all required config on startup — fail fast with clear error messages

### Identity Provider & Auth

- Realm/tenant strategy: single realm for simple apps, multi-realm for multi-tenant
- Client configuration: public client (SPA with PKCE), confidential client (backend-to-backend)
- Token lifecycle: access token TTL, refresh token rotation, session management
- User provisioning: realm import for dev/test, admin API or SCIM for production

### Database Migrations

- Versioned: sequential numbering (001_, 002_, ...) or timestamp-based
- Idempotent: safe to re-run (use `IF NOT EXISTS`, `ON CONFLICT DO NOTHING`)
- Rollback-safe: every migration has a corresponding down migration or is forward-only by design
- Applied automatically on service startup or as a separate init container
- Never modify a migration that's already been applied to a shared environment

### Reverse Proxy / API Gateway

- Route configuration: path-based routing to backend services
- Security headers injected at the proxy layer
- Rate limiting at the edge
- TLS termination
- Static asset serving (frontend build output)
- WebSocket support if needed (GraphQL subscriptions, real-time features)

## Test Coverage & E2E

### Coverage Thresholds

| Scope | Minimum | Rationale |
|---|---|---|
| Overall | 90% | Ensures broad coverage without being unrealistic |
| Domain logic | 100% | Business rules must be fully tested — no exceptions |
| Utilities/helpers | 90% | High coverage, edge cases matter |
| Handlers/controllers | 80% | Integration tests cover the rest |

### Test Pyramid

```
        ╱╲
       ╱ E2E ╲          Few, slow, high confidence
      ╱────────╲
     ╱Integration╲      Moderate count, real dependencies
    ╱──────────────╲
   ╱   Unit Tests   ╲   Many, fast, isolated
  ╱──────────────────╲
```

- **Unit tests** (70%): Fast, isolated, mock external dependencies. Test business logic, validation, state machines.
- **Integration tests** (20%): Real DB, real auth provider. Test API contracts, auth flows, error scenarios.
- **E2E tests** (10%): Full stack through the browser. Test critical user journeys only.

### Property-Based Testing

Use property-based tests to validate universal invariants that must hold for ALL inputs:

- **Bounded values**: Scores, amounts, percentages always within valid range
- **Idempotency**: Duplicate requests produce the same result, not duplicated side effects
- **State machine validity**: Only valid transitions are possible (no skipping states)
- **Round-trip consistency**: Serialize → deserialize produces the original value
- **Commutativity**: Order of independent operations doesn't affect final state

Frameworks: `fast-check` (TypeScript), `gopter` (Go), `hypothesis` (Python), `jqwik` (Java)

### Integration Tests

- Run against real dependencies (database, auth provider) in Docker
- Test scenarios:
  - Happy path: full workflow end-to-end
  - Auth/RBAC: missing token (401), expired token (401), wrong role (403), correct role (200)
  - Error paths: invalid input (400), conflict (409), not found (404)
  - Edge cases: concurrent requests, large payloads, special characters
- Test data: seeded via migrations or setup functions, cleaned between tests

### E2E Tests (Playwright/Cypress)

- Cover critical user journeys per role (not every button click)
- Run against the full stack (proxy + frontend + backend + DB + auth)
- Handle auth: programmatic login to avoid testing the auth provider's UI
- Assertions: verify visible outcomes, not implementation details
- Keep stable: avoid flaky selectors, use data-testid attributes

### Performance & Load Testing

- Establish baseline: response time p50, p95, p99 under normal load
- Load test: verify system handles expected peak traffic
- Stress test: find the breaking point
- Tools: k6, Artillery, Locust, or Gatling
- Run in CI on a schedule (not every commit — too slow)

### Test Data Management

- Seed data: deterministic, version-controlled, applied via migrations
- Test isolation: each test gets clean state (transaction rollback or truncate)
- Synthetic data for UAT: realistic but not real PII
- Anonymized production data for Staging: real patterns, no real identities

## Documentation Maintenance

### Freshness Checks

- Automated: CI job that compares documented values (URLs, passwords, ports) against actual config files
- Manual: review docs quarterly or after any infrastructure change
- Stale docs are worse than no docs — delete what you won't maintain

### Cross-Reference Accuracy

- Config files (docker-compose, .env) ↔ documentation ↔ IaC templates
- User tables in docs ↔ actual realm import JSON
- API docs ↔ actual route registrations
- When you change config, update docs in the same PR

### Incident Response Runbooks

- One runbook per failure mode: DB down, auth provider down, high latency, disk full
- Structure: symptoms → diagnosis steps → resolution → post-mortem template
- Keep runbooks next to the code (not in a wiki nobody checks)

## Deliverables (Exit Criteria for Phase 2)

- [ ] All services containerized with health checks
- [ ] Unit test coverage meets thresholds
- [ ] Property-based tests cover critical domain invariants
- [ ] Integration tests pass with real dependencies
- [ ] E2E tests cover critical user journeys
- [ ] Performance baseline established
- [ ] Documentation is current and accurate
- [ ] Database migrations are versioned and rollback-safe
- [ ] No critical or high security findings
