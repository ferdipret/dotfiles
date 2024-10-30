# Editor aliases
alias v="nvim"

# File system aliases
alias la="ls -al"
alias ls="eza --icons"
alias lst="eza --icons --tree -I=node_modules"

# Package manager aliases
alias pm="pnpm"
alias pme="pnpm exec"

# Source core alias files
for alias_file in "$ZSH_CONFIG_DIR/aliases/"*.zsh; do
	[[ -f $alias_file ]] && source "$alias_file"
done

# Source local settings, if available
for local_file in "$ZSH_CONFIG_DIR/aliases/"*.local.zsh; do
	[[ -f $local_file ]] && source "$local_file"
done
