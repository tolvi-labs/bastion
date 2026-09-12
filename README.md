# Bastion

**A pre-code crucible for Claude Code.** Bastion is a skill, `/tolvi-bastion <plan | ticket | feature description>`, that refuses to write code and instead interrogates your plan against your vault before any code exists, hardening the plan, forcing tacit reasoning into explicit form, and depositing real rationale into `vault/decisions`.

It is the hardening layer of the Tolvi stack:

```
Guild (plan) → Bastion (harden) → execute
```

## Install

```shell
git clone https://github.com/tolvi-labs/bastion
cd bastion
./install.sh          # symlinks skills/tolvi-bastion into ~/.claude/skills/tolvi-bastion
```

Invoke `/tolvi-bastion` in Claude Code. Use `--copy` for a frozen snapshot, or `--uninstall` to remove. Bastion reads the repo's `vault/` (run `tolvi init` if you don't have one); set `ANTHROPIC_API_KEY` to enable ranked retrieval via `tolvi ask`.

## What it does

You invoke Bastion at the plan→code boundary, the last cheap moment to convert tacit reasoning into explicit. It ingests whatever you have (a plan, a ticket, or three sentences of intent), retrieves the relevant decisions from your vault, scores the work to set grilling depth, then grills you one pointed question at a time on gaps, contradictions with recorded precedent, and risk. Each answer either hardens the plan or supersedes a decision, and the session ends with a hardened plan plus any new vault deposits.

Bastion is **adversarial by job but convincible, not bureaucratic.** It enforces precedent by default and can be argued out of it; when you win the argument, that is a supersede, recorded. It never blocks unconvincibly and never writes implementation code.

## Core loop

```
/tolvi-bastion PROJ-142   (or a pasted feature description)
  ├─ 1. Ingest intent   → the plan/ticket = the substrate (no code yet)
  ├─ 2. Retrieve        → tolvi recall / tolvi ask pull relevant decisions
  ├─ 3. Score           → 4-dimension rubric sets grill depth (1 question ↔ full crucible)
  ├─ 4. Grill           → pointed questions, one at a time (gaps · contradictions · risk)
  ├─ 5. Resolve         → each answer hardens the plan or supersedes a decision
  └─ 6. Deliver         → a hardened plan + new/superseding vault decisions
```

The moat is the vault, not automation. Over an empty vault Bastion is generic design review; over a dense vault it interrogates against *this system's* recorded judgment. Value increases with vault density, and there is deliberately no minimum vault size.

## Design

The full design rationale (why a crucible not a gate, the source-priority ladder, negotiability) is in [`docs/superpowers/specs/2026-07-07-bastion-gatekeeper-design.md`](docs/superpowers/specs/2026-07-07-bastion-gatekeeper-design.md), and the decisions behind it live in [`vault/decisions/`](vault/decisions/).

## Contributing

Bastion keeps its decision record in the open (`vault/`), which is fitting since its whole job is to force reasoning into the vault. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Apache 2.0. See [LICENSE](LICENSE).
