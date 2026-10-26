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

## Mandatory Learning Session Checkpoint

Before ending each learning session, update the learning documentation.

### Required actions
1. Add the topics covered in the current session to the appropriate lesson notes.
2. Record key concepts, examples, commands, and important warnings.
3. Update `LEARNING-PROGRESS.md` with demonstrated understanding, completed exercises, and pending questions.
4. Record the current lesson and exact next step so learning can resume after a conversation limit or a new chat.
5. Update this documentation before every Git commit or push.

### Learning integrity rules
- Teach one concept at a time.
- Ask prediction questions before explaining the answer when appropriate.
- Do not mark a concept as mastered until the learner demonstrates understanding.
- Preserve unfinished exercises and incorrect answers so they can be revisited.
- Never run `terraform apply`, `terraform destroy`, or make impactful Azure changes without explicit approval.

### Session completion checklist
- [ ] Lesson notes updated
- [ ] Learning progress updated
- [ ] Current lesson and next step recorded
- [ ] Pending exercises and questions recorded
- [ ] Git changes reviewed before committing

## Documentation Maintenance Automation

**Goal:** Minimize time spent maintaining the website so study time stays focused on learning Terraform.

### Intended workflow
1. During each lesson, record the topic, the learner's predictions and answers, exercises completed, and remaining questions.
2. At the end of the session, update the relevant lesson notes and `LEARNING-PROGRESS.md` together.
3. Keep `LEARNING-ROADMAP.md` aligned with the learning workflow and automation decisions.
4. Check for contradictory checkpoints, malformed Markdown, and whitespace errors.
5. Run the strict MkDocs build before proposing documentation changes.
6. Review the complete diff before committing or pushing.
7. Use GitHub Actions to publish the website after approved changes reach the configured branch.

### Safety and learning rules
- Do not mark a topic understood without evidence from the learner's answers or work.
- Preserve the one-concept-at-a-time, prediction-first teaching approach.
- Do not overwrite local work with stale GitHub content.
- Do not commit or push without the learner's approval.
- Do not run Terraform apply, destroy, or impactful Azure operations without explicit approval.

### Automation priority
Automate repetitive validation and publishing first. Then reduce manual progress-tracker maintenance. Keep the learner in control of learning decisions and changes to the published material.

## Provider-Neutral AI Learning Handoff

**Goal:** Use the same learning context with ChatGPT, Gemini, Claude, Copilot, or another AI assistant without requiring an AI API key.

### Shared source of truth
- Keep `LEARNING-ROADMAP.md`, `LEARNING-PROGRESS.md`, and lesson notes as the canonical records.
- Use `AI-LEARNING-HANDOFF.md` for the current learning state and instructions that any assistant needs.
- Use `AI-SESSION-UPDATE-PROMPT.md` when asking any assistant to reconcile and update records after a session.
- At the start of a new AI chat, share the handoff file and current progress/lesson files. If the assistant can access the GitHub repository, give it the repository and branch; otherwise upload the files.
- At the end of a session, provide the actual answers, coding exercises, commands and results to the assistant, then ask it to draft updates for all relevant records.
- If the assistant cannot write to GitHub, ask it to return complete revised files or a unified diff. Review and apply those changes to the repository yourself.

### Consistency and safety
- Keep the current checkpoint, mastery status, evidence, pending exercise, and next step consistent across files.
- Never claim an exercise or validation ran unless the learner supplied the result or it was actually run.
- Never mark mastery without learner evidence.
- Prefer small coding exercises, learner predictions, and troubleshooting when appropriate.
- Review generated changes and validate the strict MkDocs build before merging or publishing.
- No AI assistant may run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.

### Automation limitation
This provider-neutral handoff does not call an AI model in the background. It works by sharing the same files with whichever assistant the learner chooses. Automatic model-driven updates require a supported integration or separate API access; this workflow does not require or assume one.


## Current Session Checkpoint — 2026-10-24

