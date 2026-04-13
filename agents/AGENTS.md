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

### Tool Selection
Prefer purpose-built tools over shell. Shell only when no MCP tool exists.

#### Search tool selection
Match tool to question type, not as fallback chain.

| Tool | Use for |
|------|---------|
| `seek` | Concrete: known symbol, class, filename, regex, references, text |
| `codebase-retrieval` | Conceptual: architecture questions, pattern discovery, flow understanding, "how does X work", high-level codebase orientation |
| `ast-grep` | Structural: AST-aware matching, refactors across files |
| `rg` / `grep` | Literals only: logs, comments, error strings |

`seek` is free (local). `codebase-retrieval` costs per call but is the right tool for semantic/conceptual work. Use each where it excels, not one as fallback for the other.

#### `seek`
Concrete search: files, symbols, references, text/regex.

One quoted argument. All filters in that single string. Single quotes only.

Patterns:
- `sym:Name` definitions via ctags
- `file:path` / `-file:path` include/exclude paths
- `lang:python` language filter
- `content:regex` content-only regex
- `type:file` file-name matches

Examples:
- `seek 'needle'` — basic text
- `seek 'sym:validate file:agents/skills/skill-creator/scripts'` — symbol + path
- `seek 'content:"validation" lang:python file:agents/skills/skill-creator/scripts'` — content + lang + path
- `seek 'content:/validate_.*/ file:/agents\\/skills\\/skill-creator\\/scripts\\/.*\.py/'` — regex content + regex file
- `seek '(lang:go or lang:python) validation'` — boolean grouping
- `seek 'type:file config'` — filenames only
- `seek 'type:file AGENTS.md'` — agent instruction files
- `seek 'sym:main file:agents/skills/skill-creator/scripts -file:test'` — project symbol
- `seek 'lang:python content:def main file:agents/skills'` — Python entrypoints

Prefer examples matching files/symbols in the current workspace.

#### `codebase-retrieval` (augment)
Semantic search for conceptual questions. Use as **first choice** when the question is about understanding, not locating.

Use for:
- "Where is user authentication handled?" — cross-cutting, no single keyword
- "How does the payment flow work end-to-end?" — architecture/flow
- "What patterns does this codebase use for error handling?" — pattern discovery
- Gathering high-level context before starting a task
- Understanding how modules/systems relate

Do NOT use for (use `seek`):
- Known class/symbol → `seek 'sym:Foo'`
- All references to a function → `seek 'bar('`
- File by name → `seek 'type:file config'`
- Scoped definition → `seek 'sym:validate file:services'`

#### `ast-grep`
`ast-grep --lang <language> -p '<pattern>'` for AST-aware matching and refactors.

#### `rg` / `grep`
Only for: logs, comments, error strings, exact literals.

#### Data Processing
- JSON → `jq`
- YAML/XML → `yq`

### Verification
- No success claims without verification.
- Run relevant tests/builds/checks for changed work.
- Compare against base branch when it reduces risk.

## Selection
Choose results deterministically with non-interactive filters.

## Completion
End with brief summary: what changed, how verified.

## Session Documentation & Memory
- Project naming: dot-prefix repos (e.g. `.dotfiles`) → strip dot for `set_project_context` (e.g. `dotfiles`). Always pass stripped name as `project_folder`.
