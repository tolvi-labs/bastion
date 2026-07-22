---
tags: [decision, bastion]
date: 2026-07-07
repo: bastion
status: active
ticket: none
user_impact: none
product_area: Developer tooling
---

# Bastion reframed as a pre-code crucible, not an overnight agent

**Date:** 2026-07-07
**Repo:** bastion

## Why
Bastion's original identity — an autonomous agent that runs unattended and opens PRs — was the wrong shape for an engineer-in-the-loop tool. Reframing it as a gate that interrogates a plan *before* code is written gives a solo engineer a checkpoint that catches expensive-to-reverse mistakes while they are still free to change, and it works *with* the engineer rather than around them.

## How
- **Placement:** a `/bastion <TICKET | feature description>` gate to the LEFT of the code. Before code exists there is no outcome, only substrate (intent, constraints, rationale) — exactly what the vault stores and what an interrogation can reach. This is why the objection "code is the outcome, not the substrate" argues *for* a pre-code gate, not against it.
- **Purpose is a crucible, not a pass/fail gate.** One act — make the engineer defend the plan against the system's recorded judgment — yields three outputs at once: a hardened plan (correctness), an engineer who understands *why* not just *what* (comprehension, via externalizing tacit reasoning), and occasionally a better approach or caught edge case (innovation, the upside tail — named, never promised).
- **The vault is the entire moat.** Value increases monotonically with vault density; over an empty vault Bastion is just generic design review. Retrieval is therefore scoped to the current repo's vault (a cross-repo hit must never be presented as THIS system's judgment).
- **Cold-start is onboarding, never auto-generation.** No init script generates the vault — code is the outcome, so generated rationale is fabrication (the "well-written but wrong" failure mode). Greenfield → elicit precedent (first-principles questions become seed decisions); legacy → an optional one-time bootstrap proposes `patterns` only, never `decisions`.
- **Convincible, graded posture.** Contradictions are adversarial by job; a `negotiable: false` decision raises the bar ("prove me wrong") but is still supersedable, and moving one is always recorded as a supersede. Absent `negotiable` field defaults to `true`.
- **Durable kernel reused:** the 4-dimension rubric survives verbatim as the grill-depth throttle (how hard to grill), and deposits use `tolvi sync`; retrieval reads the repo's vault via the tolvi CLI. Full design in `docs/superpowers/specs/2026-07-07-bastion-gatekeeper-design.md`; shipped as the `skills/bastion/` skill in this repo.
- **Rejected:** auto-generating the vault from a code scan (fabricates rationale); a diff-time gate as v0 (deferred to phase 2 — closer to commodity `/code-review`); keeping the overnight runner (retired).

## Outcome
Bastion is a `/bastion` skill that runs a pre-code crucible over a plan and grows the vault as a byproduct.
