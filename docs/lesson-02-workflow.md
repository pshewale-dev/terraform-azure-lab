# Lesson 2 — Terraform Workflow

**Course position:** Lesson 2 of 13.  
**Purpose:** Understand the workflow commands that prepare, check, and preview a Terraform configuration before any infrastructure changes.

## Lesson objectives
- Explain what `terraform init` prepares.
- Distinguish initialization from validation and planning.
- Run safe checks only after inspecting the working directory and backend.
- Read command output and explain what it does—and does not—prove.

## Lesson 2.1 — Purpose of `terraform init`

Terraform needs to prepare a working directory before other workflow commands can reliably use its configuration and dependencies. `terraform init` initializes the working directory, including the configured backend and required providers/modules.

It does **not** create the declared Azure resources. Resource changes are reviewed through a plan and require a separately authorized apply operation.

### Prediction exercise

You open a Terraform project containing `.tf` files that has not been initialized. What is the primary purpose of `terraform init`?

- A. Create all Azure resources declared in the files.
- B. Prepare the working directory and initialize the configured backend and required providers/modules.
- C. Check the configuration for syntax errors only.
- D. Generate a plan without initializing the working directory.

**Pause here and predict before checking the explanation.**

<details>
<summary>Check the answer after making your prediction</summary>

**Correct answer: B.** Initialization prepares the working directory, backend, and dependencies. It does not deploy the resources.

</details>

### Safe verification notes
- First inspect the current directory and Terraform configuration.
- Do not run `terraform init` blindly in the repository root: the existing lab uses an Azure Storage backend.
- Use `terraform-hcl-practice/` for isolated examples where appropriate.
- Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.

## Lesson 2.2 — Next
After the learner answers Lesson 2.1, continue with `terraform validate`: what it checks and what a successful validation does not prove.

## Authoritative checkpoint
- **Current lesson:** Lesson 2 — Terraform Workflow.
- **Current concept:** 2.1 — Purpose of `terraform init`.
- **Status:** Prediction exercise presented; answer not yet recorded.
- **Next step:** Ask the learner for their prediction, then explain and proceed to `terraform validate`.
