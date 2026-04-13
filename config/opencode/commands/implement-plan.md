---
description: Implement the plan using the Orchestrator
agent: orchestrator
---

If the user provides a plan name/slug instead of inline content, read it from Obsidian using the `obsidian-cli` skill:

```bash
obsidian read path="agent-memory/<project-name>/plans/<filename>.md"
```

- `<project-name>` is derived from the current working directory name. If ambiguous, ask the user.

Coordinate/Orchestrate the implementation of the plan.
