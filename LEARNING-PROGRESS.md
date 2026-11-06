# Terraform Zero-to-Hero — Learning Progress

## Current checkpoint
Course: Terraform Zero-to-Hero
Current phase: 2 — State and dependencies
Completed through: Lesson 5 — Drift and Lifecycle
Current lesson: Lesson 6 — Remote State and Locking
Status: IN PROGRESS
Current subtopic: Safe Terraform state recovery exercise
Next action: Practise recovery in an isolated test environment, then complete the Lesson 6 assessment and interview scenarios.

**This checkpoint supersedes older current-checkpoint entries below that still say Lesson 1 or mark Lesson 6 as not started.** Historical entries are retained as a learning log.

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
| Lesson 6 — Remote state and locking | IN PROGRESS | Core concepts covered; safe recovery practical and final assessment remain |
| Remote vs. local state | UNDERSTOOD | Explained backend purpose and remote-state workflow |
| Azure Blob backend | PRACTISED | Separate remote-state lab initialized successfully |
| State metadata | COVERED | Reviewed version, Terraform version, serial, and lineage |
| State locking and concurrency | UNDERSTOOD | Covered concurrent operation protection and stale-lock precautions |
| State security | COVERED | Sensitive output masking, state exposure, encryption at rest, and data-plane access |
| State disaster recovery | CONCEPTS UNDERSTOOD | Completed Mission 02 with 5/5 correct answers; isolated practical still pending |
| Safe state recovery practical | NOT STARTED | Next: isolated test-only recovery simulation |
| Lesson 6 assessment/interview questions | PENDING | Complete after practical |

## Session log

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
2. Keep teaching interactive and engaging: short mission-style scenarios, prediction-first questions, immediate feedback, and small practical tasks.
3. Prefer concise concept-first explanations; avoid long lectures and large copy-paste exercises.
4. Use complete, safe command blocks when terminal work is needed; let the learner execute and report results.
5. Track demonstrated understanding, not just successful commands.
6. Preserve all existing Azure resources and Terraform state.
7. No `apply`, `destroy`, import, state mutation, backend migration, force-unlock, or impactful Azure operation without fresh explicit approval for that specific operation.
8. Use an isolated disposable test blob/container or local simulation for state recovery. Never experiment on the live state blob or existing Hub-and-Spoke backend.
9. Do not claim a practical exercise or repository change is complete until it has actually been performed and verified.

## Next session / resume instructions
Continue Lesson 6 in Terraform Mission Mode.
1. Start with the safe state recovery practical in an isolated test environment only.
2. Explain each recovery step briefly and ask the learner to predict the result before proceeding.
3. Preserve current and historical state evidence; never overwrite or delete a live state blob.
4. Once the practical is complete, run the Lesson 6 assessment and interview questions.
5. Then move to Lesson 7, following the course's agreed lesson sequence.

