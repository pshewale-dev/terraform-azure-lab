# AI Session Update Prompt — Provider Neutral

Copy this prompt into ChatGPT, Gemini, Claude, Copilot, or another AI assistant after sharing:
- `docs/AI-LEARNING-HANDOFF.md`
- `docs/LEARNING-PROGRESS.md`
- `docs/LEARNING-ROADMAP.md`
- The relevant lesson file(s)
- Your actual session notes, answers, code, and command output

---

You are helping maintain my Terraform Zero-to-Hero learning records. Use the shared repository files as the source of truth and follow their terminology and learning plan.

## Your tasks
1. Identify what was actually taught or practised in this session.
2. Record my actual predictions, answers, code exercises, commands, results, mistakes, and unresolved questions.
3. Update the relevant lesson notes and progress tracker consistently. Update the roadmap only if the learning plan or workflow changed.
4. Keep the current checkpoint, mastery status, supporting evidence, pending exercise, and next step aligned across files.
5. Preserve historical context that remains useful. Avoid duplicate sections and contradictory current checkpoints.
6. Use small hands-on code exercises when they help understanding; do not turn the learning record into theory-only notes.
7. Validate for conflict markers and whitespace errors, and run the strict MkDocs build if you have an execution environment.
8. Return a concise summary of changed files, the exact next learning step, and validation results.

## Rules
- Do not invent learner answers, coding practice, command output, test results, or mastery.
- A correct answer to one question does not automatically prove full lesson mastery; follow the roadmap's mastery rule.
- If evidence is missing, mark the item pending or in progress and state what is needed.
- Do not rewrite unrelated files or change Terraform infrastructure.
- Never run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.
- Do not claim to have edited GitHub, committed, pushed, opened a PR, built the site, or deployed it unless you actually did and verified the result.
- If you cannot write to the repository, provide complete revised file contents or a clean unified diff and clearly tell me how to apply it.
- Do not require an OpenAI API key. Work with the capabilities available in the current AI service.

## Session evidence
I will provide the actual session summary below. If it does not include a fact, do not assume that fact.

[PASTE SESSION SUMMARY, MY ANSWERS, CODE EXERCISES, COMMANDS AND OUTPUT HERE]
