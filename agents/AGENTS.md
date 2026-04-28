# Core
These are global rules for all projects.
- Be extremely concise. Sacrifice grammar for brevity.
- Use relevant skills/tools when they materially improve accuracy or speed.
- Simplicity first: make the smallest change that solves the problem.
- Find the root cause. No temporary fixes.
- Think holistically to find the right scope, then minimize the change within it.

## Product & Engineering Philosophy
- Assume unreleased branch work can be changed directly; avoid compatibility shims unless explicitly needed.
- If part of a feature is not wired yet, stub it safely without breaking UX.

# Context & Code Intelligence
## Codebase Context Engine
- Use `codebase-retrieval` to its fullest extent.
- Trust retrieved files/symbols/commits as the primary source of truth.
- Avoid redundant broad searches when curated context is provided.
- Treat context as a semantic map of the repo and history.
- Use `seek_search` for known symbol, class, method, file, path, or regex lookups.

# Memory
## Obsidian Memory
- Use `obsidian-cli` for all memory reads and writes in the `Notes` vault.
- If `obsidian-cli` is unavailable or fails, skip memory work and continue the task.
- Use the `obsidian-markdown` skill before creating or updating memory notes.
- Store memory under `agent-memory/` in the `Notes` vault.
- Use Obsidian properties and wikilinks for memory notes.
- Keep state in readable Markdown. Prefer updating existing notes over creating new ones.

## Session Start
- Using `obsidian-cli` in the `Notes` vault, read `agent-memory/index.md`.
- Resolve the current project name from the workspace folder.
- For Git worktrees, use `git rev-parse --show-toplevel` and `git rev-parse --git-common-dir`; if the common dir reveals the parent repo, use that repo basename.
- Normalize project names by removing leading dots, so `.dotfiles` becomes `dotfiles`.
- Using `obsidian-cli` in the `Notes` vault, read `agent-memory/<project-name>/memory.md` if it exists.
- Using `obsidian-cli` in the `Notes` vault, read the last few days of logs in `agent-memory/<project-name>/sessions/`.
- Read the relevant project files for the current request.

## Project Memory
- `agent-memory/index.md` tracks active projects with project wikilinks, status, last touched date, and short next action.
- `agent-memory/<project-name>/memory.md` holds durable project state: decisions, conventions, gotchas, recurring issues, and next actions.
- Create `agent-memory/<project-name>/memory.md` only for long-term projects, not one-off requests.
- Session logs are history. Project memory holds current state.
- If a useful state note is missing, create it in the same simple style.

## Sessions
- Before ending a session or at applicable stopping points, write or update `agent-memory/<project-name>/sessions/YYYY-MM-DD-session-NNN.md`.
- Session logs must include YAML properties with `opencode_session: ses_...`; use `opencode_session: unknown` if unavailable.
- Session logs must use the OpenCode session title as both the YAML `title` and the first `#` heading; fall back to a concise descriptive title if unavailable.
- Session logs should include summary, decisions, files touched, verification, and next steps.
- Update `agent-memory/index.md` if active projects changed or completed.
- Update the relevant `memory.md` if durable project state changed.

# Tooling & Operations
## File Operations
- Find files by name: `fd`
- Find files with path: `fd -p <file-path>`
- List directory: `fd . <directory>`
- Find with extension/pattern: `fd -e <extension> <pattern>`

## Structured Code Search
- Syntax-aware search: `ast-grep --lang <language> -p '<pattern>'`
- List matches: `ast-grep -l --lang <language> -p '<pattern>' | head -n 10`
- Prefer `seek_search` for concrete code location lookups before shell search.
- Prefer `ast-grep` over `rg`/`grep` for code structure queries.

## Data Processing
- JSON: `jq`
- YAML/XML: `yq`

## Deterministic Selection
- Use non-interactive filtering.
- Fuzzy select deterministically: `fzf --filter 'term' | head -n 1`
- Prefer deterministic commands (`head`, `--filter`, `--json` + `jq`).

## Verification
- Do not claim success without verification.
- Run the narrowest relevant check first. Broaden when risk or failure signals justify it.

## Completion
- End with a brief summary: what changed, how verified.
