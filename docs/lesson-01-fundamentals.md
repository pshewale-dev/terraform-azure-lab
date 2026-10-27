# Lesson 1 — Terraform Fundamentals

**Purpose:** Build a clear understanding of Terraform before moving
into more complex Azure configurations.

**Previous checkpoint:** Lesson 1.17 — Explicit dependencies (`depends_on`) — UNDERSTOOD based on the recorded answers below.
**Current checkpoint:** See the single authoritative checkpoint at the end of this page.

---

## 1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool.

You describe the infrastructure you want in configuration files.
Terraform uses the configuration, state and information about real
infrastructure to determine which changes may be required.

Terraform uses providers to interact with platforms such as Microsoft
Azure.

### Why use Terraform?

- Describe infrastructure as code.
- Review proposed changes before execution.
- Store configuration in Git.
- Reuse configuration across environments.
- Manage relationships between resources.

### Remember

Saving a `.tf` file does not deploy infrastructure.
Terraform must be run through the appropriate workflow.

---

## 2. Declarative versus imperative

### Declarative approach

Describe the desired end state.

Example: Declare that a resource group should exist.

Terraform determines the operations needed to reach the desired state.

### Imperative approach

Describe the sequence of operations to perform.

Example: Run commands in a particular order to create infrastructure.

### Interview point

Terraform is primarily declarative. You describe what you want,
and Terraform calculates the required operations.

---

## 3. Desired state, actual state and Terraform state

### Desired state

What your Terraform configuration declares should exist.

### Actual state

What exists in the real infrastructure.

### Terraform state

Terraform's record of managed resource identities and tracked
attributes.

Terraform uses configuration, state and information gathered from
the infrastructure to calculate proposed changes.

A plan may propose adding, updating or deleting resources.

### Remember

A proposed change is not the same as a completed change.

---

## 4. Terraform workflow

### `terraform init`

Initializes the working directory, configures the backend and installs
required providers and modules.

### `terraform validate`

Checks whether the configuration is structurally valid.

It does not guarantee that Azure permissions, quotas or remote
operations will succeed.

### `terraform plan`

Calculates and displays proposed changes.

Review the plan before deciding whether changes should be applied.

Planning does not itself execute the proposed infrastructure changes.

### `terraform apply`

Executes infrastructure changes according to the configuration,
plan and approval or automation behavior.

**Lab safety rule:** Do not run `terraform apply` without explicit
approval.

### `terraform destroy`

Requests removal of resources managed by the configuration and state.

**Lab safety rule:** Do not run `terraform destroy` without explicit
approval.

---

## 5. Terraform state

Terraform state records the relationship between managed resources
and real infrastructure objects, along with tracked information.

### Why state matters

- Helps Terraform identify resources it manages.
- Records resource identities and tracked attributes.
- Supports change calculation.
- Can contain sensitive information and must be protected.

### Remote state

Remote state stores Terraform state in a remote backend rather than
only in a local state file.

Team workflows commonly use remote state to share state and coordinate
work. Backend capabilities and locking behavior depend on the backend.

### Best practices

- Restrict access to state.
- Protect state backups.
- Never commit state files containing sensitive data to a public repo.
- Do not manually edit or delete state as a routine troubleshooting
  technique.

### Interview question

**Why does Terraform need state?**

It records the resources Terraform manages and helps Terraform map
configuration to real infrastructure when calculating changes.

---

## 6. Infrastructure drift

Drift occurs when real infrastructure changes outside the Terraform
workflow and no longer matches the expected configuration or recorded
state.

Example: Someone changes an Azure network security rule directly
through the Azure portal.

A subsequent plan may reveal differences and propose changes.
The result depends on the configuration, provider behavior, state
and current infrastructure.

### Remember

Do not automatically apply a plan just because drift is detected.
Review the proposed changes first.

### Interview question

**How would you investigate Terraform drift?**

Review the configuration and state, inspect the real infrastructure,
and run a plan to understand the proposed changes before taking action.

---

## 7. Providers

A provider is a plugin that allows Terraform to interact with a
platform or service.

The AzureRM provider manages supported Azure resources.

Example:

```hcl
provider "azurerm" {
  features {}
}
```

This configures the AzureRM provider. It does not create an Azure
resource by itself.

### Remember

A provider enables Terraform to communicate with a platform.
A resource block declares an object to manage.

---

## 8. Resources and local labels

A resource block declares an infrastructure object Terraform should
manage.

Example:

```hcl
resource "azurerm_resource_group" "demo" {
  name     = "rg-example-lab"
  location = "Central India"
}
```

### Explanation

- resource declares a resource block.
- azurerm_resource_group is the resource type.
- demo is the Terraform-local label.
- name and location are resource arguments.
The Terraform resource address is `azurerm_resource_group.demo`.

The label demo is not necessarily the name of the Azure resource.

This is a learning example. Do not apply it without reviewing the
target subscription, configuration and state.

---

## 9. Resource arguments

Arguments provide configuration values to a resource.

Example:

```hcl
name     = "rg-example-lab"
location = "Central India"
```

Here, name and location are arguments.

The accepted arguments depend on the provider's resource type.

### Interview question

What is a resource argument?

A configuration value supplied to a resource block.

---

## 10. Resource attributes

