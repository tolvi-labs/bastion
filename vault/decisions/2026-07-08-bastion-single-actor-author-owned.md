---
tags: [decision, bastion]
date: 2026-07-08
repo: bastion
status: active
ticket: none
user_impact: none
product_area: Developer tooling
negotiable: true
---

# Bastion is single-actor and author-owned; a PR mode is a re-check, not a relocated crucible

**Date:** 2026-07-08
**Repo:** bastion

## Why
The question came up: should `/bastion` also run against a pull request — your own, or someone else's? The answer follows directly from Bastion's thesis (it lives to the *left* of the code) and its mechanism (make the **author** defend the plan against what the system already knows). Held to that test, the two cases split and get opposite answers, and getting the boundary wrong would either dilute Bastion into commodity code review or invite engineers to route around the cheap pre-code moment.

## How
- **Own PR / own diff — allowed, but only as a re-check.** This is the already-deferred phase-2 diff gate ("point the same retrieve-and-match engine at a completed diff"). It is coherent because the author is still in the room to defend and any supersede they make is legitimately theirs. But it is strictly *weaker* than the plan gate — once code is written, understanding is retrofitted and expensive. So its job is narrow and must be framed as such: **did the implementation drift from the hardened plan, and does this diff fight any decision the plan didn't touch?** It is a drift-and-contradiction re-check, never a crucible relocated to PR time. Framing it as "a crucible you can run at PR time instead of plan time" is a trap — it rewards skipping the cheap moment to pay at the expensive one.
- **Someone else's PR — out of scope, not as Bastion.** The crucible needs the *author* to externalize their tacit reasoning; a third party running it on someone else's PR cannot do that (the author is not in the session), so all three crucible outputs collapse. And authority breaks: a reviewer cannot legitimately record a *supersede* against a decision on the author's behalf. What remains is "this diff contradicts decision X" surfaced for a human to raise — which is **vault-aware code review, not a crucible,** and squarely the commodity `/code-review` territory the design deliberately avoids. Giving it the Bastion name would dilute the one thing that makes Bastion distinct.
- **Multi-author is speculative today (YAGNI).** Today each change has a single author, so "someone else's PR" has no author yet, so building the multi-actor path now is speculative flexibility. If collaborators ever arrive, the correct move is **"the author runs Bastion pre-code,"** which lands right back in the single-actor, author-owned model — not "the reviewer runs Bastion on their PR."

## Outcome
Bastion stays single-actor and author-owned. This constrains the phase-2 diff gate from [[2026-07-07-bastion-reframed-as-crucible]]: if it ships, it is scoped to the author's *own* diff and framed as a drift-and-contradiction re-check. Reviewer-on-others'-PRs is explicitly left to `/code-review` (which could someday be taught to read the vault — a different tool, a different name).
