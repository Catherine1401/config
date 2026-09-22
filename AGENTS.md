# AGENTS.md

Dotfiles sync repo (zsh, tmux, kitty). nvim lives in a separate repo, cloned by `install.sh`.

## Scope map
- `install.sh` — bootstrap new machine: symlink `LINKS` map into `$HOME`, clone nvim repo if missing, set `core.hooksPath`.
- `sync.sh push [msg]` / `sync.sh pull` — sync this repo AND `~/.config/nvim` (if present) together.
- `test.sh` — validates zsh/tmux/kitty config syntax + script syntax. Auto-runs via `.githooks/pre-push`; run manually after any edit.
- `.docs/` — human docs, gitignored, never commit.

## Architecture rule
All symlink targets are declared in the `LINKS` map at the top of `install.sh`. New synced config file → add an entry there. Never hardcode a symlink elsewhere.

## Boundary rules
- nvim = independent git repo (`nvim.git`). Never merge its content into this repo.
- Never track oh-my-zsh core or third-party plugins/themes (zsh-autosuggestions, powerlevel10k, etc.) — that's installation, not config. Only `.zshrc` / `.zshenv` / `.p10k.zsh` are tracked.

## Hard rules
- New filenames and commit messages: English.
- Get explicit user approval before any `git commit` — show hunks + message, wait for confirmation.
- Never run real `git commit` / `git push` to "test" a script. Use `git diff` / `git status` / dry-run only.
- One independent change = one commit.
- Run `./test.sh` before pushing.
- No destructive git ops (`reset --hard`, `push --force`, rebase) without asking first — this repo is live state shared across real machines.
