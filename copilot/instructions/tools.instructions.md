---
name: Tool Selection
description: Preferred tools and search strategy
applyTo: "**"
---

# Tool selection

- Prefer purpose-built tools over shell. Use shell only when no better tool exists.
- Match the first meaningful search step to the task type.

## Search Routing

- Conceptual / architectural / pattern / flow questions: #tool:augment-context-engine/codebase-retrieval
- Known symbol, class, method, file, path, or regex lookup: #tool:seek/seek
- References / callers when Copilot exposes them: #tool:search/usages
- Inspect file contents after you know the path: #tool:read
- Non-code literals such as logs, comments, or error strings: `grep`

Rules:
- Apply this routing to the task itself, including your own intermediate search steps, not only to the user's wording.
- Do not spend #tool:augment-context-engine/codebase-retrieval on trivial known-file or exact-literal lookups.
- Do not use #tool:augment-context-engine/codebase-retrieval for named symbol/class/method/file lookups.
- Prefer #tool:search/usages over #tool:seek/seek for exact references/callers when it fits the question.
- Use #tool:seek/seek for broad concrete search and when no more precise navigation tool fits.
- If #tool:search/usages is unavailable, fall back to #tool:seek/seek.
- If semantic results are too broad, narrow with #tool:seek/seek and #tool:read.
- Read files only after narrowing context.
- Use #tool:execute for commands and verification.
- Choose results deterministically with non-interactive filters.

Use `jq` for JSON and `yq` for YAML/XML.

Use tool-specific syntax from the tool metadata rather than hardcoding it here.
