# Neovim Keybindings

## Leader Keys

- `<Space>` - Main leader
- `m` - Local leader

---

## LSP (Language Server Protocol)

### Navigation (via Snacks Picker)

- `gd` - Goto Definition
- `gD` - Goto Declaration
- `gr` - References
- `gI` - Goto Implementation
- `gy` - Goto Type Definition

### Code Actions

- `<leader>ca` - Code Actions
- `<leader>cr` - Rename Symbol
- `<leader>cf` - Format Buffer

### Documentation

- `K` - Hover Documentation

### Diagnostics

- `gl` - Show Line Diagnostics
- `[d` - Previous Diagnostic
- `]d` - Next Diagnostic

---

## Completion (blink.cmp)

- `<Tab>` - Accept completion / Supermaven suggestion / Jump snippet forward
- `<S-Tab>` - Previous item / Jump snippet backward
- `<CR>` - Confirm completion (no auto-select)
- `<C-e>` - Close completion menu / Clear Supermaven suggestion
- `<C-b>` - Scroll documentation up
- `<C-f>` - Scroll documentation down
- `<C-Space>` - Trigger completion manually
- `<C-p>` - Select previous item
- `<C-n>` - Select next item

### Supermaven AI

- `<Tab>` - Accept AI suggestion (when no completion menu)
- `<C-e>` - Clear AI suggestion
- `<C-j>` - Accept single word from suggestion

---

## File Navigation (Snacks Picker)

### Top-Level

- `<leader><space>` - Smart Find Files
- `<leader>,` - Buffers
- `<leader>/` - Grep in Project
- `<leader>:` - Command History
- `<leader>e` - Toggle Neo-tree Explorer

### Find

- `<leader>fb` - Find Buffers
- `<leader>fc` - Find Config Files
- `<leader>ff` - Find Files
- `<leader>fg` - Find Git Files
- `<leader>fp` - Projects
- `<leader>fr` - Recent Files

### Search

- `<leader>sb` - Buffer Lines
- `<leader>sB` - Grep Open Buffers
- `<leader>sg` - Grep in Project
- `<leader>sw` - Grep Word under cursor
- `<leader>s"` - Registers
- `<leader>s/` - Search History
- `<leader>sa` - Autocmds
- `<leader>sc` - Command History
- `<leader>sC` - Commands
- `<leader>sd` - Diagnostics (Workspace)
- `<leader>sD` - Diagnostics (Buffer)
- `<leader>sh` - Help Pages
- `<leader>sH` - Highlights
- `<leader>si` - Icons
- `<leader>sj` - Jumps
- `<leader>sk` - Keymaps
- `<leader>sl` - Location List
- `<leader>sm` - Marks
- `<leader>sM` - Man Pages
- `<leader>sp` - Search Plugin Specs
- `<leader>sq` - Quickfix List
- `<leader>sR` - Resume Last Picker
- `<leader>ss` - LSP Symbols (Buffer)
- `<leader>sS` - LSP Workspace Symbols
- `<leader>su` - Undo History

---

## Git (Snacks, Neogit & Gitsigns)

### Main Git Commands (Snacks)

- `<leader>gg` - Lazygit
- `<leader>gB` - Git Browse (Open in browser)
- `<leader>gb` - Git Branches
- `<leader>gl` - Git Log
- `<leader>gL` - Git Log Line
- `<leader>gs` - Git Status
- `<leader>gS` - Git Stash
- `<leader>gd` - Git Diff (Hunks)
- `<leader>gf` - Git Log File

### Neogit

- `<leader>gn` - Neogit Status
- `<leader>gnc` - Commit
- `<leader>gnp` - Push
- `<leader>gnl` - Log
- `<leader>gnd` - Diff
- `<leader>gnr` - Reset (unstage)

### Git Hunks (Gitsigns)

- `<leader>ghh` - Preview Hunk
- `<leader>ghn` - Next Hunk
- `<leader>ghp` - Previous Hunk
- `<leader>ghs` - Stage Hunk
- `<leader>ghu` - Undo Stage Hunk
- `<leader>ghr` - Reset Hunk
- `<leader>ghR` - Reset Buffer
- `<leader>ghb` - Blame Line
- `<leader>ght` - Toggle Signs
- `<leader>ghd` - Diff This
- `<leader>gho` - Open Fold
- `<leader>ghc` - Toggle Line Blame

---

## Diagnostics & Lists (Trouble)

