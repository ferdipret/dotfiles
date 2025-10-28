# Neovim Configuration Documentation

## Project Structure

```
.
├── init.lua                    # Main entry point - loads all config modules
├── lazy-lock.json              # Lazy.nvim plugin lockfile
├── stylua.toml                 # Stylua formatter configuration
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keymaps.lua         # Custom keymappings
│   │   ├── plugins.lua         # Lazy.nvim bootstrap and setup
│   │   └── settings.lua        # Vim options and settings
│   ├── plugins/
│   │   ├── ai.lua              # AI tools (Supermaven, Avante)
│   │   ├── colorscheme.lua     # TokyoNight theme
│   │   ├── completions.lua     # blink.cmp completion setup
│   │   ├── formatter.lua       # conform.nvim formatting
│   │   ├── git.lua             # Git integration (gitsigns, neogit, diffview)
│   │   ├── lsp.lua             # LSP configuration with Mason
│   │   ├── markdown.lua        # Markdown rendering
│   │   ├── mini.lua            # mini.pairs for auto-pairing
│   │   ├── neo-tree.lua        # File explorer
│   │   ├── obsidian.lua        # Obsidian.nvim integration
│   │   ├── snacks/
│   │   │   └── init.lua        # Snacks.nvim utilities
│   │   ├── statusline.lua      # Lualine + Barbar + Navic
│   │   ├── telescope.lua       # Telescope fuzzy finder
│   │   ├── treesitter.lua      # Treesitter and plugins
│   │   ├── trouble.lua         # Diagnostics panel
│   │   └── which-key.lua       # Keybinding help
│   ├── snippets/
│   │   └── heex.lua            # Custom HEEx snippets
│   └── utils/
│       ├── borders.lua         # Border character definitions
│       ├── completion-kinds.lua # LSP kind icons
│       ├── keymap.lua          # Keymap helper utilities
│       └── lsp-server-configs.lua # LSP server custom configs
└── nvim/                       # Nested config (appears to be LazyVim-based)
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
- **barbar.nvim**: Buffer tabline with neo-tree offset
- **nvim-navic**: Breadcrumb navigation in winbar
- **which-key.nvim**: Keybinding documentation and discovery
- **snacks.nvim**: Unified utility collection (dashboard, picker, notifications, terminal, etc.)

#### LSP & Completion
- **nvim-lspconfig**: LSP client configurations
- **mason.nvim**: LSP server installer
- **mason-lspconfig.nvim**: Bridge between mason and lspconfig
- **blink.cmp**: Modern Rust-based completion engine
  - Sources: LSP, snippets (LuaSnip), buffer, path
  - Built-in fuzzy matching and async handling
- **LuaSnip**: Snippet engine with custom snippets
- **lspkind.nvim**: VS Code-style completion icons
- **tiny-inline-diagnostic.nvim**: Inline diagnostic messages

#### AI & Assistance
- **supermaven-nvim**: AI code completion
- **avante.nvim**: ChatGPT/AI assistant integration (OpenAI o3-mini model)
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

### LSP Features
- Automatic server installation via mason-lspconfig
- Shared `on_attach` function with nvim-navic integration and LSP keybindings
- Custom capabilities from blink.cmp
- Per-server custom configuration with handlers (see `lua/plugins/lsp.lua`)
- Event-based loading on `BufReadPre` and `BufNewFile`

### Special Server Configs
- **tailwindcss**: Custom regex for Elixir/HEEx class detection
- **emmet_language_server**: Enabled for Elixir/HEEx filetypes
- **eslint**: Formatting disabled (handled by conform)
- **graphql**: Stream mode with specific filetypes

## Completion System

### blink.cmp Configuration
- **Engine**: Rust-based, 30-50% faster than nvim-cmp
- **Snippet engine**: LuaSnip with custom HEEx snippets (via snippets source with preset)
- **Keybindings**:
  - `<Tab>`: Accept completion, Supermaven suggestion (via vim.schedule), or jump snippet
  - `<S-Tab>`: Previous item or jump back in snippet
  - `<CR>`: Confirm completion
  - `<C-Space>`: Trigger completion
  - `<C-e>`: Hide completion
  - `<C-b>/<C-f>`: Scroll documentation
  - `<C-p>/<C-n>`: Navigate items

- **Sources**:
  1. lsp (with buffer fallback)
  2. path
  3. snippets (LuaSnip preset)
  4. buffer

- **Features**:
  - Auto-brackets for functions
  - Built-in fuzzy matching
  - Signature help integration
  - TokyoNight theme colors
  - lspkind icons including Supermaven

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
- `\` - Local leader

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

### Supermaven
- Event: InsertEnter
- Keybindings:
  - `<Tab>`: Accept suggestion (when no completion menu)
  - `<C-e>`: Clear suggestion
  - `<C-j>`: Accept word

### Avante (ChatGPT UI)
- Provider: OpenAI (o3-mini model)
- Timeout: 90 seconds
- Max tokens: 20,000
- Reasoning effort: high
- Dependencies: Telescope, blink.cmp, fzf-lua, img-clip, render-markdown

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
- Ensure installed: lua (minimal set)
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
- **blink.cmp** ← LuaSnip, lspkind
- **nvim-lspconfig** ← mason, mason-lspconfig, blink.cmp (for capabilities), nvim-navic
- **lualine** ← lsp-status, nvim-navic (for winbar)
- **avante** ← treesitter, dressing, plenary, nui, telescope, blink.cmp, fzf-lua, img-clip, render-markdown
- **barbar** ← gitsigns, nvim-web-devicons
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
