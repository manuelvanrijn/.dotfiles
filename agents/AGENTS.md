# General Agentic rules
- IMPORTANT: Be extremely concise. Sacrifice grammar for the sake of concision.

## Context engine
This context engine is the most advanced code indexing service there is. It deeply indexes and semantically maps your whole codebase (and history). It can provide tailored code suggestions and answers based on the codebase, best practices, coding patterns, and preferences.

- Use **Augment's context engine** `codebase-retrieval` to it's fullest potential.
- It retrieves only the most relevant files, symbols, and commits for a given task, so the LLM sees the right slice of your repo instead of a blind big context window.
- It feeds that curated context so agents behave more like a senior engineer who "knows the codebase."
- Assume that what is retrieved is what you need to use as truth, no need to perform additional grep searches.

## File Operations
- Find files by name: `fd`
- Find files with path: `fd -p <file-path>`
- List directory: `fd . <directory>`
- Find with extension/pattern: `fd -e <extension> <pattern>`

## Structured Code Search
- Find code structure: `ast-grep --lang <language> -p '<pattern>'`
- List matching files: `ast-grep -l --lang <language> -p '<pattern>' | head -n 10`
- Prefer `ast-grep` over `rg`/`grep` for syntax-aware matching

## Data Processing
- JSON: `jq`
- YAML/XML: `yq`

## Selection
- Select from multiple results deterministically (non-interactive filtering)
- Fuzzy finder: `fzf --filter 'term' | head -n 1`

## Guidelines
- Prefer deterministic, non-interactive commands (`head`, `--filter`, `--json` + `jq`)

## When you're done/finished
- Output the work you've done in a 1-3 sentence summary

## General Rules
- Early dev, no users. Do things RIGHT: clean, organized, zero tech debt. No compatibility shims.
- NEVER workarounds. Full implementations for >1000 users. No half-baked solutions.
- NEVER remove/hide/rename existing features/UI unless explicitly asked. Keep UX intact, stub if not wired.