Attributes are values exposed by resources or data sources.

Other parts of a Terraform configuration can reference these values.

For example, a resource may expose an ID that another resource can
use instead of hardcoding that ID.

### Arguments versus attributes

- Arguments configure a resource.
- Attributes expose values that can be read and referenced.

---

## 11. Input variables

Input variables allow a module to accept values instead of hardcoding
every configuration value.

Example:

```hcl
variable "location" {
  type    = string
  default = "Central India"
}
```

Reference the variable using:

```hcl
location = var.location
```

### Explanation

- variable "location" declares an input variable.
- type = string specifies its type.
- default supplies a default value.
- var.location references the variable.
Variables improve reusability. They are not automatically a secure
storage mechanism for secrets.

---

## 12. Outputs

Outputs expose selected values from a Terraform module.

Example:

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.demo.name
}
```

This output references the resource's name attribute.

Outputs can display useful values or expose values from child modules
to their callers.

Avoid exposing sensitive values unnecessarily.

---

## 13. Data sources

A data source reads information about an existing object or retrieves
information from a provider.

Example:

```hcl
data "azurerm_resource_group" "existing" {
  name = "rg-practice-lab"
}
```

This block looks up an existing resource group. It does not declare
a new resource group.

The lookup requires the resource to exist and the provider to have
appropriate access.

### Resource versus data source

- resource: declares an object Terraform manages.
- data: reads information about an object or provider result.

---

## 14. Local values — locals

Local values assign reusable names to expressions inside a module.

Example:

```hcl
locals {
  environment = "lab"
  name_prefix = "tf-${local.environment}"
}
```

References use local.environment and local.name_prefix.

Input variables accept values supplied to a module. Local values
define reusable expressions within the configuration.

Use locals when you want to reuse a calculated or derived value.

---

## 15. Implicit dependencies

Terraform can infer dependencies when one resource references an
attribute of another resource.

Example:

```hcl
resource "azurerm_resource_group" "demo" {
  name     = "rg-example-lab"
  location = "Central India"
}

