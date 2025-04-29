setopt nullglob

# --- Xresources colors (Linux only) ---
if command -v xrdb >/dev/null 2>&1; then
  # Load *.color entries into XCOLOR_<n>
  xrdb_colors=( ${(f)"$(xrdb -query | grep '\*.color')"} )
  for entry in $xrdb_colors; do
    name="${entry%%:*}"
    value="${entry#*: }"
    name="${name##*.}"
    export XCOLOR_$name="$value"
  done

  # LS_COLORS mapping: directories, symlinks, executables
  export LS_COLORS="di=1;${XCOLOR_color4}*:ln=1;${XCOLOR_color6}*:ex=1;${XCOLOR_color2}*"

  # Fallback fg/bg
  export XCOLOR_FG="${XCOLOR_color15:-#c0caf5}"
  export XCOLOR_BG="${XCOLOR_color0:-#1a1b26}"
else
  # On macOS (no xrdb), set sensible defaults
  export XCOLOR_FG="#c0caf5"
  export XCOLOR_BG="#1a1b26"
  export LS_COLORS="di=1;34*:ln=1;36*:ex=1;32*"
fi

# --- Browser Selection ---
# Prefer Vivaldi if installed, otherwise Firefox
if command -v vivaldi >/dev/null 2>&1; then
  export BROWSER="vivaldi"
else
  export BROWSER="firefox"
fi

