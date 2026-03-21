# Neovim Configuration Documentation

Welcome to your Neovim configuration documentation!

## 📚 Documentation Index

### Core Documentation
- [Architecture Overview](architecture.md) - Structure and design philosophy
- [Plugin Reference](plugins.md) - Complete plugin list and configurations
- [Keybindings](keymaps.md) - All keybindings organized by category
- [Snippets](snippets.md) - Snippet reference and how to add new ones
- [Troubleshooting](troubleshooting.md) - Common issues and solutions
- [Configuration Improvement Plan](improvement-plan.md) - Roadmap to an A+ config for coding, research, and math-heavy writing
- [Documentation Hosting Options](deployment.md) - Netlify strategies & sync workflows

### Quick Links
- [Installation](#installation)
- [Key Features](#key-features)
- [Getting Started](#getting-started)
- [Daily Workflow](#daily-workflow)

---

## Installation

### Prerequisites
```bash
# Neovim 0.11+
nvim --version

# Required tools
npm install -g prettier eslint_d
cargo install stylua
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Optional research tools
mise use -g typst@latest
# Linux example
sudo apt install latexmk zathura
```

### Setup
```bash
# Clone or symlink your config
cd ~/dotfiles/nvim/.config/nvim

# Install plugins (auto on first launch)
nvim
:Lazy sync
```

---

## Key Features

### 🚀 Performance
- **Modular lazy-loaded setup**: plugin specs split by feature
- **Current completion stack**: nvim-cmp + LuaSnip + lspkind
- **Optimized LSP**: Event-based loading, no blocking

### 🎨 UI/UX
- **Theme**: TokyoNight (night variant)
- **Statusline**: Lualine with LSP status
- **Bufferline**: Visual buffer tabs
- **File Explorer**: Neo-tree with sidebar
- **Fuzzy Finder**: Snacks picker (primary), Telescope (backup)

### 💡 Intelligence
- **LSP**: lua_ls, vtsls, elixirls, tailwindcss, emmet, texlab, tinymist
- **Completion**: nvim-cmp with LuaSnip and LSP sources
- **Formatting**: conform.nvim (auto on save)
- **AI assistant**: Avante
- **Snippets**: LuaSnip with code, LaTeX, and Typst snippets

### 📝 Notes & Obsidian
- **Integration**: obsidian-nvim (community fork)
- **Daily Notes**: Python script with date-aware generation
- **Templates**: Daily, meeting, project, todo templates
- **Workflows**: Quick capture, backlinks, tags, search

### ∑ Research & Math
- **Typst**: tinymist LSP with live preview and localleader mappings
- **LaTeX**: VimTeX + texlab with compile, view, TOC, and error workflows
- **Writing ergonomics**: wrap and spell enabled in Typst and LaTeX buffers

### 🔧 Development
- **Git**: Gitsigns, Neogit, Lazygit, Diffview
- **Terminal**: Integrated terminal with toggle
- **Diagnostics**: Trouble.nvim for errors/warnings
- **Treesitter**: Syntax highlighting and text objects

---

## Getting Started

### First Time Setup

1. **Open Neovim**: `nvim`
2. **Wait for plugins to install**: Lazy.nvim runs automatically
3. **Restart Neovim**: After installation completes
4. **Test LSP**: Open a `.lua` or `.ts` file, type and see completions

### Essential Keybindings

```
<Space>      Leader key
m            Local leader
<leader>ff   Find files
<leader>sg   Search in project (grep)
<leader>e    Toggle file explorer
<leader>gg   Open Lazygit
<leader>nd   Generate today's daily note
```

### Navigation

```
<C-h/j/k/l>  Move between splits
gd           Go to definition
gr           Find references
<leader>ca   Code actions
<leader>cf   Format file or range
```

---

## Daily Workflow

### Starting Your Day

```
1. nvim
2. <leader>nd          # Generate today's daily note
3. <leader>ff          # Find files to work on
4. <leader>gg          # Check git status
```

### Coding Session

```
1. <leader>e           # Open file explorer
2. Navigate and open files
3. gd / gr             # Navigate code with LSP
4. <leader>ca          # Code actions
5. <leader>cf          # Format file
```

### Git Workflow

```
1. <leader>gs          # Git status (Snacks)
2. <leader>gg          # Lazygit for staging/commits
3. <leader>gb          # Browse branches
4. <leader>gd          # View diffs
```

### Note Taking

```
1. <leader>nn          # Quick new note
2. <leader>nm          # Meeting note
3. <leader>ns          # Search vault
4. <leader>nb          # View backlinks
5. <leader>nt          # Search by tag
```

---

## Configuration Structure

```
.
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── settings.lua     # Vim options
│   │   ├── keymaps.lua      # Custom keybindings
│   │   ├── autocmds.lua     # Auto commands
│   │   └── plugins.lua      # Lazy.nvim setup
│   ├── plugins/             # Plugin configurations
│   │   ├── completions.lua  # nvim-cmp setup
│   │   ├── lsp.lua          # LSP configuration
│   │   ├── obsidian.lua     # Notes integration
│   │   └── ...
│   ├── snippets/            # LuaSnip snippets
│   └── utils/               # Helper functions
├── docs/                    # This documentation
└── lazy-lock.json          # Plugin versions
```

---

## Learning Resources

### Neovim Basics
- `:help` - Built-in help system
- `:Tutor` - Interactive tutorial
- `<leader>sk` - Search keymaps

### Plugin Docs
- `:Lazy` - Plugin manager interface
- `:Mason` - LSP server installer
- `:ObsidianHelp` - Obsidian.nvim commands

### This Config
- Read the [Architecture](architecture.md) guide
- Browse [Plugin Reference](plugins.md)
- Check [Keybindings](keymaps.md) when stuck

---

## Support & Updates

### Getting Help
1. Check [Troubleshooting](troubleshooting.md)
2. Search keybindings: `<leader>sk`
3. Check plugin docs: `:help plugin-name`

### Updating
```vim
:Lazy sync          " Update all plugins
:Mason update       " Update LSP servers
:TSUpdate           " Update Treesitter parsers
```

### Backup Before Changes
```bash
cd ~/dotfiles/nvim/.config/nvim
git add -A
git commit -m "backup before changes"
```

---

## Quick Reference Card

| Category | Key | Action |
|----------|-----|--------|
| **Files** | `<leader>ff` | Find files |
| | `<leader>fr` | Recent files |
| | `<leader>e` | File explorer |
| **Search** | `<leader>sg` | Grep project |
| | `<leader>sb` | Buffer lines |
| | `<leader>sw` | Search word |
| **LSP** | `gd` | Go to definition |
| | `gr` | References |
| | `<leader>ca` | Code actions |
| | `<leader>cf` | Format buffer |
| **Git** | `<leader>gg` | Lazygit |
| | `<leader>gs` | Git status |
| | `<leader>gb` | Branches |
| **Notes** | `<leader>nd` | Daily note |
| | `<leader>nn` | New note |
| | `<leader>ns` | Search vault |
| **Buffers** | `<leader>bd` | Delete buffer |
| | `<leader>,` | Buffers picker |

---

*Last updated: 2026-03-21*
*For detailed information, explore the documentation sections above.*