resource "azurerm_virtual_network" "demo" {
  name                = "vnet-example-lab"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.20.0.0/16"]
}
```

The virtual network references the resource group's location and name.

Terraform can infer that the resource group must be available before
the dependent virtual network operation.

This is an implicit dependency.

---

## 16. Explicit dependencies — `depends_on`

Use depends_on to declare a dependency when Terraform cannot infer
the required relationship from normal references.

Conceptual example:

```hcl
resource "example_resource" "dependent" {
  depends_on = [example_resource.prerequisite]
}
```

This is a conceptual example, not a usable Azure resource block.
The resource types and arguments must be valid for the actual provider.

`depends_on` declares a dependency for ordering operations. It does
not copy values and does not tell Terraform to ignore the prerequisite.

Use explicit dependencies only when a real dependency exists that
Terraform cannot infer from ordinary references.

Unnecessary dependencies can restrict Terraform's ability to perform
independent operations concurrently.

### Assessment result

Status: UNDERSTOOD

Evidence:
- Correctly identified that the dependent resource waits for the prerequisite's required operations according to Terraform's dependency graph.
- Correctly explained that `depends_on` is appropriate when Terraform cannot infer a real dependency from normal resource references.

Lesson 1.17 is understood based on these answers. Continue to the next roadmap topic only after checking existing HCL syntax and configuration-structure coverage.

---

## 17. Quick revision table

| Concept | Key point |
|---|---|
| Terraform | Infrastructure as Code tool |
| Declarative | Describe the desired end state |
| `init` | Initialize the working directory |
| `validate` | Check configuration structure |
| `plan` | Preview proposed changes |
| `apply` | Execute infrastructure changes |
| `destroy` | Request removal of managed resources |
| State | Records managed resource mappings and tracked information |
| Drift | Difference between expected and observed infrastructure |
| Provider | Connects Terraform to a platform |
| Resource | Declares an object Terraform manages |
| Argument | Configures a resource |
| Attribute | A value exposed by a resource or data source |
| Variable | Accepts an input value |
| Output | Exposes a selected value |
| Data source | Reads information from a provider |
| Local value | Names a reusable expression |
| Implicit dependency | Inferred from references |
| Explicit dependency | Declared with `depends_on` |

---

## 18. Interview practice

Try answering these without reading the notes.

1. What problem does Terraform solve?
2. What is Infrastructure as Code?
3. What is the difference between declarative and imperative approaches?
4. What is the difference between `terraform plan` and `terraform apply`?
5. Why does Terraform need state?
6. What is infrastructure drift?
7. What is a provider?
8. What is the difference between a resource argument and an attribute?
9. Why use input variables?
10. What are outputs used for?
11. What is the difference between a resource and a data source?
12. What are local values?
13. How does Terraform infer an implicit dependency?
14. When might you use depends_on?
15. Does saving a `.tf` file deploy infrastructure?
16. Why should Terraform state be protected?

### Interview confidence tracker

Track each answer as:

- Not attempted
- Practicing
- Confident

Mark an answer confident only when you can explain it clearly in
your own words.

## Lesson 1.17 — Explicit Dependencies: Knowledge Check Record

**Status: UNDERSTOOD**

### Key idea
Terraform infers dependencies from normal resource references when possible. Use `depends_on` only when a real dependency exists that Terraform cannot infer from those references.

### Knowledge-check evidence
- Prediction: `depends_on = [example_resource.prerequisite]` means the dependent resource's required operations wait for the prerequisite according to the dependency graph.
- Follow-up: an explicit dependency is useful when Terraform cannot infer the relationship from a direct resource reference.

### Next step
Review the existing notes for HCL syntax and configuration structure, then teach any uncovered material one concept at a time with a prediction-first question.



---

## 19. HCL syntax and configuration structure — hands-on notes (2026-10-24)

These exercises were completed in the isolated local directory `~/terraform-hcl-practice`, not in the Azure-backed root configuration.

### Blocks and arguments
A `locals` block is written as `locals { ... }` (plural). Values inside the block are named assignments. Terraform loads all `.tf` files in the same directory as one module; putting a practice file next to an existing root `main.tf` would cause it to join that root module. An isolated directory avoids loading the Azure backend and infrastructure resources.

### Local values, references, and expressions
Example:
```hcl
locals {
  region        = "centralIndia"
  resource_name = "${var.environment}-${local.region}-web"
}
```
- `local.region` refers to a local value.
- `var.environment` refers to an input variable.
- `${...}` interpolates an expression within a string.
- A direct reference such as `environment_copy = local.environment` is different from the literal string `"local.environment"`.
- Local values are reusable expressions; changing a referenced input changes the derived expression result.

### Input variables, defaults, and overrides
```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["prod", "dev", "test"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
```
- `var.environment` references the input variable.
- The default is used when no higher-precedence input supplies a value.
- In the exercises, `terraform.tfvars` set `environment = "test"`; the console returned `"test"`.
- `terraform console -var="environment=prod"` overrides the tfvars value for that invocation.
- Validation checks the actual condition, not the human-readable error message. A temporary allowed-list typo rejected `prod`; correcting the list fixed the rule.
- If a variable has no default and no value is supplied, Terraform requires an input when an operation needs it.

### Lists and maps
```hcl
variable "allowed_regions" {
  type    = list(string)
  default = ["centralindia", "westindia"]
}

variable "environment_tags" {
  type = map(string)
  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}
```
- `length(var.allowed_regions)` returns the number of list elements.
- List indexes are zero-based: index `0` is `centralindia`, index `1` is `westindia`; index `2` is out of range for this two-element list.
- A map lookup uses its key: `var.environment_tags["test"]` returns `"Testing"`.
- A dynamic lookup can use a variable: `var.environment_tags[var.environment]`.

### Conditional expressions
```hcl
is_production = var.environment == "prod"
instance_size = var.environment == "prod" ? "large" : "small"
```
- `==` compares values and produces a Boolean.
- A conditional uses `condition ? value_if_true : value_if_false`.
- For `environment = "prod"`, `is_production` is `true` and `instance_size` is `"large"`; for `test`, the condition is false and the size is `"small"`.

### Verification and safety
- The learner reported `terraform validate` success in the isolated practice directory.
- Terraform Console was used to evaluate expressions without deploying infrastructure.
- The practice directory has no Azure backend configuration.
- Keep the real local `terraform.tfvars` out of Git; commit an example file instead.
- Do not run `terraform apply` or `terraform destroy` for these exercises.

### Next lesson
Logical operators (`&&`, `||`, `!`). Begin with the prediction for an AND expression when `environment = "test"` and `region = "centralIndia"`; continue one operator at a time.


---

## 20. Logical operators and conditional expressions — hands-on notes (2026-10-25)

These exercises were practised in the isolated `terraform-hcl-practice/` directory. No Azure resources were deployed or modified.

### Logical operators

- `A && B`: AND — both conditions must be true.
- `A || B`: OR — at least one condition must be true.
- `!A`: NOT — reverses a Boolean value.
- `==` compares for equality; `!=` means not equal.
- Evaluate parentheses first, then the Boolean conditions, then combine the results.

Examples:
```hcl
is_india_production = (
  var.environment == "prod" &&
  lower(local.region) == "centralindia"
)

is_prod_or_dev = (
  var.environment == "prod" ||
  var.environment == "dev"
)

is_non_production = !local.is_production
```

With `environment = "test"` and `region = "centralIndia"`, the first expression is `false`: the production comparison is false even though the normalized region comparison is true.

The learner verified these console values for `environment = "test"`:
- `local.is_non_production` → `true`
- `local.is_prod_or_dev` → `false`
- `local.is_allowed_deployment` → `false`

A CLI override can test another input without changing the tfvars file:
`terraform console -var="environment=dev"`. The combined OR/conditional expression returned `"standard"` for this invocation.

### Conditional expressions with logical operators

General syntax:
```hcl
condition ? value_if_true : value_if_false
```

Example:
```hcl
(
  var.environment == "prod" || var.environment == "dev"
) ? "standard" : "small"
```

- With `environment = "test"`, result: `"small"`.
- With `environment = "dev"`, result: `"standard"`.

### List `for` expressions

Transform each item:
```hcl
[for region in var.allowed_regions : upper(region)]
```

Filter items:
```hcl
[for region in var.allowed_regions : region if region != "centralindia"]
```

Transform and filter in one expression:
```hcl
[for region in var.allowed_regions : upper(region) if region == "westindia"]
```

Prefix a string using interpolation:
```hcl
[for region in var.allowed_regions : "azure-${region}"]
```

The iteration name (`region`, `env`, `label`, or `fruit`) is introduced by the `for` expression. It is a temporary iteration variable and does not need to be declared in `variables.tf`.

### Map `for` expressions

Iterate over a map's key and value:
```hcl
{
  for env, label in var.environment_tags :
  upper(env) => upper(label)
}
```

- `{ ... }` with `key => value` produces a map; `[ ... ]` produces a list.
- `=>` separates the resulting map key from its value.
- Key and value expressions can be transformed independently.
- A trailing `if` filters entries from the resulting map.

Create a map from a list and filter it:
```hcl
{
  for region in var.allowed_regions :
  region => upper(region)
  if region == "centralindia"
}
```

Verified console result:
```hcl
{
  "centralindia" = "CENTRALINDIA"
}
```

### Current exercise / next step

Predict the value for `westindia` in:
```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
}
```

Ask the learner to predict first, then test in `terraform console`. Do not mark `for` expressions mastered solely from multiple-choice answers; continue with a small learner-written exercise.


## Map `for` expressions — conditional values and filtering (2026-10-25)

A map `for` expression can choose a value conditionally for each item and filter which items appear in the result.

With `var.allowed_regions = ["centralindia", "westindia"]`:

```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
}
```

Verified in Terraform Console:

```hcl
{
  "centralindia" = "primary"
  "westindia"    = "secondary"
}
```

- `region` becomes each list item in turn.
- `region => ...` uses that item as the map key.
- The conditional chooses `"primary"` for `centralindia` and `"secondary"` otherwise.

Filtering and transforming at the same time:

```hcl
{
  for region in var.allowed_regions :
  region => upper(region)
  if region != "centralindia"
}
```

Verified result:

```hcl
{
  "westindia" = "WESTINDIA"
}
```

The trailing `if` excludes `centralindia`; `upper(region)` transforms the remaining value while the key stays `"westindia"`. Continue using independent exercises before calling map `for` expressions mastered.


## Map `for` expression — conditional value plus filter (2026-10-25)

With `var.allowed_regions = ["centralindia", "westindia"]`, the learner ran this combined expression in Terraform Console:

```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
  if region != "westindia"
}
```

Verified console output:

```hcl
{
  "centralindia" = "primary"
}
```

How it works:
- `for region in var.allowed_regions` iterates through both region names.
- The conditional expression chooses `"primary"` for `centralindia`, otherwise `"secondary"`.
- The trailing `if region != "westindia"` excludes `westindia` from the result, so only the `centralindia` entry remains.

Important distinction: the filter controls whether an entry appears; the conditional controls the value of an entry that remains. This exercise was verified successfully, but continue using fresh examples before marking the concept mastered.


## `flatten()` — flatten nested lists (2026-10-25)

`flatten()` takes a list containing nested lists and returns a single-level list. The learner predicted the concept and verified this example in Terraform Console:

```hcl
flatten([
  ["apple", "banana"],
  ["mango", "orange"]
])
```

Result:

```hcl
[
  "apple",
  "banana",
  "mango",
  "orange",
]
```

It removes nested list structure without renaming, sorting, or dropping the elements. Verify understanding with a deeper nesting example before marking the function mastered.


### Deeper nesting and practical use of `flatten()` (2026-10-25)
A nested-list example with another level of nesting was verified in Terraform Console and returned `dev`, `test`, `prod` as one list, preserving order.

A common Terraform pattern is to flatten nested infrastructure configuration, such as a list of subnets each containing a list of security rules, into a single list of objects. Each object can retain context such as its subnet name. If the final goal is `for_each`, remember that `for_each` generally needs a map or a set of strings, not a list of objects; transform the flattened list into a map with unique keys.


## `toset()` — convert a list to a set (2026-10-25)

`toset()` converts a list to a set, removing duplicate values. The learner predicted and verified this expression in Terraform Console:

```hcl
toset(["dev", "test", "dev", "prod"])
```

The output contained `dev`, `prod`, and `test` once each. Terraform displayed a different order from the input. A set does not guarantee element order, so avoid relying on it when order matters. This concept is introduced and verified with one example; test a fresh example before marking it mastered.


### `toset()` follow-up (2026-10-25)
A second independent example was verified in Terraform Console:

```hcl
toset(["web", "app", "web", "app"])
```

Output:

```hcl
toset([
  "app",
  "web",
])
```

The learner correctly predicted two unique values. This reinforces that duplicates are removed and a set does not guarantee input order.


## `distinct()` — unique list elements (2026-10-26)

The learner verified in Terraform Console:

```hcl
distinct(["web", "app", "web", "db", "app"])
```

Output:

```hcl
tolist([
  "web",
  "app",
  "db",
])
```

The duplicate elements are removed while the order of first occurrences is preserved. The learner also compared this with `toset()` on the same input, which returned the unique strings in a different displayed order. Summary: `distinct()` returns an ordered list; `toset()` returns a set whose order is not guaranteed.


## `length()` — count elements or characters (2026-10-26)

First list example verified in Terraform Console:

```hcl
length(["web", "app", "db"])
```

Output: `3`. The function counts the three list elements. Next, verify its behaviour on a string, where it counts characters.


### `length()` on strings and lists (2026-10-26)
Verified in Terraform Console:

```hcl
length(["web", "app", "db"]) # 3
length("terraform")            # 9
```

Rule: `length()` counts list elements when given a list, and characters when given a string. A list containing strings counts the list items, not all the letters combined; for example, `length(["terraform", "azure"])` returns `2`.


### `length()` final check (2026-10-26)
Verified in Terraform Console:

```hcl
length(["terraform", "azure"])
```

Output: `2`. The list has two elements; Terraform does not add up the characters in the two strings. `length()` has now been tested on a list, a single string, and a list containing strings.


## `contains()` — check for a value in a collection (2026-10-26)

Verified in Terraform Console:

```hcl
contains(["dev", "test", "prod"], "test")
```

Output: `true`, because `"test"` is present in the list. `contains()` returns a Boolean: `true` when the value is found and `false` when it is absent. Next, test a value that is not in the list.


### `contains()` — both Boolean outcomes (2026-10-26)
Both cases were verified in Terraform Console:

```hcl
contains(["dev", "test", "prod"], "test")  # true
contains(["dev", "test", "prod"], "stage") # false
```

`contains()` returns `true` for an exact value present in the list and `false` when the value is absent.


## `lookup()` — retrieve a value from a map (2026-10-26)

Verified in Terraform Console:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "prod")
```

