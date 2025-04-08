# .zshrc - Main Zsh Configuration File

# === Basic Settings ===
# Set the Zsh configuration directory
export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Set the editor for sudo operations
export SUDO_EDITOR="nvim"

source "$ZSH_CONFIG_DIR/config.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/packages.zsh"
source "$ZSH_CONFIG_DIR/config.zsh"
