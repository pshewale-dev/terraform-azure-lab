# Lesson 6 — Remote State and Locking

**Course position:** Lesson 6.

## Objectives
- Explain backends and remote state.
- Understand locking and concurrent operations.
- Identify state security and recovery concerns.
- Practise a safe recovery workflow in an isolated environment.

## Safety and lab boundaries
- Preserve existing resources, original local state, and all existing backend configurations.
- The isolated remote-state demo uses Azure Storage with container `tfstate` and blob key `remote-state-lab.tfstate`.
- Do not confuse this demo backend with the separate `vm-practice/hub-spoke-lab` backend.
- No apply, destroy, import, state mutation, backend migration, force-unlock, or impactful Azure operation without fresh explicit approval for that specific operation.
- State files can contain secrets and identifiers. Never publish raw state JSON.
- Detailed Azure Storage Account hardening is deferred to the future Azure security learning track, as requested. Do not spend more Lesson 6 time on firewall, private endpoint, TLS, RBAC design, or retention configuration unless the learner asks.

## Covered concepts
- Local state vs. remote state and why teams use a shared backend.
- Azure Blob backend initialization and the distinction between management-plane roles and Blob data-plane permissions.
- State metadata: Terraform state format version, Terraform version, serial, and lineage.
- State locking and concurrent operations.
- `terraform force-unlock` is only for a verified stale lock after confirming no active operation.
- `sensitive = true` masks normal CLI output; it does not remove values from state.
- Azure Storage encryption at rest protects stored data but does not prevent authorized readers from downloading it.
- Blob versioning and soft delete provide recovery options subject to configuration and retention; they do not guarantee permanent recovery.
- Restoring a state version does not roll back real Azure infrastructure.

## Lab facts recorded
- Separate project: `~/terraform-remote-state-lab`.
- Backend: Azure Storage Account `stdepprashantlab`, container `tfstate`, blob `remote-state-lab.tfstate`.
- The inspected remote state tracked `terraform_data.remote_state_demo` only. This is a Terraform data resource, not an Azure resource.
- Last read-only inspection (2026-11-05) did not show Blob versioning enabled; Blob soft delete was disabled; container soft delete was not shown as configured. No settings were changed during that inspection.
- Do not assume those protection settings have since changed without a fresh read-only check.

## Mission Mode checkpoint — 2026-11-06
**Mission 02: The Terraform State Disaster — COMPLETED**

Learner answered all five incident-response decisions correctly (500/500 XP):
1. Stop further Terraform operations and preserve the current state blob.
2. Preserve the latest incorrect version, inspect the candidate known-good version, and use a controlled recovery process.
3. Recognize that restoring an older state can omit infrastructure created afterward; Terraform may then propose creating a duplicate or encounter a name conflict.
4. Run a read-only `terraform plan` and compare Terraform's tracked view with actual infrastructure before any apply.
5. Verify the existing resource identity and configuration, then reconcile it with Terraform state using import when appropriate.

Key distinction: a plan does not automatically import missing resources. Import changes state and must not be run against a real backend without explicit approval and a reviewed recovery plan.

## Completed practical — Safe state recovery (2026-11-23)
**Status: COMPLETED.** The learner demonstrated recovery using a separate test state key in the existing Azure Storage container.

### Isolated test setup
- Project: `~/terraform-remote-state-recovery`.
- Existing Storage Account: `stdepprashantlab`.
- Resource group: `rg-tf-lab-prashant-dev`.
- Container: `tfstate`.
- Separate test blob key: `lesson06-recovery-test.tfstate`.
- Original demo key `remote-state-lab.tfstate` and the Hub-and-Spoke backend/state were left untouched.
- Test resource: `terraform_data.recovery_demo` using Terraform's built-in provider. This resource does not provision an Azure infrastructure resource; Azure Blob Storage stores the Terraform state.

### Verified recovery evidence
1. Initial configuration value: `Version 1 - Original state`.
2. Backup A was pulled to `backup-v1.tfstate`: state format version 4, Terraform version 1.15.9, serial 2, lineage `ad94f4db-ab24-ed4c-4b7d-d619eca3b539`; resource input was Version 1.
3. Configuration was changed to `Version 2 - Original state`. Backup B was pulled to `backup-v2.tfstate`: serial 3; resource input was Version 2.
4. With the learner's explicit approval, Backup A was pushed to the disposable test key using `terraform state push -force`. The pulled state contained Version 1. A read-only plan proposed an in-place update from Version 1 to Version 2 (0 add, 1 change, 0 destroy).
5. Backup B was restored to the test key. The final `terraform state pull` returned `Version 2 - Original state`, and `terraform plan` reported: `No changes. Your infrastructure matches the configuration.`
6. The learner correctly answered the state-blob-loss recovery scenario: recover a known-good state copy/version, inspect it, compare with actual infrastructure, then run a read-only plan.
7. The learner correctly explained that Azure Blob backend state locking prevents concurrent Terraform operations from modifying the same state simultaneously; another operation waits or fails to acquire the lock.

### Learning conclusions
- Restoring an older state copy does not roll back the real resource.
- A read-only plan can reveal a mismatch between restored state and current configuration after refresh.
- Restoring the known-good Backup B returned the test state to the configuration's expected value.
- The state serial alone should not be used as proof of which snapshot content is present; inspect the state contents and compare lineage/resource identity as appropriate.

### Boundaries and pending cleanup
- No Azure infrastructure resource was created, changed, or deleted during this practical. Only the separate test state blob was intentionally changed.
- The original `remote-state-lab.tfstate` and Hub-and-Spoke backend/state were not changed.
- The test blob and local backup files have not been cleaned up. Do not delete them without a separate cleanup review and explicit approval.
- Detailed Azure Storage hardening remains deferred to the future Azure security learning track, as requested.
- The separate earlier `terraform state show` error (`unsupported attribute "store"`) against the original remote-state demo was not resolved by this exercise.

## Lesson 6 assessment and interview scenarios — COMPLETED
- State blob accidentally deleted while resources remain: recover a known-good state version or backup, inspect it, compare with actual infrastructure, and run a read-only plan before any changes.
- Two engineers start `terraform apply` against the same remote backend: state locking prevents concurrent state operations; the second operation waits or fails to acquire the lock.
- Lesson 6 objectives and practical workflow demonstrated. Lesson 6 is complete; continue to Lesson 7.

## Resume instructions
Begin Lesson 7 — Variables, Locals, and Outputs using `docs/lesson-07-variables.md`. Inspect prior HCL practice notes first and avoid repeating material already demonstrated. Teach concisely, concept-first and prediction-first, with small practical exercises. Keep the Lesson 6 test blob/backups untouched until a separate cleanup plan is approved.
