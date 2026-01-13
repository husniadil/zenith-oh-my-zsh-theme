# Zenith - A Sleek and Minimalist Zsh Theme

Zenith is a clean, modern Zsh theme designed for efficiency and aesthetics. Featuring a cool-toned color palette with intuitive Git status indicators, it keeps your terminal workflow smooth and distraction-free. Stay at the peak of productivity with a prompt that's both elegant and functional.

## Features

- **Minimalist design** – Keeps the focus on your workflow with subtle borders framing the prompt area.
- **Color-coded Git status** – Instantly see changes in your repository.
- **Compact directory display** – Shows only the last two directories for clarity. When in home directory, displays expanded path for better context.
- **Intuitive prompt symbols** – Quick visual feedback on success or failure.
- **Clean multiline continuation** – Subtle vertical line for multiline commands instead of distracting "quote>" prompt.
- **Session context indicators** – Shows hostname, virtualization environment, terminal multiplexer, and session info at a glance.

## Installation

### Using Oh My Zsh

1. Clone the repository into your custom themes folder:
   ```sh
   git clone https://github.com/husniadil/zenith-oh-my-zsh-theme.git ~/.oh-my-zsh/custom/themes/zenith
   ```
2. Set the theme in your `~/.zshrc` file:
   ```sh
   ZSH_THEME="zenith/zenith"
   ```
3. Apply the changes:
   ```sh
   omz reload
   ```

## Prompt Overview

Zenith provides an elegant and informative prompt with a clean bordered design:

```
╭─ @hostname [LXC:105] [tmux:dev] ~/project ✱? main
╰─ ❯
```

### Components (left to right)

| Component | Description |
|-----------|-------------|
| `╭─` / `╰─` | Subtle box-drawing border characters |
| `@hostname` | Machine hostname (always visible) |
| `[PVE]` / `[LXC:ID]` / `[VM]` | Virtualization environment indicator |
| `[tmux:session]` / `[screen:session]` / etc. | Terminal multiplexer indicator |
| `[zmx:session]` | ZMX session indicator |
| `~/project` | Current directory (last 2 folders) |
| `✱?+~` | Git status indicators |
| `main` | Git branch name |
| `❯` | Prompt symbol (cyan=success, red=failure) |

## Session Context Indicators

### Hostname

Always displayed as `@hostname` in green. Useful when working across multiple machines via SSH.

### Virtualization Environment

Automatically detects or manually configured via environment variables:

| Indicator | Detection | Environment Variable |
|-----------|-----------|---------------------|
| `[PVE]` | Manual | `export PVE_HOST=1` |
| `[LXC:105]` | Manual | `export LXC_ID=105` |
| `[LXC]` | Auto | Detected via `/proc/1/environ` |
| `[VM:100]` | Manual | `export PVE_VMID=100` |
| `[VM]` | Auto | Detected via `systemd-detect-virt` (kvm/qemu) |

### Terminal Multiplexer

Automatically detected when running inside a terminal multiplexer:

| Multiplexer | Indicator Example |
|-------------|-------------------|
| tmux | `[tmux:session-name]` |
| GNU Screen | `[screen:session-name]` |
| Zellij | `[zellij:session-name]` |
| dvtm | `[dvtm]` |
| abduco | `[abduco:session-name]` |

### ZMX Session

Detected via `$ZMX_SESSION` environment variable set by [ZMX](https://github.com/neurosnap/zmx):

```
[zmx:session-name]
```

## Git Status Indicators

| Symbol | Color | Meaning |
|--------|-------|---------|
| `✓` | Green | Clean repository |
| `✱` | Yellow | Dirty repository |
| `?` | Cyan | Untracked files |
| `+` | Green | Staged files |
| `~` | Yellow | Modified files |
| `-` | Red | Deleted files |
| `»` | Light blue | Renamed files |
| `═` | Red | Unmerged conflicts |
| `↑` | Cyan | Ahead of remote |
| `↓` | Cyan | Behind remote |

## Prompt Examples

```bash
# Simple local prompt
╭─ @macbook ~/project ✓ main
╰─ ❯

# SSH to Proxmox host
╭─ @pve [PVE] ~/scripts
╰─ ❯

# Inside LXC container with tmux
╭─ @webserver [LXC:105] [tmux:dev] ~/app ✱?+ main
╰─ ❯

# Inside VM with dirty git repo
╭─ @database [VM] ~/backup ✱~ main
╰─ ❯

# Full combo: LXC + tmux + ZMX
╭─ @container [LXC:200] [tmux:work] [zmx:session] ~/project ✓ feature-branch
╰─ ❯
```

## Customization

You can tweak colors and symbols by modifying `zenith.zsh-theme` to match your style.

### Color Reference

| Variable | Color Code | Usage |
|----------|------------|-------|
| `gray` | `FG[245]` | Borders |
| `lightblue` | `FG[075]` | Directory path |
| `cyan` | `FG[081]` | Virtualization indicators, untracked files |
| `green` | `FG[114]` | Hostname, clean status, staged files |
| `yellow` | `FG[221]` | Multiplexer indicators, dirty status |
| `red` | `FG[203]` | Deleted files, conflicts |
| `magenta` | `FG[213]` | Git branch name |
| `orange` | `FG[208]` | ZMX indicator |

## Screenshots

_Example screenshot of the prompt in action_

![Zenith Prompt Preview](https://github.com/husniadil/zenith-oh-my-zsh-theme/blob/main/screenshot.png?raw=true)

## License

Zenith is released under the [MIT License](LICENSE).
