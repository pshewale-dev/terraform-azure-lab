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
