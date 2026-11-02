# Lesson 5 — Drift and Lifecycle

**Course position:** Lesson 5 of 13  
**Phase:** 2 — Terraform Core Concepts  
**Session status:** IN PROGRESS — drift and refresh-only concepts practised with read-only Azure plans; final integrated assessment and lifecycle review remain.

## Objectives
- Explain drift between Terraform configuration and live infrastructure.
- Distinguish configuration, state, and the remote object.
- Predict how Terraform plans to reconcile drift.
- Explain the purpose and trade-offs of common lifecycle meta-arguments.
- Safely inspect refresh-only plans without changing Azure resources.

## 1. Configuration, state, and live infrastructure

These are three distinct things:
- **Configuration:** the desired settings written in Terraform files.
- **State:** Terraform's recorded mapping and last-known attributes for managed objects.
- **Live infrastructure:** the actual object currently present in Azure.

A manual Portal change can make live infrastructure differ from the desired configuration. During planning, Terraform refreshes its view of remote objects and compares the result with configuration.

### Demonstrated prediction: tag changed from `dev` to `test`
- Configuration expected `environment = "dev"`.
- A person changed the actual Azure tag to `test`.
- Learner correctly predicted that `terraform plan` would propose changing the tag back to `dev`.
- Terminology clarification: the administrator changed the live Azure resource, not Terraform state.

### Demonstrated prediction: tag deleted in Portal
- Configuration still expected `environment = "dev"`.
- The tag was absent from the live resource.
- Learner correctly predicted Terraform would propose restoring it.
- Wording clarification: this is generally **1 to change** (an in-place resource update), not 1 to add, because the resource already exists.

### Drift that requires replacement
Learner correctly reasoned that a location mismatch may require resource replacement when the provider marks that attribute as replacement-only. Terraform follows the configured desired location, not the manually changed location. For the example discussed, configuration remained `Central India`, so the replacement target would be Central India, not East US. Exact behavior depends on the resource/provider schema; do not assume every location property is mutable or replace-only.

## 2. Lifecycle meta-arguments introduced

Lifecycle rules are written inside a resource block and influence how Terraform plans resource changes.

### `prevent_destroy`
```hcl
lifecycle {
  prevent_destroy = true
}
```
- Rejects a plan that would destroy the resource while this rule is present in configuration.
- Does not ignore drift and does not prevent normal in-place updates.
- It is not a permanent Azure-side lock. If the resource block (and its lifecycle rule) is removed from configuration, this protection no longer applies to that removed block.

Learner correctly selected that a replacement requiring destruction is blocked and reported as an error while `prevent_destroy` is active. Learner also correctly predicted that removing the rule allows Terraform to propose replacement again, subject to provider behavior and configuration.

### `create_before_destroy`
```hcl
lifecycle {
  create_before_destroy = true
}
```
- Requests create-new-before-destroy-old ordering for a replacement.
- Learner correctly identified the order: create the new VM first, then destroy the old VM.
- Both objects must be able to coexist. Azure quota/capacity, globally unique names, IPs, and other constraints may prevent this strategy or require configuration changes.

### `ignore_changes`
```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```
- Tells Terraform to ignore differences in the selected attribute(s) when planning updates.
- Other managed attributes continue to be checked.
- It does not mean Terraform stops managing the whole resource.
- It can hide unwanted external changes; use only when another process/team intentionally owns those attributes.

Learner correctly explained that tag differences are ignored while other attributes continue to be checked.

### `replace_triggered_by` — conceptual introduction only
```hcl
lifecycle {
  replace_triggered_by = [
    azurerm_network_interface.app
  ]
}
```
- Can cause this resource to be replaced when a referenced managed resource or attribute has a planned change.
- Only introduced conceptually; no code was written or tested for this setting.

## 3. Assessment evidence from this session

