# Terraform HCL Practice

A small, isolated lab for practising Terraform HCL without configuring an Azure backend or creating Azure resources.

## Files

- `practice.tf`: local values, references, string interpolation, map lookup, and a conditional expression.
- `variables.tf`: a validated environment input, a list of allowed regions, and a map of environment labels.
- `versions.tf`: minimum Terraform version.
- `terraform.tfvars.example`: safe example input values.

## Run locally

Copy the example variable file to a local file (ignored by Git):

```bash
cp terraform.tfvars.example terraform.tfvars
terraform fmt
terraform init
terraform validate
terraform console
```

At the console, try `var.environment`, `var.allowed_regions[0]`, `var.environment_tags[var.environment]`, and `local.resource_name`. Exit with `exit`.

This lab is for configuration and expression practice only. Do not run `terraform apply` or `terraform destroy` for these exercises. The repository's Azure infrastructure configurations are separate from this isolated directory.


## HCL expressions covered (2026-10-25)

Logical operator examples:
```hcl
is_prod_or_dev = (
  var.environment == "prod" ||
  var.environment == "dev"
)
is_non_production = !local.is_production
```

List transformation and filtering:
```hcl
[for region in var.allowed_regions : upper(region)]
[for region in var.allowed_regions : region if region != "centralindia"]
```

Map transformation and filtering:
```hcl
{
  for region in var.allowed_regions :
  region => upper(region)
  if region == "centralindia"
}
```

The names introduced after `for` (such as `region`) are temporary iteration variables. Square brackets produce a list; curly braces with `key => value` produce a map. A trailing `if` filters the output.

Continue the current conditional-map exercise in `terraform console`; keep this directory isolated and do not apply or destroy infrastructure.


## Conditional map expressions and filters (2026-10-25)

Conditional value, verified in Terraform Console:
```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
}
```
Output: `centralindia = "primary"`, `westindia = "secondary"`.

Filter and transform, also verified:
```hcl
{
  for region in var.allowed_regions :
  region => upper(region)
  if region != "centralindia"
}
```
Output:
```hcl
{
  "westindia" = "WESTINDIA"
}
```

The `if` clause filters entries, `upper()` transforms the value, and the original region remains the key. Continue with console-only practice; do not apply or destroy infrastructure.


## Combined conditional map and filter (2026-10-25)

Verified in Terraform Console:

```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
  if region != "westindia"
}
```

Output:

```hcl
{
  "centralindia" = "primary"
}
```

The trailing `if` excludes `westindia`; the conditional selects the value for each entry that remains. This exercise is verified, but the topic is still practised rather than marked mastered. Continue with isolated console practice only; do not apply or destroy infrastructure.
