# Bastion — Crucible Design (v0)

**Date:** 2026-07-07
**Status:** design rationale. The shipped `skills/bastion/SKILL.md` is the authoritative implementation; this document explains the *why* behind it.

## One-line

Bastion is a Claude Code skill, `/bastion <TICKET | feature description>`, that refuses to write code and instead runs a *crucible* on your plan — interrogating it against the vault, forcing your tacit reasoning into explicit form, and ending by handing you a hardened plan plus any new rationale deposited into `vault/decisions`. It is the gate to the left of the code, and the session inside it is a crucible.

## Purpose: a crucible, not just a gate

A gate is binary, defensive, convergent — its success metric is "bad plans don't pass." That is the *mechanism* Bastion uses, but it is not the *purpose*. The purpose is transformation under pressure: making the engineer defend the plan against what the system already knows. That single act produces three outputs at once.

### One act, three outputs

The one act — *make the engineer defend the plan against the system's recorded judgment* — yields:

1. **A hardened plan** — the correctness facet (the gate view). Risks resolved, gaps closed, decisions honored or superseded.
2. **An engineer who understands *why*, not just *what*** — the comprehension facet. You cannot survive the interrogation without articulating your reasoning, which forces the model in your head from tacit to explicit. This is *externalizing* reasoning, not a comprehension quiz — even a principal engineer holds reasoning tacitly and benefits from making it explicit, and that externalization is literally how the vault gets fed. It is respectful, not condescending.
3. **Occasionally, a better approach or a caught edge case** — the innovation facet. Articulating under pressure sometimes reveals that the rejected option is actually better, or that the plan never handled an edge case.

The vault deposit captures all three at once: the recorded decision is simultaneously the correctness artifact, the understanding made durable, and any innovation memorialized. Bastion does not build three tools; it builds one crucible and names its three facets.

### Two guardrails (so it does not become "too much")

It would be too much if understanding and innovation were treated as *jobs Bastion must actively perform* — that builds a tutor and an ideation engine strapped to a gate. Two rules keep it lean:

1. **Innovation is the upside tail, never a promised deliverable.** The reliable outputs are the hardened plan and durable understanding. Innovation is the bonus that is named but never depended on; promising it guarantees disappointment.
2. **"Understanding" means externalizing tacit reasoning, not testing the engineer.** Bastion never checks whether you "get it"; it forces the reasoning you already hold into explicit, recorded form.

## Why this shape

An autonomous, unattended agent that takes a ticket at face value is gameable by well-written-but-wrong tickets. This design inverts each failure:

- It is the **anti-autonomous** tool — it refuses to write code and makes the engineer defend the plan.
- It is placed to the **left of the code**, on intent, where "code is the outcome, not the substrate" works *for* it: before code exists there is no outcome, only substrate — intent, constraints, rationale — which is exactly what the vault stores and what an interrogation can reach.
- Its moat is the **vault**, not automation. Bastion over an empty vault is generic design review; over a dense vault it interrogates against *this system's* recorded judgment. Value increases monotonically with vault density.

## Posture

Convincible, not bureaucratic — but adversarial by job. On any contradiction with the vault, Bastion's task is to find where the engineer's thesis fails or has gaps. It enforces precedent by default and can be argued out of it; when the engineer wins the argument, that is a supersede, recorded. It never blocks unconvincibly and never writes implementation code.

## Where it sits in the SDLC

Bastion is **the crucible at the plan→code boundary — the last cheap moment to convert tacit reasoning into explicit before committing to it.** Earlier, in pure ideation, there is nothing solid to stress. Later, once code is written, understanding is retrofitted and expensive. So Bastion is invoked at the transition from "I *think* I'll build it this way" to "I *am* building it this way."

It is **not a step run on every ticket.** The throttle (below) opts out of the trivial majority — clear, small, low-risk work is waved through in one exchange or skipped. Bastion earns its place only on ambiguous, cross-cutting, or precedent-fighting work, which is exactly where engineers burn days going down a wrong path that is expensive to reverse once it is code. It is not another hoop; it is the one checkpoint that catches costly mistakes while they are still free to change.

## Core loop

```
/bastion PROJ-142   (or a pasted feature description)
  │
  ├─ 1. Ingest intent      → the ticket/description = the substrate (no code yet)
  ├─ 2. Retrieve           → `tolvi recall` / `tolvi ask` pull relevant decisions + patterns
  ├─ 3. Score (throttle)   → 4-dim rubric sets grill depth (1 question ↔ full crucible)
  ├─ 4. Grill              → pointed questions, one at a time:
  │                            • gaps: what the plan doesn't say but the vault cares about
  │                            • contradictions: "this fights decision X — intentional?"
  │                            • risk: task-type / dependency exposure from the rubric
  ├─ 5. Resolve            → each answer either hardens the plan or supersedes a decision
  └─ 6. Deliver            → (a) hardened plan doc  (b) new/supersede vault decisions
```

Step 5 is where the value concentrates. A clarifying answer hardens the plan. An answer that is *real rationale* ("we don't cache here because the data is per-request tenant-scoped") is offered up as a vault decision — Bastion proposes the deposit, the engineer confirms. The vault grows without anyone "writing documentation."

## Components

### 1. Retrieval — read the vault via the tolvi CLI

Bastion does not build its own index. It reads the repo's own `vault/` — `tolvi recall` for the active decisions, and `tolvi ask --json` (or a direct read of `vault/decisions/`) for topical precedent. Deposits are written with `tolvi sync`, and supersedes are done inline against the repo's vault.

### 2. The throttle — the 4-dimension rubric, repurposed

