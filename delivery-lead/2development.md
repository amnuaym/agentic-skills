# Phase 2: Development & Quality

This phase focuses on building the system correctly — service components, testing at every layer, executing migration dry-runs, and maintaining documentation.

## Service Components & Infrastructure

### Container Health & Config

* **Readiness Probes**: The app should only report that it is "ready" to receive traffic when its database connection is working and all setups are complete.

* **Liveness Probes**: The app should report that it is "alive" unless it is completely broken and needs to be restarted.

* **Graceful Shutdown**: Finish handling any active user requests before turning the app off.

* **Configuration Hierarchy**: defaults → config file → environment variables → secrets.

* **Fail Fast**: Validate all required configuration on startup — fail fast and loudly if something is missing.

### Infrastructure as Code (IaC) & FinOps Tagging

* All infrastructure must be provisioned via code (Terraform, Pulumi, etc.).

* **Mandatory Tagging**: Every cloud resource must be tagged for billing visibility.

  * `Environment` (e.g., dev, staging, prod)

  * `Project` or `AppID`

  * `CostCenter` or `Owner`

* Un-tagged resources should be flagged or destroyed by CI/CD policies.

### Database Migrations (App Schema)

* Versioned: sequential numbering (001\_, 002\_, ...) or timestamp-based.

* Idempotent: safe to run multiple times without breaking anything.

* Rollback-safe: every migration has a down migration or is forward-only by design.

## SRE & Observability (Keeping It Reliable)

Site Reliability Engineering (SRE) practices must be built into the app from the start, not added as an afterthought.

### Smart Logging & Tracking

* **Machine-Readable Logs**: Write logs in a structured format (like JSON) so monitoring tools can easily search, filter, and read them.

* **Trace IDs**: Attach a unique tracking number to every user request as soon as it enters the system. Pass this number along to every backend service so you can trace the exact path of a failure.

### Setting Reliability Goals

* **SLOs (The Goal)**: Define your exact targets for success. For example, "99.9% of all checkout requests must finish in under 2 seconds."

* **SLIs (The Measurement)**: Write code to actually measure those goals in real-time. If you cannot measure it, you cannot set an SLO for it.

### Alerts & Dashboards as Code

* **Alert Rules**: Define exactly when to wake someone up (e.g., "If the error rate is over 2% for 5 minutes, send an alert"). Keep these rules saved in your code repository, not just clicked together manually in a dashboard.

* **Dashboards**: Build your basic charts (showing traffic volume, error rates, and wait times) as code so they deploy automatically with your app.

## Legacy Data Migration Execution

Building on the strategy from Phase 1, build and test the actual migration process.

* **ETL Scripts**: Write the extraction, transformation, and loading scripts.

* **Staging Dry-Runs**: Run the full migration against the Staging environment.

* **Timing/Windowing**: Measure exactly how long the migration takes to ensure it fits in the planned production maintenance window.

* **Reconciliation**: Write scripts to compare row counts and financial totals between the old and new systems to prove no data was lost.

## Test Coverage & E2E

### Test Pyramid & Thresholds

* **Unit Tests (90%)**: Fast, isolated. 100% coverage on domain/business logic.

* **Integration Tests**: Real DB, real auth provider in Docker. Test API contracts.

* **E2E Tests (Playwright/Cypress)**: Cover critical user journeys per role.

* **Property-Based Testing**: Validate universal rules (like ensuring scores never go below zero).

## Static Analysis & Security Scanning

Run the SAST/dependency scanner chosen in Phase 1 as a CI stage, not an occasional manual check.

* **Block on threshold**: fail the build on any finding at or above the CVSS threshold agreed in Phase 1 (default: 7.0).
* **Track exceptions**: if a finding is accepted rather than fixed (e.g., no patch available yet), record the exception and rationale in `/docs/architecture` — don't let it silently disappear from the next scan's diff.
* **Container images**: if using containers, scan images in the same pipeline stage, not as a separate afterthought.

## Documentation Maintenance

* Automated CI jobs to compare documented values against config files.

* Keep Incident Response Runbooks next to the code.

* Cross-reference accuracy: When you change config, update docs in the same PR.

## Deliverables (Exit Criteria for Phase 2)

* \[ \] All services containerized and configured for health checks (liveness/readiness) and graceful shutdown

* \[ \] Unit, Integration, and E2E test coverage meets thresholds

* \[ \] Property-based tests cover critical invariants where applicable

* \[ \] Performance baseline established

* \[ \] App database migrations are versioned and rollback-safe

* \[ \] No CVSS >= 7.0 findings open in static analysis (exceptions recorded if accepted rather than fixed)

* \[ \] **SRE**: Logs are formatted as JSON and Trace IDs are tracked across services

* \[ \] **SRE**: Reliability goals (SLIs/SLOs) are measured and alert rules are saved as code

* \[ \] **FinOps**: Infrastructure resource tagging applied via IaC

* \[ \] **Data**: Legacy data migration dry-runs completed in Staging with acceptable error rates and within time limits
