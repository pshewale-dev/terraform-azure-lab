# Lesson 3 — State and Resource Addresses

**Course position:** Lesson 3 of 13.

## Objectives
- Explain why Terraform state exists.
- Read basic resource addresses.
- Understand how Terraform associates configuration with tracked objects.

## Concepts
1. What state records and why Terraform needs it.
2. Resource addresses such as `azurerm_resource_group.example`.
3. How state, configuration, and real infrastructure relate.

## Practice
Use small, non-destructive examples. Do not inspect or modify real state unless the correct workspace/backend is confirmed and the action is safe.

## Authoritative checkpoint
This lesson has not started. Begin after completing Lesson 2 — Terraform Workflow.


## Session checkpoint — 2026-10-28: state hygiene and cleanup safety

### Practical scenario: retire an obsolete lab safely
A team has an old Terraform-managed environment that is no longer needed. The task is to prove scope and dependencies, review the deletion plan, obtain approval, retire only the intended resources, and preserve unrelated labs and state.

**Lessons:**
- Terraform configuration, state, and the real Azure resources are related but distinct. Never remove a state file to delete cloud resources.
- A terraform destroy plan is a high-impact proposal; inspect every target and confirm subscription, backend, workspace and resource group before approval.
- After retirement, verify the intended resources are absent and unrelated environments remain. Archive inactive configuration outside Terraform's loaded .tf and .tf.json files so it cannot be treated as active configuration.
- Protect state files (chmod 600 where appropriate), ignore state and backup files in Git, and normally commit .terraform.lock.hcl.

### Evidence from the learner's lab cleanup
- Learner confirmed the old rg-practice-lab environment was destroyed after reviewing a plan listing 51 resources.
- Old root-level Terraform files were moved to vm-practice/_archive/ with the .tf.disabled suffix.
- The separate vm-practice/hub-spoke-lab and rg-tf-lab-prashant-dev learning environment are to be preserved.
- This is recorded as completed cleanup based on the learner's confirmation; no new cleanup command was run during this documentation update.

### Practice / next step
Continue with a prediction-first, read-only exercise about configuration versus state. For a future cleanup drill, use a disposable local-only configuration and review a destroy plan without applying it. Lesson status remains IN PROGRESS until independent explanation, a fresh exercise, and troubleshooting evidence are demonstrated.

**Safety:** Never apply/destroy or make impactful Azure changes without explicit approval. Confirm target subscription/backend/workspace and exact plan each time.

## Practical session checkpoint — 2026-10-29

### Lab verified
- Working directory: `~/azure-lab/terraform-hcl-practice`.
- Terraform v1.17.0; AzureRM provider v4.81.0.
- No backend/cloud block was found in this directory's `.tf` files; a local `terraform.tfstate` file exists with owner-only permissions.
- `terraform state list` returned `azurerm_resource_group.lab`.
- `terraform state show azurerm_resource_group.lab` displayed the tracked resource group's name, `centralindia` location, and three expected tags.

### Exercise and evidence
- Compared `main.tf` against the state output; the address, resource group name, location, and tags matched.
- Prediction: changing the `environment` tag from `dev` to `test` should cause an in-place update. Learner reported that `terraform plan` proposed one tag change; no apply was performed.
- Restored the tag to `dev`, ran `terraform fmt`, `terraform validate`, and `terraform plan`; learner reported no changes.
- Interview recall: learner correctly described `plan` as previewing proposed changes and `apply` as executing changes against the target provider.

### Current status
Lesson 3 remains **IN PROGRESS**. The concepts above are practised in this lab, not fully mastered. Next: one small practical exercise distinguishing configuration, state, and live Azure, then a troubleshooting drill and a concise interview explanation. Preserve the existing learning resource group and state; no apply/destroy or state mutation without explicit approval.



## Practical session checkpoint — 2026-10-30: drift and refresh-only planning

### Environment confirmed
- Working directory: `~/azure-lab/terraform-hcl-practice`.
- No `backend` or `cloud` block in this directory; state is local in `terraform.tfstate`.
- State address: `azurerm_resource_group.lab`.
- State inspection recorded `rg-tf-lab-prashant-dev` in `centralindia`, with tags `environment=dev`, `managed_by=terraform`, and `purpose=learning-lab`.
- Read-only Azure CLI verification confirmed the live resource group matched those configured/state values.

