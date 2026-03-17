---
description: Create a plan from a spec
agent: plan
model: openai/gpt-5.4
---

Write a plan for the provided specification given by the user as input.

DO NOT USE the `brainstorming` skill. You aren't allowed to use that in this state.
DO NOT SPAWN subagents to do any work. You are the expert in planning.

When finished and you are going to write the plan it's IMPORTANT you save it to `.opencode/plans` with the filename that MUST BE EQUAL to the input specification filename.

After the plan is written, (if applicable verified) and finalized, the final step will be to store the file using the `bear-notes` skill with the tag `#agent-memory/plans` aswell.
Make sure that links to notes that are present in Bear Notes are Bear-style wiki links to the notes.
