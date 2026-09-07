---
tags: [decision, bastion]
date: 2026-09-07
repo: bastion
status: active
ticket: none
user_impact: low
product_area: Developer tooling
---

# Bastion's Step 6 emits a structured JSON brief alongside the existing text block

**Date:** 2026-09-07
**Repo:** bastion

## Why
Guild's docs promise Bastion forwards a structured `{how, scope, appliedDirectives, resolvedGaps}` brief downstream, but Bastion never actually produced one — Step 6 only emitted free text. Magellan (the new compile-layer skill) needs a machine-readable brief to decompose, and re-parsing free text on every run is fragile and wastes reasoning on a solved problem.

## How
Step 6 now emits a second fenced `json` block immediately after the existing `HARDENED PLAN` text block, carrying `how`, `scope` (`{in, out}`), `appliedDirectives`, and `resolvedGaps` — derived from state already held by that point in the flow (the restated intent, the grill's resolutions, the vault hits honored), so no new retrieval is required. This is strictly additive: the free-text block, which remains the primary human-readable output, is untouched.

## Outcome
Bastion's output now has two audiences: the free-text block for a human, and the JSON block for a downstream compile step. Magellan's Phase 1 (Ingest) reads this JSON block as its primary input contract.
