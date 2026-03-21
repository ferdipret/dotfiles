if [ -f ~/.config/openclaw/protonmail.env ]; then
	export $(grep -v '^#' ~/.config/openclaw/protonmail.env | xargs)
fi

if [ -f ~/.config/openclaw/mcp.env ]; then
	export $(grep -v '^#' ~/.config/openclaw/mcp.env | xargs)
fi
