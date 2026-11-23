# Terraform Zero-to-Hero — Learning Progress

## Current checkpoint
Course: Terraform Zero-to-Hero
Current phase: 3 — Writing Terraform
Completed through: Lesson 6 — Remote State and Locking
Current lesson: Lesson 7 — Variables, Locals, and Outputs
Status: NOT STARTED
Next action: Begin Lesson 7 from `docs/lesson-07-variables.md`. Start with input variables and type constraints; inspect existing HCL notes first and do not repeat already-practised material.

**This checkpoint is authoritative as of 2026-11-23 and supersedes older current-checkpoint entries below. Historical entries remain as a learning log.**

### Latest Lesson 6 evidence — 2026-11-23
- Completed a safe recovery simulation using the existing Azure Storage Account `stdepprashantlab`, resource group `rg-tf-lab-prashant-dev`, container `tfstate`, and a separate test key: `lesson06-recovery-test.tfstate`.
- Exercise directory: `~/terraform-remote-state-recovery`.
- The original `remote-state-lab.tfstate` and the Hub-and-Spoke backend/state were not used or modified.
- The test configuration managed only `terraform_data.recovery_demo`. This is Terraform's built-in data resource; it did not create or modify an Azure infrastructure resource. Azure Blob Storage held the test state.
- Backup A: state serial 2, resource input `Version 1 - Original state`.
- Backup B: state serial 3, resource input `Version 2 - Original state`.
- After restoring Backup A to the disposable test key, a read-only plan correctly proposed an in-place update from Version 1 to Version 2.
- Restored Backup B; `terraform state pull` returned Version 2 and `terraform plan` reported no changes.
- Learner correctly answered the state-blob-loss recovery scenario and the concurrent-apply/state-locking interview scenario.
- No production state blob or Azure infrastructure resource was changed. The disposable test state blob was intentionally modified during the approved exercise and has not been cleaned up.
- Keep the test blob and local backup files until cleanup is explicitly planned; do not delete them automatically.
- Azure Storage hardening remains deferred to the future security track, as previously requested.
- Separate parked issue: `terraform state show` against the original remote-state demo previously returned `unsupported attribute "store"`. This exercise used a separate state key and did not resolve or modify that original state.


## Verified technical environment and lab boundaries
- Existing local project: `~/azure-lab/terraform-hcl-practice`
- Separate remote-state lab: `~/terraform-remote-state-lab`
- Remote backend: Azure Blob Storage, container `tfstate`, key `remote-state-lab.tfstate`
- Remote-state demo currently tracks `terraform_data.remote_state_demo`; this is a Terraform data resource, not an Azure resource.
- Existing Hub-and-Spoke lab has its own backend and state; do not confuse it with the remote-state demo.
- Preserve all existing Azure resources, original local state, and all existing backend/state configurations.
- Never publish state JSON, credentials, subscription identifiers, or secret values.

## Learning assessment
| Topic | Status | Evidence / next action |
|---|---|---|
| Lessons 1–4 — Terraform fundamentals and configuration | COMPLETED / PRACTISED | Historical learning log below; revisit during review as needed |
| Lesson 5 — Drift and Lifecycle | COMPLETED | Completed 2026-11-04 |
| Lesson 6 — Remote state and locking | COMPLETED (2026-11-23) | Azure-backed isolated recovery exercise completed; Backup A/B, stale-state detection, Backup B restoration, clean plan, recovery and locking scenarios answered |
| Remote vs. local state | UNDERSTOOD | Explained backend purpose and remote-state workflow |
| Azure Blob backend | PRACTISED | Separate remote-state lab initialized successfully |
| State metadata | COVERED | Reviewed version, Terraform version, serial, and lineage |
| State locking and concurrency | UNDERSTOOD | Covered concurrent operation protection and stale-lock precautions |
| State security | COVERED | Sensitive output masking, state exposure, encryption at rest, and data-plane access |
| State disaster recovery | DEMONSTRATED | Recovered the known-good test state after deliberately restoring an older copy; verified configuration/state consistency with a read-only plan |
| Safe state recovery practical | COMPLETED | Separate Azure Blob key `lesson06-recovery-test.tfstate`; Backup A serial 2 (Version 1), Backup B serial 3 (Version 2); restored A, observed proposed update, restored B, verified Version 2 and no changes |
| Lesson 6 assessment/interview questions | COMPLETED | Correctly answered deleted-state-blob recovery and concurrent Terraform operation/state-locking scenarios |

## Session log

### 2026-11-23 — Lesson 6 recovery practical and assessment completed
- Used a separate Azure Blob backend key, `lesson06-recovery-test.tfstate`, in the existing `stdepprashantlab` storage account and `tfstate` container. Kept the original `remote-state-lab.tfstate` and Hub-and-Spoke backend untouched.
- Created `terraform_data.recovery_demo` with input `Version 1 - Original state`; pulled and saved Backup A (serial 2).
- Updated the configuration to `Version 2 - Original state`; Backup B contained serial 3 and the Version 2 value.
- With explicit approval, pushed Backup A to the disposable test key using `terraform state push -force`. The pulled state contained Version 1; a read-only plan proposed an in-place update from Version 1 to Version 2 (0 add, 1 change, 0 destroy).
- Restored Backup B; `terraform state pull` showed Version 2 and `terraform plan` reported no changes.
- Correctly answered the safe response to a deleted state blob (recover a known-good version, inspect, compare with actual infrastructure, and run a read-only plan) and the concurrency scenario (backend state locking prevents simultaneous state operations).
- Lesson 6 practical, assessment scenarios and interview scenario completed. No Azure infrastructure resource was created or modified; only the separate test state blob was changed. Test cleanup remains pending and must be planned explicitly.
- Next: Lesson 7 — Variables, Locals, and Outputs. Do not repeat earlier HCL function/collection material unless a specific gap requires review.