Output: `"large"`. The key `prod` maps to the value `large`. `lookup()` retrieves a map value by key; unlike `contains()`, it does not merely test whether a value is present. Next, explore a missing key and the optional default argument.


### `lookup()` with a default value (2026-10-26)

Verified in Terraform Console:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "test", "medium")
```

Output: `"medium"`. Since `test` is not a key in the map, Terraform returns the third argument as the default. If the requested key exists, `lookup()` returns its mapped value instead.


### `lookup()` existing key with a default (2026-10-26)
Learner correctly predicted that this expression returns `"small"`:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "dev", "medium")
```

Because `dev` exists, Terraform returns its mapped value. The default is used only if the key is missing. Await console verification for this final example.


### `lookup()` checkpoint closed (2026-10-26)
Final example verified in Terraform Console:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "dev", "medium")
```

Output: `"small"`. Since `dev` exists, the mapped value is returned and the default is ignored. Combined with the verified missing-key example, this completes the introductory `lookup()` exercise.


## `coalesce()` — first non-null value (2026-10-26)

Verified in Terraform Console:

```hcl
coalesce(null, null, "dev", "prod")
```

Output: `"dev"`. `coalesce()` returns the first non-null argument, evaluating from left to right. It skips the two `null` values and returns `"dev"`; it does not continue to `"prod"` after finding a non-null value. Verify a fresh example before marking the concept complete.


### `coalesce()` follow-up (2026-10-26)
Verified in Terraform Console:

```hcl
coalesce(null, "test", "prod")
```

Output: `"test"`. Since `test` is the first non-null argument, `prod` is not returned. Two examples now confirm the first-non-null behaviour.


## `join()` — combine a list of strings (2026-10-26)

Verified in Terraform Console:

```hcl
join("-", ["dev", "east", "01"])
```

Output: `"dev-east-01"`. `join()` combines the list elements into a single string, placing the first argument as the separator between elements. Test a fresh example with a different separator to reinforce the concept.


### `join()` follow-up (2026-10-26)

Verified in Terraform Console:

```hcl
join("/", ["subscriptions", "resourceGroups", "vnet"])
```

Output: `"subscriptions/resourceGroups/vnet"`. The `/` separator is inserted between elements; it is not added before the first element or after the last. This is the second verified `join()` example.


## `split()` — split a string into a list (2026-10-26)

Verified in Terraform Console:

```hcl
split("-", "dev-east-01")
```

Output:

```hcl
tolist([
  "dev",
  "east",
  "01",
])
```

`split(separator, string)` divides the input string at each occurrence of the separator and returns a list of strings. `tolist(...)` is Terraform Console's display of the list result; it is not an extra wrapper required in the expression.


## String functions: `split()`, `replace()`, and `upper()` (2026-10-26)

Verified in Terraform Console:

```hcl
split("-", "dev-east-01")
# => tolist(["dev", "east", "01"])

