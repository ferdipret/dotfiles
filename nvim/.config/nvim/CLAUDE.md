# Neovim Configuration Documentation

## Project Structure

```
.
├── init.lua                    # Main entry point - loads all config modules
├── lazy-lock.json              # Lazy.nvim plugin lockfile
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keymaps.lua         # Custom keymappings
│   │   ├── plugins.lua         # Lazy.nvim bootstrap and setup
│   │   └── settings.lua        # Vim options and settings
│   ├── plugins/
│   │   ├── ai.lua              # AI tools (Avante)
│   │   ├── colorscheme.lua     # TokyoNight theme
│   │   ├── completions.lua     # nvim-cmp completion setup
│   │   ├── formatter.lua       # conform.nvim formatting
│   │   ├── git.lua             # Git integration (gitsigns, neogit, diffview)
│   │   ├── lsp.lua             # LSP configuration with Mason
│   │   ├── math.lua            # Typst and LaTeX workflows
│   │   ├── markdown.lua        # Markdown rendering
│   │   ├── mini.lua            # mini.pairs for auto-pairing
│   │   ├── neo-tree.lua        # File explorer
│   │   ├── obsidian.lua        # Obsidian.nvim integration
│   │   ├── quality.lua         # Linting and test workflows
│   │   ├── snacks/
│   │   │   └── init.lua        # Snacks.nvim utilities
│   │   ├── statusline.lua      # Lualine + Barbar + Navic
│   │   ├── telescope.lua       # Telescope fuzzy finder
│   │   ├── treesitter.lua      # Treesitter and plugins
│   │   ├── trouble.lua         # Diagnostics panel
│   │   └── which-key.lua       # Keybinding help
│   ├── snippets/
│   │   ├── heex.lua            # Custom HEEx snippets
│   │   ├── tex.lua             # LaTeX snippets
│   │   └── typst.lua           # Typst snippets
│   └── utils/
│       ├── borders.lua         # Border character definitions
│       ├── completion-kinds.lua # LSP kind icons
│       ├── keymap.lua          # Keymap helper utilities
│       └── lsp-server-configs.lua # LSP server custom configs
```

## Plugin Architecture

### Plugin Manager
- **lazy.nvim**: Modern plugin manager with lazy loading
- Bootstrap location: `lua/config/plugins.lua`
- Plugins auto-loaded from `lua/plugins/` directory
- Each plugin file returns a table with plugin specs

### Key Plugins

#### Core UI
- **tokyonight.nvim**: Colorscheme (night variant)
- **lualine.nvim**: Statusline with global status
- **bufferline.nvim**: Buffer tabline with neo-tree offset
- **nvim-navic**: Breadcrumb navigation in winbar
- **which-key.nvim**: Keybinding documentation and discovery
- **snacks.nvim**: Unified utility collection (dashboard, picker, notifications, terminal, etc.)

#### LSP & Completion
- **nvim-lspconfig**: LSP client configurations
- **mason.nvim**: LSP server installer
- **mason-lspconfig.nvim**: Bridge between mason and lspconfig
- **nvim-cmp**: Completion engine
  - Sources: LSP, snippets (LuaSnip), buffer, path, calc, markdown rendering
- **LuaSnip**: Snippet engine with custom snippets
- **lspkind.nvim**: VS Code-style completion icons
- **tiny-inline-diagnostic.nvim**: Inline diagnostic messages

#### AI & Assistance
- **avante.nvim**: ACP agent integration with OpenCode and Claude Code
- **mcphub.nvim**: MCP server management and Avante bridge
- **img-clip.nvim**: Image pasting for markdown
- **render-markdown.nvim**: Live markdown rendering

#### Code Intelligence
- **nvim-treesitter**: Syntax highlighting and AST parsing
- **nvim-ts-autotag**: Auto-close HTML/JSX tags
- **playground**: Treesitter playground for debugging
- **conform.nvim**: Async formatting with multiple formatter support

#### File Management
- **neo-tree.nvim**: File explorer (replaced Snacks explorer)
- **telescope.nvim**: Fuzzy finder (backup to Snacks picker)
- **telescope-fzf-native.nvim**: Native FZF sorter for Telescope
- **fzf-lua**: Alternative FZF integration

