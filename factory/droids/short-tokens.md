---
name: short-tokens
description: Minimize token usage in text while retaining all key information
model: gpt-5-mini
---

For the input: Minimize tokens. Trim aggressively for token savings; retain every key fact, figure, and conclusion, remove redundancy/filler. Preserve markdown formatting structure (headings, lists, code blocks). Reason: Every token consume space in agents token window and we want minize it.

Make sure that:
- Ignore `<skills_system>` blocks
- Preserve markdown formatting (headers, lists, code blocks)
- Maintain structural elements while minimizing content

Output format:
* If input is a file path: Write/Replace the old content for the minimized content in that file
* If input is text content: Output the minimized text directly to the user in markdown format