### 2026-11-06 — Terraform Mission Mode: Mission 02, The Terraform State Disaster
- User requested more engaging, interactive practice because long lecture-style sessions were causing boredom/sleepiness.
- Agreed to continue with short incident scenarios, prediction-first multiple-choice decisions, immediate feedback, XP, and practical follow-through.
- Completed all five challenges correctly: stop further operations and preserve state; inspect candidate versions before restoration; recognize that an older state can omit newer infrastructure; validate with a read-only plan; reconcile verified existing resources through import rather than blindly applying.
- Score: 500/500 XP.
- Key distinction reinforced: restoring state does not roll back Azure infrastructure; importing changes Terraform state and requires explicit approval when used against a real backend.
- No Azure resources, live state blobs, or backend settings were changed during the mission.
- Next checkpoint: isolated safe state recovery practical. After that, Lesson 6 assessment and interview questions; then move to Lesson 7.

### 2026-11-05 — Lesson 6: Remote state and locking
- Remote backend initialized successfully in the isolated `~/terraform-remote-state-lab` project.
- Remote state inspection showed `terraform_data.remote_state_demo` as the only tracked resource. Do not assume how it entered state; `terraform init` alone does not create/populate a resource instance.
- State locking: concurrent Terraform operations are blocked; investigate a suspected stale lock and confirm no active operation before considering force-unlock.
- `Storage Blob Data Reader` permits reading and downloading blob contents.
- Terraform `sensitive = true` masks normal CLI output but does not remove values from state.
- Azure Storage encryption at rest protects stored data; it does not prevent authorized readers from downloading and reading the blob.
- Blob soft delete supports recovery of deleted blobs; Blob versioning supports recovery of earlier versions after overwrite. Recovery depends on retention and deletion controls.
- State recovery must be coordinated: stop concurrent Terraform operations, preserve the current version, identify the last known-good version, restore carefully, and validate against actual infrastructure. Restoring state does not roll back infrastructure.

### 2026-11-05 — Read-only backend protection inspection
For Storage Account `stdepprashantlab`, Azure CLI reported:
- Blob versioning: `isVersioningEnabled: null` (not shown as enabled).
- Blob soft delete: `enabled: false`, `days: null`.
- Container soft delete: `containerDeleteRetentionPolicy: null` (not shown as configured).
- No Azure settings were changed during this inspection.
- Detailed Storage Account hardening (RBAC, network firewall/private endpoints, TLS, retention and related controls) is deferred to the future Azure security learning track, as explicitly requested. Do not reopen this topic in Lesson 6 unless the user asks.

### 2026-11-04 — Lesson 5
- Lesson 5 — Drift and Lifecycle: completed.

### Earlier learning history
- 2026-10-21: Existing Hub-and-Spoke lab validated. Learner requested a restart from zero because previous lessons relied too much on copying code. Agreed to concept-first teaching and explicit progress tracking.
- Earlier fundamentals practice covered desired state, `terraform plan`, state, drift, providers, resources, arguments, attributes, variables, outputs, data sources, locals, and dependencies. Older checkpoint entries below are historical and are not the current resume point.

## Rules for every session
1. Resume from the current checkpoint above; do not restart from old historical entries.
2. Keep teaching concise, concept-first and practical; use prediction-first questions and small exercises. Do not introduce missions, XP, or gamification.
3. Prefer concise concept-first explanations; avoid long lectures and large copy-paste exercises.
4. Use complete, safe command blocks when terminal work is needed; let the learner execute and report results.
5. Track demonstrated understanding, not just successful commands.
6. Preserve all existing Azure resources and Terraform state.
7. No `apply`, `destroy`, import, state mutation, backend migration, force-unlock, or impactful Azure operation without fresh explicit approval for that specific operation.
8. Use an isolated disposable test blob/container or local simulation for state recovery. Never experiment on the live state blob or existing Hub-and-Spoke backend.
9. Do not claim a practical exercise or repository change is complete until it has actually been performed and verified.

## Next session / resume instructions
Begin Lesson 7 — Variables, Locals, and Outputs, using `docs/lesson-07-variables.md` and the canonical 13-lesson roadmap.
1. Inspect existing HCL practice notes and identify which variable/type concepts have already been covered; do not repeat them unnecessarily.
2. Start with the Lesson 7 objectives: input variables, type constraints, defaults, validation and overrides.
3. Continue concept-first, concise, prediction-first, with small learner-written exercises and verification.
4. Preserve all existing Azure resources and state. The Lesson 6 test blob and local backups remain until a separately approved cleanup plan.
5. Keep the original remote-state demo's `unsupported attribute "store"` issue parked and clearly separate; it was not fixed by the Lesson 6 recovery exercise.
