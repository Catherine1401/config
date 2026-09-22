# huyvv's dotfiles

My zsh, tmux, and kitty config, synced across every machine I use. Neovim config lives in its own repo: [nvim](https://github.com/Catherine1401/nvim).

Use it, fork it, rip out what doesn't fit you. It's tuned for how I work, not a framework.

## Install

```
git clone git@github.com:Catherine1401/config.git ~/config && ~/config/install.sh
```

That's it. It symlinks the config into place, clones the nvim repo, installs tmux plugins (TPM) and the oh-my-zsh custom plugins/theme, and sets up a pre-push check — all idempotent, safe to re-run anytime.

## What's inside

- **zsh** — `.zshrc`, `.zshenv`, `.p10k.zsh` (powerlevel10k)
- **tmux** — `.tmux.conf`, plugins installed automatically via TPM
- **kitty** — `kitty.conf` + theme files
- **nvim** — separate repo, cloned automatically, kept independent so its history stays clean

Everything is symlinked from this repo into `$HOME`, declared centrally in the `LINKS` map at the top of `install.sh`. No GNU Stow, no magic — just plain bash.

Every push runs `test.sh` first (via a git hook), which checks config syntax before it ever reaches another machine. Broken config never propagates.

This repo also ships an `AGENTS.md` — if you point an AI coding agent (Codex, ...) at this repo, it picks up the conventions immediately instead of guessing.

## Customize

Add a new config file → add one line to the `LINKS` map in `install.sh`. That's the only place symlinks are declared.

## Credits

Maintained by [huyvv](https://github.com/Catherine1401).
