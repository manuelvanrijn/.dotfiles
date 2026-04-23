# Core
These are global rules for all projects.
- Be extremely concise. Sacrifice grammar for brevity.
- Use relevant skills/tools when they materially improve accuracy or speed.
- Simplicity first: make the smallest change that solves the problem.
- Find the root cause. No temporary fixes.
- Think holistically to find the right scope, then minimize the change within it.

## Product & Engineering Philosophy
- Assume unreleased branch work can be changed directly; avoid compatibility shims unless explicitly needed.
- If part of a feature is not wired yet, stub it safely without breaking UX.

# Context & Code Intelligence
## Codebase Context Engine
- Use `codebase-retrieval` to its fullest extent.
- Trust retrieved files/symbols/commits as the primary source of truth.
- Avoid redundant broad searches when curated context is provided.
- Treat context as a semantic map of the repo and history.
- Use `seek_search` for known symbol, class, method, file, path, or regex lookups.

# Tooling & Operations
## File Operations
- Find files by name: `fd`
- Find files with path: `fd -p <file-path>`
- List directory: `fd . <directory>`
- Find with extension/pattern: `fd -e <extension> <pattern>`

## Structured Code Search
- Syntax-aware search: `ast-grep --lang <language> -p '<pattern>'`
- List matches: `ast-grep -l --lang <language> -p '<pattern>' | head -n 10`
- Prefer `seek_search` for concrete code location lookups before shell search.
- Prefer `ast-grep` over `rg`/`grep` for code structure queries.

## Data Processing
- JSON: `jq`
- YAML/XML: `yq`

## Deterministic Selection
- Use non-interactive filtering.
- Fuzzy select deterministically: `fzf --filter 'term' | head -n 1`
- Prefer deterministic commands (`head`, `--filter`, `--json` + `jq`).

## Verification
- Do not claim success without verification.
- Run the narrowest relevant check first. Broaden when risk or failure signals justify it.

## Completion
- End with a brief summary: what changed, how verified.