#### Git Integration
- **gitsigns.nvim**: Git decorations and hunk actions
- **neogit**: Magit-like Git interface
- **diffview.nvim**: Git diff viewer

#### Workflow
- **trouble.nvim**: Diagnostics, references, and quickfix panel
- **mini.pairs**: Auto-pairing brackets
- **dressing.nvim**: Enhanced UI for vim.ui.select/input
- **obsidian.nvim**: Obsidian vault integration
- **vimtex**: LaTeX compile/view workflow
- **typst-preview.nvim**: Typst live preview
- **nvim-lint**: External linter integration
- **neotest**: Unified test runner

## Configuration Flow

### Startup Sequence
1. `init.lua` loads in order:
   - `config.settings` → Vim options
   - `config.keymaps` → Custom keybindings
   - `config.plugins` → Lazy.nvim bootstrap and plugin loading
   - `config.autocmds` → Auto commands

### Plugin Loading Strategy
- **Priority plugins**: snacks.nvim (priority = 1000, lazy = false)
- **Event-based**: Most plugins lazy-load on events (VeryLazy, InsertEnter, BufReadPre, etc.)
- **Key-based**: Many plugins load on first keymap usage
- **Filetype-based**: Language-specific plugins load per filetype

## LSP Configuration

### Installed Servers (via Mason)
- `lua_ls` - Lua (Neovim config)
- `vtsls` - TypeScript/JavaScript
- `eslint` - JavaScript linting
- `elixirls` - Elixir
- `graphql` - GraphQL
- `emmet_language_server` - HTML/CSS snippets
- `tailwindcss` - TailwindCSS
- `texlab` - LaTeX/BibTeX
- `tinymist` - Typst

### LSP Features
- Automatic server installation via mason-lspconfig
- `nvim-navic` attaches through `LspAttach`
- Custom capabilities from `cmp-nvim-lsp`
- Per-server custom configuration with handlers (see `lua/plugins/lsp.lua`)
- Event-based loading on `BufReadPre` and `BufNewFile`

### Special Server Configs
- **tailwindcss**: Custom regex for Elixir/HEEx class detection
- **emmet_language_server**: Enabled for Elixir/HEEx filetypes
- **eslint**: Formatting disabled (handled by conform)
- **graphql**: Stream mode with specific filetypes
- **texlab**: latexmk-based build settings with save-time compilation
- **tinymist**: Typst root detection via `typst.toml` or `.git`

## Completion System

### nvim-cmp Configuration
- **Engine**: `nvim-cmp`
- **Snippet engine**: LuaSnip with custom HEEx, Elixir, LaTeX, and Typst snippets
- **Keybindings**:
  - `<Tab>`: Confirm completion or jump snippet
  - `<S-Tab>`: Previous item or jump back in snippet
  - `<CR>`: Confirm completion
  - `<C-Space>`: Trigger completion
  - `<C-e>`: Hide completion
  - `<C-b>/<C-f>`: Scroll documentation

- **Sources**:
  1. LSP
  2. snippets
  3. buffer and path
  4. calc and markdown helpers

## Formatting

### conform.nvim Setup
- **Format on save**: Enabled with 500ms timeout and LSP fallback
- **Formatters by filetype**:
  - Lua: `stylua`
  - TS/JS/React: `prettier` → `eslint_d` (chain)
  - Markdown/JSON/HTML: `prettier`
  - Zsh: `shfmt`

- **Manual format**: `<leader>cf` (normal/visual)

## Keybinding Philosophy

### Leader Key
- `<Space>` - Main leader
- `m` - Local leader

### Snacks Keybinding Categories
- **Top-level shortcuts**:
  - `<leader><space>` - Smart file finder
  - `<leader>,` - Buffers
  - `<leader>/` - Grep
  - `<leader>:` - Command history

- **Find** (`<leader>f*`): Files, git files, recent, projects, config
- **Git** (`<leader>g*`): Status, branches, log, diff, browse, lazygit
- **Search** (`<leader>s*`): Grep, symbols, diagnostics, help, commands
- **Buffers** (`<leader>b*`): Delete, navigate
- **UI toggles** (`<leader>u*`): Spell, wrap, diagnostics, etc.
- **LSP** (`g*`): Definitions, references, implementations, type defs

