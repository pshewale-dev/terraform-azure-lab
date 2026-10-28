# Hands-on Production-Style Labs

**Purpose:** Every numbered lesson must include a practical lab, not just definitions. The labs build toward a realistic Azure production platform: consistent naming and tags, segmented networking, controlled access, reusable modules, remote state, CI/CD, observability, and safe change management.

These are **production-pattern learning labs**, not permission to modify a live production subscription. Use a dedicated non-production subscription/resource group or local-only exercises. Start with plan/review; do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval. Never point a practice configuration at the existing Azure Storage backend unless the exact backend and state impact have been reviewed and approved.

## Lab rules for every lesson

Each lab must contain:
1. **Real-world ticket/story** — what an infrastructure team has been asked to deliver.
2. **Architecture and trade-off** — why the resources and controls exist.
3. **Small build task** — learner writes or changes a small part; no giant copy-paste exercise.
4. **Prediction first** — predict the plan/result before running a command.
5. **Verification** — exact safe command(s), expected evidence, and what the evidence does not prove.
6. **Failure drill** — one realistic fault and a troubleshooting path.
7. **Security/cost/safety check** — least privilege, secret handling, cost exposure, and change blast radius.
8. **Cleanup plan** — only execute cleanup after explicit approval; otherwise document what would be removed.
9. **Evidence and status** — record learner's code, command output, explanation, and any weak area. Chat predictions are not the same as command-verified results.

Target **30 minutes per session**: 5 minutes recall/design, 15 minutes hands-on, 5 minutes verify/troubleshoot, 5 minutes interview explanation. A lab may span multiple sessions; do not rush or claim mastery.

## Lab environment and safety tiers

- **Tier 0 — local-only:** HCL expressions, `terraform console`, formatting, validation, plans against mock/local-safe configurations. No cloud resources.
- **Tier 1 — isolated Azure sandbox:** a dedicated non-production subscription and uniquely named resource group, budgets/alerts where available, restricted region and resource types. Use only after the learner confirms the target subscription and approval.
- **Tier 2 — production-pattern design review:** review architecture, security, plans, pipeline approvals and recovery procedures without applying changes to production.

Before any cloud lab, verify the active subscription, tenant, identity, backend, workspace, resource group, and estimated costs. Never put credentials or secrets in source control or plain-text tfvars. Use approved identity federation/managed identity and Key Vault patterns where appropriate.

## The 13 practical labs

### Lab 1 — Turn a manual resource request into HCL
**Production story:** The platform team needs a consistent resource group naming/tagging convention for dev, test, and prod.

**Build:** In a local-only folder, define typed variables for environment and location, locals for a naming convention and mandatory tags, and outputs for the calculated names/tags. Keep the first iteration to expressions; then add a minimal Azure resource configuration for plan-only review if a safe sandbox is approved.

**Verify:** `terraform fmt -check`, `terraform validate` (after safe initialization when needed), and inspect variable/output values. Explain why valid HCL does not prove cloud resources exist.

**Failure drill:** Supply an unsupported environment or omit a required value. Add a validation rule and explain the error.

**Evidence:** Learner changes one naming rule independently and explains how inconsistent names/tags affect operations and cost reporting.

### Lab 2 — Workflow: safely review an infrastructure change
**Production story:** A change request adds a tag and a subnet to an application environment.

**Build:** Use an isolated local lab configuration; practise the sequence `init`, `fmt`, `validate`, `plan`. Do not connect to a production backend or apply changes.

**Verify:** Identify the purpose and limits of each command; read the plan for create/update/delete/replace actions.

**Failure drill:** Introduce a deliberate syntax/type error, predict which check should catch it, then repair it.

**Evidence:** Learner explains why a successful plan is a proposal, not a deployment, and identifies any destructive or replacement action.

### Lab 3 — State and resource addresses
**Production story:** A resource label is being renamed and the team must avoid accidental recreation.

**Build:** In a disposable local-only state lab, create a tiny local resource or equivalent safe example, inspect `terraform state list` and resource addresses, and compare a configuration rename with a state-aware move plan. Do not use the existing Azure-backed state.

**Verify:** Explain the relationship between configuration, state address, and real object identity. Use `terraform state show` only against the disposable lab.

**Failure drill:** A configuration address no longer matches state. Diagnose the proposed plan and describe when a reviewed `moved` block is appropriate.

**Evidence:** Learner can explain the address before and after a rename and why state edits need care.

### Lab 4 — Dependencies and execution order
**Production story:** A private endpoint depends on a subnet and DNS configuration; a deployment must respect the dependency graph.

