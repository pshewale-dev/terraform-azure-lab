# Terraform Zero-to-Hero — Learning Progress

## Current checkpoint
Course: Terraform Zero-to-Hero
Current phase: Phase 1 — Fundamentals
Current course checkpoint (authoritative, 2026-10-26): hands-on HCL function practice in `terraform-hcl-practice/`.
Status: Practised and verified `join()`, `split()`, `replace()`, and `upper()` through prediction-first exercises and Terraform Console; `format()` has been practised through four prediction examples but is not yet console-verified or mastered.
Latest evidence for `format()`: `format("%s-%s-%s", "dev", "east", "01")` -> `"dev-east-01"`; `format("%s-%02d", "web", 3)` -> `"web-03"`; `format("%s-%02d", "app", 12)` -> `"app-12"`; `format("%s-%02d", "vm", 7)` -> `"vm-07"`. The learner initially selected the wrong result for the first zero-padding example, then correctly predicted the next two examples.
Reference: `lower()` converts letters to lowercase; a separate exercise was skipped at the learner's request.
Next topic: If useful, verify today's `format()` examples in Terraform Console, then continue with one small HCL concept at a time, prediction-first, in the isolated practice directory. Keep map `for` expressions as practised rather than mastered until independently re-tested.
Safety: Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval. Preserve Azure resources and remote state.
The older checkpoint entries below are retained as historical records; this current checkpoint supersedes them.

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

### GitHub Pages Publishing — 2026-10-23

- Added `.github/workflows/pages.yml` for MkDocs GitHub Pages deployment.
- Workflow triggers on documentation/configuration changes pushed to
  `feature/dynamic-nsg`, or via manual workflow dispatch.
- Uses GitHub Actions to build with `python -m mkdocs build --strict`
  and deploy the generated `site/` artifact.
- Local strict build passed; Material for MkDocs emitted an upstream
  MkDocs 2.0 warning that did not fail the build.
- Confirmed `site_url` is
  `https://pshewale-dev.github.io/terraform-azure-lab/`.
- GitHub Pages has not yet been enabled/configured in repository settings.
- Next: review and commit the workflow and this progress update after approval;
  push only after separate approval, then select GitHub Actions as the Pages source.
- Terraform Lesson 1.17 (`depends_on`) remains in progress.

## Authoritative Current Status — 2026-10-24

This section supersedes older current-status and resume entries above. Historical session notes are retained for context.

### Terraform learning
- Current phase: Phase 1 — Fundamentals.
- Lesson 1.17 — Explicit dependencies (`depends_on`): **UNDERSTOOD**.
- Evidence: correctly predicted that the dependent resource waits for the prerequisite's required operations, and confirmed that explicit dependencies are appropriate when Terraform cannot infer the relationship from normal resource references.
- Next topic: verify existing coverage of HCL syntax and configuration structure before teaching it.
- Teaching approach: one concept at a time, prediction-first, small learner-written exercises.
- Do not mark further concepts understood without evidence from the learner.

### Website status
- Website: https://pshewale-dev.github.io/terraform-azure-lab/
- GitHub Pages deployment workflow exists at `.github/workflows/pages.yml` and publishes from `feature/dynamic-nsg`.
- Local MkDocs strict build passed on 2026-10-24 using the project virtual environment.
- The Material for MkDocs MkDocs 2.0 notice is an upstream warning; it did not fail the strict build.
- Local documentation edits were reported for the lesson and progress tracker; the current GitHub branch was reviewed and found to contain older checkpoints. The current remote update aligns the published documentation with the verified learning status.
- Future documentation changes should update lesson notes, progress, and roadmap together, run strict build and whitespace checks, review the diff, then publish through the existing workflow.

### Safety
- No Terraform apply, destroy, or impactful Azure operation is authorized by this documentation work.
- Preserve Azure resources and remote Terraform state.



## Authoritative Current Status — 2026-10-24 (HCL practice session)

This entry supersedes older current-status/resume instructions above. Earlier session records remain as history.

### Practice workspace
- Local workspace: `~/terraform-hcl-practice`, intentionally isolated from the Azure-backed Terraform configurations in `~/azure-lab`.
- Repository copy: `terraform-hcl-practice/` on `feature/dynamic-nsg`.
- The directory is for HCL/configuration and console exercises only; no Azure backend is configured in this practice directory.
- Local `terraform.tfvars` is ignored by Git. A safe `terraform.tfvars.example` is committed instead.
- No `terraform apply`, `terraform destroy`, or Azure infrastructure changes were performed as part of this learning session.

