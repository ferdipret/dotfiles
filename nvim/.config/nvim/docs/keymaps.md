# Neovim Keybindings

[<- Back to Index](index.md)

This file documents the current live keymap layout.

## Leaders

- `<Space>` - main leader
- `m` - local leader

## How To Discover Mappings

- `<leader>` - open the main which-key menu
- `m` - open the local-leader which-key menu when a filetype provides local mappings
- `<leader>sk` - search all keymaps with Snacks picker
- `<leader>?` - show buffer-local keymaps
- which-key groups now include icons and clearer category labels

---

## Global Editor Maps

- `<C-h>` - move to left split
- `<C-j>` - move to lower split
- `<C-k>` - move to upper split
- `<C-l>` - move to right split
- `<Esc>` - clear search highlight
- `<A-j>` - move current line or selection down
- `<A-k>` - move current line or selection up
- terminal `<Esc>` - leave terminal mode

---

## Completion

Current completion stack: `nvim-cmp` + `LuaSnip`

- `<Tab>` - confirm visible completion or expand/jump snippet
- `<S-Tab>` - select previous completion item or jump backward in snippet
- `<CR>` - confirm completion without auto-select
- `<C-e>` - abort completion
- `<C-b>` - scroll docs up
- `<C-f>` - scroll docs down
- `<C-Space>` - trigger completion

---

## Files And Pickers

- `<leader><space>` - smart find files
- `<leader>,` - buffers
- `<leader>/` - grep
- `<leader>:` - command history
- `<leader>e` - explorer

### Find

- `<leader>fb` - buffers
- `<leader>fc` - find config file
- `<leader>ff` - find files
- `<leader>fg` - find git files
- `<leader>fp` - projects
- `<leader>fr` - recent files

### Search

- `<leader>sa` - autocmds
- `<leader>sb` - buffer lines
- `<leader>sB` - grep open buffers
- `<leader>sc` - command history
- `<leader>sC` - commands
- `<leader>sd` - diagnostics
- `<leader>sD` - buffer diagnostics
- `<leader>sg` - grep
- `<leader>sh` - help pages
- `<leader>sH` - highlights
- `<leader>si` - icons
- `<leader>sj` - jumps
- `<leader>sk` - keymaps
- `<leader>sl` - location list
- `<leader>sm` - marks
- `<leader>sM` - man pages
- `<leader>sp` - plugin specs
- `<leader>sq` - quickfix list
- `<leader>sR` - resume picker
- `<leader>ss` - LSP symbols
- `<leader>sS` - LSP workspace symbols
- `<leader>su` - undo history
- `<leader>sw` - grep word or selection
- `<leader>s"` - registers
- `<leader>s/` - search history

---

## LSP And Code

### Navigation

- `gd` - goto definition
- `gD` - goto declaration
- `gr` - references
- `gI` - goto implementation
- `gy` - goto type definition

### Actions

- `<leader>ca` - code actions
- `<leader>cf` - format buffer
- `<leader>cR` - rename file

### References

- `]]` - next reference
- `[[` - previous reference

---

## AI

- `<leader>aa` - ask AI about the current code or selection
- `<leader>ac` - chat with the codebase
- `<leader>af` - focus the AI panel
- `<leader>ah` - open chat history
- `<leader>am` - select model
- `<leader>aR` - show repo map
- `<leader>as` - stop current AI request
- `<leader>at` - toggle AI panel

---

## Git

### Snacks Git

- `<leader>gB` - git browse
- `<leader>gb` - git branches
- `<leader>gd` - git diff hunks
- `<leader>gf` - git log file
- `<leader>gg` - lazygit
- `<leader>gl` - git log
- `<leader>gL` - git log line
- `<leader>gs` - git status
- `<leader>gS` - git stash

### Neogit

- `<leader>gn` - Neogit status
- `<leader>gnc` - commit
- `<leader>gnd` - diff
- `<leader>gnl` - log
- `<leader>gnp` - push
- `<leader>gnr` - reset (unstage)

### Gitsigns

