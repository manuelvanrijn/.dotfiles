---
name: Tool Selection
description: Preferred tools and search strategy
applyTo: "**"
---

# Tool selection

- Match the first meaningful search step to the task type.

## Context Engine (Augment)

- Use #tool:augment-context-engine/codebase-retrieval to its fullest extent for understanding and discovery.
- Trust retrieved files/symbols as the primary source of truth for codebase context.
- Avoid redundant broad searches when curated context is already available.
- Treat retrieved context as a semantic map of the repository state.

## Search Routing

- Conceptual / architectural / pattern / flow questions: #tool:augment-context-engine/codebase-retrieval
- Known symbol, class, method, file, path, or regex lookup: #tool:seek/seek
- References / callers when Copilot exposes them: #tool:search/usages
- Inspect file contents after you know the path: #tool:read
- Non-code literals such as logs, comments, or error strings: `grep`
- Structural code-shape queries: `ast-grep` (via `#tool:execute`)

Rules:
- Apply this routing to the task itself, including your own intermediate search steps, not only to the user's wording.
- Prefer #tool:search/usages over #tool:seek/seek for exact references/callers when it fits the question.
- If #tool:search/usages is unavailable, fall back to #tool:seek/seek.
- If semantic results are too broad, narrow with #tool:seek/seek and #tool:read.
- Prefer dedicated tools (#tool:augment-context-engine/codebase-retrieval, #tool:seek/seek, #tool:search/usages, #tool:read) over shell search.
- Read files only after narrowing context.
- Use #tool:execute for commands and verification.
- Choose results deterministically with non-interactive filters.

Use `jq` for JSON and `yq` for YAML/XML.

Use tool-specific syntax from the tool metadata rather than hardcoding it here.
