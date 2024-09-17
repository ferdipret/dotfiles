source ~/.zplug/init.zsh

if [[ -a ~/.aliases.zsh ]]; then
  source ~/.aliases.zsh

  if [[ -a ~/.aliases.local.zsh ]]; then
    source ~/.aliases.local.zsh
  fi
fi

# Make sure to use double quotes
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

eval "$(starship init zsh)"
eval "$($HOME/.local/bin/mise activate zsh)"

# pnpm
export PNPM_HOME="/Users/Ferdinand.Pretorius/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