### Other Key Bindings
- `<C-/>` or `<C-_>` - Toggle terminal
- `gd/gr/gI/gy/gD` - LSP navigation via Snacks picker
- `<leader>ca` - Code actions
- `<leader>cf` - Format file/range
- `<leader>a*` - AI workflows via Avante
- `<leader>r*` - run tests, lint buffers, and inspect output
- `m...` - filetype-local note and math workflows
- `<leader>z/Z` - Zen mode / Zoom
- `[[/]]` - Jump to prev/next word reference

## Vim Settings

### Display
- Global statusline (laststatus = 3)
- Line numbers with relative numbers
- Always show signcolumn
- No wrap, scrolloff = 8
- Cursorline enabled
- List chars for trailing spaces, tabs
- Custom fillchars for folds, diffs

### Editing
- Tab/shift width = 2
- No expandtab (uses tabs)
- Undo file enabled
- No swap/backup files
- 300ms timeout and updatetime
- Clipboard integration (unnamedplus)
- Smart case search

## AI Integration

### Avante (ACP agent UI)
- Primary provider: OpenCode via ACP
- Secondary provider: Claude Code via ACP
- MCP integration: MCP Hub custom tools and slash commands
- Dependencies: Telescope, fzf-lua, img-clip, render-markdown, mcphub.nvim

## Math Authoring

### Typst
- `typst-preview.nvim` provides live preview commands
- Local mappings: `mp` preview, `ms` sync, `mf` follow cursor
- `tinymist` provides Typst LSP support

### LaTeX
- `vimtex` handles compile, view, TOC, and errors
- Local mappings: `mc` compile, `mv` view, `mt` TOC, `me` errors, `mk` clean
- `texlab` provides LaTeX/BibTeX LSP support

## Custom Utilities

### `utils/borders.lua`
- Box drawing character definitions for consistent UI borders
- Used by Telescope for window borders

### `utils/completion-kinds.lua`
- LSP kind icons (likely for completion menu)

### `utils/keymap.lua`
- Helper functions for creating keymaps

### `utils/lsp-server-configs.lua`
- Custom LSP server initialization functions
- Contains `lua_ls_init` for Lua LSP configuration

## Theme Configuration

### TokyoNight Settings
- Style: night
- Used for:
  - Main colorscheme
  - Completion menu colors (via highlights)
  - Lualine theme
  - Status/buffer line integration

## Treesitter

### Configuration
- Auto-install parsers
- Ensure installed: lua, markdown, markdown_inline, latex, bibtex, typst
- Sync install: false
- Modules: highlight, indent
- Aliases: heex → html (for autotag)

## Known Patterns

### Modular Plugin Structure
Each plugin file returns a table with one or more plugin specs:
```lua
return {
  {
    "author/plugin-name",
    dependencies = {...},
    config = function() ... end,
    keys = {...},
    event = "...",
  }
}
```

### Lazy Loading Strategy
- UI plugins: VeryLazy event
- Completion: InsertEnter
- Formatters: BufReadPre, BufNewFile
- Pickers/finders: Key-based loading
- LSP: Loaded via lspconfig (no explicit lazy)

### Snacks Integration
- Replaces many standalone plugins (picker, terminal, notifications, dashboard)
- Unified keybinding scheme
- Toggle system for UI options
- Extensive picker integration for LSP navigation

## Dependencies Between Plugins

### Critical Dependencies
- **nvim-cmp** ← LuaSnip, cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-calc, lspkind
- **nvim-lspconfig** ← mason, mason-lspconfig, cmp-nvim-lsp (for capabilities), nvim-navic
- **lualine** ← nvim-navic (for winbar)
- **avante** ← treesitter, dressing, plenary, nui, telescope, blink.cmp, fzf-lua, img-clip, render-markdown
- **bufferline** ← nvim-web-devicons
- **telescope** ← plenary, telescope-fzf-native
- **treesitter** ← nvim-ts-autotag, playground

## File Types

### Elixir/Phoenix Support
- LSP: elixirls
- Formatters: prettier, eslint_d (for JS/TS)
- Tailwind: Custom class regex for HEEx templates
- Emmet: Enabled for heex filetype
- Snippets: Custom HEEx snippets in `lua/snippets/heex.lua`
- Autotag: Alias heex → html

