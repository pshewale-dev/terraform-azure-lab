# Lesson 5 Appendix — Lifecycle Meta-Arguments (hands-on)

**Course position:** Lesson 5 — Drift and Lifecycle (continuation/practical appendix).
**Status:** IN PROGRESS. `prevent_destroy` added and formatting/validation reported complete; other arguments require safe practical verification and final assessment.
**Workspace:** `~/azure-lab/terraform-hcl-practice` (local state).

## Scope
These lifecycle meta-arguments are part of Lesson 5, not a separate numbered lesson:
- `prevent_destroy`
- `create_before_destroy`
- `ignore_changes`
- `replace_triggered_by`

## Session evidence — 2026-11-03 conceptual review
- `prevent_destroy`: learner correctly explained that a planned destroy/replacement is blocked while the lifecycle rule remains in the resource configuration. Removing the entire resource block also removes the rule; it is not an Azure-side permanent lock.
- `create_before_destroy`: learner correctly identified create-new-first, destroy-old-afterward ordering and discussed coexistence constraints including private IP conflicts, names, and quota/capacity.
- `ignore_changes`: learner correctly explained that only listed attributes are ignored and unlisted attributes remain managed.
- `replace_triggered_by`: learner correctly described the intent to replace a resource when a referenced managed resource/attribute has a relevant planned change.
- These were conceptual predictions; do not claim they were all implemented or command-verified.

## Practical session — 2026-11-04

### `prevent_destroy`
- Added `lifecycle { prevent_destroy = true }` inside the existing `azurerm_storage_account.imported` resource in `networking.tf`.
- Learner reported running `terraform fmt` and `terraform validate` successfully. Command output was not supplied, so this is learner-reported evidence.
- No destructive plan was run; no apply or Azure/state change occurred.

### `ignore_changes`
- Learner stated that `ignore_changes = [tags]` was already present for the manually changed Azure Portal tag and that it behaves as expected.
- No new code edit or plan verification was performed in this session. Treat as learner-reported existing lab work.
- Confirmed understanding: tag differences are ignored, while unrelated managed attributes (for example, replication type) remain detectable.

### `create_before_destroy`
- Learner correctly described create-new-first, then destroy-old ordering.
- Learner correctly reasoned that if replacement creation fails due to Azure quota, Terraform cannot proceed to destroy the old VM. Clarification: quota is generally discovered during apply; a plan does not reserve quota or guarantee the replacement can be created.
- No HCL was written or validated for this argument in this session.

### `replace_triggered_by`
- Learner correctly predicted that a VM can also be replaced when its referenced managed disk requires replacement.
- Clarification: a relevant planned change to the referenced managed resource/attribute is needed; not every in-place disk update necessarily causes VM replacement.
- No HCL was written or validated for this argument in this session.

## Remaining work
1. Use a local-only or isolated configuration example to practise `create_before_destroy`; do not attempt replacement against the existing Azure Storage Account.
2. Use a small local-only managed-resource example or carefully reasoned HCL snippet for `replace_triggered_by`.
3. Confirm the existing `ignore_changes = [tags]` block only if needed; avoid unnecessary Azure plan calls.
4. Complete an integrated assessment and distinguish conceptual understanding from command-verified implementation.

## Next numbered lesson
After this appendix and the Lesson 5 assessment are complete, proceed to **Lesson 6 — Remote State and Locking** (`lesson-06-remote-state.md`). Lesson numbers 7–13 remain unchanged.

## Safety
- Preserve `rg-tf-lab-prashant-dev`, its VNet, subnet, both Storage Accounts and local Terraform state.
- Preserve `vm-practice/hub-spoke-lab` and its separate Azure Storage backend/state.
- Do not deliberately remove the imported resource block or create a destructive plan against the real lab account.
- No `terraform apply`, `terraform apply -refresh-only`, `terraform destroy`, state mutation, import, backend migration, or impactful Azure operation without fresh explicit approval.

## Teaching approach
Continue one concept at a time, prediction-first, concise and practical. Use learner-written small examples, safe verification and a troubleshooting drill. Do not mark the appendix complete until remaining practical work and the assessment are demonstrated.
