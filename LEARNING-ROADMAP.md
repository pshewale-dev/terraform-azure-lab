# Terraform Zero-to-Hero Learning Roadmap

## Course rules
- Teach concepts before giving code.
- Explain why each feature exists and how it works.
- Avoid large copy-paste exercises.
- Learner predicts behavior before running commands.
- Learner writes small changes independently.
- Every lesson includes practice, verification, troubleshooting,
  and a recall question.
- Track understanding, not merely successful commands.
- Never run terraform apply, destroy, or other impactful Azure
  operations without explicit approval.
- Use the existing Azure remote backend for the lab.
- Preserve existing Azure resources and state.

## Phase 1: Fundamentals
1. What Terraform is and what problem it solves
2. Declarative vs. imperative automation
3. Terraform workflow and execution model
4. Providers, resources, arguments, and attributes
5. HCL syntax and configuration structure

## Phase 2: State and dependencies
6. init, validate, plan, apply, and destroy
7. Terraform state and resource addresses
8. Dependency graphs and implicit dependencies
9. Drift, refresh, and lifecycle
10. Remote state, locking, and backend security

## Phase 3: Writing Terraform
11. Input variables and type constraints
12. Locals and outputs
13. Lists, maps, objects, and expressions
14. Conditions, functions, and dynamic blocks
15. count vs. for_each
16. Data sources and resource references
17. Debugging and error diagnosis

## Phase 4: Reusable infrastructure
18. Module design and module interfaces
19. Module composition and dependencies
20. Azure resource groups and networking
21. VNets, subnets, and NSGs
22. Linux VMs and SSH
23. Managed identities and Key Vault
24. Hub-and-Spoke networking

## Phase 5: Professional workflows
25. Git workflow and code reviews
26. Azure DevOps Terraform pipelines
27. Validation and plan review
28. State recovery and troubleshooting
29. Security and secret management
30. Interview scenarios and independent capstone

## Mastery rule
A lesson is mastered only when the learner can explain the
concept, predict behavior, complete a small exercise, and
troubleshoot a related problem without copying the solution.
