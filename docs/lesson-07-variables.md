# Lesson 7 — Variables, Locals, and Outputs

**Course position:** Lesson 7 of 13.

**Status:** IN PROGRESS — prior coverage audit completed on 2026-11-23. Do not restart this lesson from the basics.

## Objectives
- Define input variables and type constraints.
- Use defaults, validation, and overrides.
- Distinguish input variables, locals, and outputs.

## Prior coverage — already covered; do not repeat

Existing evidence is recorded in `docs/lesson-01-fundamentals.md` and `terraform-hcl-practice/`.

| Topic | Existing evidence | Coverage |
|---|---|---|
| Input variable declaration/reference | `variable "location"`, `type = string`, `default`, `var.location` | Covered |
| String variables and defaults | `variable "environment"`, default `dev` | Practised |
| Allowed-value validation | Validation permits `prod`, `dev`, and `test` | Practised |
| Variable overrides | `terraform.tfvars` and `terraform console -var="environment=prod"` | Practised; console evidence recorded |
| Collection type constraints | `list(string)` and `map(string)` | Practised |
| Locals | References, interpolation, derived names/labels, Boolean and conditional expressions | Practised in isolated HCL lab |
| Outputs | Basic output syntax and resource-attribute reference | Theory covered; practical verification remains |

### Existing files
- `terraform-hcl-practice/variables.tf`: environment, allowed_regions, environment_tags.
- `terraform-hcl-practice/terraform.tfvars.example`: sample environment input.
- `terraform-hcl-practice/practice.tf`: local values derived from variables and expressions.
- `docs/lesson-01-fundamentals.md`: introductory variable, output and local-value explanations, plus prior practice evidence.

## Remaining work — teach only these gaps

1. Start with a short recall check to confirm the learner still understands the existing material. Do not repeat a full explanation of basic variable declarations, defaults, validation, tfvars, CLI overrides, list/map types, or locals.
2. Check whether more complex type constraints (such as object types) are needed for the roadmap's next practical tasks. Teach and practise only the missing part.
3. Build a small output example in the isolated HCL practice directory. Verify output values safely without deploying infrastructure.
4. Explain the interface distinction in one compact example:
   - input variables: values supplied to a module;
   - locals: internal derived/reusable values;
   - outputs: selected values exposed to a caller or operator.
5. Review sensitive output handling and avoid exposing sensitive values unnecessarily.

## Practical lab

Use only `~/azure-lab/terraform-hcl-practice` (or its repository counterpart `terraform-hcl-practice/`). This lab has no Azure backend and is intended for Terraform Console, formatting, and validation.

- Learner writes a small output block independently.
- Predict the output before running a safe command.
- Verify with Terraform Console or a safe local-only workflow.
- Do not run `terraform apply` or `terraform destroy`.
- Keep real `terraform.tfvars` files out of Git; commit only safe examples.

## Evidence rules
- Distinguish historical console-verified practice from chat-only predictions.
- Do not mark an item command-verified unless the command was run and its output was observed.
- Do not mark Lesson 7 complete until the learner independently explains and practises the remaining output/interface gaps and completes the lesson assessment.

## Authoritative checkpoint
Lesson 7 is IN PROGRESS. Resume with a brief recall check, then continue only with the gaps above. Lesson 6 is completed; do not return to it unless requested.
