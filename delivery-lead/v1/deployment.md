# Phase 3: Deployment & Operations

This phase ensures the system is secure, observable, and reliably deployable. Nothing goes to production without passing through these controls.

## DevSecOps

### OWASP Top 10 Compliance

Audit against all 10 categories periodically (at minimum: before first release, then quarterly):

| Category | Key Controls |
|---|---|
| A01: Broken Access Control | RBAC enforcement, JWT validation, audit logging |
| A02: Cryptographic Failures | TLS enforcement, PII encryption at rest, proper key management |
| A03: Injection | Parameterized queries, input validation, no string concatenation in SQL |
| A04: Insecure Design | Rate limiting, request size limits, state machine enforcement |
| A05: Security Misconfiguration | Security headers, version hiding, no default credentials in prod |
| A06: Vulnerable Components | Pinned versions, dependency scanning, minimal dependencies |
| A07: Auth Failures | PKCE flow, token expiry, brute force protection, generic error messages |
| A08: Data Integrity | JWT signature verification, algorithm restriction |
| A09: Logging & Monitoring | Audit log, access log, auth failure logging |
| A10: SSRF | No user-controlled URLs, internal services isolated |

### Security Headers

Enforce at the reverse proxy layer (nginx/Traefik/cloud LB):

```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none';
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Strict-Transport-Security: max-age=63072000; includeSubDomains
```

### Rate Limiting

- Apply to all public-facing endpoints (not just auth)
- Strategy: per-IP for anonymous, per-user for authenticated
- Configure burst allowance for legitimate spikes
- Return `429 Too Many Requests` with `Retry-After` header

### Data Encryption

- **At rest**: Column-level encryption for PII (pgcrypto, application-level, or cloud KMS)
- **In transit**: TLS 1.2+ for all external traffic, mTLS between services in production
- **Key management**: Keys in secret store, never in code. Rotation without downtime.

### Authentication & Session Management

- Token validation: verify signature, expiry, issuer, audience on every request
- Key rotation: JWKS cache with TTL, handle key rollover gracefully
- Session handling: short-lived access tokens, refresh token rotation
- Logout: revoke refresh tokens, clear client-side storage

### Authorization

- RBAC at minimum: roles assigned in identity provider, enforced in middleware
- ABAC if needed: attribute-based rules for fine-grained access (e.g., "can only see own team's data")
- Principle of least privilege: default deny, explicitly grant
- Audit: log every access decision (especially denials)

### Audit Trail

- Log all state-changing operations: who, when, what changed (before/after)
- Immutable: audit records cannot be modified or deleted by the application
- Retention: define retention period per regulation (GDPR, SOX, industry-specific)
- Queryable: support investigation ("show me all changes to policy X in the last 30 days")

## CI/CD Pipeline

### Pipeline Stages

```
┌────────┐   ┌──────────────┐   ┌─────────────┐   ┌──────────┐   ┌──────────┐
│  Lint  │──▶│  Unit Tests  │──▶│ Integration │──▶│   E2E    │──▶│  Deploy  │
│        │   │  + Coverage  │   │   Tests     │   │          │   │          │
└────────┘   └──────────────┘   └─────────────┘   └──────────┘   └──────────┘
              Fail if < 90%      Docker Compose     Full stack     Per-env gates
              domain < 100%      real dependencies  + browser      approval for Prod
```

### Branch Protection

- `main`/`master`: protected, requires PR with at least 1 approval
- All CI checks must pass before merge
- No force push to protected branches
- Squash merge to keep history clean

### Deployment Strategy

- **Dev**: Auto-deploy on merge to main (or on push to feature branch)
- **UAT**: Manual trigger or auto-deploy to UAT branch
- **Staging**: Auto-deploy after UAT sign-off, runs full regression
- **Production**: Manual approval gate, deployment window, rollback plan ready

### Rollback Plan

- Every deployment must have a documented rollback procedure
- Blue-green or canary deployments for zero-downtime releases
- Database migrations must be backward-compatible (old code can run against new schema)
- Feature flags to disable new functionality without redeploying

## Dependency Management

### Vulnerability Scanning

- Automated scanning in CI: Dependabot (GitHub), Snyk, or Trivy
- Block merges with critical/high vulnerabilities
- Weekly scan schedule for transitive dependencies
- Track and document accepted risks (with expiry dates)

### Container Image Security

- Use minimal base images (Alpine, distroless, scratch)
- Pin base image versions (no `latest` tag)
- Scan images in CI before pushing to registry
- Multi-stage builds: build dependencies don't ship in production image
- Run as non-root user inside containers

### Dependency Hygiene

- Pin exact versions in lock files (package-lock.json, go.sum)
- Prefer well-maintained, widely-used packages
- Audit new dependencies before adding (license, maintenance status, download count)
- Remove unused dependencies regularly

## TLS & Certificates

### Certificate Management

- Development: self-signed certificates (acceptable, document the browser warning)
- Production: certificates from a trusted CA (Let's Encrypt, cloud-managed, or purchased)
- Renewal automation: cert-manager (Kubernetes), certbot (standalone), or cloud-native
- Monitor expiry: alert 30 days before expiration

### TLS Configuration

- Minimum TLS 1.2 (disable 1.0 and 1.1)
- Strong cipher suites: `HIGH:!aNULL:!MD5`
- HSTS header with long max-age
- HTTP → HTTPS redirect (301)

## Secret Rotation

### Rotation Procedures

| Secret | Rotation Frequency | Zero-Downtime Method |
|---|---|---|
| Database passwords | Quarterly | Dual-password support during rotation window |
| API keys | On compromise or annually | Issue new key, grace period, revoke old |
| TLS certificates | Before expiry (auto-renew) | Hot reload or rolling restart |
| Auth provider secrets | Annually | Update in secret store, restart services |
| Encryption keys | Annually | Re-encrypt with new key, keep old key for reads |

### Rotation Checklist

1. Generate new secret
2. Deploy new secret to secret store
3. Update services to use new secret (rolling restart)
4. Verify services are healthy with new secret
5. Revoke/delete old secret
6. Update documentation

## Production Hardening Checklist

- [ ] Debug mode disabled (no dev servers, no verbose errors to clients)
- [ ] Default credentials removed or changed
- [ ] Unnecessary ports closed
- [ ] Health check endpoints don't expose sensitive info
- [ ] Error responses are generic (no stack traces, no internal paths)
- [ ] Logging level appropriate (info in prod, not debug)
- [ ] Resource limits set on containers (CPU, memory)
- [ ] Backup strategy configured and tested
- [ ] Monitoring and alerting active (uptime, error rate, latency)
- [ ] Disaster recovery plan documented and tested

## Deliverables (Exit Criteria for Phase 3)

- [ ] OWASP Top 10 audit passed with no critical findings
- [ ] CI/CD pipeline complete with all stages
- [ ] Security headers verified in production
- [ ] Rate limiting active on public endpoints
- [ ] Secrets rotated and rotation procedure documented
- [ ] Container images scanned and clean
- [ ] TLS configured and certificates auto-renewing
- [ ] Production hardening checklist completed
- [ ] Incident response runbooks written and reviewed
- [ ] Monitoring and alerting active
