---
description: write plan/context as spec to _IGNORE/specs
agent: build
---

You are writing a SPEC markdown file for the just-finished planning session.

## Inputs
- Today: !`date +%F`
- Project root (cwd): !`pwd`
- Optional title override: "$ARGUMENTS" (if empty, infer from plan)
- Current todos: !`opencode todo list 2>/dev/null || echo "[]"`

## Requirements
1) Ensure `_IGNORE/specs` exists in the project root.
2) Create a spec file in `_IGNORE/specs`.
3) Filename: `YYYY-MM-DD_<slug>.md`
   - `<slug>` derived from title:
     - lowercase
     - spaces/dashes => `_`
     - remove non `[a-z0-9_]`
     - collapse multiple `_`
4) Write the gathered context, plan from the planning conversation to the spec file.
5) Make sure the information is clear enought for another developer or ai agent to implement the plan.
6) Avoid overwriting:
   - If file exists, append `_2`, `_3`, ... before `.md`.

## Execution (do it, don't just describe)
- Use bash to `mkdir -p _IGNORE/specs` in project root.
- Extract plan steps from conversation + parse todoread output.
- Decide title:
  - If `$ARGUMENTS` not empty => title = `$ARGUMENTS`
  - Else if conversation has clear plan topic => infer from that
  - Else if todoread has items => title = first todo content
  - Else => ask user for a short title, then continue.
- Write the final markdown to the chosen filepath.
- Reply with the created filepath + 1 sentence summary.
