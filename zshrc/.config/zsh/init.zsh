# .zshrc - Main Zsh Configuration File

# === Basic Settings ===
# Set the Zsh configuration directory
export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Set the editor for sudo operations
export SUDO_EDITOR="nvim"

source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/packages.zsh"

# === Browser Selection ===
# Set the default browser based on availability
if command -v vivaldi >/dev/null 2>&1; then
	export BROWSER="vivaldi"
else
	export BROWSER="firefox" # Fallback to Firefox
fi
