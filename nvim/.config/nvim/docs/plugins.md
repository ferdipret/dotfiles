# Plugin Reference

[← Back to Index](index.md)

Complete reference of all plugins in this configuration.

---

## Core Plugins

### Plugin Manager
- **lazy.nvim** - Modern plugin manager with lazy loading
  - File: `lua/config/plugins.lua`
  - Auto-installs on first run
  - Commands: `:Lazy`, `:Lazy sync`, `:Lazy update`

---

## UI & Appearance

### Colorscheme
- **tokyonight.nvim** - Tokyo Night theme (night variant)
  - File: `lua/plugins/colorscheme.lua`
  - Used throughout: completion, statusline, borders

### Statusline
- **lualine.nvim** - Statusline with LSP info
  - File: `lua/plugins/statusline.lua`
  - Shows: mode, git, diagnostics, and active LSP clients
  - Global statusline enabled

### Bufferline
- **bufferline.nvim** - Buffer tabs at top
  - File: `lua/plugins/statusline.lua`
  - Replaced: barbar.nvim (had bugs)
  - Features: diagnostics, git status, neo-tree offset

### Breadcrumbs
- **nvim-navic** - LSP breadcrumbs in winbar
  - File: `lua/plugins/statusline.lua`
  - Shows: current function/class context

### Keybinding Help
- **which-key.nvim** - Shows available keybindings
  - File: `lua/plugins/which-key.lua`
  - Auto-appears after typing leader
  - Preset: helix
  - Uses rounded popups, icons, and named command groups

---

## Navigation & Search

### Primary Picker
- **snacks.nvim** - Unified picker/utilities
  - File: `lua/plugins/snacks/init.lua`
  - Features: files, grep, LSP, git, notifications, terminal, zen mode
  - Priority: 1000 (loads first)

### Backup Picker
- **telescope.nvim** - Fuzzy finder
  - File: `lua/plugins/telescope.lua`
  - Backup if Snacks doesn't work
  - Dependencies: plenary, fzf-native

### File Explorer
- **neo-tree.nvim** - Sidebar file explorer
  - File: `lua/plugins/neo-tree.lua`
  - Key: `<leader>e`
  - Features: git status, hidden files, follow current file

---

## Code Intelligence

### LSP
- **nvim-lspconfig** - LSP client configurations
  - File: `lua/plugins/lsp.lua`
  - Servers: lua_ls, vtsls, elixirls, tailwindcss, emmet, eslint, texlab, tinymist
  - Loading: `BufReadPre`, `BufNewFile`

- **mason.nvim** - LSP server installer
  - File: `lua/plugins/lsp.lua`
  - UI: `:Mason`
  - Auto-installs configured servers

- **mason-lspconfig.nvim** - Bridge mason ↔ lspconfig

- **tiny-inline-diagnostic.nvim** - Inline diagnostic messages

### Completion
- **nvim-cmp** - Completion engine
  - File: `lua/plugins/completions.lua`
  - Sources: LSP, snippets, path, buffer, markdown rendering, calc
  - Keymaps: `<Tab>`, `<S-Tab>`, `<CR>`, `<C-e>`, `<C-b>`, `<C-f>`, `<C-Space>`

- **LuaSnip** - Snippet engine
  - File: `lua/snippets/heex.lua`
  - See: `docs/snippets.md`

- **lspkind.nvim** - VS Code-style icons

### AI
- **avante.nvim** - ACP-capable coding agent interface
  - File: `lua/plugins/ai.lua`
  - Primary agent: `opencode`
  - Secondary agent: `claude-code`
  - Key group: `<leader>a*`

- **mcphub.nvim** - MCP server manager and Avante bridge
  - File: `lua/plugins/ai.lua`
  - Config: `~/.config/mcphub/servers.json`
  - Key: `<leader>aM`
  - Planned servers: Linear, GitHub, Context7, Playwright, Sequential Thinking

### Quality
- **nvim-lint** - External linter integration
  - File: `lua/plugins/quality.lua`
  - Key: `<leader>rl`
  - Linters: eslint_d, markdownlint-cli2, ruff, shellcheck

