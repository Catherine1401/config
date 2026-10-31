# yazi keybindings

| Key | Action |
| --- | --- |
| `y` | Yank selected files (copy) + copy to system clipboard |
| `x` | Yank selected files (cut) + copy to system clipboard |
| `Ctrl-p` | Paste files from system clipboard into current directory |
| `E` | Extract hovered archive to a directory typed after `-o` (7zz) |

## Defaults (yazi 26.5.6, still active)

Overridden above: `y`, `x` (now also copy to system clipboard).

### Navigation

| Key | Action |
| --- | --- |
| `j` / `k` | Next / previous file |
| `h` / `l` | Parent / child directory |
| `H` / `L` | Back / forward in directory history |
| `gg` / `G` | Top / bottom |
| `Ctrl-u` / `Ctrl-d` | Half page up / down |
| `Ctrl-b` / `Ctrl-f` | Page up / down |
| `gh` / `gc` / `gd` | Go `~` / `~/.config` / `~/Downloads` |
| `g Space` | Jump interactively |
| `gf` | Follow hovered symlink |
| `z` / `Z` | Jump via fzf / zoxide |

### Preview

| Key | Action |
| --- | --- |
| `K` / `J` | Seek preview up / down (office.yazi: previous / next page) |
| `Tab` | Spot hovered file |

### Selection

| Key | Action |
| --- | --- |
| `Space` | Toggle selection |
| `Ctrl-a` | Select all |
| `Ctrl-r` | Invert selection |
| `v` / `V` | Visual mode (select / unset) |
| `Esc` | Exit visual mode, clear selection, or cancel search |

### File operations

| Key | Action |
| --- | --- |
| `o` / `Enter` | Open |
| `O` / `Shift-Enter` | Open interactively |
| `p` / `P` | Paste / paste overwriting |
| `Y` / `X` | Cancel yank |
| `-` / `_` | Symlink yanked files (absolute / relative) |
| `Ctrl--` | Hardlink yanked files |
| `d` / `D` | Trash / delete permanently |
| `a` | Create file (end with `/` for directory) |
| `r` | Rename |
| `;` / `:` | Run shell command / run and block |
| `.` | Toggle hidden files |
| `cc` / `cd` / `cf` / `cn` | Copy path / dirname / filename / name without extension |

### Search and filter

| Key | Action |
| --- | --- |
| `s` / `S` | Search by name (fd) / content (ripgrep) |
| `Ctrl-s` | Cancel search |
| `f` | Filter |
| `/` / `?` | Find next / previous |
| `n` / `N` | Next / previous match |

### Sort and linemode

| Key | Action |
| --- | --- |
| `,m` `,b` `,e` `,a` `,n` `,s` | Sort by mtime / btime / extension / alphabetical / natural / size |
| `,M` `,B` `,E` `,A` `,N` `,S` | Same, reversed |
| `,r` | Sort randomly |
| `ms` `mp` `mb` `mm` `mo` `mn` | Linemode size / permissions / btime / mtime / owner / none |

### Tabs and misc

| Key | Action |
| --- | --- |
| `tt` | New tab in current directory |
| `tr` | Rename tab |
| `1`-`9` | Switch to tab |
| `[` / `]` | Previous / next tab |
| `{` / `}` | Swap tab with previous / next |
| `w` | Task manager |
| `~` / `F1` | Help |
| `q` / `Q` | Quit / quit without writing cwd file |
| `Ctrl-c` | Close tab, or quit if last |
| `Ctrl-z` | Suspend |
