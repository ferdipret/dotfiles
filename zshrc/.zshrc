# ~/.zshrc
# Source the main Zsh configuration
if [[ -f ~/.config/zsh/init.zsh ]]; then
	source ~/.config/zsh/init.zsh
fi

# pnpm
export PNPM_HOME="/home/ferdi/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
