# Lesson 6 — Terraform Lifecycle Meta-Arguments (hands-on)

**Course position:** Dedicated practical follow-up to Lesson 5  
**Status:** CONCEPTUAL SESSION COMPLETED; HANDS-ON LAB PENDING  
**Next session workspace:** `~/azure-lab/terraform-hcl-practice` (local state)

## Objectives
Practise the four lifecycle meta-arguments with small, safe, plan-based exercises:
- `prevent_destroy`
- `create_before_destroy`
- `ignore_changes`
- `replace_triggered_by`

## Session evidence — 2026-11-03

The learner completed prediction-first conceptual exercises and explained:

1. **`prevent_destroy`**
   - Correctly identified that a replacement requiring destruction is blocked while `prevent_destroy = true` remains in the resource configuration.
   - Correctly explained the limitation: if the entire resource block is removed, its lifecycle rule is removed too; a later plan can propose destruction, and applying that plan can delete the resource.
   - Recognized that the plan is where the proposed destruction can be reviewed before apply.

2. **`create_before_destroy`**
   - Correctly identified the create-new-first, destroy-old-afterward ordering.
   - Correctly predicted that an Azure private-IP collision can prevent old and new VMs from coexisting and cause replacement creation to fail.
   - Discussed coexistence constraints such as IP addresses, names, quota/capacity and networking.

3. **`ignore_changes`**
   - Correctly explained that only listed attributes are ignored.
   - Identified `tags` as an example and correctly predicted that an unlisted VM-size change remains detectable.
   - Reviewed the example syntax for ignoring `tags` and `admin_password`; the learner described the intended attributes but did not independently type or validate the HCL.

4. **`replace_triggered_by`**
   - Correctly named the argument and explained its intended use: trigger replacement of one managed resource when a referenced managed resource/attribute has a planned change.
   - This remains conceptual; no HCL was written or tested.

## Practical work not yet performed

- No lifecycle block was added to `networking.tf`.
- No `terraform fmt`, `terraform validate`, or `terraform plan` was run in this session.
- No apply, destroy, state mutation, import, or Azure change was performed.
- Do not claim any lifecycle rule is installed or verified in the workspace.

## Next session — hands-on practice

1. Resume in `~/azure-lab/terraform-hcl-practice`; confirm the workspace and local-state context without switching to `vm-practice/hub-spoke-lab`.
2. Start with a brief recall: `terraform plan -refresh-only` previews a state refresh to reflect Azure; it does not change Azure or persist state by itself.
3. Inspect the existing imported Storage Account resource block and current configuration before editing.
4. Have the learner add `prevent_destroy = true` inside `azurerm_storage_account.imported`, then run `terraform fmt` and `terraform validate`. Review a normal plan only if safe and useful; do not deliberately remove the block or create a destructive plan against the real lab resource.
5. Practise the remaining arguments in isolated/local examples or carefully chosen configuration snippets, with predictions before validation/planning.
6. For `replace_triggered_by`, use a small managed-resource example and explain which planned change triggers replacement.
7. Finish with a practical troubleshooting drill and independent explanation. Mark hands-on completion only after the learner writes and verifies the examples.

## Safety and environment

- Preserve `rg-tf-lab-prashant-dev`, its VNet, subnet, both Storage Accounts, and local Terraform state.
- Preserve `vm-practice/hub-spoke-lab` and its separate Azure Storage backend/state.
- The imported Storage Account `stdepprashantlab` is not disposable.
- No `terraform apply`, `terraform apply -refresh-only`, `terraform destroy`, state mutation, import, backend migration, or impactful Azure operation without fresh explicit approval for that specific operation.
- Do not use the existing Azure-backed resources to test destructive behavior. Prefer local-only examples and plan review.
- Keep the teaching concise, one concept at a time, prediction-first, and avoid unnecessary command output.
