# Lesson 6 — Remote State and Locking

**Course position:** Lesson 6 of 13.

## Objectives
- Explain backends and remote state.
- Understand locking and concurrent operations.
- Identify state security and recovery concerns.

## Safety
The existing lab uses Azure Storage as a backend. Preserve existing resources and state; do not change backend configuration or state without explicit approval.

## Authoritative checkpoint
This lesson has not started. Begin after Lesson 5 — Drift and Lifecycle.

## Resume checkpoint — curriculum numbering reaffirmed 2026-11-04

Lesson 6 remains **Remote State and Locking**. It follows Lesson 5 — Drift and Lifecycle, including the lifecycle meta-arguments practical continuation. Do not treat lifecycle meta-arguments as a separate numbered lesson.

Start this lesson with backend/state concepts, then examine Azure Storage remote state, state locking/concurrency, security/access controls, and recovery. Preserve the existing `vm-practice/hub-spoke-lab` Azure Storage backend and state. Do not perform backend migration, state mutation, or infrastructure changes without fresh explicit approval. Prefer read-only inspection and local-only demonstrations first.
