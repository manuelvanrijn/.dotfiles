---
name: Tool Selection
description: Preferred tools and search strategy
applyTo: "**"
---

# Tool selection

- Prefer purpose-built tools over shell. Use shell only when no MCP tool exists.
- Match the primary tool to the question type. Use fallbacks only if the primary tool is unavailable, incomplete, or too noisy.

## Search Strategy

- Go broad to narrow.
- For conceptual/semantic work (architecture, patterns, "how does X work?"), always prefer #tool:augment-context-engine/codebase-retrieval before #tool:seek/seek.
- Start with #tool:augment-context-engine/codebase-retrieval, glob patterns, or #tool:seek/seek to discover relevant areas.
- Narrow with text search, regex, or usages (#tool:searchusages`) for specific symbols or patterns.
- Read files only when you know the path or need full context.

## Default tool by intent

| Intent | Primary | Fallback |
|--------|---------|----------|
| Conceptual / architectural understanding | #tool:augment-context-engine/codebase-retrieval | #tool:search/codebase + #tool:read` |
|All call sites / references | #tool:seek/seek | #tool:search/usages |
| Inspect file contents | #tool:read` | #toolsearch/codebase |
| Broad text/symbol search across codebase | #tool:seek/seek | #tool:search/codebase |
| Find file by name | #tool:seek/seek with `type:file ...` | #tool:search/codebase |
| Logs, comments, error strings | `grep` | #tool:seek/seek if `grep` is unavailable |

- Use #tool:augment-context-engine/codebase-retrieval MCP first when it is available and the task is conceptual or architectural.
- Use #tool:seek/seek and built-in search tools for fast, local discovery.
- Use #tool:seek/seek for concrete work when you want precise results or tighter control over the search.
- Use #tool:edit` onlyafter you know exactly what needs to change.
- Use #tool:execute` forcommands, checks, and repo-wide verification.

- Use #tool:seek/seek for concrete work: known symbol, class name, filename, regex, references, text search.
- Default to `max_results=200` so searches stay bounded.
- Use #tool:search/codebase as the built-in fallback for conceptual work when Augment is unavailable.
- Use #tool:search/usages when you need references or callers and #tool:seek/seek is too broad.
- Use `rg` or `grep` only for literals: logs, comments, error strings.
- Prefer `jq` for JSON and `yq` for YAML/XML.
- Choose results deterministically with non-interactive filters.
- If #tool:augment-context-engine/codebase-retrieval is too vague, narrow with #tool:seek/seek, #tool:search/usages, or `read`.
- If #tool:seek/seek is too noisy for a code pattern, switch to #tool:search/codebase plus #tool:read.

## When to combine tools

- Orientation: #tool:augment-context-engine/codebase-retrieval
- Navigation: #tool:search/usages
- Sweep: #tool:seek/seek
- Refactor: #tool:seek/seek or #tool:augment-context-engine/codebase-retrieval → #tool:read → #tool:edit

##`seek` query syntax (for #tool:seek/seek)

- Use one query string. Put all terms and filters in that same string.
- Search operators:
	- Plain substring: `CoreRouter`
	- Content-only search: `content:async def.*handler`
	- Explicit regex search: `regex:foo.*bar`
- Symbol search:
	- `sym:CoreRouter` (definitions via ctags)
- Filters:
	- `file:router/src` (include path)
	- `-file:test` (exclude path)
	- `lang:python`
	- `case:yes|no|auto`
	- `type:file` (filename matches only)
- Boolean logic:
	- `foo or bar`
	- `(foo or bar) lang:go`
	- `handleError file:api -file:test`

Notes:
- Prefer `regex:` for explicit regex intent. Use `content:` when you want to constrain the search surface to file content.
- Do not split filters into separate tool calls; combine them in one query.
- CLI exit codes (seek docs): `0` = match, `1` = no match, `2` = error.

Validated examples in this repository:
- `Dotfiles`
- `content:Dotfiles`
- `regex:Dotfiles.*Agent`
- `sym:setup`
- `agents file:config`
- `Dotfiles lang:markdown`
- `case:yes Dotfiles`
- `type:file AGENTS.md`
- `agents -file:plugins`
- `Dotfiles or Rakefile`
- `(Dotfiles or Rakefile) lang:markdown`
- `agents file:config -file:plugins`
