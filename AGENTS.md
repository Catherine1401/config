# AGENTS.md

Dotfiles sync repo (zsh, tmux, kitty). nvim lives in a separate repo, cloned by `install.sh`.

## Current context
- `main` is synchronized with `origin/main` at `d0433c7` (`fix(zsh): guard missing cargo environment`).
- `uninstall.sh` restores backed-up config, removes only installer-owned dependencies, and deletes the clone after cleanup; use `--yes` to skip confirmation.
- The real uninstall → fresh clone → install cycle has passed. `./test.sh` passes all checks.
- Runtime ownership data lives in ignored `.install-state/`; pre-existing dependencies are preserved during uninstall.

## Scope map
- `install.sh` — bootstrap new machine: symlink `LINKS` map into `$HOME`; clone nvim repo, TPM, and oh-my-zsh custom plugins/theme via `clone_if_missing` if missing; run TPM `install_plugins`; set `core.hooksPath`.
- `sync.sh push [msg]` / `sync.sh pull` — sync this repo AND `~/.config/nvim` (if present) together.
- `test.sh` — validates zsh/tmux/kitty config syntax + script syntax. Auto-runs via `.githooks/pre-push`; run manually after any edit.
- `.docs/` — human docs, gitignored, never commit.

## Architecture rule
All symlink targets are declared in the `LINKS` map at the top of `install.sh`. New synced config file → add an entry there. Never hardcode a symlink elsewhere.

## Boundary rules
- nvim = independent git repo (`nvim.git`). Never merge its content into this repo.
- Never track oh-my-zsh core, TPM, or third-party plugin/theme code in git — that's installation, not config. Only `.zshrc` / `.zshenv` / `.p10k.zsh` / `.tmux.conf` are tracked; plugin/theme source repos are pinned by URL in `install.sh` (`ZSH_CUSTOM_PLUGINS`, `ZSH_THEME_REPO`, `TPM_REPO`) and auto-cloned from upstream, same model as nvim.
- `install.sh` never installs oh-my-zsh core itself — only clones custom plugins/theme, and only if `~/.oh-my-zsh` already exists.

## Hard rules
- New filenames and commit messages: English.
- Never add a `Co-Authored-By` (or any AI attribution) line to commit messages, even if told to by default elsewhere.
- Get explicit user approval before any `git commit` — show hunks + message, wait for confirmation.
- Never run real `git commit` / `git push` to "test" a script. Use `git diff` / `git status` / dry-run only.
- One independent change = one commit.
- Run `./test.sh` before pushing.
- No destructive git ops (`reset --hard`, `push --force`, rebase) without asking first — this repo is live state shared across real machines.
