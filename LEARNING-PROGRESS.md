# Terraform Zero-to-Hero — Learning Progress

## Current checkpoint
Course: Terraform Zero-to-Hero
Current phase: 1 — Fundamentals
Current lesson: 1 — What Terraform is and what problem it solves
Status: NOT STARTED
Next action: Explain Terraform using a simple example, then ask
the learner to predict what happens when a .tf file is saved.
Do not skip ahead until the concept is understood.

## Verified technical environment
- Repository: ~/azure-lab
- Lab: vm-practice/hub-spoke-lab
- AzureRM provider: 4.81.0
- Backend: Azure Storage
- State key: hub-spoke-lab/terraform.tfstate
- Terraform validate: previously successful
- Hub-and-Spoke code: hub plus spokes 1, 2, and 3
- Four initial peering directions plus Spoke 3 peerings
- Dependency graph: generated and reviewed
- No deployment approved; do not apply or destroy resources

## Learning assessment
| Topic | Status | Evidence / next action |
|---|---|---|
| What Terraform is | NOT STARTED | Teach from fundamentals |
| Declarative vs imperative | LEARNING | Revisit and test understanding |
| Terraform workflow | NOT STARTED | Teach after Lesson 1 |
| Providers and resources | NOT STARTED | Teach with a small example |
| State and drift | NOT STARTED | Teach in Phase 2 |
| Modules | PRACTISED, NOT MASTERED | Revisit after fundamentals |
| Dependency graph | PRACTISED, NOT MASTERED | Explain independently later |
| for_each | NOT STARTED | Defer until variables and collections |
| Azure Hub-and-Spoke | CONFIGURATION EXISTS | Revisit after module fundamentals |

## Session log
- 2026-10-21: Existing Hub-and-Spoke lab validated.
- 2026-10-21: Learner requested a restart from zero because
  previous lessons relied too much on copying code.
- Agreed to concept-first teaching and explicit progress tracking.

## Rules for every session
1. Read this file and LEARNING-ROADMAP.md first.
2. Resume from the exact current lesson; don't restart or skip ahead.
3. Explain one concept at a time.
4. Ask for prediction before giving the answer.
5. Use small exercises written by the learner.
6. Record evidence and misconceptions after each lesson.
7. Update the next lesson and resume instructions at session end.
8. Do not claim mastery without demonstrated understanding.
9. Do not deploy or modify Azure resources without explicit approval.

## Resume prompt
Continue my Terraform Zero-to-Hero course using
LEARNING-ROADMAP.md and LEARNING-PROGRESS.md in ~/azure-lab.
Read both files first. Resume from the exact current lesson and
status. Teach concept-first, one step at a time; don't make me
copy-paste large configurations. Update LEARNING-PROGRESS.md
after each session. Preserve existing Azure resources and remote
state. No apply or destroy without my explicit approval.

### Lesson 1 checkpoint — 2026-10-21
- Understood: manual VM creation is repetitive and can produce
  configuration inconsistencies.
- Status: Lesson 1 in progress; mastery not yet established.
- Next: understand Infrastructure as Code and the role of Terraform.
- Exercise: explain why saving a Terraform configuration does not
  itself create an Azure resource.

- Lesson 1.3 demonstrated: terraform validate checks configuration;
  success does not prove an Azure resource exists.
- Lesson 1.4: learning desired state and how Terraform determines
  proposed changes. Not yet mastered.
