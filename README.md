# huyvv's dotfiles

My zsh, tmux, kitty, Hyprland, and Noctalia config, synced across every machine I use. Neovim config lives in its own repo: [nvim](https://github.com/Catherine1401/nvim).

Use it, fork it, rip out what doesn't fit you. It's tuned for how I work, not a framework.

## Install

```
git clone git@github.com:Catherine1401/config.git ~/config && ~/config/install.sh
```

That's it. It symlinks the config into place, clones the nvim repo, installs tmux plugins (TPM) and the oh-my-zsh custom plugins/theme, and sets up a pre-push check — all idempotent, safe to re-run anytime.

## Uninstall

```
~/config/uninstall.sh
```

This restores every config file backed up during installation, removes only dependencies and directories created by the installer, then deletes the dotfiles repo itself. Existing files and dependencies that the installer did not create are left untouched. Use `--yes` to skip the confirmation prompt.

## What's inside

- **zsh** — `.zshrc`, `.zshenv`, `.p10k.zsh` (powerlevel10k)
- **tmux** — `.tmux.conf`, plugins installed automatically via TPM
- **kitty** — `kitty.conf` + theme files
- **Hyprland** — Lua configuration with US/Colemak-DH layout switching, Noctalia theme module, and Lua language server settings
- **Noctalia** — settings, colors, plugin sources, and screenshot preferences
- **nvim** — separate repo, cloned automatically, kept independent so its history stays clean

Hyprland and Noctalia must already be installed. The imported configuration preserves its existing fonts, `/home/hw` paths, monitor settings, and GPU references. GPU device symlinks, local backups, and wallpapers are not included; provision these machine-specific dependencies separately before using the configuration on another machine.

`bin/toggle-touchpad.sh` is linked to `~/.local/bin/toggle-touchpad.sh` for the existing Hyprland shortcuts. It requires Python 3, `hyprctl`, `notify-send`, and `XDG_RUNTIME_DIR`. It toggles all mice whose names contain `touchpad` (case-insensitive), leaving other mice untouched, and reports an error if none match. Its state marker is scoped to the Hyprland session; reloading device settings can reset the actual state independently of this marker.

`bin/switch-keyboard-layout.sh` is linked to `~/.local/bin/switch-keyboard-layout.sh` and bound to `SUPER + K`. It cycles every Hyprland keyboard between US and US (Colemak-DH) and shows the active keymap in a notification. It requires `hyprctl`, Python 3, and `notify-send`.

Hyprland resolves `SUPER + <letter>` binds by the active layout symbol (`input:resolve_binds_by_sym`), so with Colemak-DH active `SUPER + E` means the key that types `e` rather than the key in the QWERTY E position. `SUPER + K` follows the same rule, so it sits on the key that types `k` in each layout.

Everything is symlinked from this repo into `$HOME`, declared centrally in the `LINKS` map at the top of `install.sh`. No GNU Stow, no magic — just plain bash.

Every push runs `test.sh` first (via a git hook), which checks config syntax before it ever reaches another machine. Broken config never propagates.

This repo also ships an `AGENTS.md` — if you point an AI coding agent (Codex, ...) at this repo, it picks up the conventions immediately instead of guessing.

## Customize

Add a new config file → add one line to the `LINKS` map in `install.sh`. That's the only place symlinks are declared.

## Credits

Maintained by [huyvv](https://github.com/Catherine1401).
