# Lesson 6 — Remote State and Locking

**Course position:** Lesson 6 of 13.

## Objectives
- Explain backends and remote state.
- Understand locking and concurrent operations.
- Identify state security and recovery concerns.

## Safety
The existing lab uses Azure Storage as a backend. Preserve existing resources and state; do not change backend configuration or state without explicit approval.

## Authoritative checkpoint
This lesson has not started. Begin after Lesson 5 — Drift and Lifecycle.

## Resume checkpoint — curriculum numbering reaffirmed 2026-11-04

Lesson 6 remains **Remote State and Locking**. It follows Lesson 5 — Drift and Lifecycle, including the lifecycle meta-arguments practical continuation. Do not treat lifecycle meta-arguments as a separate numbered lesson.

Start this lesson with backend/state concepts, then examine Azure Storage remote state, state locking/concurrency, security/access controls, and recovery. Preserve the existing `vm-practice/hub-spoke-lab` Azure Storage backend and state. Do not perform backend migration, state mutation, or infrastructure changes without fresh explicit approval. Prefer read-only inspection and local-only demonstrations first.


---

## Session checkpoint — 2026-11-05: State security and recovery concepts

### Covered
- Remote backend initialized successfully in the isolated `~/terraform-remote-state-lab` project.
- Remote state inspection showed `terraform_data.remote_state_demo` as the only tracked resource. A local backup was saved at `/tmp/remote-state-lab-backup.json`; do not publish state contents.
- State locking: concurrent Terraform operations are blocked; investigate a suspected stale lock and confirm no active operation before considering force-unlock.
- `Storage Blob Data Reader` permits reading and downloading blob contents.
- Terraform `sensitive = true` masks normal CLI output but does not remove values from state.
- Azure Storage encryption at rest protects stored data; it does not prevent authorized readers from downloading and reading the blob.
- Blob soft delete supports recovery of deleted blobs; Blob versioning supports recovery of earlier versions after overwrite. Multiple versions may be retained, subject to retention and deletion controls; recovery is not guaranteed forever.
- State recovery must be coordinated: stop concurrent Terraform operations, preserve the current version, identify the last known-good version, restore carefully, and validate against actual infrastructure. Restoring state does not roll back infrastructure.

### Read-only backend protection inspection — 2026-11-05
For Storage Account `stdepprashantlab`, Azure CLI reported:
- Blob versioning: `isVersioningEnabled: null` (not shown as enabled).
- Blob soft delete: `enabled: false`, `days: null`.
- Container soft delete: `containerDeleteRetentionPolicy: null` (not shown as configured).
No Azure settings were changed during this inspection.

### Next session
**Practical Azure Storage hardening, followed by a safe state recovery exercise.**
- Review RBAC, network access, public access, and HTTPS-only settings.
- Evaluate Blob versioning, Blob soft delete, container soft delete, retention, and cost.
- Make changes only with fresh explicit approval.
- Practise recovery on a disposable test blob or isolated test container; do not overwrite, delete, or restore the live Terraform state blob.

### Safety
Preserve the existing Azure lab resources, original local state, separate Hub-and-Spoke backend/state, and this remote-state demo backend/state. No apply, destroy, state mutation, import, backend migration, or impactful Azure operation without fresh explicit approval.
