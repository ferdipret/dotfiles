# Architecture Overview

[← Back to Index](index.md)

## Design Philosophy

This Neovim configuration follows these principles:

1. **Performance First**: Lazy loading, async operations, fast completion
2. **Modular Structure**: Each plugin in its own file
3. **Minimal Dependencies**: Only essential plugins
4. **Well Documented**: Clear comments and external docs
5. **Maintainable**: Simple, predictable patterns

---

## Startup Sequence

### 1. Entry Point (`init.lua`)
```lua
require("config.settings")   -- Vim options first
require("config.keymaps")    -- Custom keybindings
require("config.plugins")    -- Bootstrap lazy.nvim
require("config.autocmds")   -- Auto commands last
```

### 2. Plugin Loading (`lua/config/plugins.lua`)
```lua
-- Bootstrap lazy.nvim if not installed
-- Automatically load all files from lua/plugins/
-- Each file returns a table of plugin specs
```

### 3. Plugin Initialization Order

**Priority = 1000 (loads first)**
- snacks.nvim - Core utilities

**Event = "VeryLazy" (loads after UI)**
- Most UI plugins
- Statusline, bufferline
- File explorer
- Pickers

**Event = "InsertEnter"**
- blink.cmp completion
- Supermaven AI

**Event = "BufReadPre", "BufNewFile"**
- LSP configuration
- Treesitter
- Formatters

**Lazy = true, keys = {...}** (loads on keypress)
- Git plugins
- Telescope
- Obsidian

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── lazy-lock.json                # Plugin versions (committed)
│
├── docs/                         # Documentation
│   ├── index.md                  # This documentation
│   ├── architecture.md           # Architecture guide
│   ├── plugins.md                # Plugin reference
│   ├── keymaps.md                # Keybinding reference
│   ├── snippets.md               # Snippet reference
│   └── troubleshooting.md        # Common issues (new)
│
├── lua/
│   ├── config/                   # Core configuration
│   │   ├── settings.lua          # Vim options
│   │   ├── keymaps.lua           # Custom keybindings
│   │   ├── plugins.lua           # Lazy.nvim bootstrap
│   │   └── autocmds.lua          # Auto commands
│   │
│   ├── plugins/                  # Plugin configurations
│   │   ├── completions.lua       # blink.cmp setup
│   │   ├── lsp.lua               # LSP + Mason
│   │   ├── treesitter.lua        # Syntax highlighting
│   │   ├── formatter.lua         # conform.nvim
│   │   ├── obsidian.lua          # Notes integration
│   │   ├── git.lua               # Git plugins
│   │   ├── statusline.lua        # Lualine + bufferline
│   │   ├── neo-tree.lua          # File explorer
│   │   ├── telescope.lua         # Fuzzy finder (backup)
│   │   ├── snacks/
│   │   │   └── init.lua          # Snacks utilities
│   │   ├── ai.lua                # Supermaven + Avante
│   │   ├── colorscheme.lua       # TokyoNight theme
│   │   ├── which-key.lua         # Keybinding help
│   │   ├── trouble.lua           # Diagnostics panel
│   │   ├── markdown.lua          # Markdown rendering
│   │   └── mini.lua              # mini.pairs
│   │
│   ├── snippets/                 # LuaSnip snippets
│   │   └── heex.lua              # HEEx/Phoenix snippets
│   │
│   └── utils/                    # Helper utilities
│       ├── borders.lua           # Border definitions
│       ├── completion-kinds.lua  # LSP kind icons
│       ├── keymap.lua            # Keymap helpers
│       └── lsp-server-configs.lua # LSP custom configs
```

---

## Plugin Architecture

### Core Layers

```
┌─────────────────────────────────┐
│   User Interface (UI)           │
│   - Colorscheme (TokyoNight)    │
│   - Statusline (Lualine)        │
│   - Bufferline                  │
│   - Which-key                   │
└─────────────────────────────────┘
           ▼
┌─────────────────────────────────┐
│   Navigation & Search           │
│   - Snacks Picker (primary)     │
│   - Telescope (backup)          │
│   - Neo-tree (file explorer)    │
└─────────────────────────────────┘
           ▼
┌─────────────────────────────────┐
│   Code Intelligence             │
│   - LSP (nvim-lspconfig)        │
│   - Completion (blink.cmp)      │
│   - AI (Supermaven, Avante)     │
│   - Snippets (LuaSnip)          │
└─────────────────────────────────┘
           ▼
┌─────────────────────────────────┐
│   Editing & Formatting          │
│   - Treesitter (syntax)         │
│   - Formatter (conform.nvim)    │
│   - Auto-pairs (mini.pairs)     │
└─────────────────────────────────┘
           ▼
┌─────────────────────────────────┐
│   Version Control               │
│   - Gitsigns (decorations)      │
│   - Neogit (interface)          │
│   - Lazygit (TUI)               │
│   - Diffview (diffs)            │
└─────────────────────────────────┘
           ▼
