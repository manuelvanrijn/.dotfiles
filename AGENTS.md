# Dotfiles — Agent Notes

## Setup

```
rake          # runs setup_osx.sh + setup_software.sh + all symlinks
```

No test suite. Verify by checking that symlinks exist after running rake.

## Symlink Conventions

Two patterns, both managed by `Rakefile`:

1. **`.symlink` files** in `git/`, `node/`, `ruby/`, `vim/`, `zsh/` → `~/.<basename>` (e.g. `zsh/zshrc.symlink` → `~/.zshrc`)
2. **Whole directories** linked as-is:
   - `agents/` → `~/.agents`
   - `codex/` → `~/.codex`
   - `copilot/` → `~/.copilot`
   - `config/mise/` → `~/.config/mise`
   - `config/opencode/` → `~/.config/opencode`
   - `factory/` → `~/.factory`

Edits in the repo take effect immediately (symlinks, no rebuild needed). Rake skips already-existing targets silently (`SKIPPED: ...`).

## Key Files

| Path | Purpose |
|------|---------|
| `config/opencode/opencode.jsonc` | OpenCode config (model, plugins, MCP, providers) |
| `config/mise/config.toml` | Managed language versions (Go, Node, Rust, Python, Ruby) |
| `Brewfile` | Homebrew packages — edit here, run `brew bundle install` |
| `zsh/zshrc.symlink` | Main shell config |

## AGENTS.md Duplication

`agents/AGENTS.md`, `codex/AGENTS.md`, `factory/AGENTS.md`, and `config/opencode/AGENTS.md` are **all identical**. They contain the global agent instructions. Keep them in sync manually when editing any one of them.

## Language Versions (mise)

Versions are pinned in `config/mise/config.toml`. Change there, then run `mise install`. Current pins: Ruby 4.0.1, Node 24.11.1, Python 3.13.3, Go 1.25.6, Rust stable.

## OpenCode Config

- Default model: `github-copilot/gpt-5-mini`
- Plugins: `opencode-openai-codex-auth`, `opencode-notifier`, `opencode-dcp`, `opencode-handoff`
- Project-level instructions loaded automatically from: `CLAUDE.md`, `.cursor/rules/*.md`, `.github/instructions/*.md`, `GEMINI.md`, `WINDSURF.md`
- Custom slash commands: `config/opencode/commands/` (markdown files)
- Custom plugins: `config/opencode/plugins/` (TypeScript files)
- Skills: `agents/skills/` (symlinked to `~/.agents/skills/`)
