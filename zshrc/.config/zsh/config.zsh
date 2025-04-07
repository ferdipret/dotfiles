setopt nullglob

# Load Xresources colors into shell variables
xrdb_colors=(${(f)"$(xrdb -query | grep '\*.color')"})
for entry in $xrdb_colors; do
  name="${entry%%:*}"
  value="${entry#*: }"
  name="${name##*.}"
  export XCOLOR_$name="$value"
done

export LS_COLORS="di=1;${XCOLOR_4}*:ln=1;${XCOLOR_6}*:ex=1;${XCOLOR_2}*"
# Optionally map them to more readable vars
export XCOLOR_FG="${XCOLOR_15:-#c0caf5}"
export XCOLOR_BG="${XCOLOR_0:-#1a1b26}"

# === Browser Selection ===
# Set the default browser based on availability
if command -v vivaldi >/dev/null 2>&1; then
	export BROWSER="vivaldi"
else
	export BROWSER="firefox" # Fallback to Firefox
fi
