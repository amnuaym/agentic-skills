# Phase 2: Data Protection & Secrets Management

This phase protects the data itself, on the assumption that access controls from Phase 1 will eventually fail for some account, somewhere — encryption and secrets management are the layer that limits the damage when that happens, not a redundant extra step.

## Encryption at Rest

* Apply encryption per the data classification tier from Phase 0 — Restricted/Regulated data should always be encrypted at rest; lower tiers may be a business call rather than a hard requirement
* Prefer encryption managed by the storage/database platform or a dedicated key management service over custom application-level cryptography, which is easy to implement subtly wrong
* Decide what "at rest" actually covers in this architecture — primary database, backups, logs, and any data warehouse/analytics copy can all hold the same sensitive data under different retention and access rules

## Encryption in Transit

* TLS everywhere data crosses a trust boundary — including internal traffic, not just the public-facing edge, if the threat model identified internal network trust as a concern
* Consider mTLS for service-to-service communication where the threat model calls for mutual verification, not just one-way trust of the caller
* Certificate management (issuance, rotation, expiry monitoring) needs an owner — an expired internal certificate silently disabling encryption is a common, avoidable failure

## Key Management

* Keys live in a dedicated key management service (cloud KMS or an HSM), not embedded in application code or configuration
* Define a rotation policy per key, and confirm rotation actually happens on schedule rather than being a policy that exists only on paper
* Separate **key-use** access (an application encrypting/decrypting data with a key) from **key-management** access (someone who can rotate, disable, or export the key) — these are different privilege levels and should not default to the same set of people

## Secrets Management

* No secrets (API keys, database credentials, tokens) in source code, configuration files, or the repository — this is one of the most common and most consequential gaps to check for
* Use a dedicated secrets manager/vault with scoped access per secret (a service should only be able to read the secrets it actually needs, not the whole store)
* Rotate secrets on a defined schedule and immediately upon any suspected exposure, with rotation actually tested to confirm dependent services pick up the new value without manual intervention

## Non-Production Data Handling

* Restricted/regulated data used in development, staging, or test environments needs masking, tokenization, or synthetic data generation — copying production data as-is into a lower-security environment defeats the classification work done in Phase 0
* If synthetic/masked data can't fully replicate a bug, prefer a tightly scoped, time-limited, logged exception over a standing practice of using real data in non-production

## Data Retention & Secure Deletion

* Define retention per classification tier, informed by both business need and any regulatory floor/ceiling (check `compliance-officer` when a named regulation sets a specific number, e.g. SOX's financial-record retention or a GDPR data-minimization expectation)
* Deletion needs to be genuine — "soft delete" flags that leave data recoverable don't satisfy a real deletion requirement; confirm what "deleted" actually means in each data store, including backups
* Where retention periods conflict across regulations or business needs (e.g., an erasure request against a record still under a mandatory retention period), flag the conflict explicitly rather than resolving it unilaterally — this is the same class of conflict `compliance-officer` surfaces between GDPR and SOX

## Deliverables (Exit Criteria for Phase 2)

- [ ] Encryption at rest applied per data classification tier
- [ ] Encryption in transit enforced, including internally where the threat model warrants it
- [ ] Key management approach defined with rotation policy and use/management access separation
- [ ] Secrets management approach defined — no secrets in code, config, or repo
- [ ] Non-production data handling defined for restricted/regulated data
- [ ] Data retention and secure deletion defined per classification tier, with cross-regime conflicts flagged
