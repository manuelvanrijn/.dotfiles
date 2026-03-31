# Core
These are IMPORTANT principles you MUST follow at all times.
- Be extremely concise. Sacrifice grammar for brevity.
- BEFORE replying, ALWAYS use skills/tools proactively when they apply.
- Simplicity first: make the smallest change that solves the problem.
- Find the root cause. No temporary fixes.
- Think holistically to find the right scope; then minimize the change within that scope.

## Product & Engineering Philosophy
- Assume unreleased branch work can be changed directly; avoid compatibility shims unless explicitly needed.
- If part of a feature is not wired yet, stub it safely without breaking UX.

## Execution & Autonomy

### Tool Selection & Operations
- Prefer purpose-built tools over shell. Use shell only when no suitable MCP tool exists.
- Prefer the `seek` cli over `glob`, `grep`, and `rg`.
- Skip `seek` if we aren't in a git repository.
- Verify tool availability before assuming it is missing.
- If `seek` fails, state the exact failure once, then use the narrowest fallback tool.

Use the tool that matches the query stage, and do not skip stages without stating why:
1. Any identifier, symbol, filename, route, path, or code pattern -> `seek`
2. If `seek` fails, say so explicitly, then use the narrowest fallback tool
3. Structural or syntax-aware matching -> `ast-grep`
4. Logs, comments, error strings, or exact plain text -> `rg` or `grep`

NOTE:
- Do not continue with `glob`, `rg`, or `grep` once you already have concrete search terms.
- `glob` is for file listing only, not code search.
- `rg`/`grep` are for plain text only, not normal code exploration.
- If concrete search terms are known, using `grep`, `rg`, or `glob` instead of `seek` is a workflow violation unless `seek` failed.
- If you deviate from the preferred tool path, state the reason in one sentence before continuing.

#### `seek`
Use this tool when you know the concrete search term.

Examples:
- `seek 'needle'` - basic text
- `seek 'sym:validate file:agents/skills/skill-creator/scripts'` - symbol + path scope
- `seek 'content:"validation" lang:python file:agents/skills/skill-creator/scripts'` - content + language + path scope
- `seek 'content:/validate_.*/ file:/agents\\/skills\\/skill-creator\\/scripts\\/.*\.py/'` - regex content + regex file
- `seek '(lang:go or lang:python) validation'` - boolean grouping
- `seek 'type:file config'` - filenames only
- `seek 'content:"foo\"bar"'` - escaped quote

Prefer examples that match files or symbols that exist in the current workspace.

Rules:
- pass exactly ONE quoted argument
- keep all filters in one string

#### Structural search `ast-grep`
Use `ast-grep --lang <language> -p '<pattern>'` for AST-aware matching and refactors.

#### Plain-text search `rg` or `grep`
Use `rg` or `grep` only for:
- logs
- comments
- error strings
- exact literals

#### Data Processing
- JSON -> `jq`
- YAML/XML -> `yq`

### Verification Before Done
- Do not claim success without verification.
- Run the relevant tests, builds, or checks for the work you changed.
- Compare against the base branch when that meaningfully reduces risk.

## Selection
Choose results deterministically with non-interactive filters.

## Completion Protocol
End with a brief summary of what changed and how you verified it.