Learner independently answered the following prediction questions:
1. External tag changed from `dev` to `test`: correctly predicted Terraform would plan to restore `dev`.
2. Tag deleted in Portal: correctly predicted Terraform would restore the missing tag; understood it is an in-place change rather than a new resource.
3. Location drift where provider requires replacement: correctly predicted replacement; clarified that the configured location determines the replacement target.
4. `prevent_destroy = true`: initially considered ignoring the difference, then self-corrected and correctly stated that Terraform blocks a plan requiring destruction.
5. `ignore_changes = [tags]`: correctly explained that tag differences are ignored while other attributes remain managed.
6. `create_before_destroy = true`: correctly identified create-new-first, destroy-old-second.

**Status:** These concepts are UNDERSTOOD / PRACTISED based on the answers above. Lesson 5 is not complete yet: refresh-only planning, a safe practical inspection, and a final integrated assessment remain.

## 4. Refresh-only planning — practised 2026-11-02

On 2026-11-02, the learner ran both commands in `~/azure-lab/terraform-hcl-practice`:

- `terraform plan` refreshed its view of Azure and proposed an in-place resource-group tag update from live `Production` to configured `dev`: **0 to add, 1 to change, 0 to destroy**.
- `terraform plan -refresh-only` reported the external resource-group tag difference in the opposite direction (`dev` in prior state to `Production` in Azure) and explained that it would not undo the remote change. It also surfaced provider/API-reported subnet and VNet attribute differences (`service_endpoints`, `service_endpoint_policy_ids`, and nested subnet properties); these were observations, not proof that an administrator manually changed them.
- The learner correctly explained that refresh-only previews updating Terraform state to reflect Azure, while normal plan proposes reconciling Azure with configuration.
- The learner correctly answered that running another normal plan after a refresh-only **plan** still proposes `Production` → `dev`, because a plan does not persist the refreshed state.
- No `terraform apply -refresh-only` was run. No state update was persisted and no Azure resource was changed.

### Key distinction
- `terraform plan`: previews proposed infrastructure changes to make remote resources match configuration.
- `terraform plan -refresh-only`: previews state changes to make Terraform's recorded values match remote infrastructure.
- `terraform apply -refresh-only`: persists refreshed values to state; it does not change remote infrastructure. Not run in this session.

## 5. Manually deleted and unmanaged resources — conceptual assessment
- If a resource remains in configuration and state but is manually deleted from Azure, a normal plan generally proposes recreating it.
- If a resource exists in Azure but is absent from both configuration and state, Terraform normally does not manage or automatically delete/import it.
- The learner explained why importing a business-critical existing resource is preferable to recreating it: avoid downtime, preserve existing application configuration, and reduce rebuild effort.
- The learner understood that import associates an existing remote object with a Terraform resource address in state, while matching `.tf` configuration must still be written separately.
- The learner correctly refused a hypothetical production plan showing `0 to add, 0 to change, 1 to destroy`, explaining that the unexpected destruction must be investigated before approval.
- No resource was deleted or imported. No `terraform import` command was run.

## 6. Next steps and safety
- Complete a final integrated assessment, then review lifecycle meta-arguments with practical examples, beginning with `prevent_destroy`.
- Do not mark Lesson 5 complete until the integrated assessment is passed.
- Keep all further exercises read-only unless the learner gives fresh, explicit approval for a specific state-changing or Azure-impacting operation.

## Environment and safety guardrails

- Repository: `pshewale-dev/terraform-azure-lab`, branch `main`.
- Workspace: `~/azure-lab/terraform-hcl-practice`.
- Terraform version last recorded: `1.17.1`; AzureRM provider: `4.81.0`.
- This practice workspace uses local state; do not confuse it with `vm-practice/hub-spoke-lab`, which uses a separate Azure Storage backend.
- Preserve `rg-tf-lab-prashant-dev`, its VNet, subnet, storage account, and local Terraform state, plus the separate hub-and-spoke lab.
- No `terraform apply`, `terraform destroy`, state mutation, import, backend migration, or impactful Azure operation without fresh explicit approval.
- Keep exercises read-only and avoid unnecessary Azure spend.

## Teaching approach
Continue one concept at a time, prediction-first, with concise explanations and small practical exercises. Avoid long multiple-choice chains and unnecessary command-output requests. Do not mark Lesson 5 complete until the pending refresh-only exercise and final assessment are demonstrated.