- `<leader>xx` - Toggle diagnostics view
- `<leader>xX` - Toggle buffer diagnostics
- `<leader>cs` - Document symbols (Trouble)
- `<leader>cl` - LSP definitions/references (Trouble)
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list

---

## Buffers (Snacks & Barbar)

- `<leader>bd` - Delete Buffer
- `<leader>bp` - Pin Buffer
- `<leader>bP` - Close All But Pinned
- `<leader>bo` - Close Other Buffers
- `[b` - Previous Buffer
- `]b` - Next Buffer

---

## UI Toggles

- `<leader>us` - Toggle Spelling
- `<leader>uw` - Toggle Wrap
- `<leader>uL` - Toggle Relative Numbers
- `<leader>ud` - Toggle Diagnostics
- `<leader>ul` - Toggle Line Numbers
- `<leader>uc` - Toggle Conceal Level
- `<leader>uT` - Toggle Treesitter
- `<leader>ub` - Toggle Dark/Light Background
- `<leader>uh` - Toggle Inlay Hints
- `<leader>ug` - Toggle Indent Guides
- `<leader>uD` - Toggle Dim
- `<leader>uC` - Change Colorscheme
- `<leader>un` - Dismiss Notifications

---

## Utilities

- `<leader>z` - Toggle Zen Mode
- `<leader>Z` - Toggle Zoom
- `<leader>.` - Toggle Scratch Buffer
- `<leader>S` - Select Scratch Buffer
- `<leader>cR` - Rename File
- `<leader>N` - Neovim News

### Notifications

- `<leader>xn` - Notification History
- `<leader>x?` - Notification History (alternative)
- `<leader>un` - Dismiss All Notifications

### Terminal

- `<C-/>` - Toggle Terminal
- `<C-_>` - Toggle Terminal (alternative)
- `<leader>tf` - Toggle floating terminal rooted at project

### Word References

- `]]` - Next Reference
- `[[` - Previous Reference

---

## Formatting (Conform)

- `<leader>cf` - Format File or Range (normal/visual mode)
- Format on save: Enabled (500ms timeout)

---

## File Explorer (Neo-tree)

- `<leader>e` - Toggle File Explorer

---

## Notes & Obsidian

### Core Operations

- `<leader>no` - Open in Obsidian App
- `<leader>nn` - New Note
- `<leader>nd` - Generate Today's Daily Note (Python script - date-aware)
- `<leader>ns` - Search Vault
- `<leader>nf` - Follow Link

### Enhanced Workflows

- `<leader>nq` - Quick Switch Note
- `<leader>nb` - Show Backlinks
- `<leader>nt` - Search Tags
- `<leader>nl` - Show All Links
- `<leader>nT` - Table of Contents
- `<leader>nx` - Extract to New Note (visual mode)

### Templates

- `<leader>nti` - Insert Template
- `<leader>ntm` - Meeting Template
- `<leader>ntp` - Project Template
- `<leader>ntt` - Todo Template

### Quick Capture

- `<leader>nm` - Quick Meeting Note
- `<leader>ni` - Quick Idea

### File Operations

- `<leader>nr` - Rename Note
- `<leader>np` - Paste Image

### Preview

- `<leader>nP` - Toggle Markdown Preview

### Todo/Checkbox Management

- `<CR>` - Toggle Checkbox (in markdown)
- `<leader>nc` - Toggle Checkbox

### Navigation

- `<leader>ny` - Generate Yesterday's Daily Note (Python script - correct date/schedule)
- `<leader>nY` - Generate Tomorrow's Daily Note (Python script - correct date/schedule)
- `<leader>nD` - Browse Daily Notes (picker with all dailies)
- `<leader>nw` - Switch Workspace

**Why Use Python Script for Daily Notes?**
The Python script (`generate_daily_note.py`) is date-aware and generates:
- Correct navigation links (yesterday/tomorrow relative to the note's date)
- Correct day-of-week specific schedule (e.g., Chess on Tuesday)
- Correct title and frontmatter for the target date
- Weekend vs weekday template based on actual day

**Backlinks Navigation:**
- When viewing backlinks (`:ObsidianBacklinks` or `<leader>nb`):
  - Use standard picker navigation: `<C-n>`/`<C-p>` or arrow keys
  - Press `<CR>` to open the selected backlink
  - Press `<Esc>` to close the picker

---

## General Notes

- Most Snacks pickers support fuzzy search
- LSP features require language server to be installed via Mason
- Git features require working directory to be a git repository
- Diagnostic keybindings only active when LSP is attached
- Obsidian features require markdown filetype
