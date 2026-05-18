# ~/.zshrc
# Source the main Zsh configuration
if [[ -f ~/.config/zsh/init.zsh ]]; then
	source ~/.config/zsh/init.zsh
fi

# pnpm
export PNPM_HOME="/home/ferdi/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/home/ferdi/.opencode/bin:$PATH

export EDITOR=nvim
export VISUAL=nvim