### Concepts practised and evidence
- HCL block structure and `locals`: corrected the block type to `locals`; isolated configuration validated successfully.
- Local references and interpolation: built resource-name strings using `local.environment`, `local.region`, and `${...}`; correctly predicted examples such as `web-prod-01` and `dev-centralIndia-web`.
- Direct references versus quoted text: correctly identified that `local.environment` is a reference while `"local.environment"` is literal text.
- Input variables and local values: used `var.environment` and `local.region` together in a derived resource name.
- Variable defaults and overrides: verified `terraform.tfvars` value `test` and command-line override precedence using `terraform console -var="environment=prod"`.
- Variable validation: added a `contains(...)` rule. A typo in the allowed list temporarily rejected `prod`; the issue was diagnosed and the allowed values corrected to `prod`, `dev`, and `test`.
- Collections: practised a `list(string)` of allowed regions and a `map(string)` of environment labels; used list indexes and map-key lookups.
- Conditional expressions: practised `var.environment == "prod" ? "large" : "small"` and Boolean comparison `var.environment == "prod"`.
- Learner correctly predicted that the production condition is `true` and the conditional result for `prod` is `large`.
- Successful `terraform validate` was reported for the isolated practice configuration. Console output confirmed `var.environment = "test"`, `local.resource_name = "test-centralIndia-web"`, and map lookup/local label = `"Testing"`.
- A list-index prediction was incorrect once: index `1` returns the second list element, `westindia`. A map-lookup prediction was also incorrect once: key `"test"` returned `"Testing"`. These are useful review points, not evidence of failure to progress.

### Exact next-session checkpoint
- Next concept: logical operators `&&` (AND), `||` (OR), and `!` (NOT).
- Resume with the AND expression:
  ```hcl
  is_india_production = (
    var.environment == "prod" &&
    lower(local.region) == "centralindia"
  )
  ```
- First ask the learner to predict the result when `environment = "test"` and `region = "centralIndia"`; do not give the answer before the prediction.
- Then complete the small hands-on exercise and proceed to OR and NOT one concept at a time.
- Continue prediction-first, learner-written practice; do not repeat completed variable/collection lessons unless needed to correct a misconception.
- Keep the isolated practice directory separate from root Azure backend configurations. No apply/destroy or impactful Azure operations without explicit approval.


## Authoritative Current Status — 2026-10-25 (logical operators and for expressions)

This checkpoint supersedes older current-status/resume entries above. Historical entries remain as session history.

### Workspace and safety
- Practice directory: `terraform-hcl-practice/`, isolated from the Azure-backed root configuration.
- Input file: local `terraform.tfvars` sets `environment = "test"`; `terraform.tfvars.example` is only a template and is not auto-loaded by Terraform.
- Verified command-line override: `terraform console -var="environment=dev"` produced the expected `"standard"` result for the combined OR/conditional expression.
- Console and `terraform validate` only; no `terraform apply`, `terraform destroy`, Azure resource changes, or remote-state changes.

### Topics practised and evidence
- Logical operators:
  - `&&` (AND): both conditions must be true.
  - `||` (OR): at least one condition must be true.
  - `!` (NOT): reverses a Boolean.
  - Combined expressions were evaluated in precedence order using parentheses, NOT, and AND.
- Verified in Terraform Console with `environment = "test"`:
  - `local.is_non_production` returned `true`.
  - `local.is_prod_or_dev` returned `false`.
  - `local.is_allowed_deployment` returned `false`.
- Conditional expressions: correctly predicted `"small"` for test; combined OR/conditional expression returned `"small"` for test and `"standard"` with `-var="environment=dev"`.
- List `for` expressions:
  - Correctly predicted uppercase transformation using `upper(region)`.
  - Correctly identified filtering with `if`, including `!=` and `==`.
  - Correctly understood interpolation in `"azure-${region}"`.
- Map `for` expressions:
  - Correctly identified iteration variables (e.g. `env`, `label`, `fruit`) as temporary names introduced by the `for` expression, not declarations in `variables.tf`.
  - Correctly distinguished list output `[...]` from map output `{ key => value }`.
  - Correctly predicted independent transformations of map keys and values with `upper()`.
  - Correctly predicted that filtering `if env != "test"` retains `dev` and `prod`.
  - Verified in console that filtering `var.allowed_regions` with `if region == "centralindia"` returns only `{"centralindia" = "CENTRALINDIA"}`.
- Misconceptions to revisit gently: the learner initially predicted true for AND when one side was false, and initially predicted true for the OR expression when both comparisons were false. They corrected these after truth-table walkthroughs and console checks.
- Mastery status: **practised / improving; not yet marked mastered**. Continue to collect independent evidence in new examples.

