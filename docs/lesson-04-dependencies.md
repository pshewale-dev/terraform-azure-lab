# Lesson 4 — Dependencies and Execution Order

**Course position:** Lesson 4 of 13  
**Status:** COMPLETED — 2026-11-01  
**Phase:** Phase 2 — Terraform Core Concepts

## Learning objectives

- Explain implicit dependencies created by resource references.
- Read Terraform's dependency graph and describe execution order.
- Understand which independent resources Terraform can create concurrently.
- Use `depends_on` only when a dependency cannot be expressed through a normal reference.
- Apply dependency concepts to a small Azure network deployment.

## 1. Implicit dependencies

Terraform creates an implicit dependency when one resource argument references an attribute of another resource.

Example from the Azure lab:

```hcl
resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.20.1.0/24"]
}
```

The reference `azurerm_virtual_network.app.name` tells Terraform that the subnet depends on the VNet. Terraform does not infer a dependency merely because two literal strings happen to match.

The VNet and storage account also reference the resource group:

```hcl
location            = azurerm_resource_group.lab.location
resource_group_name = azurerm_resource_group.lab.name
```

Those references establish their dependencies on the resource group.

## 2. Dependency graph and execution order

The lab's graph showed these edges:

- `azurerm_storage_account.app -> azurerm_resource_group.lab`
- `azurerm_virtual_network.app -> azurerm_resource_group.lab`
- `azurerm_subnet.app -> azurerm_virtual_network.app`

In this graph representation, an edge points from the dependent resource to its prerequisite. Read the execution flow in the opposite direction:

```text
Resource Group
   ├── Virtual Network
   │      └── Subnet
   │
   └── Storage Account
```

After the resource group is ready, the VNet and storage account are independent and can be processed concurrently. The subnet must wait for the VNet.

Terraform builds and traverses the dependency graph; it does not simply execute resource blocks in file order.

## 3. Explicit dependencies

The `depends_on` meta-argument declares a dependency that Terraform cannot infer from an ordinary resource reference. Avoid adding it when a normal reference already expresses the relationship, because unnecessary dependencies can restrict parallel execution.

The introductory `depends_on` concept was covered earlier in Lesson 1.17. Lesson 4 reinforced it in the context of the graph and a real deployment.

## 4. Hands-on Azure lab

**Workspace:** `~/azure-lab/terraform-hcl-practice`  
**Region:** `centralindia`  
**Existing resource group:** `rg-tf-lab-prashant-dev`

The learner configured these resources in `networking.tf`:

- `azurerm_virtual_network.app`
  - Name: `vnet-dependency-lab`
  - Address space: `10.20.0.0/16`
- `azurerm_subnet.app`
  - Name: `snet-app`
  - Address prefix: `10.20.1.0/24`
  - References the VNet name, creating an implicit dependency.
- `azurerm_storage_account.app`
  - Name: `stdepprashant2026`
  - Standard / LRS.
  - References the existing resource group.

A CIDR typo was corrected before deployment. The learner confirmed the complete plan looked correct. The plan was reviewed as **3 to add, 0 to change, 0 to destroy**. The learner then ran `terraform apply` and reported successful resource creation.

Reported `terraform state list` output:

```text
azurerm_resource_group.lab
azurerm_storage_account.app
azurerm_subnet.app
azurerm_virtual_network.app
```

This confirms the four resource addresses were present in the local Terraform state after deployment. The resource group was pre-existing; the three networking/storage resources were added in this lesson.

## 5. Commands practised

```bash
terraform fmt
terraform validate
terraform plan
terraform graph
terraform apply
terraform state list
```

The learner reported successful formatting/validation and a reviewed plan. The graph was inspected to understand dependencies. The learner ran the apply after reviewing the plan and confirmed the resulting state addresses.

## 6. Assessment and demonstrated understanding

**Final question:** If the VNet address space changes, does Terraform know the subnet depends on the VNet, and why?

**Learner's answer:** The subnet depends on the VNet because the configuration contains an implicit reference in `networking.tf`.

**Assessment:** Correct. The learner identified the resource reference `azurerm_virtual_network.app.name` as the source of the dependency. Clarification recorded: changing the VNet CIDR does not itself create the dependency; the reference does.

Demonstrated understanding:
- Resource references create implicit dependency edges.
- Literal names that happen to match do not create dependency edges.
- The resource graph determines ordering rather than file order.
- Independent resources can run concurrently after their shared prerequisite is ready.
- A subnet waits for its referenced VNet.
- The graph's displayed edge direction is dependent-to-prerequisite; execution proceeds prerequisite-to-dependent.

**Status:** Lesson 4 completed. The concepts were explained, applied in a real Azure lab, and assessed with a correct final explanation. This is evidence of understanding in this lesson, not a claim of permanent mastery across every dependency scenario.

## 7. Safety and cost notes

- The lab used the dedicated learning resource group in the learner's Azure trial subscription.
- No virtual machine, gateway, or other compute resource was added in this exercise.
- Preserve the resource group and the resources created here unless the learner explicitly approves a specific change or deletion.
- Do not run another `terraform apply`, `terraform destroy`, state mutation, backend migration, or impactful Azure operation without fresh explicit approval.
- Keep the separate `vm-practice/hub-spoke-lab` and its Azure Storage backend/state untouched.

## Next lesson

**Lesson 5 — Drift and Lifecycle.**

Start with one prediction-first scenario about a configuration value differing from the live Azure value. Distinguish configuration, state, and remote infrastructure; then inspect a safe plan and discuss lifecycle behavior. Do not repeat Lesson 4 unless a short recall check is useful.
