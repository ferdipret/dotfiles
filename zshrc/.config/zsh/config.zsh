# === Browser Selection ===
# Set the default browser based on availability
if command -v vivaldi >/dev/null 2>&1; then
	export BROWSER="vivaldi"
else
	export BROWSER="firefox" # Fallback to Firefox
fi