### Exact resume point
- Current topic: Terraform `for` expressions, combining a conditional expression with a list-to-map transformation.
- Pending prediction: for
  ```hcl
  {
    for region in var.allowed_regions :
    region => (region == "centralindia" ? "primary" : "secondary")
  }
  ```
  predict the value associated with key `westindia`.
- Ask for the prediction first. Then verify in the isolated Terraform console and explain only as needed.
- Keep teaching one concept at a time and avoid large copy-paste exercises.
- No apply/destroy or impactful Azure operations without explicit approval.


## Authoritative Current Status — 2026-10-25 (map for-expression verified)

This checkpoint supersedes the earlier 2026-10-25 resume instructions above. Historical notes remain as learning history.

### Evidence from the latest exercise
- Correctly predicted that `westindia` receives `"secondary"` in a map `for` expression with a conditional value. Terraform Console confirmed:
  ```hcl
  {
    "centralindia" = "primary"
    "westindia"    = "secondary"
  }
  ```
- Correctly predicted that filtering out `centralindia` and applying `upper(region)` leaves:
  ```hcl
  {
    "westindia" = "WESTINDIA"
  }
  ```
  Terraform Console output matched the prediction.
- Demonstrated the combined behavior of map `for` expressions: iteration, key/value construction, conditional values, filtering, and transformation.
- A spelling slip in the written prediction (`WESTINIDA`) did not affect the concept; the actual console output was correct.

### Current learning status
- Phase: 1 — Fundamentals / HCL practice.
- Current topic: list and map `for` expressions, including conditional values and filters.
- Status: practised with correct console verification; continue testing independent understanding before marking mastered.
- Practice remains in the isolated `terraform-hcl-practice/` directory.
- No `terraform apply`, `terraform destroy`, Azure resource changes, or remote-state changes were performed.

### Exact next step
Give one small learner-written map `for` exercise combining a conditional value with a filter. Ask for a prediction first, then ask the learner to write and run the expression and share the console output. Continue to the next suitable HCL concept only after this exercise.

### Safety reminder
Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval. Preserve existing Azure resources and remote state.


### Verified exercise: conditional map value plus filter (2026-10-25)
Learner independently ran the expression in Terraform Console and produced the expected output:

```hcl
{
  for region in var.allowed_regions :
  region => (region == "centralindia" ? "primary" : "secondary")
  if region != "westindia"
}
```

Console result:

```hcl
{
  "centralindia" = "primary"
}
```

This verifies the learner can combine a map `for` expression, conditional value, and trailing filter in one expression. `westindia` is excluded by the filter, so its conditional value is not present in the result. Keep the topic as practised; use another fresh example before marking it mastered.

### Next step
Move to the next small HCL concept with prediction-first practice. Continue in the isolated `terraform-hcl-practice/` directory. Do not run `terraform apply` or `terraform destroy`, and do not change Azure resources or remote state.


### Verified concept: `flatten()` (2026-10-25)
Learner predicted that `flatten()` combines nested lists into one list, then ran a separate example in Terraform Console and got the expected output:

```hcl
flatten([
  ["apple", "banana"],
  ["mango", "orange"]
])
```

Output was a single list containing `"apple"`, `"banana"`, `"mango"`, `"orange"` in that order. Takeaway: `flatten()` removes nested list structure; it preserves the element values and order. Treat as introduced and verified with one example; test with a deeper nested list before marking mastered.


### Deeper `flatten()` verification (2026-10-25)
Learner ran a nested-list example with an additional nesting level and returned the expected flat list `["dev", "test", "prod"]` in order. `flatten()` is now verified with both two-level and deeper nested-list examples. Practical use discussed: flatten nested subnet/rule data into a single list of objects before reshaping it into a map keyed by unique identifiers for `for_each`. Continue reinforcing with a small hands-on example.


### Learning scope decision (2026-10-25)
Keep the current `flatten()` lesson at the basic level: learner has verified ordinary and deeper nested-list examples in Terraform Console. Defer the subnet/NSG nested-data use case until the relevant Azure subnet and NSG rules lessons. Do not introduce that applied pattern early; continue one concept at a time.


### `toset()` — list to set (2026-10-25)
Learner correctly predicted option B and verified this expression in Terraform Console:

```hcl
toset(["dev", "test", "dev", "prod"])
```

