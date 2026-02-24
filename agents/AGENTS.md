# Core Principles
- IMPORTANT: Be extremely concise. Sacrifice grammar for concision.
- IMPORTANT: BEFORE replying, ALWAYS ask: should I use a skill/tool? Use best available.
- Simplicity First: Smallest possible change. Minimal code impact.
- Minimal Impact: Touch only what’s necessary. Avoid regressions.
- No Laziness: Find root causes. No temporary fixes. Senior engineer standards.
- Think holistically: consider affected areas, files, and side effects.

# Product & Engineering Philosophy
- Early dev, no users: prioritize correctness, cleanliness, zero tech debt.
- No compatibility shims or hacks.
- NEVER remove/hide/rename existing features/UI unless explicitly asked.
- If something is not wired yet: stub, don’t break UX.
- For non-trivial work: ask “is there a more elegant solution?” (avoid over-engineering for trivial fixes).

# Planning Guidelines
- ALWAYS ask clarifying questions BEFORE committing to a plan.
- Surface edge cases, constraints, and architectural implications.
- Plans must be concise, actionable steps (not essays).
- Include “what” and “why”, not just “how”.
- Maintain hierarchy: product/UX → architecture → code structure.
- List unresolved questions at the end of the plan.
- Write detailed specs upfront to reduce ambiguity.
- Use subagents to research codebase parts in parallel when possible.

# Execution & Autonomy
## Autonomous Bug Fixing
- When given a bug report: fix directly.
- Use logs, errors, and failing tests as primary signals.
- No hand-holding or unnecessary context switching.
- Proactively fix failing CI tests.

## Verification Before Done
- Never mark complete without proving it works.
- Run tests, check logs, validate behavior.
- Diff behavior between main and changes when relevant.
- Ask: “Would a staff engineer approve this?”

# Self-Improvement Loop
- After ANY user correction: update `docs/lessons.md`.
- Capture mistake patterns and prevention rules.
- Ruthlessly iterate to reduce future error rate.
- Review relevant lessons at session start.

# Context & Code Intelligence
## Context Engine (Augment)
- Use `codebase-retrieval` to its fullest extent.
- Trust retrieved files/symbols/commits as the primary source of truth.
- Avoid redundant broad searches when curated context is provided.
- Treat context as a semantic map of the repo and history.

# Tooling & Operations
## File Operations
- Find files by name: `fd`
- Find files with path: `fd -p <file-path>`
- List directory: `fd . <directory>`
- Find with extension/pattern: `fd -e <extension> <pattern>`

## Structured Code Search
- Syntax-aware search: `ast-grep --lang <language> -p '<pattern>'`
- List matches: `ast-grep -l --lang <language> -p '<pattern>' | head -n 10`
- Prefer `ast-grep` over `rg`/`grep` for code structure queries.

## Data Processing
- JSON: `jq`
- YAML/XML: `yq`

## Deterministic Selection
- Use non-interactive filtering.
- Fuzzy select deterministically: `fzf --filter 'term' | head -n 1`
- Prefer deterministic commands (`head`, `--filter`, `--json` + `jq`).

# Completion Protocol
- Do not declare done without validation.
- Provide a 1–3 sentence summary of the work performed when finished.
