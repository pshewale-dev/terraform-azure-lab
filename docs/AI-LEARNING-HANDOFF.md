# AI Learning Handoff — Terraform Zero-to-Hero

Use this file when starting or continuing a learning session with ChatGPT, Gemini, Claude, Copilot, or another AI assistant. No provider-specific API key is required to use this handoff.

## Repository
- Repository: `pshewale-dev/terraform-azure-lab`
- Learning branch: `feature/dynamic-nsg`
- Canonical records: `docs/LEARNING-ROADMAP.md`, `docs/LEARNING-PROGRESS.md`, and `docs/lesson-01-fundamentals.md`
- Read the canonical records before teaching or editing. Do not rely on this summary if the latest progress file says otherwise.

## Current known checkpoint
- Phase 1 — Fundamentals.
- Lesson 1.17, explicit dependencies (`depends_on`): UNDERSTOOD, based on the learner correctly answering the resource-ordering prediction and when explicit dependencies are useful.
- Next step: inspect existing notes for HCL syntax and configuration structure before teaching new material.
- Teaching style: one concept at a time, prediction-first, short learner-written coding exercises where useful, then verify and troubleshoot.
- Do not mark a concept mastered until the learner demonstrates it.
- The learner wants practical coding, not theory alone. Use local-only validation when appropriate, such as `terraform fmt` and `terraform validate`, and explain what each command checks.
- Never run `terraform apply`, `terraform destroy`, or impactful Azure operations without explicit approval.

## Session start
1. Read this handoff and the latest progress tracker, roadmap, and relevant lesson notes.
2. Confirm the current checkpoint and pending exercise from the canonical records.
3. Continue from that point; do not repeat mastered material unless needed for a brief recall check.
4. Ask the learner to predict first, then give a small coding task when it materially helps understanding.

## Session end
1. Record only topics actually covered, answers actually given, code actually written, and tests/commands actually run.
2. Update relevant lesson notes and the progress tracker together; update the roadmap only when the plan or workflow changes.
3. Preserve useful historical notes, but make the current checkpoint unambiguous.
4. Check consistency, conflict markers, and whitespace; run the strict MkDocs build if tools permit.
5. If direct GitHub write access is unavailable, return complete revised files or a patch for the learner to apply.
6. Never claim a GitHub commit, push, build, or deployment succeeded unless it was actually verified.

## Provider-neutral workflow
- The learner may upload these files to any AI assistant.
- If that assistant has repository access, it may propose edits to the existing branch or a separate review branch according to the learner's approval.
- If it has no repository access, it should return edits or a patch, not claim it changed GitHub.
- Do not require an OpenAI API key or assume the learner has API credits.
- This file is a portable handoff, not a background agent. Sharing it does not automatically synchronize chats or update GitHub.


## Authoritative current checkpoint — 2026-10-28
Use this section together with the newest checkpoint in docs/LEARNING-PROGRESS.md; it supersedes the older Lesson 1 checkpoint above.

- **Current lesson:** Lesson 3 — State and Resource Addresses, IN PROGRESS.
- **Recent work:** read-only state/address inspection; protected local state permissions with chmod 600; checked Git ignore patterns for state, backup state files, and .terraform/; confirmed .terraform.lock.hcl is normally committed.
- **Retired lab cleanup:** learner confirmed old rg-practice-lab resources were destroyed after reviewing a plan listing 51 resources. The old root Terraform files were renamed to .tf.disabled and moved into vm-practice/_archive/.
- **Must preserve:** vm-practice/hub-spoke-lab and the separate Azure-backed rg-tf-lab-prashant-dev learning resource group and state. Do not treat these as part of the retired cleanup.
- **Next step:** ask a prediction-first question about configuration and state disagreeing, then use read-only state commands only after confirming the working directory and backend. Do not delete files or state to simulate a mismatch.
- **Safety:** no terraform apply, terraform destroy, state/backend migration, or impactful Azure operation without fresh explicit approval. A historical approval to retire the old lab is not blanket permission for future operations.