**Build:** Model a small network dependency in HCL, first using natural attribute references and then compare a case where an explicit dependency is justified. Avoid creating Azure resources unless sandbox approval exists.

**Verify:** Generate and inspect `terraform graph` where supported, and explain which edge is inferred from a reference.

**Failure drill:** A hidden operational dependency is not represented by a value reference. Decide whether `depends_on` is justified and state its limits.

**Evidence:** Learner distinguishes data dependency from mere desired ordering and avoids adding unnecessary explicit dependencies.

### Lab 5 — Drift and lifecycle safety
**Production story:** Someone manually changes an NSG tag or rule outside Terraform and a later plan detects drift.

**Build:** Use a local/mock example to inspect how configuration and state can differ. Review lifecycle settings such as `prevent_destroy` and `ignore_changes` conceptually before using them.

**Verify:** Read a plan and classify intended correction, in-place update, replacement, and deletion.

**Failure drill:** A broad `ignore_changes` hides a security-relevant rule change. Explain why this is risky and propose a narrower alternative.

**Evidence:** Learner explains how to investigate drift and why blindly applying a plan can overwrite an intentional emergency change.

### Lab 6 — Remote state, locking and recovery
**Production story:** Multiple engineers and an Azure DevOps pipeline need a shared state file with access controls.

**Build:** Draw and review an Azure Storage backend design: dedicated state storage, restricted network/access, encryption, least-privilege identity, versioning/recovery controls where configured, and state separation by environment. Do not initialize against or change the existing backend for practice.

**Verify:** Review backend configuration with secrets omitted; explain locking, concurrent runs, state sensitivity, and why state is not ordinary source code.

**Failure drill:** A pipeline cannot access the backend or reports a lock. Follow a diagnostic checklist; do not force-unlock without confirming ownership and impact.

**Evidence:** Learner can describe a safe recovery sequence and what must be verified before any state recovery action.

### Lab 7 — Variables, locals, outputs and environment contracts
**Production story:** Dev/test/prod share one module but differ in size, address space, and availability requirements.

**Build:** Define typed inputs, validation for allowed CIDR/environment values, locals for common tags/names, and outputs for integration points. Keep secret values out of committed tfvars.

**Verify:** Use safe sample values and inspect plan/output structure without exposing sensitive values.

**Failure drill:** An invalid CIDR or missing required variable reaches planning. Improve validation and explain which checks happen before resource creation.

**Evidence:** Learner explains the difference between input contract, internal calculation, and exported output.

### Lab 8 — Collections, for_each, dynamic blocks and data sources
**Production story:** An application platform needs multiple subnets and NSG rules from a maintainable map rather than duplicated resource blocks.

**Build:** Model two subnets and a small set of named rules with maps/objects. Convert stable logical keys to `for_each`; use a dynamic block only where a nested provider block needs iteration. Use a data source only when looking up a resource managed elsewhere.

**Verify:** Predict resource addresses and the effect of adding or renaming a map key before reviewing the plan.

**Failure drill:** A list index shifts or duplicate keys appear. Explain why stable keys are important and choose between `count` and `for_each`.

**Evidence:** Learner independently adds one subnet/rule and predicts the address-level change.

### Lab 9 — Reusable modules
**Production story:** Several application teams need the same secure network pattern with controlled variation.

**Build:** Create a small module interface for a resource group/network pattern, with typed inputs and outputs; call it from a root module. Keep provider/backend configuration in the appropriate root layer.

**Verify:** Review the module tree, input/output contracts, naming, tags, and plan shape. No apply required.

**Failure drill:** A child module expects an input the caller does not supply, or a module output is referenced incorrectly. Diagnose the validation/plan error.

**Evidence:** Learner can explain what belongs in a module and what should remain environment-specific.

### Lab 10 — Azure networking: hub-and-spoke baseline
**Production story:** An organization separates shared services from application spokes and needs controlled east-west connectivity.

**Build:** Design a hub VNet and two spokes with non-overlapping CIDRs, subnets, NSGs, explicit peering, and a documented route/DNS strategy. Start with an architecture diagram and a plan-only configuration. Use the existing Hub-and-Spoke lab for read/review only unless changes are explicitly approved.

**Verify:** Check CIDR overlap, peering directionality, naming, tags, and intended traffic paths. Review the plan for unexpected replacements.

**Failure drill:** Peering exists but traffic fails. Troubleshoot address spaces, peering flags, routes, NSGs, DNS and appliance paths in a deliberate order.

**Evidence:** Learner traces a packet path and explains which control allows or denies it.

