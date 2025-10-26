# Zenith - A Sleek and Minimalist Zsh Theme

Zenith is a clean, modern Zsh theme designed for efficiency and aesthetics. Featuring a cool-toned color palette with intuitive Git status indicators, it keeps your terminal workflow smooth and distraction-free. Stay at the peak of productivity with a prompt that’s both elegant and functional.

## Features

- **Minimalist design** – Keeps the focus on your workflow with subtle borders framing the prompt area.
- **Color-coded Git status** – Instantly see changes in your repository.
- **Compact directory display** – Shows only the last two directories for clarity. When in home directory, displays expanded path for better context.
- **Intuitive prompt symbols** – Quick visual feedback on success or failure.
- **Clean multiline continuation** – Subtle vertical line for multiline commands instead of distracting "quote>" prompt.

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
╭─ ~/project ✱? main
╰─ ❯
```

- **Subtle Borders** – Uses box-drawing characters (`╭─` and `╰─`) in gray to frame the prompt area without visual clutter.
- **Directory** – Shows the last two folders in the path. When in home directory, displays both `~` and the full path (e.g., `~ /Users/username`) for better context.
- **Git Status** – Displays:
  - `✓` (green) if clean
  - `✱` (yellow) if dirty repository
  - `+` (green) for staged files
  - `~` (yellow) for modified files
  - `-` (red) for deleted files
  - `»` (light blue) for renamed files
  - `═` (red) for unmerged conflicts
  - `?` (cyan) for untracked files
  - `↑` (cyan) if ahead of remote
  - `↓` (cyan) if behind remote
- **Prompt Symbol** – Shows `❯` in cyan for success and red for failure.
- **Multiline Continuation** – Uses a subtle vertical line (`│`) for continued commands instead of the default `quote>` prompt.

## Customization

You can tweak colors and symbols by modifying `zenith.zsh-theme` to match your style.

## Screenshots

_Example screenshot of the prompt in action_

![Zenith Prompt Preview](https://github.com/husniadil/zenith-oh-my-zsh-theme/blob/main/screenshot.png?raw=true)

## License

Zenith is released under the [MIT License](LICENSE).