┌─────────────────────────────────┐
│   Utilities & Workflow          │
│   - Snacks (utilities)          │
│   - Obsidian (notes)            │
│   - Trouble (diagnostics)       │
│   - ToggleTerm (terminal)       │
└─────────────────────────────────┘
```

---

## Key Components

### 1. Completion System (blink.cmp)

**Why blink.cmp?**
- 30-50% faster than nvim-cmp (Rust-based)
- Built-in fuzzy matching
- Better async handling
- Native snippet support

**Source Priority:**
1. LSP (score: 100)
2. Snippets (score: 80)
3. Path (score: 50)
4. Buffer (score: 40)

**Integration:**
- LuaSnip for snippets
- Supermaven for AI suggestions
- lspkind for icons

### 2. LSP Configuration

**Server Management:**
- Mason: Install/update LSP servers
- mason-lspconfig: Bridge to nvim-lspconfig
- nvim-lspconfig: Server configurations

**Installed Servers:**
- lua_ls (Lua)
- vtsls (TypeScript/JavaScript)
- elixirls (Elixir)
- tailwindcss (TailwindCSS)
- emmet_language_server (HTML/CSS)
- eslint (Linting)

**Loading Strategy:**
- Event-based: `BufReadPre`, `BufNewFile`
- Automatic attachment to buffers
- Shared `on_attach` with keybindings

### 3. Picker System (Snacks)

**Primary Picker:** Snacks.picker
- Fast, modern, integrated
- Used for: files, grep, LSP, git

**Backup Picker:** Telescope
- Available if Snacks doesn't work
- More plugin ecosystem support

**Features:**
- Fuzzy search
- Live grep
- LSP integration
- Git integration

### 4. File Explorer (Neo-tree)

**Features:**
- Sidebar position
- Git status indicators
- Follow current file
- Show hidden files
- Integration with bufferline offset

**Replaced:** Snacks explorer (too minimal)

### 5. Git Integration

**Three-tier approach:**
1. **Gitsigns**: Inline decorations, hunk operations
2. **Neogit**: Magit-like interface for staging
3. **Lazygit**: Full-featured TUI (external)
4. **Diffview**: View file diffs and history

### 6. Notes System (Obsidian)

**Plugin:** obsidian-nvim (community fork)
- Better blink.cmp integration
- Snacks picker support
- Active maintenance

**Workflow:**
- Daily notes with Python script
- Templates: daily, meeting, project, todo
- Quick capture with keybindings
- Backlinks and tag search
- Image attachment support

**Python Integration:**
- Date-aware note generation
- Day-specific schedules
- Weekend vs weekday templates

---

## Performance Optimization

### Lazy Loading Strategy

**Never Lazy:**
- snacks.nvim (priority 1000, needed early)

**VeryLazy (after UI):**
- Statusline, bufferline
- File explorer
- Pickers
- Which-key

**On InsertEnter:**
- Completion engine
- AI suggestions

**On BufRead:**
- LSP configuration
- Treesitter
- Formatters
- Gitsigns

**On Keypress:**
- Git interfaces
- Obsidian commands
- Less-used tools

### Startup Optimization

Current startup time: **~75ms**

**What's loaded immediately:**
1. Settings, keymaps, autocmds
2. Snacks.nvim (utilities)

**What's deferred:**
- Everything else loads on-demand

**Tips for speed:**
- Don't load Snacks eagerly unless needed
- Keep `ensure_installed` minimal for Treesitter
- Use event-based loading for LSP

---

## Extension Points

### Adding a New Plugin

1. Create file in `lua/plugins/`
2. Return plugin spec table
3. Configure lazy loading
4. Add keybindings
5. Document in `docs/plugins.md`

Example:
```lua
-- lua/plugins/my-plugin.lua
return {
  "author/my-plugin.nvim",
  event = "VeryLazy",  -- or keys, cmd, ft
  opts = {
    -- configuration
  },
  keys = {
    { "<leader>mp", "<cmd>MyPlugin<cr>", desc = "My Plugin" },
  },
}
```

### Adding LSP Server

1. Install via Mason: `:Mason`
2. Add to `ensure_installed` in `lua/plugins/lsp.lua`
3. Optionally add custom config in handlers

### Adding Snippets

1. Create/edit file in `lua/snippets/`
2. Use LuaSnip format
3. Document in `docs/snippets.md`

---

## Configuration Patterns

### Plugin Spec Pattern
```lua
return {
  "author/plugin",
  dependencies = { "required/plugin" },
  event = "VeryLazy",
  opts = {}, -- passes to setup()
  -- OR
  config = function()
    require("plugin").setup({})
  end,
  keys = {}, -- keybindings
}
```

### Keybinding Pattern
```lua
keys = {
  { "<leader>key", "<cmd>Command<cr>", desc = "Description" },
  { "<leader>fn", function() code() end, desc = "Function call" },
  { "<leader>v", "command", mode = "v", desc = "Visual mode" },
}
```

### LSP Handler Pattern
```lua
["server_name"] = function()
  setup_lsp("server_name", {
    filetypes = { "ft1", "ft2" },
    settings = {},
    on_attach = function(client, bufnr)
      -- custom logic
    end,
  })
end
```

---

### Formatting Expectations

- `conform.nvim` orchestrates all formatters (see `lua/plugins/formatter.lua`).
- No `stylua.toml` is committed; Stylua should be invoked with `--indent-type Tabs --indent-width 2`.
- JavaScript/TypeScript rely on `prettier` + `eslint_d`; install both globally for seamless save-on-format.
- Shell scripts use `shfmt`; ensure it is available in `$PATH`.

---

## Design Decisions

### Why These Choices?

**blink.cmp over nvim-cmp**
- Faster (Rust-based)
- Simpler API
- Better async

**Snacks over individual plugins**
- Unified interface
- Better integration
- Less duplication

**Neo-tree over nvim-tree**
- More features
- Better git integration
- Active development

**bufferline over barbar**
- More stable
- Fewer bugs
- Better maintained

**Community obsidian.nvim fork**
- Modern plugin support
- Active maintenance
- Bug fixes

---

*Next: [Plugin Reference](plugins.md) →*
