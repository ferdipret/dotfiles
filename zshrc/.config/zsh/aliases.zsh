# Editor aliases
alias v="nvim"

# File system aliases
alias ls='eza --icons --group-directories-first --color=always'
alias la='eza -la --icons --group-directories-first --color=always'
alias lst='eza -T --level=2 --icons --group-directories-first --color=always -I=node_modules'
alias lg='eza -l --icons --git --group-directories-first --color=always'

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