- **neotest** - Unified test runner
  - File: `lua/plugins/quality.lua`
  - Key group: `<leader>r*`
  - Adapters: plenary, python, vitest

### Treesitter
- **nvim-treesitter** - Syntax highlighting & parsing
  - File: `lua/plugins/treesitter.lua`
  - Auto-install: true
  - Parsers: lua, markdown, markdown_inline, latex, bibtex, typst
  - Modules: highlight, indent

- **nvim-ts-autotag** - Auto-close HTML/JSX tags

---

## Math And Research Writing

### Typst
- **typst-preview.nvim** - Live Typst preview
  - File: `lua/plugins/math.lua`
  - Filetype: `typst`
  - Local keys: `mp`, `ms`, `mf`

- **tinymist** - Typst LSP
  - File: `lua/plugins/lsp.lua`
  - Auto-installed via Mason

### LaTeX
- **vimtex** - LaTeX workflow and tooling
  - File: `lua/plugins/math.lua`
  - Compile backend: `latexmk`
  - External tools: TeX distribution + `latexmk`, with `zathura` or `okular` recommended for viewing
  - Local keys: `mc`, `mv`, `mt`, `me`, `mk`

- **texlab** - LaTeX and BibTeX LSP
  - File: `lua/plugins/lsp.lua`
  - Auto-installed via Mason

---

## Editing & Formatting

### Formatting
- **conform.nvim** - Async formatter
  - File: `lua/plugins/formatter.lua`
  - Format on save: enabled (500ms timeout)
  - Formatters: stylua, prettier, eslint_d, shfmt

### Auto-pairs
- **mini.pairs** - Auto-close brackets/quotes
  - File: `lua/plugins/mini.lua`

---

## Git Integration

### Decorations
- **gitsigns.nvim** - Git decorations & hunk operations
  - File: `lua/plugins/git.lua`
  - Features: signs, blame, hunk operations
  - Keys: `<leader>gh*`

### Interfaces
- **neogit** - Magit-like Git interface
  - File: `lua/plugins/git.lua`
  - Keys: `<leader>gn*`
  - Integrates with diffview

- **diffview.nvim** - File diffs and history
  - Used by neogit and snacks

---

## Notes & Obsidian

### Note Taking
- **obsidian.nvim** - Obsidian vault integration (community fork)
  - File: `lua/plugins/obsidian.lua`
  - Vault: `~/Documents/notes`
  - Keys: `<leader>n*`
  - Features: daily notes, templates, backlinks, tags

### Markdown
- **render-markdown.nvim** - Live markdown rendering
  - File: `lua/plugins/markdown.lua`
  - Provides in-buffer syntax highlighting for rich markdown

- **markdown-preview.nvim** - Browser-based preview with autosync scrolling
  - File: `lua/plugins/markdown.lua`
  - Key: `<leader>nP`

- **img-clip.nvim** - Paste images in markdown

---

## Utilities

### Diagnostics
- **trouble.nvim** - Diagnostics/quickfix panel
  - File: `lua/plugins/trouble.lua`

### Terminal
- **toggleterm.nvim** - Floating terminal anchored to git root
  - File: `lua/plugins/toggleterm.lua`
  - Key: `<leader>tf`
  - Direction: float, starts in insert mode

### UI Enhancements
- **dressing.nvim** - Better vim.ui.select/input

---

## Plugin Loading Order

1. **Immediate** (priority 1000): snacks.nvim
2. **Immediate**: colorscheme, completion, treesitter, mini.pairs, vimtex, explorer helpers
3. **VeryLazy**: which-key, bufferline, avante, inline diagnostics
4. **BufReadPre/New**: LSP, formatters, gitsigns
5. **Keys/Filetypes**: Git tools, obsidian, toggleterm, telescope, typst preview

---

## Plugin Count

- **Total plugins**: ~35
- **Core functionality**: ~20
- **Optional/extras**: ~15

---

*Next: [Keymaps Reference](keymaps.md) →*
