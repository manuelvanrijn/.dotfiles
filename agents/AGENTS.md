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
- Prefer `seek` over `glob`, `grep`, and `rg` for code search and repo exploration.

#### `seek`
Use this tool when you know the concrete search term.

Use one quoted argument only. Keep every filter inside that single string. Single quotes only.

When spawning sub-agents that may not inherit this config, pass: `Use seek 'pattern' for code search. All filters in ONE quoted string. Never use grep/rg.`

Patterns:
- `sym:Name` definitions via ctags
- `file:path` include paths
- `-file:path` exclude paths
- `lang:python` language filter
- `content:regex` content-only regex
- `type:file` file-name matches

Examples:
- `seek 'needle'` - basic text
- `seek 'sym:validate file:agents/skills/skill-creator/scripts'` - symbol + path scope
- `seek 'content:"validation" lang:python file:agents/skills/skill-creator/scripts'` - content + language + path scope
- `seek 'content:/validate_.*/ file:/agents\\/skills\\/skill-creator\\/scripts\\/.*\.py/'` - regex content + regex file
- `seek '(lang:go or lang:python) validation'` - boolean grouping
- `seek 'type:file config'` - filenames only
- `seek 'type:file AGENTS.md'` - agent instruction files
- `seek 'sym:main file:agents/skills/skill-creator/scripts -file:test'` - project symbol search
- `seek 'lang:python content:def main file:agents/skills'` - Python entrypoints

Prefer examples that match files or symbols that exist in the current workspace.

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
