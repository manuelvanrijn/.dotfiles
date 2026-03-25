# Core
These are IMPORTANT principles you MUST follow at all times.
- Be extremely concise. Sacrifice grammar for brevity.
- BEFORE replying, ALWAYS use skills/tools proactively when they apply.
- Simplicity first: make the smallest change that solves the problem.
- Minimal impact: touch only what is necessary. Avoid regressions.
- Find the root cause. No temporary fixes.
- Think holistically: consider affected areas, files, and side effects.

## Product & Engineering Philosophy
- Assume unreleased branch work can be changed directly; avoid compatibility shims unless explicitly needed.
- If part of a feature is not wired yet, stub it safely without breaking UX.
- For non-trivial work, choose the simplest solution that fully solves the problem.

## Planning Guidelines
- Use subagents in parallel when they clearly reduce time on non-trivial research or review.

## Execution & Autonomy

### Tool Selection & Operations
- Prefer purpose-built tools over shell. Use shell only when no suitable MCP tool exists.
- Prefer the `seek` cli over `Glob`, `Grep`, and `rg`.
- Verify tool availability before assuming it is missing.
- If `seek` fails, state the exact failure once, then use the narrowest fallback tool.

Use the tool that matches the query stage, and do not skip stages without stating why:
1. Unknown location, architecture, or "where does this live?" -> `mcp_vector_search_search_context`
2. Known or partially known identifier, symbol, filename, route, path, or exact code pattern -> `seek`
3. If `seek` fails, say so explicitly, then use the narrowest fallback tool
4. Behavior-oriented follow-up after narrowing context -> `mcp_vector_search_search_code`
5. Structural or syntax-aware matching -> `ast-grep`
6. Logs, comments, error strings, or exact plain text -> `rg` or `grep`

NOTE:
- Do not continue with `Glob`, `rg`, or `grep` once you already have concrete search terms.
- `Glob` is for file listing only, not code search.
- `rg`/`grep` are for plain text only, not normal code exploration.
- If concrete search terms are known, using `grep`, `rg`, or `Glob` instead of `seek` is a workflow violation unless `seek` failed.
- If you deviate from the preferred tool path, state the reason in one sentence before continuing.
- Do not treat model-guessed terms as concrete search terms.
- Only use `seek` first when the term is user-provided, already verified from prior search results, or directly visible in known context.
- If the terms are inferred guesses about possible implementation details, start with `mcp_vector_search_search_context`.

#### `mcp_vector_search_search_context`
Use this tool only when you do not yet know where the code lives.
IMPORTANT: If `mcp_vector_search_search_context` returns concrete names, files, symbols, routes, or paths, you MUST switch to `seek`.

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

#### `mcp_vector_search_search_code`
Use this tool when:
- the code area is already narrowed
- you need behavioral understanding
- `seek` did not help because the question is still conceptual

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
- Choose results deterministically with non-interactive filters

## Completion Protocol
- End with a brief summary of what changed and how you verified it.
