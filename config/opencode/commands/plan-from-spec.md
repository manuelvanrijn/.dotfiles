---
description: Create a plan from a spec
agent: plan
model: openai/gpt-5.4
reasoningEffort: high
temperature: 0.1
---

Write a plan for the provided specification given by the user as input.

DO NOT USE the `brainstorming` skill. You aren't allowed to use that in this state.
DO NOT SPAWN subagents to do any work. You are the expert in planning.

## Reading the spec

If the user provides a spec name/slug instead of inline content, read it from Obsidian using the `obsidian-cli` skill:

```bash
obsidian read path="agent-memory/<project-name>/specs/<filename>.md"
```

- `<project-name>` is derived from the current working directory name. If ambiguous, ask the user.

## Saving the plan

Save the plan to Obsidian using the `obsidian-cli` skill:

```bash
obsidian create path="agent-memory/<project-name>/plans/<date>-<slug>.md" content="<plan content>" silent overwrite
```

- Filename should match the spec filename (e.g. spec `2026-04-08-feature-name-design.md` → plan `2026-04-08-feature-name.md`).
- Use `obsidian-markdown` skill conventions for the content.
- Add frontmatter properties: `type: plan`, `project: <project-name>`, `date: <date>`.
- Reference the specification using an Obsidian wikilink: `[[agent-memory/<project-name>/specs/<spec-filename>|Spec: <title>]]`.