The durable kernel survives verbatim — Clarity, Task-Type Risk, Context Availability, Dependency Risk — but its consumer changes. It does not score "safe to hand to an unattended agent." It scores **how hard to grill the human**: high-clarity/low-risk work is waved through with one confirmation; low-clarity/high-risk work gets the full crucible. Proportional grilling is what keeps engineers from routing around the gate. The one directive that carries over is *never let the gate silently write code*.

### 3. The source-priority ladder — what Bastion challenges *from*

Bastion is only ever a bureaucrat if it asserts textbook answers as system truth. It must not. Challenges are drawn in strict priority order, and general engineering knowledge is used **only to generate questions, never to assert verdicts**:

1. **Vault decisions / patterns** — the strongest source. Bastion *interrogates against* recorded precedent ("this fights decision X").
2. **Repo `CLAUDE.md` + as-built code conventions** — legitimate system truth even with no vault.
3. **General engineering judgment** — used *only* to generate good questions. With no precedent, Bastion *elicits* the practice rather than asserting one: not "use the repository pattern" but "how does this system isolate data access, and why that way?" The answer becomes recorded practice.

**Source-transparency is mandatory.** Every challenge is labeled by where it comes from — "this contradicts 3 recorded decisions" versus "I have no precedent here; this is first-principles and your answer will seed the vault." Bastion never bluffs textbook as system truth. This is also why there is **no minimum vault size**: value is gated on "is there something worth grilling about here" (from precedent *or* from risk), not on how full the vault is — and a hard minimum would block the very first sessions that build the vault.

### 4. Negotiability — graded adversarial posture

Every decision carries a negotiability marker in its frontmatter:

```yaml
negotiable: true   # default — yields to a coherent justification
negotiable: false  # load-bearing — supersedable only by a thesis that survives adversarial stress
```

Bastion's job on any contradiction is adversarial regardless of the marker: find where the thesis fails. The marker sets the **bar**, not a lock:

- `negotiable: true` — a coherent justification that survives normal questioning is enough; Bastion records the supersede.
- `negotiable: false` — still supersedable, but Bastion escalates: it actively hunts for the failure point in the engineer's reasoning, and only a thesis that survives that stress passes. "Prove me wrong," not "give me a reason."

Nothing is an absolute lock; the hardest decisions simply cost more to move, and moving one is always recorded as a supersede.

### 5. Deliverable

When the crucible ends, Bastion hands back:

1. **A hardened plan doc** — the original intent annotated with the risks resolved, the gaps closed, and the decisions it now honors or supersedes.
2. **Vault deposits** — new `vault/decisions` entries (and supersede links) for any real rationale surfaced during grilling, each proposed by Bastion and confirmed by the engineer.

## Process integration

Bastion is connective tissue across the existing stack, not an island.

**Input flexibility.** Bastion ingests *whatever the engineer has* — a formal plan, a ticket, or three sentences of intent — and hardens it. It is a gate at the plan→code boundary, not the planner.

**Hand-off, not duplication.** Bastion's output (a hardened plan) is exactly the input an implementation-planning flow wants. Bastion feeds that pipeline; it does not replace it.

**Boundary with brainstorming/design.** Both interrogate intent before code, so the line must be explicit: brainstorming is *generative and open* ("what are we building, what are the options"); Bastion is *adversarial and precedent-anchored* ("where does THIS plan fail against what the system already knows"). Sequential, not redundant — brainstorm to shape, Bastion to stress-test. Bastion must never become a second brainstorming.

**Tooling map:**

| Tool | Role in Bastion |
|---|---|
| **`tolvi recall` / `tolvi ask`** | Retrieve relevant vault decisions/patterns |
| **`tolvi sync`** | Write deposits (supersede links done inline) |
| **an issue tracker** (optional) | Ingest a ticket by ID (`/bastion PROJ-142`); optional, falls back to free-text intent |
| **your implementation-planning flow** | Bastion hands off to it — hardened plan → implementation |
| **library-docs lookup** (optional) | Verify a library's real API during grilling (e.g. a deprecated method) |

## Cold-start behavior (the "no vault" answer)

No init script generates the vault. Auto-generating decisions from code is the trap we explicitly reject: code is the outcome, so generated rationale is fabrication — the same "well-written but wrong" failure this design exists to prevent. Decisions only ever come from the engineer, live, during grilling.

- **Greenfield / no vault:** Bastion grills from first principles plus the rubric, using general knowledge only to generate questions (source-priority tier 3). Session one is thin; session ten is dense. Cold-start is the onboarding, not a bug.
- **Legacy / no vault (in v0):** an optional one-time `patterns`-bootstrap — a read of the codebase that proposes `vault/patterns` entries, because conventions (naming, layering, libraries, test style) are genuinely recoverable from code. It **never** writes `decisions`.

## Explicitly not building (YAGNI)

- No decision auto-generation from code, ever.
- No diff-time gate in v0. Deferred to phase 2, reusing this same retrieve-and-match engine on a completed diff.
- No standalone runner or bash orchestrator. The old glue stays retired; Bastion lives entirely as a Claude Code skill over the existing vault stack.
- No "understanding" or "innovation" subsystems. Both are emergent facets of the one crucible act, not separately built features.

## Phase 2 (deferred)

A diff-time gate that points the same retrieval-and-match engine at a completed diff before commit/PR, checking the change against vault patterns and decisions. Deferred deliberately: it is closer to commodity `/code-review` territory, and the plan-phase engine should be proven first.

## Open questions

None blocking. Sub-mechanics to settle during planning: the exact frontmatter key for negotiability (`negotiable` vs a namespaced `bastion.*`), and how the hardened-plan doc is formatted and where it lands (in-repo `docs/` vs handed back inline).
