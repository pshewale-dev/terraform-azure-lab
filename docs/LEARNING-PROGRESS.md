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
### Public Repository Cleanup — 2026-10-23

- Confirmed `dev.tfvars`, `prod.tfvars`, and `test.tfvars` contain
  resource-group names, locations, and usernames, not credentials.
- Local copies preserved.
- Added these environment-specific files to `.gitignore`.
- Staged removal of the three files from Git tracking.
- Staged whitespace check passed.
- Important: earlier public Git history still contains the files.
- Next: stage `.gitignore`, review the complete staged diff, then
  commit only after approval.
- GitHub Pages remains unconfigured.

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

## Progress Update — 2026-10-23

### Completed / Understood
- Lesson 1.4 — Desired state and the purpose of `terraform plan`: UNDERSTOOD
- Lesson 1.5 — `terraform plan` previews changes; it does not apply them: UNDERSTOOD
- Lesson 1.6 — Terraform state and how it relates to real infrastructure: UNDERSTOOD

### Current Checkpoint
- Phase: 1 — Terraform Fundamentals
- Current lesson: 1.7 — Terraform drift
- Status: IN PROGRESS
- Concepts covered: external changes to infrastructure, drift, and how planning can identify proposed corrections.
- Pending exercise: Predict what happens when Azure has a manually changed tag and `terraform plan` proposes reverting it, without running `terraform apply`.

### Next Session
1. Finish the Lesson 1.7 prediction exercise.
2. Update this progress file with the result.
3. Continue with exactly one new beginner-friendly concept.
4. Explain the concept before introducing code.
5. Ask for a prediction before moving on.
6. Do not deploy or modify Azure infrastructure without explicit approval.


## Progress Update — 2026-10-23

### Understood
- Lesson 1.4 — Desired state and planning
- Lesson 1.5 — Purpose of terraform plan
- Lesson 1.6 — Terraform state
- Lesson 1.7 — Terraform drift
- Lesson 1.8 — Providers
- Lesson 1.9 — Resources and local labels
- Lesson 1.10 — Resource arguments
- Lesson 1.11 — Resource attributes
- Lesson 1.12 — Input variables
- Lesson 1.13 — Outputs
- Lesson 1.14 — Data sources
- Lesson 1.15 — Local values (locals)
- Lesson 1.16 — Implicit dependencies

### Current Checkpoint
- Phase: 1 — Terraform Fundamentals
- Current lesson: 1.17 — Explicit dependencies (depends_on)
- Status: IN PROGRESS
- Pending: Answer the prediction exercise about how depends_on affects resource ordering.

### Learning Rules
- Explain one concept at a time before introducing code.
- Ask me to predict behavior before moving forward.
- Track understanding, not just successful commands.
- No terraform apply, destroy, deployment, or impactful Azure changes without my explicit approval.
- Preserve existing Azure resources and Terraform state.

### Next Session
Resume at Lesson 1.17. First finish the pending prediction exercise, then update this checkpoint before teaching the next concept.


## Website Development Checkpoint — 2026-10-23

### Project
- Repository: ~/azure-lab
- Website: Terraform Zero to Hero
- Documentation: Markdown with MkDocs Material
- Planned hosting: GitHub Pages
- Planned URL: https://pshewale-dev.github.io/terraform-azure-lab/

### Verified Progress
- [x] Existing MkDocs configuration reviewed.
- [x] Lesson notes and learning roadmap files exist.
- [x] Python virtual environment created at .venv.
- [x] MkDocs 1.6.1 installed in the virtual environment.
- [x] MkDocs Material 9.7.7 installed in the virtual environment.
- [x] Local website preview works.
- [x] `python -m mkdocs build --strict` succeeds.
- [ ] Review the rendered lesson headings, code examples, and revision table.
- [ ] Review Git status and confirm generated files are excluded.
- [ ] Review all documentation changes.
- [ ] Commit only after explicit review and approval.
- [ ] Configure and verify GitHub Pages deployment.

### Mandatory Documentation Rule
Before every Git commit or push, and before ending every learning session:
1. Update the relevant lesson notes with topics and examples covered.
2. Update this progress file with demonstrated understanding and evidence.
3. Record unfinished exercises, questions, and misconceptions.
4. Record the exact current lesson and next action.
5. Verify the roadmap and progress tracker agree.
6. Review Git changes before committing or pushing.

Never mark a concept mastered merely because a command succeeded. Preserve the learner's prediction answers and demonstrated understanding.

### Resume Point
- Learning: Lesson 1.17 — Explicit dependencies (`depends_on`).
- Status: IN PROGRESS.
- Pending exercise: Predict what `depends_on = [example_resource.prerequisite]` means for resource ordering.
- Website: Local preview and strict build succeed.
- Next website action: Review Git status and generated-file exclusions, then inspect the rendered documentation.
- Safety: No commit, push, `terraform apply`, `terraform destroy`, or impactful Azure changes without explicit approval.

### Website Validation Update — 2026-10-23

- MkDocs strict build: PASSED.
- Local browser preview: WORKING.
- Navigation: Home, Terraform Fundamentals, Learning Tracker, Roadmap.
- Source files present: index.md, lesson-01-fundamentals.md,
  LEARNING-PROGRESS.md, LEARNING-ROADMAP.md.
- Git exclusions verified: .venv/ and site/ are ignored.
- Git whitespace check: no issues reported for tracked changes.
- Material for MkDocs displayed an upstream MkDocs 2.0 warning;
  the current strict build still succeeded.

### Remaining Before First Commit

- [ ] Review rendered lesson formatting, including interview questions
  and the revision table.
- [ ] Review all source changes and ensure no secrets are included.
- [ ] Verify the learning checkpoint and roadmap agree.
- [ ] Obtain explicit approval before committing.
- [ ] Configure GitHub Pages deployment after the source review.

### Exact Resume Instructions

1. Continue reviewing the local website and lesson formatting.
2. Fix any remaining Markdown issues.
3. Update lesson notes and progress before committing.
4. Review staged changes before the first commit.
5. Do not push or deploy until explicitly approved.
6. Resume the Terraform course at Lesson 1.17 and ask the pending
   prediction question about depends_on before teaching a new concept.

### Final Formatting Check — 2026-10-23

- [x] Removed malformed `### ### Interview question` headings.
- [x] Confirmed no malformed headings remain.
- [x] Rebuilt the site successfully with `python -m mkdocs build --strict`.
- [x] Confirmed the revision table uses Markdown table syntax.
- [ ] Visually verify the interview headings and revision table in Firefox.
- [ ] Complete final source and Git review before the first commit.

### Resume Reminder

The website work does not change the Terraform course checkpoint.
Resume Lesson 1.17 — Explicit dependencies (`depends_on`).
The prediction exercise is still pending; do not mark it mastered.
## Authoritative Current Status — 2026-10-23

This section supersedes older current-status entries above; those entries
are retained as historical session records.

- Current course phase: Phase 1 — Fundamentals
- Current lesson: 1.17 — Explicit dependencies (`depends_on`)
- Status: IN PROGRESS
- Pending prediction: Explain what
  `depends_on = [example_resource.prerequisite]` means for resource ordering.
- Do not mark mastered until the learner answers and demonstrates understanding.

Website status:
- Local preview works.
- `python -m mkdocs build --strict` succeeds.
- `.venv/` and `site/` are ignored by Git.
- Remaining: visually verify the lesson, then complete the final review.
- No commit or push until explicitly approved.
