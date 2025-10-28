# Troubleshooting

[← Back to Index](index.md)

## Plugins Not Installing
- Run `nvim --headless "+Lazy sync" +qa` to install any missing plugins pinned in `lazy-lock.json`.
- If a build step fails (e.g., `blink.cmp`, `avante.nvim`), open Neovim and run `:Lazy log` for the full error, then re-run the command from the terminal.
- Delete `.local/share/nvim/lazy/<plugin>` and retry if the cache becomes inconsistent.

## LSP Servers Not Attaching
- Verify the server is installed with `:Mason`; install missing entries (`lua_ls`, `vtsls`, `eslint`, `elixirls`, `graphql`, `tailwindcss`, `emmet_language_server`).
- Run `:LspInfo` and ensure the buffer filetype matches the server's `filetypes` list.
- If formatters conflict, remember `eslint` formatting is disabled; rely on `conform.nvim` via `<leader>cf`.

## Formatting Skipped
- `conform.nvim` formats on save with a 500 ms timeout; large files may exceed this. Re-run `<leader>cf` if the timeout is hit.
- Check the active formatter with `:ConformInfo`; install missing CLIs (e.g., `npm i -g prettier eslint_d`, `cargo install stylua`, `go install mvdan.cc/sh/v3/cmd/shfmt@latest`).
- For Lua, Stylua runs with tabs at width 2; pass `--indent-type Tabs --indent-width 2` when running manually.

## Completion or AI Issues
- Confirm `blink.cmp` is built (`~/.local/share/nvim/lazy/blink.cmp/target` should exist); if not, run `nvim --headless "+Lazy build blink.cmp" +qa`.
- Supermaven suggestions depend on its background service; reinstall with `:Lazy build supermaven-nvim` if `<Tab>` stops accepting suggestions.
- Run `:checkhealth blink.cmp` to diagnose missing dependencies.

## Obsidian Workflow Problems
- The vault is expected at `~/Documents/notes`. Update `lua/plugins/obsidian.lua` if you relocate it.
- Daily notes rely on `~/Documents/notes/.scripts/generate_daily_note.py`. Ensure Python 3 is available and run the script manually (`python3 path/to/script 0`) to confirm it prints a `FILE_PATH:` line.
- Render and clipboard helpers (`render-markdown.nvim`, `img-clip.nvim`) require `xdg-open`/`wl-copy` on Linux; install them if preview features fail.

## Avante Build Failures
- `avante.nvim` requires `make` plus a C toolchain. On Debian/Ubuntu install `build-essential`; on macOS install Xcode command-line tools.
- Configure your OpenAI API key (`export OPENAI_API_KEY=...`) before starting Neovim or the provider will refuse requests.
