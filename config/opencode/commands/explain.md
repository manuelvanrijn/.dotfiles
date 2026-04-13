---
name: explain
description: Explain how a certain feature works in the codebase by trying to explain it in a structured way for a developer to understand.
---

# Explain

Provide a structured, concrete overview of how the following works in the codebase based on the provided input:

Structure your answer as follows:

1. Phases / lifecycle

* Describe the flow in clear chronological phases
* For example: trigger → processing → external calls → completion

2. Calls and interactions (per phase)
   For each step:

* from → to (which system/component calls what)
* endpoint / method (HTTP, service call, job, etc.)
* key payload / parameters
* authentication used (none / user token / app token / other)

3. Code entrypoints (important)

* List the concrete controllers, services, jobs, and models involved
* Include file paths (relative to the repo)
* Identify where the flow starts and where key decisions are made

4. State changes

* What changes in the database or application state?
* Which fields are set or updated?
* Are records created, updated, or deleted?

5. Decision points / branches

* Where are conditional paths?
* What happens in different scenarios (e.g. success/failure, existing vs new user, expired, etc.)
* Explicitly mention guards and validations

6. Side effects / async processes

* Which background jobs, events, or external integrations are triggered?
* When do they occur (sync vs async)?

7. Summary diagram

* Provide a compact table or ASCII diagram showing:
  from → to → purpose of each step

8. Where to modify for changes

* List the main files/locations where this behavior can be changed
* Map them to parts of the flow

Goal:
A concrete, code-level overview that allows someone to:

* quickly understand how the system works
* see where data, authentication, and state change
* identify where to implement changes

Be specific and avoid abstract descriptions — mention real classes, methods, and fields.

INPUT:
