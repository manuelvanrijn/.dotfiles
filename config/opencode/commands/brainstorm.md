---
description: Brainstorming a idea to a spec
model: github-copilot/claude-opus-4.6
temperature: 0.7
---

Use the `brainstorming` skill to convert the user's input to a specification document.

When finished, save the spec to Obsidian using the `obsidian-cli` skill:

```bash
obsidian create path="agent-memory/<project-name>/specs/<date>-<slug>.md" content="<spec content>" silent overwrite
```

- `<project-name>` is derived from the current working directory name. If ambiguous, ask the user.
- Filename format: `<date>-<slug>.md` (e.g. `2026-04-08-feature-name-design.md`)
- Use `obsidian-markdown` skill conventions for the content (properties/frontmatter, wikilinks, callouts).
- Add frontmatter properties: `type: spec`, `project: <project-name>`, `date: <date>`.
