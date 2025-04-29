# .zshrc.packages - Package-Specific Configurations

# === Zplug ===
# Initialize Zplug, a plugin manager for Zsh
source ~/.zplug/init.zsh

# Plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if they aren't installed
if ! zplug check --verbose; then
	printf "Install plugins? [y/N]: "
	if read -q; then
		echo
		zplug install
	fi
fi

# Load zplug plugins
zplug load

# === Mise ===
# Activate Mise if installed, otherwise show an informative message
if [[ -x "$HOME/.local/bin/mise" ]]; then
	eval "$($HOME/.local/bin/mise activate zsh)"
else
	echo "Mise is not installed or not found in the path."
	echo "Please install Mise following the instructions at: https://mise.org/docs/installation"
fi

# === Starship Prompt ===
# Initialize the Starship prompt if installed, otherwise show an informative message
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
else
	echo "Starship prompt is not installed or not found in the path."
	echo "Please install Starship following the instructions at: https://starship.rs/guide/#installation"
fi

# Source package-specific settings
for package_file in "$ZSH_CONFIG_DIR/packages/"*.zsh; do
	[[ -f $package_file ]] && source "$package_file"
done

# Auto-chmod anything in ~/.config/zsh/scripts so it’s executable
SCRIPTS_DIR="$HOME/.config/zsh/scripts"

if [[ -d $SCRIPTS_DIR ]]; then
  for file in "$SCRIPTS_DIR"/*; do
    # only regular files, and only if not already executable
    if [[ -f $file && ! -x $file ]]; then
      chmod +x "$file"
    fi
  done
fi
