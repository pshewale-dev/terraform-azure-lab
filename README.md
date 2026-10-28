# Terraform Zero to Hero — Azure & DevOps Lab

A hands-on learning repository for **Terraform, Microsoft Azure, Git, and Azure DevOps**. The goal is to understand infrastructure as code, practise production-style patterns safely, and build the skills to explain and troubleshoot them in technical interviews.

📚 **Learning website:** https://pshewale-dev.github.io/terraform-azure-lab/  
🌿 **Default branch:** `main`

## What you'll learn

- Terraform fundamentals and HCL
- The `init → fmt → validate → plan` workflow
- State, resource addresses, drift, and safe state handling
- Variables, locals, outputs, expressions, collections, and modules
- Azure networking, compute, identity, Key Vault, and Hub-and-Spoke design
- Git workflows, CI/CD concepts, Azure DevOps pipelines, and troubleshooting
- Production-style change review, security, cost awareness, and recovery practices

The course is organised into 13 lessons, a learning tracker, a roadmap, and practical labs.

## Learning approach

This repository follows a **concept-first, prediction-first** approach:

1. Learn one concept at a time and understand why it exists.
2. Predict what Terraform will do before running a command.
3. Make a small change yourself instead of copying a large solution.
4. Verify the result and understand what the evidence does—and does not—prove.
5. Practise a troubleshooting scenario and explain the concept in your own words.
6. Update the learning tracker at each session checkpoint.

A successful command is not, by itself, proof of mastery. The tracker records evidence and the next step.

## Repository layout

```text
.
├── README.md
├── mkdocs.yml                    # MkDocs Material site configuration
├── docs/
│   ├── index.md                  # Website home page
│   ├── lesson-01-fundamentals.md
│   ├── lesson-02-workflow.md
│   ├── lesson-03-state.md
│   ├── lesson-04-dependencies.md
│   ├── ...                       # Remaining numbered lessons
│   ├── production-labs.md        # Practical lab requirements and scenarios
│   ├── LEARNING-PROGRESS.md      # Current checkpoint and evidence
│   └── LEARNING-ROADMAP.md       # Curriculum and learning rules
├── terraform-hcl-practice/
│   ├── main.tf                   # Azure Resource Group lab
│   ├── practice.tf               # HCL/locals exercises
│   ├── variables.tf
│   ├── versions.tf
│   └── .terraform.lock.hcl
└── vm-practice/
    ├── _archive/                 # Retired root-level configuration, preserved
    └── hub-spoke-lab/            # Separate Hub-and-Spoke lab
```

Files ending in `.tf.disabled` under `vm-practice/_archive/` are archived reference material, not active Terraform configuration. Terraform does not load those files as `.tf` configuration.

## Start here

1. Open the [learning website](https://pshewale-dev.github.io/terraform-azure-lab/).
2. Read [Lesson 1 — Core Concepts and HCL](https://pshewale-dev.github.io/terraform-azure-lab/lesson-01-fundamentals/).
3. Review the [learning roadmap](https://pshewale-dev.github.io/terraform-azure-lab/LEARNING-ROADMAP/) and [progress tracker](https://pshewale-dev.github.io/terraform-azure-lab/LEARNING-PROGRESS/).
4. Follow the next step in the tracker rather than skipping ahead.

## Preview the documentation locally

The site uses Python, MkDocs, and the MkDocs Material theme. From the repository root, a local preview can be built in a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install mkdocs-material
python -m mkdocs build --strict
python -m mkdocs serve
```

Then open the local address printed by `mkdocs serve` (usually `http://127.0.0.1:8000/`). The generated `site/` directory and `.venv/` are ignored by Git.

## Terraform lab safety

Some directories contain real Azure-backed configurations. In particular, `terraform-hcl-practice/` has been used to create and verify the Azure Resource Group `rg-tf-lab-prashant-dev` in `centralindia`. Treat this as a **real cloud lab**, not as a disposable local-only example.

Before running Terraform commands in any lab, confirm:

- The current directory and configuration files
- The active Azure subscription and identity
- The backend and state location
- The Terraform workspace
- The resources and costs that could be affected

**Never run `terraform apply`, `terraform destroy`, or other impactful Azure operations without explicitly reviewing the plan and approving the exact change.** Do not delete or manually edit state files as a troubleshooting shortcut. Back up and protect state; it can contain sensitive information.

The `vm-practice/hub-spoke-lab/` directory is a separate lab and has an Azure Storage backend configured. Do not run `terraform init` or change its backend casually. The retired root-level VM practice configuration is archived for reference; its archival does not mean nested labs or their state have been deleted.

## Git and security practices

- Work from `main` and use focused branches for changes when needed.
- Review `git diff` and `git status` before committing.
- Commit `.terraform.lock.hcl` for reproducible provider selections.
- Keep `.terraform/`, state files, plan files, credentials, private keys, and sensitive variable files out of version control.
- Never put passwords, access tokens, service-principal secrets, or other credentials in source files or README examples.
- Check the GitHub Actions workflow after pushing documentation changes; a successful Git push does not itself prove that GitHub Pages has deployed.

## Learning checkpoint rule

Before ending a study session or making a learning-related commit, update the relevant lesson notes and `docs/LEARNING-PROGRESS.md` with:

- The concepts covered
- The learner's predictions and demonstrated understanding
- Practical work and verification evidence
- Unresolved questions or mistakes to revisit
- The exact next step

See [Production-Style Hands-on Labs](https://pshewale-dev.github.io/terraform-azure-lab/production-labs/) for the lab format and safety tiers.

---

This is a personal learning project. Use a dedicated non-production Azure sandbox for new cloud exercises, and follow your organisation's policies for credentials, access, cost controls, and change approvals.
