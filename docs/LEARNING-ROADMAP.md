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
