source ~/.zplug/init.zsh

# Make sure to use double quotes
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

eval "$(starship init zsh)"
eval "$(/home/ferdi/.local/bin/mise activate zsh)"
