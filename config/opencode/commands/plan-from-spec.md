---
description: Create a plan from a spec
agent: plan
model: openai/gpt-5.4
reasoningEffort: high
temperature: 0.1
---

Prerequisite: If `.opencode/plans` doesn't exist, create a symlink to the folder `~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Notes/agent-memory/<project-name>/plans/`, where <project-name> is the name of the project you are working on. If in doubt, ask the user for the project name.

Write a plan for the provided specification given by the user as input.

DO NOT USE the `brainstorming` skill. You aren't allowed to use that in this state.
DO NOT SPAWN subagents to do any work. You are the expert in planning.

When finished and you are going to write the plan it's IMPORTANT you save it to `.opencode/plans` with the filename that MUST BE EQUAL to the input specification filename.
Reference the specification file in the plan using obsidian links.

