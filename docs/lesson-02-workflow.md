# Lesson 2 — Terraform Workflow

**Course position:** Lesson 2 of 13.  
**Purpose:** Practise the workflow commands that prepare, check, preview, and safely apply Terraform configuration.

## Lesson objectives
- Explain what `terraform init` prepares.
- Distinguish initialization, formatting, validation, planning, and applying.
- Inspect a plan before deployment and verify the result.
- Understand how state tracks an Azure resource.

## Lesson 2.1 — `terraform init`

`terraform init` prepares a working directory, including the configured backend and required providers/modules. It does **not** create the declared Azure resources.

### Prediction exercise
You open a Terraform project containing `.tf` files that has not been initialized. What is the primary purpose of `terraform init`?

- A. Create all Azure resources declared in the files.
- B. Prepare the working directory and initialize the configured backend and required providers/modules.
- C. Check the configuration for syntax errors only.
- D. Generate a plan without initializing the working directory.

**Correct answer: B.** The learner selected B and explained/continued through the practical workflow.

### Lab evidence
- Initial no-resource configuration: `terraform init` returned success. Repeated directory listings did not show `.terraform/`; this anomaly was not resolved and must not be described as resolved.
- Later Azure resource-group configuration: AzureRM provider requirement added; init reported success.

## Lesson 2.2 — `terraform fmt` and `terraform validate`

- `terraform fmt` formats Terraform configuration consistently.
- `terraform validate` checks syntax and internal consistency; it does not prove that Azure authentication, permissions, quotas, or deployment will succeed.
- Learner reported formatting and validation succeeded for the Azure resource-group configuration.

## Lesson 2.3 — `terraform plan`

A plan previews proposed changes. It does not apply them.

- The no-resource practice configuration returned no changes because it contained variables and local values but no resource blocks.
- Learner correctly predicted that validation can pass while planning can still reveal provider, state, permissions, or remote infrastructure issues.
- `terraform plan -refresh=false` was used for the no-resource exercise. Reminder: skipping refresh is not a reliable check that existing infrastructure matches configuration.

## Lesson 2.4 — First real Azure Resource Group

### Scenario
Create a dedicated development resource group in Central India, inspect the plan, apply only after review, and verify the resulting resource.

### Configuration concept
The configuration declared:
- Required Terraform version `>= 1.5.0`.
- Provider source `hashicorp/azurerm`, version constraint `~> 4.0`.
- An `azurerm` provider configuration targeting the selected subscription.
- Resource address `azurerm_resource_group.lab`.
- Azure name `rg-tf-lab-prashant-dev`, location `Central India`.
- Tags: `environment = "dev"`, `managed_by = "terraform"`, `purpose = "learning-lab"`.

Never publish subscription identifiers or credentials in learning notes. The actual subscription ID is intentionally omitted here.

### Verified outcome (2026-10-28)
- Azure CLI 2.83.0 was available; the selected subscription was enabled.
- `az group exists --name rg-tf-lab-prashant-dev` returned `false` before creation.
- Learner reported `terraform init`, `terraform fmt`, and `terraform validate` succeeded.
- Initial plan showed one resource to add. The learner corrected tag key/value typos before applying.
- The learner explicitly approved applying the plan.
- Apply result: `Resources: 1 added, 0 changed, 0 destroyed`.
- `az group show` verified the resource group in `centralindia` with the three expected tags.
- `terraform state list` returned `azurerm_resource_group.lab`.
- Subsequent `terraform plan` reported “No changes. Your infrastructure matches the configuration.”

### Production lessons
- `resource "azurerm_resource_group" "lab"` creates the Terraform address `azurerm_resource_group.lab`; `lab` is a Terraform local label, not the Azure resource name.
- Changing a local label after the resource is in state changes its address. Without a state move, Terraform may plan destroy/create. A suitable `moved` block can preserve the object when only its address changes.
- `.terraform.lock.hcl` records provider selections and hashes; it is not Terraform state.
- Configuration, state, and real Azure infrastructure are distinct and must be compared deliberately.

## Safety rules
- Inspect the directory and backend before initialization.
- Review the exact plan before applying.
- Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.
- Preserve the resource group created in this lab unless a future, specific change is approved.
- Keep the existing Azure Storage backend and its remote state untouched.

## Current checkpoint
- **Lesson 2:** workflow concepts practised and lab verified; not marked globally mastered.
- **Next lesson:** Lesson 3 — State and Resource Addresses.
- **Pending prediction:** If `main.tf` is deleted but Terraform state remains, what happens? The learner has not answered yet.
- **Next action:** Ask for the prediction, then inspect state read-only with `terraform state list` and `terraform state show azurerm_resource_group.lab`. Do not delete files to simulate the scenario.
