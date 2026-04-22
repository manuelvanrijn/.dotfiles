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

## Search Routing
Choose the tool that matches the task, not the wording of the prompt.
- Architecture, patterns, module relationships, ownership, end-to-end flow, or "how/why does this work?": `codebase-retrieval` first.
- Known symbol, class, method, file, path, or regex lookup: `seek` first.
- References, callers, implementations, type information, or call hierarchy: `lsp` first.
- Structural or syntax-aware matching / bulk refactors: `ast-grep`.
- Exact non-code literals such as logs, comments, and error strings: `grep` or `rg`.

Rules:
- Prefer purpose-built tools over shell. Use shell only when no better tool exists.
- Apply this routing to the task itself, including your own intermediate search steps, not only to the user's literal wording.
- Use `codebase-retrieval` for understanding.
- Use `seek` for locating known code.
- Use `lsp` for code intelligence on already-located symbols.
- If `lsp` is unavailable or unsupported, fall back to `seek`.
- Do not use `codebase-retrieval` for named symbol/class/method/file lookups.
- Do not spend semantic search on trivial known-file, known-symbol, or exact-literal lookups.
- Use `grep`/`rg` only for exact literal lookup. Stop there unless the literal search fails.
- Do not use `grep`/`rg` or file-name globbing for normal code search when `lsp` or `seek` fit better.

## Selection
- Choose results deterministically with non-interactive filters.

## Data Processing
- Use `jq` for JSON and `yq` for YAML/XML.

## Verification
- Do not claim success without verification.
- Run the narrowest relevant check first. Broaden when risk or failure signals justify it.

## Completion
- End with a brief summary: what changed, how verified.