The latest practice session covered HCL block structure, local values, string interpolation, direct references, input variables, defaults and overrides, variable validation, lists, maps, map lookups, and conditional expressions in the isolated `terraform-hcl-practice/` directory.

### Resume next session
1. Start with logical operators: `&&` (AND), `||` (OR), and `!` (NOT).
2. Ask for a prediction before explaining the result.
3. First exercise: predict `is_india_production` when `var.environment = "test"` and `local.region = "centralIndia"`, where the condition combines the production check and a lowercase region comparison with `&&`.
4. Let the learner write and validate the small change, then cover OR and NOT separately.
5. Do not repeat already practised variable/collection concepts unless revisiting an identified misconception is useful.

### Practice workspace and repository hygiene
- Keep `terraform-hcl-practice/` isolated from the Azure-backed root Terraform configuration.
- Commit `terraform.tfvars.example`, not a real `terraform.tfvars`; ignore local tfvars, state, and the `.terraform/` working directory.
- Practice uses Terraform Console and validation only. No Azure resources or remote state should be changed.
- The session's current checkpoint and the progress tracker/lesson notes must agree.
- Preserve historical progress entries; newer dated authoritative checkpoint sections supersede old current-status text.


## Current Session Checkpoint — 2026-10-25 (supersedes 2026-10-24 checkpoint)

### Covered
- Logical operators `&&`, `||`, and `!`, including combined Boolean expressions.
- Conditional expressions combined with OR; verified `"small"` for `test` and `"standard"` for a console-level `dev` override.
- List `for` expressions for transformation, filtering, upper/lower case, and string interpolation.
- Map `for` expressions for key/value iteration, key/value transformation, list-to-map conversion, and filtering.
- Verified a filtered map in Terraform Console: `{"centralindia" = "CENTRALINDIA"}`.
- The learner asked what names such as `env`, `label`, and `fruit` mean; clarified that they are temporary iteration variables defined in the `for` expression, not input variables.

### Exact resume point
1. Continue with the pending prediction for a conditional expression inside a map `for` expression:
   ```hcl
   {
     for region in var.allowed_regions :
     region => (region == "centralindia" ? "primary" : "secondary")
   }
   ```
2. Ask what value the `westindia` key receives before explaining.
3. Verify in the isolated practice console.
4. Continue with small hands-on examples and keep the learner's answers as evidence; do not mark mastery without independent demonstration.

### Safety
Keep all practice in `terraform-hcl-practice/`. Do not run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval. Preserve Azure resources and remote state.


## Current Session Checkpoint — 2026-10-25 (map for expressions verified)

### Evidence covered
- Correctly predicted the values for a conditional map `for` expression: `centralindia = "primary"` and `westindia = "secondary"`; Terraform Console confirmed the result.
- Correctly predicted and verified that filtering out `centralindia` and transforming the remaining value with `upper(region)` produces `{"westindia" = "WESTINDIA"}`.
- Practised iteration, map key/value construction, conditional values, trailing `if` filters, and `upper()` together.

### Resume instructions
1. Continue with one small map `for` exercise combining a filter and a conditional value.
2. Ask the learner to predict the result before running Terraform Console.
3. Have the learner write the expression independently and share the actual console output.
4. Keep map `for` expressions as practised, not mastered, until independent understanding is demonstrated on a fresh example.
5. Keep all practice in the isolated `terraform-hcl-practice/` directory.

### Safety
No `terraform apply`, `terraform destroy`, Azure resource changes, or remote-state changes. Preserve existing Azure resources and state.


### Latest checkpoint — 2026-10-25
- Learner independently ran a map `for` expression combining a conditional value and a filter.
- Expression filtered out `westindia` and returned only `{ "centralindia" = "primary" }`; Terraform Console output matched the prediction.
- Takeaway: trailing `if` controls inclusion; `? :` chooses the value for an included entry.