### Web Development
- LSP: vtsls (TypeScript), eslint, graphql, tailwindcss, emmet
- Formatters: prettier, eslint_d
- Treesitter: Auto-install for syntax highlighting

## Performance Considerations

### Current Performance Characteristics
- Snacks loads immediately (priority = 1000, lazy = false)
- Most plugins lazy-load appropriately
- Treesitter: sync_install = false (good)
- Mason: auto-installation enabled (could slow first start)

### Potential Bottlenecks
1. **Snacks eager loading**: Large plugin loaded upfront
2. **Format on save**: 500ms timeout could block saves
3. **Avante dependencies**: Heavy dependency tree
4. **Treesitter auto-install**: Downloads parsers on demand

## Backup Configurations

### Nested nvim/ Directory
- Contains a separate LazyVim-based configuration
- Files: init.lua, lazy-lock.json, lazyvim.json
- Appears to be a backup or alternative config
- Not loaded by main init.lua

## Testing Requirements for AI Agents

### CRITICAL: Always Test Before Confirming
**When making ANY changes to plugin configurations, LSP setup, or keybindings, you MUST test in headless mode BEFORE claiming the fix works.**

### Required Headless Tests

#### 1. Basic Error Check
```bash
nvim --headless -c "e lua/config/keymaps.lua" -c "sleep 3" -c "messages" -c "quit" 2>&1 | grep -iE "error|failed"
```
Expected: No output (no errors)

#### 2. LSP Attachment Test
```bash
nvim --headless -c "e lua/test.lua" -c "sleep 5" -c "lua local clients = vim.lsp.get_clients({bufnr=0}); print('LSP clients:', #clients); for _, c in ipairs(clients) do print('  - ' .. c.name) end" -c "quit" 2>&1
```
Expected: Should show `lua_ls` for Lua files

#### 3. LSP Commands Availability
```bash
nvim --headless -c "e lua/test.lua" -c "sleep 3" -c "lua print('LspInfo:', vim.fn.exists(':LspInfo') == 2 and 'EXISTS' or 'MISSING')" -c "quit" 2>&1
```
Expected: `LspInfo: EXISTS`

#### 4. Filetype Restriction Test
```bash
echo "# Test" > /tmp/test.md && nvim --headless -c "e /tmp/test.md" -c "sleep 5" -c "lua local clients = vim.lsp.get_clients({bufnr=0}); if #clients == 0 then print('✓ Correct: No LSP on markdown') else for _, c in ipairs(clients) do print('ERROR: ' .. c.name .. ' attached incorrectly') end end" -c "quit" 2>&1
```
Expected: No LSP servers attached to markdown files (unless explicitly configured)

### Cache Clearing
If tests fail unexpectedly, clear Neovim caches:
```bash
rm -rf ~/.local/state/nvim/lazy/* ~/.cache/nvim/*
```

### Common Issues to Watch For

1. **Plugin Loading Order**
   - Problem: Plugin B requires Plugin A, but A loads after B
   - Solution: Add `dependencies = { "author/plugin-a" }` to Plugin B spec
   - Test: Run headless mode and check for "nil value" errors

2. **API Breaking Changes**
   - Problem: Plugin updates change API (e.g., `mason-lspconfig` v2.0.0 removed `setup_handlers()`)
   - Solution: Check plugin git tags and documentation for API changes
   - Test: Verify function exists before calling: `print(type(require('plugin').function))`

3. **Filetype Leakage**
   - Problem: LSP attaches to wrong filetypes (e.g., `elixirls` on markdown)
   - Solution: Explicitly set `filetypes = {...}` in LSP config
   - Test: Open different file types and verify correct LSP attachment

4. **Event-based Loading Failures**
   - Problem: Plugin loads too late or never loads
   - Solution: Check `event`, `keys`, `cmd`, and `ft` triggers in plugin spec
   - Test: Verify commands/functions exist: `vim.fn.exists(':CommandName')`

### Testing Workflow for AI Agents

1. **Make the change** to configuration files
2. **Run headless tests** (all 4 tests above)
3. **Clear caches** if tests fail unexpectedly
4. **Re-run tests** after cache clear
5. **Only then** report success to the user

**NEVER skip steps 2-4.** Configuration errors cause frustration and waste time.
