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
