# Phase 1: Planning & Design

This phase establishes the architectural foundation before any code is written. The goal is to make deliberate, documented decisions that prevent costly rework later.

## Architecture Design

### Domain-Driven Design & Service Split

* Identify bounded contexts — each context owns its data and logic

* Start with a modular monolith unless there's a clear reason to split (e.g., independent scaling, separate team ownership)

* Document service responsibilities and what they do NOT own

### API & Data Layering

* **Frontend/Backend separation**: Frontend never talks to DB directly.

* **API Design**: REST for standard CRUD, GraphQL for flexible UI queries.

* **Data Architecture**: Database-per-service vs. shared instance.

* **Consistency model**: Strong consistency within a service, eventual consistency between services.

### Communication Patterns

* **Synchronous (Wait for it)**: The system makes a request and stops to wait for an immediate answer (like a phone call). Use this when a user is actively waiting for data to load on their screen.

* **Asynchronous (Send and forget)**: The system sends a message and moves on to other work (like sending a text message). The receiver handles the task in the background when it is ready. Use this for slow tasks, like generating large reports, processing files, or sending emails.

* **Safety Nets**: Always set a time limit (timeout) so systems do not wait forever if another part of the system breaks. Also, plan how to safely retry tasks if they fail the first time.

## SRE & Observability Planning

Before building the system in Phase 2, we need to decide how we will measure its health and reliability. You cannot write code to track goals if you have not defined what those goals are.

* **Identify Critical User Journeys**: What are the most important things a user does in the app that absolutely cannot fail? (For example: logging in, finishing a checkout, or uploading a file).

* **Define Goals (SLOs)**: What is the exact target for success for those journeys? (For example: "99.9% of checkouts must be successful and take less than 2 seconds").

* **Choose Measurements (SLIs)**: What exactly will we measure to see if we are hitting our goal? (For example: "We will measure the time between the 'Submit Order' click and the database save confirmation").

* **Tracing Strategy**: Decide how you will track a single user's action as it moves through different parts of the system (e.g., passing a unique "Trace ID" header in every API request).

## FinOps & Cloud Economics

Architecture decisions dictate infrastructure costs. Don't wait until production to look at the bill.

* **Cost Estimation**: Run the proposed architecture through the cloud provider's pricing calculator.

* **Budget Approval**: Present the estimated monthly run-rate to the business sponsor for sign-off.

* **Right-sizing Strategy**: Plan to start small in production and scale out, rather than over-provisioning from day one.

* **Data Lifecycle Costs**: Define archiving strategies (e.g., moving old data to AWS S3 Glacier/cold storage) to save database costs.

## Legacy Data Migration Strategy

If replacing an old system, data migration is often the highest-risk component.

* **Schema Mapping**: Document exactly how fields in the legacy system map to the new database.

* **Cleansing Plan**: Identify stale or invalid data. Decide whether to clean it before migration or drop it.

* **Cutover Approach**: Big Bang (migrate everything over a weekend) vs. Trickle (migrate batches continuously).

* **Tooling**: Decide if you are writing custom ETL scripts or using managed data migration services.

## Environment Strategy

* **Dev**: Local development, fast iteration, seed/mock data.

* **UAT**: User acceptance testing, synthetic realistic data.

* **Staging**: Pre-production validation, anonymized production data.

* **Production**: Live system, real data, strict access control.

* **Environment Parity**: Use the same container images across all environments (config differs, not code).

## Scalability & Resiliency

* Design services to be stateless.

* Connection pooling for databases.

* Queue-based load leveling for traffic spikes.

* Retries with exponential backoff and circuit breakers for external calls.

## Deliverables (Exit Criteria for Phase 1)

* [ ] Architecture diagram (services, data flow, network topology)

* [ ] API contracts (OpenAPI spec or GraphQL schema)

* [ ] Environment strategy document

* [ ] ADRs for: service split, API style, DB strategy, and communication patterns

* [ ] **Communication**: Map out which features will use sync vs. async communication

* [ ] **SRE**: Reliability goals (SLOs) and exact measurements (SLIs) defined for critical user journeys

* [ ] **SRE**: Tracing strategy (Trace IDs) and logging format agreed upon

* [ ] **FinOps**: Cloud cost estimates documented and budget approved

* [ ] **Data**: Legacy data migration strategy defined and mapped
