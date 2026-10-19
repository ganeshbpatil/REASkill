# RE Lab: standing rules

These rules apply to every investigation in this repo. If a brief conflicts with them, the rules win: stop and ask.

## 0. Legal gate (before any analysis)
- Every target must have a row in `targets/MANIFEST.csv` with `source` and `basis` filled in. If either is missing, do not analyse it.
- Allowed reasons to analyse: interoperability, security research, competitive *behaviour* analysis of software we lawfully obtained, or our own artifacts.
- Do not: bypass DRM or licence checks, use leaked or stolen builds, log in with credentials that aren't ours, or send traffic to competitor infrastructure beyond what a normal user's client would send.
- If a target's EULA forbids reverse engineering, record that under `basis` and flag it in `brief.md`. Proceeding then needs a human sign-off.

## 1. Targets are read-only
- `targets/` holds raw inputs only. Never modify, patch or repack a file there. Work on copies inside `investigations/<id>/evidence/`.
- Record a SHA-256 for each target at intake (`scripts/Add-Target.ps1`). Re-check the hash before citing a target in a report.
- Only run target code in a sandbox (VM, emulator, or REA's provider sandbox). Never run it on the host.
- HAR files contain cookies, tokens and PII. Remove `Authorization`, `Cookie`, `Set-Cookie` and personal data before anything goes into `evidence/`.

## 2. Workflow (always in this order)
1. **brief.md**: question, scope, out-of-scope, success criteria. No analysis until it's filled in.
2. **evidence/**: raw REA output only. Each file name starts with a step number, e.g. `03-rea-strings-libfoo.txt`. Append the exact REA command and tool version to `evidence/LOG.md`.
3. **report.md**: findings. Every claim cites an evidence file and gives a confidence level.
4. **specs/**: a reusable build spec. Write one only when the finding is worth building.

## 3. Evidence standards
- Cite every claim: `[E:03-rea-strings-libfoo.txt]`.
- Confidence levels:
  - **Confirmed**: observed at runtime or in traffic.
  - **Likely**: static evidence from two or more independent sources.
  - **Inferred**: a single source or a reasoned guess. Mark it as one.
- Report what the evidence shows, not what we'd like to be true. Record negative results too.

## 4. Clean-room boundary (non-negotiable)
- `report.md` and `specs/` describe **behaviour, data contracts, UX flows and architecture**. They never contain decompiled or disassembled code, copied assets, copied strings longer than an identifier, or competitor secrets (API keys, signing keys, internal endpoints that need auth).
- Specs must be implementable by someone who has never seen `evidence/`.
- If you're tempted to paste code into a spec, describe what it does instead.

## 5. Output conventions
- Investigation folder name: `YYYY-MM-<target-slug>`.
- Paths in docs are relative to the repo root.
- At the end of each session, update the `Status` line at the top of `brief.md`.
