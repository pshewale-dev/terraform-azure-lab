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

## Next practical — Safe state recovery
**Status: NOT STARTED.**

Use a disposable isolated test blob/container or a local simulation. Do not overwrite, delete, restore, or mutate the live demo state blob or the Hub-and-Spoke state.

Practical sequence:
1. Create or use a disposable test state fixture, keeping the live backend untouched.
2. Preserve a copy of the current test state before simulating an error.
3. Simulate an outdated state version only inside the disposable test environment.
4. Inspect the available versions/copies and identify the candidate recovery point.
5. Restore only the disposable test state using a controlled method.
6. Validate the recovered state and compare it with the test infrastructure.
7. Identify any resource missing from the recovered state; discuss import without executing a state mutation unless explicitly approved.
8. Record the result and cleanup plan. Do not delete Azure resources without explicit approval.

After the practical:
- Complete Lesson 6 assessment.
- Complete Lesson 6 interview scenarios.
- Mark Lesson 6 complete only after the learner demonstrates the workflow.
- Then move to Lesson 7.

## Resume instructions
Continue in short, interactive Terraform Mission Mode: concept first, prediction question, practical step, learner reports result, then feedback. Avoid long lectures and large copy-paste blocks. Preserve all existing Azure resources and state.