### Resume instructions
Proceed to the next small HCL concept using prediction-first practice, one concept at a time. Keep examples in `terraform-hcl-practice/`. Do not mark map `for` expressions mastered yet; verify with a fresh example later. Do not run `terraform apply` or `terraform destroy` or alter Azure resources/remote state.


### Latest checkpoint — `flatten()` (2026-10-25)
- Learner correctly predicted that `flatten()` combines nested lists into one list.
- Ran a separate example in Terraform Console; output preserved `apple`, `banana`, `mango`, `orange` in order as a single list.
- Status: introduced and verified with one example; test a deeper nested list before marking mastered.
- Next: ask for a prediction on a list with multiple nesting levels, then verify in the isolated practice directory.


### `flatten()` checkpoint update — 2026-10-25
- Verified deeper nesting: nested list flattened to `dev`, `test`, `prod` in order.
- Discussed a real Terraform use case: flatten nested subnet/security-rule configuration into one list of objects, then convert it to a uniquely keyed map if using `for_each`.
- Next: use a small prediction-first exercise to practise `flatten()` with nested objects; continue avoiding infrastructure changes.


### Latest checkpoint — `toset()` (2026-10-25)
- Learner correctly predicted and verified that `toset(["dev", "test", "dev", "prod"])` removes the duplicate `dev`.
- Console output order differed from the input, reinforcing that sets do not guarantee order.
- Status: introduced and verified with one example. Continue with a short independent exercise before moving on.


### `toset()` checkpoint update — 2026-10-25
- Second example verified: `toset(["web", "app", "web", "app"])` returns the unique strings `app` and `web`.
- Learner predicted two unique values correctly; the console output confirmed it.
- `toset()` has been practised with two examples. Move to the next small HCL concept; revisit conversion to sets in the `for_each` context later.


### `distinct()` checkpoint — 2026-10-26
- Verified `distinct(["web", "app", "web", "db", "app"])` returns `tolist(["web", "app", "db"])`.
- Compared directly with `toset()` using the same input; set output displayed as `app`, `db`, `web`.
- Key distinction verified: `distinct()` returns a list preserving first-occurrence order; `toset()` removes duplicates but does not guarantee order.
- Next: continue to the next small HCL concept using prediction-first practice.


### `length()` checkpoint — 2026-10-26
- Learner predicted and verified `length(["web", "app", "db"])` returns `3`.
- Next: practise `length()` on a string; keep the lesson prediction-first.


### `length()` checkpoint update — 2026-10-26
- Verified list length (`["web", "app", "db"]` -> `3`) and string length (`"terraform"` -> `9`) in Terraform Console.
- Learner correctly described the distinction: list elements versus string characters.
- Clarification: list of two strings has length `2`, not the combined character count.
- Next: use a short prediction-first exercise to reinforce `length()` before moving on.


### `length()` checkpoint complete for this introductory pass — 2026-10-26
- Verified list count: `length(["web", "app", "db"])` -> `3`.
- Verified string character count: `length("terraform")` -> `9`.
- Verified list-of-strings count: `length(["terraform", "azure"])` -> `2`, not the combined character count.
- Move to the next small HCL function/concept with prediction-first practice.


### `contains()` checkpoint — 2026-10-26
- Learner correctly predicted and verified `contains(["dev", "test", "prod"], "test")` -> `true`.
- Takeaway: `contains()` checks whether the exact value is present and returns a Boolean.
- Next: predict and verify a missing value, expected to return `false`.


### `contains()` checkpoint complete — 2026-10-26
- Verified the present case: `contains(["dev", "test", "prod"], "test")` -> `true`.
- Correctly predicted and verified the absent case: `contains(["dev", "test", "prod"], "stage")` -> `false`.
- Both Boolean outcomes confirmed. Move to the next small HCL concept with prediction-first practice.


### `lookup()` checkpoint — 2026-10-26
- Learner predicted and verified `lookup({ dev = "small", prod = "large" }, "prod")` returns `"large"`.
- Takeaway: `lookup()` retrieves the map value associated with a key.
- Next: test a missing key and introduce the optional default value.