replace("dev-east-01", "east", "west")
# => "dev-west-01"

replace("web-web-web", "web", "app")
# => "app-app-app"

replace("dev-east-01", "-", "/")
# => "dev/east/01"

upper("dev-east-01")
# => "DEV-EAST-01"

upper("Azure DevOps 2026")
# => "AZURE DEVOPS 2026"
```

- `split(separator, string)` splits a string at each separator and returns a list of strings. Terraform Console displays this as `tolist([...])`; that is not an extra wrapper required in the expression.
- `replace(string, substring, replacement)` replaces all occurrences of the matching substring and leaves other characters unchanged.
- `upper(string)` converts letters to uppercase; spaces, punctuation, and digits remain unchanged.
- Reference only: `lower(string)` is the counterpart that converts letters to lowercase. A separate `lower()` exercise was intentionally skipped at the learner's request.

## `format()` — build a formatted string (2026-10-26)

`format(format_string, values...)` builds a string by replacing format specifiers with the supplied values.

Prediction practice (not yet verified in Terraform Console):

```hcl
format("%s-%s-%s", "dev", "east", "01")
# => "dev-east-01"

format("%s-%02d", "web", 3)
# => "web-03"

format("%s-%02d", "app", 12)
# => "app-12"

format("%s-%02d", "vm", 7)
# => "vm-07"
```

- `%s` inserts a string value.
- `%d` formats an integer as a decimal number.
- `%02d` formats an integer with a minimum width of two characters, padding with a leading zero when needed. For example, `7` becomes `07`, while `12` remains `12`.
- The width is a minimum, not a maximum.

**Learning status:** Practised through four prediction examples. Console verification is still pending, so this function is not yet marked mastered. To verify safely, open Terraform Console in the isolated HCL practice directory and enter each expression; no Azure deployment is needed.

## `trimspace()` — remove leading and trailing whitespace (2026-10-26)

Verified in Terraform Console:

```hcl
trimspace("   dev-east-01   ")
```

Output: `"dev-east-01"`. The whitespace at the beginning and end is removed. Whitespace inside the string is preserved; for example, the space in `"Azure DevOps"` would remain.

**Learning status:** One example verified in Terraform Console. Continue with a fresh example before considering the concept mastered.

## Terraform built-in string function reference (checked 2026-10-26)

Terraform has built-in functions for transforming, formatting, splitting, searching, and checking strings. The table below focuses first on functions that are practical in everyday Terraform and Azure DevOps work. Function availability can depend on the Terraform language/runtime version; check the official documentation for your installed version.

### Commonly useful functions

| Function | What it does | Example | Result |
|---|---|---|---|
| `lower(string)` | Converts letters to lowercase | `lower("DEV-East")` | `"dev-east"` |
| `upper(string)` | Converts letters to uppercase | `upper("dev-east")` | `"DEV-EAST"` |
| `title(string)` | Uppercases the first letter of each word | `title("azure devops")` | `"Azure Devops"` |
| `trimspace(string)` | Removes whitespace from both ends | `trimspace("  dev  ")` | `"dev"` |
| `trim(string, cutset)` | Removes any characters in the cutset from both ends | `trim("!!dev!!", "!")` | `"dev"` |
| `trimprefix(string, prefix)` | Removes a matching prefix from the start | `trimprefix("env-dev", "env-")` | `"dev"` |
| `trimsuffix(string, suffix)` | Removes a matching suffix from the end | `trimsuffix("main.tf", ".tf")` | `"main"` |
| `replace(string, search, replacement)` | Replaces every matching substring; slash-delimited search can be a regex | `replace("dev-east", "east", "west")` | `"dev-west"` |
| `split(separator, string)` | Splits a string into a list | `split("-", "dev-east-01")` | `["dev", "east", "01"]` |
| `join(separator, list)` | Joins list elements into one string | `join("-", ["dev", "east", "01"])` | `"dev-east-01"` |
| `format(spec, values...)` | Formats values into a string | `format("%s-%02d", "web", 3)` | `"web-03"` |
| `startswith(string, prefix)` | Tests whether a string begins with a prefix | `startswith("prod-web", "prod-")` | `true` |
| `endswith(string, suffix)` | Tests whether a string ends with a suffix | `endswith("main.tf", ".tf")` | `true` |
| `strcontains(string, substring)` | Tests whether a string contains a substring | `strcontains("prod-web", "web")` | `true` |
| `substr(string, offset, length)` | Extracts part of a string by character offset and length | `substr("terraform", 0, 4)` | `"terr"` |
| `chomp(string)` | Removes newline characters at the end | `chomp("hello\\n")` | `"hello"` |

### Advanced or situational functions

| Function | What it does | When to use it |
|---|---|---|
| `formatlist(spec, values...)` | Formats values into a list of strings | Build consistently formatted labels or names from parallel lists |
| `indent(number, string)` | Adds indentation to each line except the first | Prepare multiline text |
| `regex(pattern, string)` | Returns matches for a regular expression | Extract or validate a pattern when simpler functions are insufficient |
| `regexall(pattern, string)` | Returns all regex matches | Extract multiple matches |
| `strrev(string)` | Reverses a string | Rare/specialized transformations |
| `templatestring(template, vars)` | Evaluates a string as a Terraform template with supplied variables | Specialized dynamic-template scenarios; use carefully |

**Practical learning order:** `trimspace()`, `lower()` / `upper()`, `replace()`, `split()` / `join()`, `format()`, prefix/suffix checks and removals, then `substr()` and regex functions. Don't try to memorize every function at once—learn by using realistic examples and verifying them in Terraform Console.

**Important distinctions:**
- `trimspace()` removes whitespace; `trim()` removes any characters in its second-argument cutset from the ends.
- `split()` returns a list; `join()` turns a list of strings into one string.
- `replace()` can use a regular expression when the search argument is wrapped in forward slashes.
- `startswith()`, `endswith()`, and `strcontains()` return booleans, not modified strings.

Official reference: [Terraform built-in functions — String functions](https://developer.hashicorp.com/terraform/language/functions).


## HCL string-function combinations — checkpoint (2026-10-26)

Recent prediction-first practice (answers were provided by the learner; these examples were not reported as console-verified in this session):

```hcl
replace(lower("PROD-east-vm"), "prod", "test")
# => "test-east-vm"

