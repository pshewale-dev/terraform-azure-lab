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


## `flatten()` (2026-10-25)

Verified in Terraform Console:

```hcl
flatten([
  ["apple", "banana"],
  ["mango", "orange"]
])
```

Output is a single list: `apple`, `banana`, `mango`, `orange` in the same order. `flatten()` removes nested list structure; it does not change the values. Try a deeper nesting example before considering the concept mastered.


### Deeper nesting and real-world pattern (2026-10-25)
A deeper nested-list expression was verified to produce the flat list `dev`, `test`, `prod` in order. In real Terraform configurations, `flatten()` is often used to turn nested infrastructure data (for example, subnets with nested security rules) into one list of objects. When creating resources with `for_each`, reshape that list into a map with unique keys because `for_each` does not accept a list of objects directly.


## `toset()` (2026-10-25)

Verified in Terraform Console:

```hcl
toset(["dev", "test", "dev", "prod"])
```

The result contains each unique string once (`dev`, `prod`, `test` in the displayed output). The duplicate is removed; a set does not guarantee the input order. Practise one fresh example before considering this mastered.


### `toset()` follow-up (2026-10-25)
Second verified console example:

```hcl
toset(["web", "app", "web", "app"])
```

Output contains only `app` and `web`. The learner correctly predicted two unique values. Set order is not guaranteed. Revisit `toset()` later when learning `for_each`.