### Lab 11 — Compute, identity and secrets
**Production story:** A Linux application VM needs administrative access, monitoring, and secret retrieval without credentials embedded in Terraform.

**Build:** Design a VM with SSH-key-based access, managed identity, least-privilege RBAC, and Key Vault access. Use a sandbox plan only after approval; never commit private keys or secret values.

**Verify:** Review network exposure, public IP necessity, inbound SSH source restrictions, identity scope, and whether any plan output could reveal sensitive data.

**Failure drill:** The VM cannot read a secret. Check identity assignment, role scope, access model, propagation, network/private endpoint/DNS and audit evidence.

**Evidence:** Learner explains why managed identity is preferable to storing a service principal secret in configuration.

### Lab 12 — Git and Azure DevOps Terraform CI/CD
**Production story:** Platform changes must be reviewed, validated and approved before they can affect infrastructure.

**Build:** Create a pipeline design or YAML for formatting, validation, security/lint checks where available, plan artifact publication, and a protected approval gate before any apply stage. Use secure workload identity and protected variables/service connections.

**Verify:** Demonstrate a pull-request workflow and identify which identity can access state and which stage could change infrastructure. The initial lab must stop before apply.

**Failure drill:** A PR changes a production CIDR or plan includes a deletion. Make the pipeline publish evidence and require human review rather than automatically applying.

**Evidence:** Learner explains branch/PR controls, plan review, approval boundaries, credentials, and why an untrusted PR must not receive production credentials.

### Lab 13 — Production-style capstone and incident drill
**Production story:** Deliver a repeatable baseline for a fictional production application: hub/spoke network, segmented subnets/NSGs, Linux compute design, managed identity, Key Vault integration, monitoring hooks, remote-state design, and gated pipeline.

**Build:** Start from a requirements sheet and architecture diagram. Organize root/module structure, inputs/outputs, naming/tags, environment separation, state design, and pipeline gates. Work in stages; the capstone is not a single copy-paste task.

**Verify:** Run safe static checks and inspect a saved plan in a dedicated sandbox only when approved. Write a pre-deployment checklist and rollback/recovery notes.

**Failure drill:** Choose one: unexpected replacement, state lock, provider authentication failure, subnet overlap, or identity access denied. Troubleshoot from evidence, not guesses.

**Evidence:** Learner presents architecture decisions, a plan review, a security review, troubleshooting notes, and an interview-style explanation. Mastery requires independent work and evidence, not merely completing the page.

## Required lab completion record

For each lab, update `LEARNING-PROGRESS.md` with:
- **Status:** NOT STARTED / IN PROGRESS / PREDICTION ONLY / COMMAND VERIFIED / REVIEWED / MASTERED.
- **Work performed:** exact files/changes and commands actually run.
- **Evidence:** learner's prediction, actual output/plan excerpt (redacted), and explanation.
- **Failure drill:** symptom, diagnostic steps, root cause if confirmed, and fix.
- **Next step:** the smallest independent task still pending.

Never label a lab COMMAND VERIFIED unless the command was actually run and its output supplied or observed. Never label a lab MASTERED without independent implementation, explanation, and troubleshooting evidence.


## Cross-cutting production exercise — retire an obsolete environment safely

Use this scenario across Lessons 3, 5, 6, 12 and 13. The objective is not merely to run destroy; it is to demonstrate controlled change management.

1. Identify the exact subscription, tenant/identity, backend, workspace, resource group, and environment owner.
2. Confirm whether the resources are managed by this configuration/state and check for shared dependencies or resources managed elsewhere.
3. Generate and review a destroy plan in a disposable lab or approved sandbox. List every target, replacement/deletion, and cost or dependency concern. Stop if the scope is unexpected.
4. Obtain explicit approval for the exact plan and target scope before executing any destructive action.
5. After approved cleanup, verify the intended resources are absent and unrelated environments still exist. Record redacted evidence and any remaining external resources or charges.
6. Keep the state/backend until the retirement and recovery/audit requirements are satisfied. Never delete state as a way to remove cloud resources.
7. Archive inactive configuration so Terraform does not load it as active configuration; preserve useful code/history and document what was retired.

**Observed case study (learner-confirmed):** the old rg-practice-lab environment was destroyed after a plan listing 51 resources, and old root-level configuration files were moved to vm-practice/_archive/ with the .tf.disabled suffix. The separate vm-practice/hub-spoke-lab and rg-tf-lab-prashant-dev learning lab are out of scope and must be preserved. No new Azure operation is performed by documenting this case.