### Exercise and evidence
- Learner predicted that changing the configured `environment` tag from `dev` to `test` would result in an in-place update; reported plan output showed one tag change. No apply was run.
- Restored the tag to `dev`; `terraform fmt`, `terraform validate`, and a normal `terraform plan` completed, with the plan reporting no changes.
- Learner described drift as an external change to infrastructure (for example, through the Azure portal) that differs from Terraform's expected values.
- Learner correctly chose to change `main.tf` to `test` and run plan if `test` is the intended value to retain.
- A `terraform plan -refresh-only` showed saved state recorded `environment=test` while live Azure reported `environment=dev`. It previewed a state refresh and explicitly did not propose undoing the external change in Azure.
- No `terraform apply -refresh-only` was run; therefore the refresh-only result was not explicitly persisted to the state file.
- A later ordinary `terraform plan` refreshed its in-memory view from Azure and reported no changes because live Azure matched configuration. Ordinary plan alone does not persist a refreshed state snapshot.

### Key distinction
- **Refresh-only plan:** previews how state would be updated to reflect observed remote objects; does not change remote infrastructure.
- **Refresh-only apply:** persists the refreshed state snapshot; it is a state update, not an infrastructure correction.
- **Ordinary plan:** refreshes remote objects for planning and compares the refreshed view with configuration; it may propose infrastructure changes when configuration differs from live reality. Running plan alone does not persist the refreshed snapshot.

### Status and next exercise
Lesson 3 remains **IN PROGRESS**. The learner demonstrated drift reasoning and interpreted the refresh-only output for this scenario; further independent explanation and troubleshooting are still required. Next, ask the learner to explain in their own words why saved state can differ from live Azure and distinguish the three operations above, then practise a concise interview response.

**Safety:** No apply, destroy, state mutation, or Azure resource change occurred in this session. Preserve `rg-tf-lab-prashant-dev` and its local state. No state mutation, backend migration, or impactful Azure operation without fresh explicit approval.


## Final session checkpoint — 2026-11-01: Lesson 3 completed

### Topics completed and demonstrated
- **Configuration, state, and real infrastructure:** explained that Terraform state records Terraform's mapping to managed objects; it does not recreate missing configuration.
- **Missing resource configuration:** correctly predicted that when a resource declaration is removed while its state entry remains, Terraform plans to destroy that resource, assuming required provider configuration remains available. If provider configuration is also missing, planning may instead fail with a configuration/provider error.
- **Resource address changes:** used a `moved` block to describe the address change from `azurerm_resource_group.lab` to `azurerm_resource_group.learning`. The learner ran plan and reported `0 to add, 0 to change, 0 to destroy`. **No apply was run**, so the move was planned but not persisted to state.
- **Terraform label vs Azure name:** distinguished changing a Terraform resource label/address from changing the actual Azure resource name. A label move does not rename the Azure resource; changing the actual resource name may require replacement depending on provider behavior.
- **`moved` block vs `terraform state mv`:** discussed declarative, version-controlled address migration with a `moved` block versus a manual state operation with `terraform state mv`.
- **State recovery:** correctly described restoring a valid protected state backup as the preferred recovery path. If no backup exists, recreate/verify configuration and import existing resources with `terraform import`; large environments require careful resource-by-resource reconciliation.
- **State security:** correctly explained that state may contain secrets and sensitive infrastructure details; local state is acceptable for isolated practice when protected, while team environments should use a secure remote backend with encryption, restricted access and RBAC. If exposed publicly, treat secrets as compromised, rotate them, investigate access, and remove exposed state from repository history where possible. Deleting the file in a later commit does not erase Git history.
- **`terraform state rm` vs `terraform destroy`:** correctly explained that `state rm` removes Terraform's tracking entry but leaves the real Azure resource intact; `destroy` deletes managed infrastructure when the operation succeeds and updates state accordingly. After `state rm`, a later plan may propose creating the resource again if its configuration remains.

### Assessment
- Final assessment: all three scenario exercises answered correctly, with sound reasoning.
- Final distinction question (`state rm` vs `destroy`): answered correctly.
- **Lesson status: COMPLETED.** The learner demonstrated conceptual understanding in prediction-based explanations. This is a learning checkpoint, not a claim that every Terraform state recovery operation has been performed hands-on.

### Environment and safety boundary
- Practice workspace: `~/azure-lab/terraform-hcl-practice`; local state, no backend/cloud block in this workspace. Keep it distinct from `vm-practice/hub-spoke-lab`, which uses a separate Azure Storage backend.
- The moved-block plan was reviewed only; no apply was performed, so do not claim the state address migration was committed.
- No state deletion, import, state mutation, apply, destroy, backend migration, or Azure resource change was performed for this assessment.
- Preserve `rg-tf-lab-prashant-dev`, its state, and `vm-practice/hub-spoke-lab`. No impactful Azure action without fresh explicit approval.

### Next lesson
Proceed to **Lesson 4 — Dependencies and Execution Order**. Do not repeat the introductory `depends_on` material already covered in Lesson 1.17; build on it by studying Terraform's dependency graph, implicit dependencies from references, execution ordering/concurrency, and when explicit dependencies are genuinely needed.
