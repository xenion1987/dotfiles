# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).
Supports **Linux (KDE/Wayland)** and **macOS**.

Each package directory mirrors the structure of `$HOME`. Stow creates symlinks
from `$HOME` into the corresponding package directory.

## Installation

| Tool     | Install                                        |
| -------- | ---------------------------------------------- |
| GNU Stow | Package manager                                |
| Git      | Package manager                                |
| Zsh      | Package manager                                |
| tmux     | Package manager                                |
| albert   | https://albertlauncher.github.io/installation/ |
| atuin    | https://docs.atuin.sh/cli/guide/installation/  |
| direnv   | https://direnv.net/docs/installation.html      |
| ghostty  | https://ghostty.org/docs/install/binary        |
| wezterm  | https://wezterm.org/installation.html          |
| nvim     | Package manager                                |
| LazyVim  | https://www.lazyvim.org/installation           |
| vim      | Package manager                                |
| VSCodium | https://vscodium.com/                          |


## Machine-specific Overrides

Some settings are intentionally **not** tracked in this repo.
Create these files locally — they will be sourced automatically if they exist:

**`~/.gitconfig.local`** — Git identity per machine:

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = ABC123
```

Referenced from `.gitconfig` via:

```ini
[include]
    path = ~/.gitconfig.local
```

**`~/.zshrc.local`** — Shell overrides per machine:

```zsh
export KUBECONFIG=~/.kube/my-cluster.yaml
alias vpn="openconnect vpn.example.com"
```

## Adding a New Package

```sh
# 1. Create the package directory mirroring $HOME structure
mkdir -p "${HOME}/workspace/dotfiles/${PACKAGE}/.config/${PACKAGE}"

# 2. Move the existing config into the repo
mv "${HOME}/.config/${PACKAGE}" "${HOME}/workspace/dotfiles/${PACKAGE}/.config/"

# 3. Symlink it back via Stow
stow --target="${HOME}" --dir="${HOME}/workspace/dotfiles" "${PACKAGE}"

# 4. Commit
cd "${HOME}/workspace/dotfiles" && git add "${PACKAGE}" && git commit -m "feat: add ${PACKAGE} config"
```

## Useful Stow Commands

```sh
# Set dotfiles dir
DOTFILES_DIR="${HOME}/workspace/dotfiles"

# Global usable command
stow --dir="${DOTFILES_DIR}" --target="${HOME}" "${PACKAGE}"

# Preview what would be symlinked (dry run)
stow --simulate --dir="${DOTFILES_DIR}" --target="${HOME}" "${PACKAGE}"

# Re-apply a package (e.g. after adding a new file)
stow --restow --dir="${DOTFILES_DIR}" --target="${HOME}" "${PACKAGE}"

# Remove symlinks for a package
stow --delete --dir="${DOTFILES_DIR}" --target="${HOME}" "${PACKAGE}"

# Adopt existing files into the repo (then review with git diff!)
stow --adopt --dir="${DOTFILES_DIR}" --target="${HOME}" "${PACKAGE}"
```

## tmux

```sh
DOTFILES_DIR="${HOME}/workspace/dotfiles"
stow --dir="${DOTFILES_DIR}" --target="${HOME}" tmux
tmux new-session -d -s install_plugins '~/.tmux/plugins/tpm/bin/install_plugins'
```

That's all. Start `tmux`.

## oh-my-zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm -f "${HOME}/.zshrc"
DOTFILES_DIR="${HOME}/workspace/dotfiles"
stow --dir="${DOTFILES_DIR}" --target="${HOME}" zsh
```