- `<leader>ghb` - blame line
- `<leader>ghc` - toggle current line blame
- `<leader>ghd` - diff this
- `<leader>ghh` - preview hunk
- `<leader>ghn` - next hunk
- `<leader>gho` - open fold
- `<leader>ghp` - previous hunk
- `<leader>ghr` - reset hunk
- `<leader>ghR` - reset buffer
- `<leader>ghs` - stage hunk
- `<leader>ght` - toggle signs
- `<leader>ghu` - undo stage hunk

---

## Lists, Diagnostics, And Notifications

### Trouble

- `<leader>cl` - LSP definitions, references, and more in Trouble
- `<leader>cs` - symbols in Trouble
- `<leader>dd` - workspace diagnostics
- `<leader>db` - buffer diagnostics
- `<leader>dl` - location list
- `<leader>dq` - quickfix list

### Notifications

- `<leader>xn` - notification history picker
- `<leader>x?` - notification history window
- `<leader>un` - dismiss notifications

---

## Buffers, Scratch, And UI

- `<leader>bd` - delete buffer
- `<leader>.` - toggle scratch buffer
- `<leader>S` - select scratch buffer
- `<leader>z` - toggle zen mode
- `<leader>Z` - toggle zoom
- `<leader>N` - Neovim news

### UI Toggles

- `<leader>ub` - dark background
- `<leader>uC` - colorschemes
- `<leader>uc` - conceal level
- `<leader>uD` - dim
- `<leader>ud` - diagnostics
- `<leader>ug` - indent guides
- `<leader>uh` - inlay hints
- `<leader>uL` - relative numbers
- `<leader>ul` - line numbers
- `<leader>un` - dismiss notifications
- `<leader>us` - spelling
- `<leader>uT` - Treesitter
- `<leader>uw` - wrap

---

## Terminal

- `<C-/>` - toggle Snacks terminal
- `<C-_>` - alternate terminal toggle
- `<leader>tf` - toggle floating terminal rooted at the project git dir

---

## Notes And Obsidian

### Core

- `<leader>nb` - show backlinks
- `<leader>nD` - browse daily notes
- `<leader>nd` - generate today's daily note
- `<leader>nf` - follow link
- `<leader>nl` - show all links
- `<leader>nn` - new note
- `<leader>no` - open in Obsidian app
- `<leader>nq` - quick switch note
- `<leader>ns` - search vault
- `<leader>nT` - table of contents
- `<leader>nt` - search tags
- `<leader>nw` - switch workspace

### Capture And File Operations

- `<leader>ni` - quick idea
- `<leader>nm` - quick meeting note
- `<leader>np` - paste image
- `<leader>nr` - rename note
- `<leader>nx` - extract selection to a new note
- `<leader>nc` - toggle markdown checkbox

### Templates

- `<leader>nti` - insert template
- `<leader>ntd` - decision template
- `<leader>ntg` - debug template
- `<leader>ntl` - learning template
- `<leader>ntm` - meeting template
- `<leader>ntp` - project template
- `<leader>ntt` - todo template

### Daily Navigation

- `<leader>ny` - generate yesterday's daily note
- `<leader>nY` - generate tomorrow's daily note

### Preview

- `<leader>nP` - toggle markdown preview

### Local Note Actions

These are buffer-local in markdown buffers and use `m` as the local leader.

- `mb` - show backlinks
- `mc` - toggle checkbox
- `md` - generate today's daily note
- `ml` - show links
- `mo` - open in Obsidian app
- `mp` - paste image
- `mr` - rename note
- `mt` - search tags
- `my` - generate yesterday's daily note
- `mY` - generate tomorrow's daily note

---

## Math And Research Writing

### Local LaTeX Actions

These are buffer-local in `tex` and `plaintex` buffers and use `m` as the local leader.

- `mc` - compile document
- `me` - show errors
- `mk` - clean aux files
- `mt` - open table of contents
- `mv` - view PDF

### Local Typst Actions

These are buffer-local in `typst` buffers and use `m` as the local leader.

- `mf` - toggle preview follow cursor
- `mp` - toggle preview
- `ms` - sync preview to cursor

---

## Notes

- `m` is the configured local leader, but most filetype-local workflows have not yet moved there.
- The most reliable in-editor cheatsheets are `<leader>`, `<leader>sk`, and `<leader>?`.
- This file is intended to track the live config during the Phase 1 cleanup.
