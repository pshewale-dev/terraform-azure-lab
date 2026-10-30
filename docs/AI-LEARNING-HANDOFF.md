# AI Learning Handoff — Terraform Zero-to-Hero

Use this file when starting or continuing a learning session with ChatGPT, Gemini, Claude, Copilot, or another AI assistant. No provider-specific API key is required to use this handoff.

## Repository
- Repository: `pshewale-dev/terraform-azure-lab`
- Learning branch: `main`
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

## Authoritative current checkpoint — 2026-10-29

This section supersedes the older current checkpoint above; older notes are retained as historical context. Read `docs/LEARNING-PROGRESS.md` and `docs/lesson-03-state.md` for the evidence record.

- **Course:** Phase 1 — Fundamentals; Lesson 3 — State and Resource Addresses; **IN PROGRESS**.
- **Verified environment:** repository `~/azure-lab`, branch `main`; lab directory `~/azure-lab/terraform-hcl-practice`; Terraform v1.17.0; AzureRM v4.81.0.
- **Backend/state context:** no backend or cloud block was found in this lab's `.tf` files; local `terraform.tfstate` exists with owner-only permissions. Do not confuse this directory with `vm-practice/hub-spoke-lab`, which uses a separate Azure Storage backend.
- **Evidence from 2026-10-29:** `terraform state list` returned `azurerm_resource_group.lab`; `terraform state show` displayed the recorded name, location and tags. Configuration and state attributes were compared and matched. Learner predicted a tag-only update; the plan proposed one tag change for `dev` → `test`, then the tag was restored and a final plan reported no changes. `terraform fmt` and `terraform validate` were run. No apply or Azure resource changes were performed.
- **Interview recall:** learner explained that `terraform plan` previews proposed changes and `terraform apply` executes changes against the target provider. Clarified that `apply` may create a fresh plan unless given a saved plan.
- **Status:** concepts practised/verified in this exercise, not globally mastered; Lesson 3 remains in progress.
- **Next session:** continue with one practical, read-only scenario about configuration, state addresses and live infrastructure; include verification, one troubleshooting drill and an interview explanation. Do not resume a long chain of multiple-choice questions.
- **Safety:** preserve `rg-tf-lab-prashant-dev`, its state, and `vm-practice/hub-spoke-lab`. No `terraform apply`, `terraform destroy`, state mutation, or impactful Azure action without fresh explicit approval.



## Authoritative current checkpoint — 2026-10-30

This section supersedes earlier current-checkpoint sections above. The canonical progress tracker and Lesson 3 notes contain the detailed evidence.

- **Course:** Phase 1 — Fundamentals; Lesson 3 — State and Resource Addresses; **IN PROGRESS**.
- **Repository:** `pshewale-dev/terraform-azure-lab`; active learning branch: `main`.
- **Workspace:** `~/azure-lab/terraform-hcl-practice`; Terraform v1.17.0; AzureRM provider v4.81.0.
- **State context:** this workspace has no `backend` or `cloud` block and uses local `terraform.tfstate`. Do not confuse it with `vm-practice/hub-spoke-lab`, which has a separate Azure Storage backend.
- **Verified object:** state address `azurerm_resource_group.lab`; resource group `rg-tf-lab-prashant-dev` in `centralindia`; tags `environment=dev`, `managed_by=terraform`, `purpose=learning-lab`. Read-only Azure CLI output matched configuration and state.
- **2026-10-30 learning evidence:** learner predicted a configured tag change from `dev` to `test` would be in-place; plan showed one tag change and no apply occurred. The tag was restored to `dev`; fmt, validate and normal plan were run, and the plan reported no changes. Learner correctly explained drift and chose to update configuration if the external value is intended to be retained.
- **Refresh distinction:** refresh-only plan showed saved state `test` versus live Azure `dev`; it previews updating state to reflect live values without changing Azure. No refresh-only apply was run, so the state refresh was not explicitly persisted. A later normal plan refreshed its in-memory view and reported no changes; normal plan alone does not persist a refreshed snapshot.
- **Status:** Lesson 3 remains in progress. The above is practised/verified for this exercise, not mastery.
- **Next session:** one practical, read-only troubleshooting exercise explaining why saved state may differ from live Azure and distinguishing refresh-only plan, refresh-only apply, and ordinary plan; then a concise interview explanation.
- **Safety:** preserve `rg-tf-lab-prashant-dev`, its local state, and `vm-practice/hub-spoke-lab`. No apply, destroy, state mutation, backend migration, or impactful Azure operation without fresh explicit approval.
