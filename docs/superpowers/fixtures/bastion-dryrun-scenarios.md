# Bastion Dry-Run Scenarios

Verification for a prose skill = run the input, confirm the observable beats. No pytest.

## S1 — Clear, low-risk, vault-covered (throttle waves through)
Input: `/bastion PROJ-142` where PROJ-142 is a well-specced "add a GET endpoint, no schema change" ticket in a repo whose vault has a matching pattern.
Expected beats: ingest resolves the ticket; retrieval surfaces the matching pattern; throttle scores GO (>=80) and grills with ONE confirming question, not a full interrogation; ends with a hardened plan + writing-plans hand-off offer.

## S2 — Contradicts a non-negotiable decision (escalated crucible + supersede)
Input: `/bastion` with pasted intent "I'll add a Redis cache in front of the tenant billing read path" in a repo whose vault holds `negotiable: false` decision "no caching of per-request tenant-scoped data".
Expected beats: retrieval flags the contradiction and labels it "contradicts decision X (non-negotiable)"; throttle scores lower → full crucible; grill escalates, actively hunting the failure in the engineer's thesis; if the engineer's thesis survives, Bastion proposes a SUPERSEDE of decision X (never a silent override); deposit is confirmed before writing.

## S3 — Greenfield, no vault (elicitation mode, tier-3 labeling)
Input: `/bastion` with pasted intent in a repo with an empty/absent vault.
Expected beats: retrieval returns nothing; every challenge is labeled "no precedent here — first-principles, your answer will seed the vault"; Bastion ELICITS ("how does this system isolate data access, and why that way?") rather than asserting a textbook answer; answers that are real rationale are proposed as NEW decisions.
