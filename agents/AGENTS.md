# Core
These are IMPORTANT principles you MUST follow at all times.
- Be extremely concise. Sacrifice grammar for brevity.
- BEFORE replying, ALWAYS use skills/tools proactively when they apply.
- Simplicity first: make the smallest change that solves the problem.
- Find the root cause. No temporary fixes.
- Think holistically to find the right scope, then minimize the change within it.

## Product & Engineering Philosophy
- Assume unreleased branch work can be changed directly; avoid compatibility shims unless explicitly needed.
- If part of a feature is not wired yet, stub it safely without breaking UX.

## Execution & Autonomy

### Tool Selection
Prefer purpose-built tools over shell. Use shell only when no MCP tool exists.

#### Search tool selection
Match the primary tool to the question type. Use fallbacks only if the primary tool is unavailable, incomplete, or too noisy.

| Tool | Use for |
|------|---------|
| `seek` | Concrete: known symbol, class name, filename, regex, references, text search |
| `lsp` | Code intelligence: definition, references, type/docs, call hierarchy, implementations |
| `codebase-retrieval` | Conceptual: architecture questions, pattern discovery, flow understanding, "how does X work", high-level codebase orientation |
| `ast-grep` | Structural: AST-aware matching, refactors across files |
| `rg` / `grep` | Literals only: logs, comments, error strings |

`seek` is free/local. `lsp` is compiler-accurate. `codebase-retrieval` costs per call but is right for semantic/conceptual/pattern-recognition work. Use each where it fits. Substitute only per fallback rules.

#### Default tool per intent

| Intent | Primary | Fallback |
|--------|---------|----------|
| Definition of a known symbol | `lsp goToDefinition` | `seek 'sym:Name'` |
| All call sites / references | `lsp findReferences` | `seek 'functionName('` |
| Type signature / docs | `lsp hover` | — |
| Call graph | `lsp incomingCalls` / `outgoingCalls` | — |
| Interface implementations | `lsp goToImplementation` | `seek` |
| Broad text/symbol search across codebase | `seek` | — |
| Find file by name | `seek 'type:file ...'` | — |
| Conceptual / architectural understanding | `codebase-retrieval` | `seek` + `lsp` |
| Syntax-aware pattern matching / bulk refactor | `ast-grep` | — |
| Logs, comments, error strings | `rg` | `seek` if `rg` unavailable |

Fallback rules:
- If `lsp` is unavailable or returns nothing, use `seek`
- If `codebase-retrieval` is too vague, narrow with `seek` or `lsp`
- If `seek` is too noisy for a code pattern, use `ast-grep`

#### When to combine tools
Complex tasks often need multiple tools:
- Orientation: `codebase-retrieval`
- Navigation: `lsp`
- Sweep: `seek`
- Refactor: `ast-grep`
- Verify: tests/build

#### `seek`
Broad concrete search: files, symbols, references, text/regex. Use for multi-file text search, filenames, or when LSP is unavailable.

Use one quoted argument only. Put all filters in that string. Use single quotes only.

Patterns:
- `sym:Name` definitions via ctags
- `file:path` / `-file:path` include/exclude paths
- `lang:python` language filter
- `content:regex` content-only regex
- `type:file` file-name matches

Examples:
- `seek 'needle'`
- `seek 'sym:validate file:agents/skills/skill-creator/scripts'`
- `seek 'content:"validation" lang:python file:agents/skills/skill-creator/scripts'`
- `seek 'content:/validate_.*/ file:/agents\\/skills\\/skill-creator\\/scripts\\/.*\.py/'`
- `seek '(lang:go or lang:python) validation'`
- `seek 'type:file config'`
- `seek 'type:file AGENTS.md'`
- `seek 'sym:main file:agents/skills/skill-creator/scripts -file:test'`
- `seek 'lang:python content:def main file:agents/skills'`

Prefer examples matching files/symbols in the current workspace.

#### `lsp`
Compiler-accurate code intelligence. Prefer over `seek` for precise, type-checked results.

Operations: `goToDefinition`, `findReferences`, `hover`, `documentSymbol`, `workspaceSymbol`, `goToImplementation`, `prepareCallHierarchy`, `incomingCalls`, `outgoingCalls`.

Use for:
- Exact symbol definition → `goToDefinition`
- Type-checked call sites → `findReferences`
- Type signature / docs → `hover`
- All symbols in a file → `documentSymbol`
- Who calls this function / what it calls → `incomingCalls` / `outgoingCalls`
- Interface implementations → `goToImplementation`

Use `seek` for broad text search, filenames, or when LSP is unavailable for the language.

#### `codebase-retrieval`
Semantic search for conceptual questions. First choice for understanding, not locating.

Use for:
- "Where is user authentication handled?"
- "How does the payment flow work end-to-end?"
- "What patterns does this codebase use for error handling?"
- High-level context before starting
- Understanding module/system relationships

Do not use for:
- Known class/symbol → `seek 'sym:Foo'` or `lsp goToDefinition`
- All references to a function → `lsp findReferences` or `seek 'bar('`
- File by name → `seek 'type:file config'`
- Scoped definition → `seek 'sym:validate file:services'`

#### `ast-grep`
Use `ast-grep --lang <language> -p '<pattern>'` for AST-aware matching and refactors.

Use for syntax-tree pattern matching and bulk refactors. For symbol-aware navigation and call graphs, use `lsp`.

#### `rg` / `grep`
Only for non-code plaintext: logs, comments, error strings, build output. For code search, prefer `seek`.

#### Data Processing
- JSON → `jq`
- YAML/XML → `yq`

### Verification
- No success claims without verification.
- Run the narrowest relevant tests/checks that cover the change.
- Broaden verification when risk, scope, or failure signals justify it.
- Compare against base branch when it reduces risk.

## Selection
Choose results deterministically with non-interactive filters.

## Completion
End with a brief summary: what changed, how verified.

## Session Documentation & Memory
- Dot-prefixed repos (e.g. `.dotfiles`) → strip the dot for `set_project_context` (e.g. `dotfiles`). Always pass the stripped name as `project_folder`.
