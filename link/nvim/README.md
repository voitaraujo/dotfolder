# Neovim config

<img width="1440" alt="SCR" src="https://github.com/voitaraujo/dotfolder/assets/36885540/5c3b8fe7-3a44-4a29-b32e-a36c594815ae">


## Installation

> first of all, make sure you have the latest version of neovim and git installed.

- If you're already using neovim, it is a good idea to make a backup of your current configuration before continuing.

- Clear your current config and cache directories.
```

# Linux / Macos (unix)

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

```
> On Windows, you'll find both of these folders at "C:\Users\\%USERNAME%\AppData\Local\", they are called "nvim" and "nvim-data" respectively.

- Then clone this repo to your neovim config dir.
```

# Linux / Macos (unix)

git clone "https://github.com/voitaraujo/nvim-config.git" ~/.config/nvim

```

Aight, you're good to go now.

## Keymaps 
_WIP_

## CAVEATS
Also you may need some external resourses to use this config, such as *rg*(ripgrep), any font from *Nerd Fonts* installed on your terminal, *make*(or *cmake* depending on your platform), and more. To make sure you config is "ok", run `:checkhealth` inside your neovim and fix any error pointed.
