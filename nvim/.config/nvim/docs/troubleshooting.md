# Troubleshooting

[← Back to Index](index.md)

## Plugins Not Installing
- Run `nvim --headless "+Lazy sync" +qa` to install any missing plugins pinned in `lazy-lock.json`.
- If a build step fails (e.g., `avante.nvim`, `markdown-preview.nvim`), open Neovim and run `:Lazy log` for the full error, then re-run the command from the terminal.
- Delete `.local/share/nvim/lazy/<plugin>` and retry if the cache becomes inconsistent.

## LSP Servers Not Attaching
- Verify the server is installed with `:Mason`; install missing entries (`lua_ls`, `vtsls`, `eslint`, `elixirls`, `graphql`, `tailwindcss`, `emmet_language_server`, `texlab`, `tinymist`).
- Run `:LspInfo` and ensure the buffer filetype matches the server's `filetypes` list.
- If formatters conflict, remember `eslint` formatting is disabled; rely on `conform.nvim` via `<leader>cf`.

## Formatting Skipped
- `conform.nvim` formats on save with a 500 ms timeout; large files may exceed this. Re-run `<leader>cf` if the timeout is hit.
- Check the active formatter with `:ConformInfo`; install missing CLIs (e.g., `npm i -g prettier eslint_d`, `cargo install stylua`, `go install mvdan.cc/sh/v3/cmd/shfmt@latest`).
- For Lua, Stylua runs with tabs at width 2; pass `--indent-type Tabs --indent-width 2` when running manually.

## Completion or AI Issues
- Confirm `nvim-cmp` source plugins are installed by checking `:Lazy` for `cmp-buffer`, `cmp-path`, `cmp-calc`, and `cmp-nvim-lsp`.
- If completion stops working, run `:messages` and `:Lazy log` to look for source-loading or config errors.
- Avante requires a valid `OPENAI_API_KEY`; if requests fail, restart Neovim after exporting the variable in your shell.

## Linting Or Test Issues
- `nvim-lint` depends on external CLIs; install `eslint_d`, `markdownlint-cli2`, `ruff`, and `shellcheck` for the matching filetypes you care about.
- `neotest` adapters depend on your project test runner, such as `pytest` or `vitest`, being available in the project environment.
- Use `<leader>ro` and `<leader>rO` to inspect test output when a run fails unexpectedly.

## Obsidian Workflow Problems
- The vault is expected at `~/Documents/notes`. Update `lua/plugins/obsidian.lua` if you relocate it.
- Daily notes rely on `~/Documents/notes/.scripts/generate_daily_note.py`. Ensure Python 3 is available and run the script manually (`python3 path/to/script 0`) to confirm it prints a `FILE_PATH:` line.
- Render and clipboard helpers (`render-markdown.nvim`, `img-clip.nvim`) require `xdg-open`/`wl-copy` on Linux; install them if preview features fail.

## Math Workflow Problems
- For LaTeX on Arch, install `texlive-meta biber latexmk`; that gives VimTeX and texlab the expected build tools.
- For PDF viewing on Arch, install `zathura zathura-pdf-mupdf` if forward search or `VimtexView` does not open a document.
- For Typst preview, open a `*.typ` file and run `:TypstPreviewUpdate` if the preview binaries have not been downloaded yet.
- Confirm `tinymist` and `texlab` are installed in Mason when Typst or LaTeX LSP features do not attach.

## Avante Build Failures
- `avante.nvim` requires `make` plus a C toolchain. On Debian/Ubuntu install `build-essential`; on macOS install Xcode command-line tools.
- Configure your OpenAI API key (`export OPENAI_API_KEY=...`) before starting Neovim or the provider will refuse requests.