replace("dev-dev-prod", "dev", "test")
# => "test-test-prod"

join("-", split("/", "dev/east/01"))
# => "dev-east-01"

lower(format("%s-%s", "APP", "PROD"))
# => "app-prod"

upper(substr("terraform", 0, 4))
# => "TERR"

trimsuffix(trimprefix("dev-east-vm", "dev-"), "-vm")
# => "east"

startswith("prod-east-vm", "prod-") && endswith("prod-east-vm", "-vm")
# => true

!strcontains("dev-east-vm", "prod")
# => true

startswith("dev-east-vm", "prod-") || endswith("dev-east-vm", "-vm")
# => true

strcontains("prod-east-vm", "east") && !strcontains("prod-east-vm", "dev")
# => true

startswith(replace("dev-east-vm", "dev", "prod"), "prod-")
# => true

substr(format("%s-%s", "azure", "devops"), 6, 6)
# => "devops"

length(split("-", "dev-east-vm"))
# => 3

length("dev-east-vm")
# => 11
```

### Concepts demonstrated in predictions
- Nested functions are evaluated from the inside out; the inner result becomes the outer function's argument.
- `replace()` replaces all occurrences of its search substring and is case-sensitive.
- `split()` produces a list; `join()` combines list elements with the selected separator.
- `format()` builds a string; `lower()` and `upper()` change letter case.
- `substr(string, offset, length)` uses a zero-based offset and a character count.
- `trimprefix()` removes a matching leading prefix; `trimsuffix()` removes a matching trailing suffix.
- `startswith()`, `endswith()`, and `strcontains()` return Boolean values.
- `&&` means AND, `||` means OR, and `!` means NOT.
- `length()` counts characters in a string and elements in a list.

These are successful multiple-choice predictions, not proof of mastery or console verification. Continue with independent examples and console checks before marking functions mastered.


## Checkpoint update — 2026-10-26 (continued HCL function practice)

Prediction-first examples correctly answered in this session:

```hcl
replace(lower("PROD-east-vm"), "prod", "test")
# => "test-east-vm"

