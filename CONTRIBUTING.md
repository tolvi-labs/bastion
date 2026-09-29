# Contributing to Bastion

Bastion is a Claude Code skill: a pre-code crucible that interrogates a plan against your vault, hardens it, and never writes code. Contributions welcome, with one rule that's different here.

## The rule that's different: change the tool, record the why

This project keeps its decision record in the open, in [`vault/`](vault/), and **a change to how the skill behaves must come with the reasoning.** If your PR changes Bastion's behavior (the grill-depth rubric, the source-priority ladder, the deposit/supersede flow, retrieval), include a vault decision that captures *why*:

```shell
tolvi sync decision "Short imperative title"   # writes vault/decisions/YYYY-MM-DD-<slug>.md
```

Commit it alongside your code. PRs that change behavior without a decision will be asked to add one. This is the product dogfooding itself, and it's especially apt for Bastion, whose whole job is to force reasoning into the vault before code exists.

## What belongs in the public vault

Engineering decisions only: the *why* of the code. **Never** put client or project names, JIRA keys, business strategy, competitive analysis, revenue, PII, or security-incident specifics in this repo; those belong in a private vault. Use placeholders like `PROJ-142` for tickets. See [`vault/README.md`](vault/README.md).

## Local setup

```shell
git clone https://github.com/tolvi-labs/bastion
cd bastion
./install.sh          # symlinks skills/tolvi-bastion into ~/.claude/skills/tolvi-bastion (invoke with /tolvi-bastion)
```

Bastion reads the repo's `vault/`; run `tolvi init` if a repo has no vault yet. Set `ANTHROPIC_API_KEY` to enable ranked retrieval via `tolvi ask`.

## Standards

- Match the existing prose and structure of `skills/tolvi-bastion/SKILL.md`.
- Bastion never writes implementation code; preserve that in every change.
- The vault grows only from real, engineer-confirmed rationale; never fabricate a decision from a code read.
- One decision per behavior change. Session logs stay out of this repo.