Console output contained `dev`, `prod`, and `test` once each. The duplicate `dev` was removed; the displayed order differed from the input. Key takeaway: a set contains unique elements and does not guarantee order. Status: introduced and verified with one example; continue with a small follow-up before marking mastered.


### `toset()` follow-up verified (2026-10-25)
Learner predicted that `toset(["web", "app", "web", "app"])` would contain two unique values and verified it in Terraform Console. Actual output was `toset(["app", "web"])`. This confirms duplicate removal and reinforces that set ordering is not guaranteed. `toset()` has now been verified with two examples; proceed to the next small HCL concept, and revisit set conversion later when it is useful for `for_each`.


### `distinct()` versus `toset()` verified (2026-10-26)
Learner ran both expressions in the isolated Terraform Console:

```hcl
distinct(["web", "app", "web", "db", "app"])
toset(["web", "app", "web", "db", "app"])
```

`distinct()` returned `tolist(["web", "app", "db"])`, preserving the first-occurrence order. `toset()` returned the unique strings in a different displayed order (`app`, `db`, `web`). This confirms the difference: `distinct()` returns a list and preserves order; `toset()` returns a set with no guaranteed order. Status: verified in console.


### `length()` — count list elements (2026-10-26)
Learner predicted that `length(["web", "app", "db"])` returns `3` and verified it in Terraform Console. Status: first example verified. Next, test `length()` on a string to see that it counts characters rather than collection elements.


### `length()` on strings verified (2026-10-26)
Learner ran `length("terraform")` in Terraform Console and got `9`. They correctly articulated the distinction: for a list, `length()` counts list elements; for a single string, it counts characters. Clarification added: a list containing multiple strings still counts items, not the total letters across those strings. Example to reinforce: `length(["terraform", "azure"])` returns `2`.


### `length()` list-of-strings check verified (2026-10-26)
Learner predicted and ran `length(["terraform", "azure"])`; Terraform Console returned `2`. This confirms that a list's length is its number of elements, not the combined character count of the strings. The `length()` concept has now been verified on a list, a string, and a list of strings.


### `contains()` — check whether a value exists (2026-10-26)
Learner predicted and verified `contains(["dev", "test", "prod"], "test")` in Terraform Console; output was `true`. The function returns a Boolean indicating whether the exact value is present in the list. Next practice: check a value that is absent and verify the result is `false`.


### `contains()` missing-value check verified (2026-10-26)
Learner predicted `contains(["dev", "test", "prod"], "stage")` would return `false` and verified both the present-value and missing-value cases in Terraform Console:

```hcl
contains(["dev", "test", "prod"], "test")  # true
contains(["dev", "test", "prod"], "stage") # false
```

This confirms `contains()` returns `true` when the exact value is present and `false` when absent. Concept verified with both outcomes.