replace("dev-dev-prod", "dev", "test")
# => "test-test-prod"

join("-", split("/", "dev/east/01"))
# => "dev-east-01"

lower(format("%s-%s", "APP", "PROD"))
# => "app-prod"

upper(substr("terraform", 0, 4))
# => "TERR"

trimsuffix(trimprefix("dev-east-vm", "dev-"), "-vm")
# => "east"

startswith("prod-east-vm", "prod-") && endswith("prod-east-vm", "-vm")
# => true

!strcontains("dev-east-vm", "prod")
# => true

startswith("dev-east-vm", "prod-") || endswith("dev-east-vm", "-vm")
# => true

strcontains("prod-east-vm", "east") && !strcontains("prod-east-vm", "dev")
# => true

startswith(replace("dev-east-vm", "dev", "prod"), "prod-")
# => true

substr(format("%s-%s", "azure", "devops"), 6, 6)
# => "devops"

length(split("-", "dev-east-vm"))
# => 3

length("dev-east-vm")
# => 11
```

### Understanding demonstrated
- Correct predictions involving nested functions evaluated from the inside out.
- Correctly applied case-sensitive replacement of all matching occurrences, split/join, formatting and case conversion, substring offset/length, prefix/suffix removal, Boolean string checks, and `&&`, `||`, and `!`.
- Distinguished `length()` on a list (element count) from `length()` on a string (character count).

### Evidence limits
These examples were answered as prediction exercises in the conversation. They were not reported as newly verified in Terraform Console, and no function is marked mastered based on these answers alone.

### Exact resume point
Pending prediction:

```hcl
length(distinct(["dev", "prod", "dev", "test", "prod"]))
```

Choices: A `5`, B `3`, C `2`, D `["dev", "prod", "test"]`.

Ask for the learner's prediction before explaining. Continue one concept at a time. Use only the isolated `terraform-hcl-practice/` directory for safe console verification; do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.


## Checkpoint — 2026-10-27: collection and function predictions

The learner correctly answered the following chat-based prediction exercises. These are **prediction evidence only**, not newly verified Terraform Console results, and do not by themselves establish mastery.

### Functions and behaviors practised
- `concat(["dev", "test"], ["prod"])` → `["dev", "test", "prod"]`; an empty list contributes no elements.
- `compact(["dev", "", "test", "", "prod"])` → `["dev", "test", "prod"]`; removes empty strings.
- `merge()` with overlapping keys → later map values override earlier values; unrelated keys remain.
- `zipmap(["environment", "region"], ["prod", "centralindia"])` → map pairing each key with its value by position.
- `try(tonumber("not-a-number"), 100)` → `100`; `try()` returns the first argument that doesn't produce an error.
- `try(local.sizes["test"], "medium")` → `"medium"` when the key is missing.
- `can(tonumber("42"))` → `true`; `can(tonumber("hello"))` → `false`.
- `can(try(tonumber("hello"), 10))` → `true`: `try()` yields 10, then `can()` checks that successful result.
- `element(["dev", "test", "prod"], 1)` → `"test"`; `element(..., 4)` wraps around to `"test"`; `element(..., -1)` → `"prod"`. Contrast with direct indexing, which errors for an out-of-range index.
- `slice(["dev", "test", "stage", "prod"], 1, 3)` → `["test", "stage"]`; start inclusive, end exclusive. `slice(..., 0, 2)` → `["dev", "test"]`.
- `reverse(["dev", "test", "prod"])` → `["prod", "test", "dev"]`.
- `sort(["prod", "dev", "test"])` → `["dev", "prod", "test"]`; sorting is lexicographical and case-sensitive. `reverse(sort(...))` reverses the sorted list.
- `sort(distinct(["prod", "dev", "prod", "test", "dev"]))` → `["dev", "prod", "test"]`.
- `flatten([["web", "app"], [], ["db", "cache"]])` → `["web", "app", "db", "cache"]`; `flatten()` recursively flattens directly nested lists.
- `distinct(flatten([["web", "app"], ["web", "db"]]))` → `["web", "app", "db"]`.
- A `for` expression with `flatten()` generated `["dev-web", "dev-db", "prod-web", "prod-db"]`.
- Filtered list `for` expressions practised string filters, `startswith()`, numeric `n > 3`, and modulo `n % 2 == 0`; the learner corrected misunderstandings about filtering versus transforming values.
- Map `for` expressions practised `env => upper(env)` and filtering out `test`.
- `keys(map)` returns keys in lexicographical order; `length(keys(map))` returned `3`.
- `values(map)` returns values in the same order as the sorted keys. For keys `dev`, `prod`, `test`, the exact result was `["small", "large", "medium"]`.
- `reverse(values(map))` → `["medium", "large", "small"]`.
- `lookup({ dev = "small", prod = "large" }, "test", "medium")` → `"medium"` when the key is absent; lookup for existing key `"prod"` returns `"large"`.

### Understanding demonstrated and limits
- The learner made correct predictions for the examples above, including correction after some distractor answers.
- These exercises were answered in conversation and were not reported as newly verified in Terraform Console. Do not mark these functions mastered on multiple-choice answers alone.
- Accuracy note: duplicate keys in `zipmap()` should not be used as a map-override technique. Use `merge()` when intentionally overriding keys. The lesson's duplicate-key example was only prediction practice; verify official behavior before using such a pattern.

### Exact resume point
Continue with one small prediction exercise at a time. A suitable next step is a fresh `lookup()`/map-function composition or another collection function, with accurate choices. Then ask the learner to independently explain the result and later verify selected examples in Terraform Console inside `terraform-hcl-practice/`.

Safety remains unchanged: do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval; preserve Azure resources and remote state.

## Authoritative checkpoint — 2026-10-27 (HCL function basics pause)

### Status
Pause the dedicated function-by-function prediction drills here and resume the main Terraform roadmap next session. The learner has demonstrated a useful basic understanding of common string, collection, map, error-handling, and for-expression patterns. This is not a claim that every Terraform built-in function has been learned or mastered; functions should be revisited when a configuration or troubleshooting requirement calls for them.

### Prediction practice completed in chat
The learner correctly predicted these recent examples:
- upper(lookup(local.environment_sizes, "dev", "medium")) → "SMALL"
- lower(lookup(local.environment_sizes, "test", "MEDIUM")) → "medium"
- length(keys(local.environment_sizes)) + length(lookup(local.environment_sizes, "dev", "unknown")) → 8
- contains(keys(local.environment_sizes), "stage") → false
- alltrue() over size comparisons → false when one comparison fails.
- anytrue() over size comparisons → true when one comparison succeeds.
- coalesce("", null, "dev", "prod") → "dev"
- coalescelist([], ["dev", "test"], ["prod"]) → ["dev", "test"]
- coalesce(try(local.environment, null), "dev") with an existing empty-string local → "dev"
- can(tonumber("42")) → true; can(tonumber("hello")) → false
- try(tonumber("hello"), 99) → numeric 99
- lookup(merge(local.default_sizes, local.custom_sizes), "dev", "unknown") → "large" because the later map overrides the earlier key.
- length(keys(merge(local.default_sizes, local.custom_sizes))) → 3 unique keys.
- A filtered map for-expression with upper(size) excludes test and returns the remaining transformed map.
- distinct(flatten([...])) → ["dev-web", "prod-web"]
- A zipmap() + map for-expression + upper() → {dev = "SMALL", prod = "LARGE"}

### Evidence boundary
These latest examples were chat-based prediction exercises, not newly verified in Terraform Console. One combined exercise using upper(try(local.environment_sizes["test"], "medium")) was presented but not answered; it is not required to resume the main roadmap. Keep prior console-verified evidence separate from these predictions. Do not mark all functions mastered from multiple-choice answers alone.

### Next session
Move to the next main Terraform topic: workflow and state fundamentals, starting with the purpose of terraform init, terraform validate, and terraform plan, then state and resource addresses. Continue prediction-first and one concept at a time. Use the isolated terraform-hcl-practice/ directory when hands-on HCL verification is useful. Do not run terraform apply, terraform destroy, or impactful Azure operations without explicit approval.
