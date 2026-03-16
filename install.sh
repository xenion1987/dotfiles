#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ══════════════════════════════════════════════════════════════════════════════
# Helper
# ══════════════════════════════════════════════════════════════════════════════

log() { echo "→ $*"; }
ok() { echo "✓ $*"; }
warn() { echo "⚠ $*"; }

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

is_kde() {
  is_linux || return 1
  [[ "${XDG_CURRENT_DESKTOP:-}" == *"KDE"* ]] && return 0
  [[ "${DESKTOP_SESSION:-}" == *"plasma"* ]] && return 0
  command -v plasmashell &>/dev/null && return 0
  command -v kwin_wayland &>/dev/null && return 0
  return 1
}

# ══════════════════════════════════════════════════════════════════════════════
# Stow
# ══════════════════════════════════════════════════════════════════════════════

stow_packages() {
  local PACKAGES=(shell git tmux nvim wezterm atuin direnv zsh)

  if is_kde; then
    log "KDE detected – adding kde package"
    PACKAGES+=(kde)
  fi

  for pkg in "${PACKAGES[@]}"; do
    log "Stowing: $pkg"
    if stow --simulate --target="$HOME" --dir="$DOTFILES" "$pkg" 2>/dev/null; then
      stow --target="$HOME" --dir="$DOTFILES" "$pkg"
    else
      warn "Konflikt bei '$pkg' – übersprungen. Manuell prüfen:"
      warn "  stow --simulate --target=\$HOME --dir=$DOTFILES $pkg"
    fi
  done
}

# ══════════════════════════════════════════════════════════════════════════════
# Zsh / oh-my-zsh / Powerlevel10k
# ══════════════════════════════════════════════════════════════════════════════

setup_zsh() {
  log "Setting up Zsh..."

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ ! -d "$p10k_dir" ]]; then
    log "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
  fi

  ok "Zsh ready"
}

# ══════════════════════════════════════════════════════════════════════════════
# tmux
# ══════════════════════════════════════════════════════════════════════════════

setup_tmux() {
  log "Setting up tmux..."

  # TPM
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi

  # ~/.config/tmux → ~/.tmux
  if [[ ! -L "$HOME/.config/tmux" ]]; then
    log "Linking ~/.config/tmux → ~/.tmux"
    ln -sf "$HOME/.tmux" "$HOME/.config/tmux"
  fi

  # Plugins installieren
  log "Installing tmux plugins..."
  tmux new-session -d -s install_plugins \
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || true

  # tmux-powerline config
  local powerline_conf="$HOME/.config/tmux-powerline/config.sh"
  if [[ ! -f "$powerline_conf" ]]; then
    log "Generating tmux-powerline config..."
    "$HOME/.config/tmux/plugins/tmux-powerline/generate_config.sh"
    cp "${powerline_conf}.default" "$powerline_conf"
  fi

  # tmux-powerline theme
  local theme="$HOME/.config/tmux-powerline/themes/my-theme.sh"
  if [[ ! -f "$theme" ]]; then
    log "Copying tmux-powerline theme..."
    mkdir -p "$HOME/.config/tmux-powerline/themes"
    cp "$HOME/.config/tmux/plugins/tmux-powerline/themes/default.sh" "$theme"
  fi

  ok "tmux ready"
  warn "Ggf. manuell anpassen: $powerline_conf"
  warn "Ggf. manuell anpassen: $theme"
}