### `lookup()` — retrieve a map value by key (2026-10-26)
Learner correctly predicted and verified this expression in Terraform Console:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "prod")
```

Console output: `"large"`. Key takeaway: `lookup()` retrieves the value associated with a key in a map. Next, practise a key that is missing and learn how the optional default value works.


### `lookup()` default value verified (2026-10-26)
Learner correctly predicted and verified this expression in Terraform Console:

```hcl
lookup({
  dev  = "small"
  prod = "large"
}, "test", "medium")
```

Output: `"medium"`, because the key `test` is absent and the third argument supplies the default. This verifies both normal key lookup and missing-key fallback. Next, practise one short independent example with a different map and default.


### `lookup()` existing-key follow-up predicted (2026-10-26)
Learner correctly predicted that `lookup({ dev = "small", prod = "large" }, "dev", "medium")` returns `"small"` because `dev` exists. The default `"medium"` is only used when the requested key is absent. Ask the learner to verify this final example in Terraform Console before closing the introductory `lookup()` checkpoint.


### `lookup()` final example verified (2026-10-26)
Learner ran `lookup({ dev = "small", prod = "large" }, "dev", "medium")` in Terraform Console and got `"small"`, matching the prediction. This confirms that when the requested key exists, its mapped value is returned even when a default is provided; the default applies only when the key is absent. Introductory `lookup()` practice is now verified across present and missing keys.


### `coalesce()` — first non-null value (2026-10-26)
Learner correctly predicted and verified `coalesce(null, null, "dev", "prod")` in Terraform Console; output was `"dev"`. The function evaluates arguments from left to right and returns the first non-null value. Status: first example verified; continue with a short independent example before marking the concept complete.


### `coalesce()` follow-up verified (2026-10-26)
Learner correctly predicted and ran `coalesce(null, "test", "prod")` in Terraform Console; output was `"test"`. This confirms the function returns the first non-null argument from left to right. `coalesce()` is verified with two examples; proceed to the next small concept while keeping examples prediction-first.


### `join()` — combine strings with a separator (2026-10-26)
Learner correctly predicted and verified this expression in Terraform Console:

```hcl
join("-", ["dev", "east", "01"])
```

Output: `"dev-east-01"`. `join()` combines list elements into one string, inserting the specified separator between elements. Status: first example verified; use one independent example with a different separator before moving on.


### `join()` follow-up verified (2026-10-26)
Learner correctly predicted and verified this expression in Terraform Console:

```hcl
join("/", ["subscriptions", "resourceGroups", "vnet"])
```

Output: `"subscriptions/resourceGroups/vnet"`. This confirms that `join()` inserts the chosen separator between list elements to create one string. `join()` is verified with two examples using different separators.


### `split()` — string to list (2026-10-26)
- Learner verified `split("-", "dev-east-01")` in Terraform Console; output was `tolist(["dev", "east", "01"])`.
- Takeaway: `split(separator, string)` divides a string wherever the separator occurs and returns a list of strings. `tolist(...)` is the console's display of the list result, not a wrapper the learner must add.
- Next: continue with the next small HCL concept using prediction-first practice.


### Current HCL function checkpoint — 2026-10-26
- Verified `split("-", "dev-east-01")` -> a list containing `"dev"`, `"east"`, and `"01"`.
- Verified `replace("dev-east-01", "east", "west")` -> `"dev-west-01"`; `replace("web-web-web", "web", "app")` -> `"app-app-app"`; and `replace("dev-east-01", "-", "/")` -> `"dev/east/01"`. These examples confirm replacement of every occurrence of the matching substring.
- Verified `upper("dev-east-01")` -> `"DEV-EAST-01"` and `upper("Azure DevOps 2026")` -> `"AZURE DEVOPS 2026"`. Letters change to uppercase; spaces, punctuation, and digits remain unchanged.
- `lower()` is the corresponding lowercase conversion function; learner asked to skip a separate exercise for it, but include it in the notes for reference.
- Next topic: continue with one small HCL concept, prediction-first, in the isolated `terraform-hcl-practice/` directory.

## Dated Study Schedule — Interview Preparation (2026-10-26)

- **Availability:** 30 minutes daily, 7 days/week (3.5 hours/week).
- **Priority:** Azure DevOps + Terraform interview preparation.
- **Target window:** 2026-10-26 through 2026-12-20. Dates are targets, not completion claims.
- **Daily routine:** 5 min recall, 15 min one concept/exercise, 5 min safe verification, 5 min interview explanation/progress note.
- **Oct 26–Nov 1:** HCL functions and expressions; fresh `for` expression check.
- **Nov 2–8:** Terraform workflow, plans, state, dependencies, drift, remote-state safety.
- **Nov 9–15:** Variables, types, validation, locals, outputs.
- **Nov 16–22:** Collections, functions, conditionals, `count` vs `for_each`, dynamic blocks.
- **Nov 23–29:** Modules and Azure resource group/VNet/subnet/NSG design.
- **Nov 30–Dec 6:** Linux VM/SSH, managed identity, Key Vault, security, Hub-and-Spoke.
- **Dec 7–13:** Git/PR workflow and Azure DevOps Terraform CI/CD, plan review, approval gates, troubleshooting.
- **Dec 14–20:** Interview mock sessions and a small capstone design/review.
- **Mastery:** Preserve earlier evidence as practised/verified. A date passing never implies mastery; require explanation, fresh prediction, independent small task, and troubleshooting evidence.
- **Safety:** Use the isolated `terraform-hcl-practice/` workspace for HCL exercises. Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval; preserve Azure resources and remote state.

### `format()` prediction-first practice — 2026-10-26
- Correctly predicted `format("%s-%s-%s", "dev", "east", "01")` -> `"dev-east-01"`.
- Initially predicted that `format("%s-%02d", "web", 3)` would preserve `%02d` literally; corrected after explanation that `%02d` formats an integer with minimum width two and zero-padding, so the result is `"web-03"`.
- Correctly predicted `format("%s-%02d", "app", 12)` -> `"app-12"`, understanding that width two is a minimum, not a maximum.
- Correctly predicted `format("%s-%02d", "vm", 7)` -> `"vm-07"`.
- Status: practised through four prediction examples; not yet independently verified in Terraform Console and not marked mastered.
- Next: learner can run the expressions in the isolated `terraform-hcl-practice/` Terraform Console if desired, then continue with one small HCL concept. Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations.
