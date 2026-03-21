# Configuration Improvement Plan

[<- Back to Index](index.md)

This document captures the plan to move this Neovim config from a strong personal setup to an A+ configuration for:

- everyday software engineering
- agentic coding and codebase exploration
- academic AI research
- math-heavy writing and note-taking

---

## Target Outcome

The target state is:

- **Architecture**: A+
- **Modern Neovim patterns**: A+
- **Performance and lazy-loading**: A+
- **Docs and config trustworthiness**: A+
- **Agentic coding support**: A+
- **Research and note-taking**: A+
- **Keymap discoverability and mnemonics**: A+
- **Math authoring**: A+
- **Portability**: A

To get there, the work should happen in phases so the config stays stable while improving.

---

## Guiding Principles

1. One source of truth. Runtime config, docs, and keymaps must agree.
2. One primary tool per surface. Avoid multiple overlapping systems unless there is a clear reason.
3. Fast by default. Expensive features should load late or only when needed.
4. Strong local workflows. Coding, writing, research, and note capture should all feel first-class.
5. Portable setup. Avoid machine-specific assumptions where possible.
6. Research-friendly defaults. Code buffers and writing buffers can have different ergonomics.
7. Mnemonic and discoverable keymaps. Bindings should be easy to infer, browse, and remember.

---

## Phase 1: Restore Trust In The Config

Priority: highest

### Goals

- remove drift between docs and runtime behavior
- eliminate conflicting mappings and settings
- remove stale or misleading plugin references

### Work Items

- reconcile completion docs with the actual engine in `lua/plugins/completions.lua`
- choose one `maplocalleader` value and document it consistently
- lock `maplocalleader` to `m` across runtime config, docs, and cheatsheets
- remove duplicate mappings such as `<leader>nd` and `<leader>sb`
- scope markdown-only mappings so they do not leak into general editing
- remove Supermaven configuration, mappings, statusline references, and doc references now that it is no longer part of the workflow
- remove or document stale references to disabled or unused plugins
- update `docs/index.md`, `docs/plugins.md`, `docs/keymaps.md`, `docs/architecture.md`, and `CLAUDE.md` from actual runtime behavior
- generate a runtime-trustworthy keymap reference so docs stop drifting from actual mappings

### Phase 1 Execution Order

1. Build a complete inventory of live mappings and their owners.
2. Resolve contradictory settings and duplicate bindings.
3. Remove dead workflow pieces, starting with Supermaven.
4. Update docs so they describe the cleaned runtime behavior.
5. Verify the resulting config in headless mode.

### A+ Criteria

- docs match the live config
- every published keybinding works as documented
- no duplicate high-value mappings
- no dead core-plugin claims in docs
- keymap docs are maintained from real behavior instead of memory
- Supermaven is fully removed from runtime behavior, UI, and docs

---

## Phase 2: Consolidate The Core Workflow Stack

Priority: highest

### Goals

- reduce overlap in search, completion, terminal, and git surfaces
- make plugin ownership clear

### Work Items

- choose one completion strategy and finish it end-to-end
  - either stay on `nvim-cmp` and remove `blink.cmp` drift
  - or migrate cleanly to `blink.cmp`
- keep Snacks as the primary picker layer and demote Telescope to dependency-only use where required
- decide whether ToggleTerm or `Snacks.terminal()` is the primary terminal UX
- decide whether Trouble remains a separate diagnostics UX or whether Snacks pickers cover enough
- remove stale dependencies such as disabled `barbar.nvim` and likely-unused `lsp-status.nvim`

### A+ Criteria

- one obvious picker workflow
- one obvious completion workflow
- one obvious terminal workflow
- no orphaned plugin dependencies in `lazy-lock.json`

---

## Phase 3: Keymap And Which-Key UX Overhaul

Priority: highest

### Goals

- make keybindings mnemonic, consistent, and easy to discover
- make `which-key` feel like a real command map rather than a partial hint layer
- keep plugin-specific maps co-located while making the overall system coherent

### Current Problems To Fix

- keymaps are mostly co-located with plugin specs, but not fully normalized
- some mappings are registered through Lazy `keys`, some through direct `vim.keymap.set`, some through `wk.add`, and some dynamically
- `which-key` has only light group metadata today and does not yet present a rich, icon-forward command surface
- there are real overlaps and misleading namespaces today, including duplicate bindings and conflicting group labels
- local leader is now consistently set to `m`, but most filetype-local workflows still need to migrate onto it

### Design Direction

- keep global editor maps in `lua/config/keymaps.lua`
- keep plugin maps in the plugin spec that owns them whenever possible
- use `which-key` as the authoritative UI layer for groups, subgroup names, icons, and discoverability
- require every user-facing mapping to have a clear `desc`
- separate global leader maps from filetype-local or workflow-local maps using `maplocalleader`
- reserve direct anonymous mappings for cases where plugin APIs require them, and document those exceptions

### Proposed Namespace Model

- `<leader>f` = find and files
- `<leader>s` = search and symbols
- `<leader>g` = git
- `<leader>c` = code actions and code transforms
- `<leader>d` = diagnostics and debugging
- `<leader>t` = terminal and task running
- `<leader>n` = notes and research
- `<leader>u` = UI toggles
- `<leader>b` = buffers
- `<leader>a` = AI and agentic workflows
- `<localleader>` = filetype-local actions such as markdown, Obsidian, LaTeX, Typst, or notebook-like helpers

### Work Items

- audit every live mapping source and normalize registration style where practical
- choose one final `maplocalleader` value and document it consistently
- resolve namespace confusion such as the current overload around `<leader>x`
- move diagnostics and debugging into a more mnemonic shared namespace, likely `<leader>d`
- make filetype-local workflows use `<localleader>` instead of consuming valuable global leader space
- give `which-key` richer metadata with icons, subgroup labels, and more descriptive copy
- ensure dynamic mappings such as Snacks toggles are still represented clearly in `which-key`
- make `<leader>sk` and `<leader>?` part of the documented discovery workflow
- create and maintain a trustworthy cheatsheet in `docs/keymaps.md` that reflects the actual map layout

### Cheatsheet And Discovery Expectations

The final setup should provide at least three ways to discover mappings:

- `which-key` popup after pressing `<leader>` or `<localleader>`
- searchable keymap picker via Snacks on `<leader>sk`
- a maintained markdown cheatsheet in `docs/keymaps.md`

### A+ Criteria

- bindings are mnemonic enough that categories are easy to guess
- `which-key` shows rich, informative groups and labels
- every important workflow has an obvious namespace
- filetype-local actions are clearly separated from global actions
- there are no duplicate leader mappings in core workflows
- the cheatsheet and popup agree with the live config

---

## Phase 4: Performance And Startup Discipline

Priority: high

### Goals

- improve startup behavior without harming workflow quality
- defer heavy features until they are actually needed

### Work Items

- review eager plugins and lazy-load anything not needed at startup
- revisit `snacks.nvim` eager loading and enable only the modules that are worth the startup cost
- lazy-load `neo-tree`, DAP, markdown rendering, Telescope, and other expensive secondary tools where possible
- move `after/plugin/dap-python.lua` into the DAP plugin spec so debugging can be lazily loaded cleanly
- make snippet loading lazy where possible
- replace auto-install behavior with explicit install lists where startup checks are not needed

### A+ Criteria

- startup feels consistently fast
- cold start and first-edit flows are predictable
- no major plugin does expensive work before the relevant feature is used

---

## Phase 5: Agentic Coding Upgrade

Priority: high

### Goals

- make the editor better for AI-assisted implementation, refactoring, debugging, and codebase research
- reduce friction in the loop of search -> reason -> edit -> test -> review

### Work Items

- make Avante a first-class surface with explicit keymaps for ask, edit, review, fix, explain, and chat history
- expose AI mappings and workflows through `which-key`
- add a lint layer such as `nvim-lint` so the editor catches issues outside formatter and LSP coverage
- add test orchestration such as `neotest` for fast run-nearest, run-file, and failure navigation loops
- add session or workspace persistence with `auto-session` or `resession`
- strengthen DAP with real launch configurations and keymaps for Python and JS/TS workflows
- consider adding fast movement and structure-editing helpers such as `flash.nvim`, `mini.ai`, and `mini.surround`

### A+ Criteria

- AI tools are discoverable and easy to invoke
- testing, linting, and debugging feel integrated rather than bolted on
- codebase exploration is fast in large repos
- sessions can be resumed without reconstructing context manually

---

## Phase 6: Research And Knowledge Work Upgrade

Priority: high

### Goals

- make long-form reading, synthesis, and note capture feel as good as coding
- improve support for academic AI workflows

### Work Items

- set markdown- and note-specific local defaults for `wrap`, `spell`, and readability
- add a dedicated research reading mode or buffer-local writing profile
- keep quick capture strong in Obsidian, but unify note navigation and search around the main picker strategy
- review templates for research notes, paper notes, experiment logs, and reading summaries
- consider bibliography and citation workflows if papers become a major writing task
- improve long-context review workflows with better outline, symbols, or document navigation

### A+ Criteria

- markdown buffers feel optimized for reading and writing
- note capture remains fast
- literature review and synthesis feel low-friction
- research notes and code notes can coexist cleanly

---

## Phase 7: First-Class Math Authoring

Priority: high

Academic AI research needs math support that is better than plain markdown snippets.

### Recommended Direction

Use a dual-track approach:

- **Typst for modern drafting**
- **LaTeX for compatibility and submission workflows**

This gives you a modern writing experience without giving up the standard academic toolchain.

### Typst Track

Typst is the recommended modern-first option for active writing because it is cleaner than LaTeX for many authoring tasks.

#### Suggested additions

- Treesitter support for `typst`
- LSP support via `tinymist`
- live preview with `typst-preview.nvim` or an equivalent preview workflow
- snippets for theorem blocks, equations, figures, tables, and common AI paper structures

#### Best use cases

- private research notes that need polished math
- drafts, memos, and internal writeups
- fast iteration on equations and layout

### LaTeX Track

LaTeX should still be supported because journals, conferences, and collaborators often expect it.

#### Suggested additions

- `lervag/vimtex`
- `texlab` LSP
- Treesitter support for `latex` and `bibtex`
- snippets for equations, aligned environments, theorem environments, citations, and paper scaffolding

#### Best use cases

- submission-ready papers
- collaborator compatibility
- citation-heavy documents and established templates

### Markdown Math Support

Markdown and Obsidian notes should remain part of the workflow, but math handling should be upgraded.

#### Suggested goals

- strong inline and block math authoring ergonomics
- reliable math rendering in the preview workflow
- snippets for common notation used in ML and AI research
- smooth movement between notes, drafts, and formal paper writing

### A+ Criteria

- writing math in Neovim feels natural rather than fragile
- there is a clear path from rough note -> structured draft -> submission document
- both Typst and LaTeX are supported appropriately
- equations, citations, and previews are easy to work with

---

## Recommended Plugin And Feature Additions

These are the most likely additions to reach the target state:

- `nvim-lint`
- `neotest`
- `auto-session` or `resession`
- `flash.nvim`
- `mini.ai`
- `mini.surround`
- `vimtex`
- `typst-preview.nvim`
- `texlab` and `tinymist` LSP setups

These should be introduced only after Phase 1 cleanup so the base remains coherent.

---

## Success Metrics

The config reaches the target state when:

- docs are trustworthy and current
- startup feels fast without feature regressions
- coding, debugging, linting, testing, and AI assistance form a coherent loop
- keymaps are easy to remember, browse, and trust
- research writing feels intentionally supported, not merely tolerated
- math-heavy work is first-class in both quick notes and formal drafts

---

## Implementation Order

1. Fix trust and cleanup issues.
2. Consolidate overlapping core tools.
3. Rebuild the keymap architecture and `which-key` UX.
4. Tighten lazy-loading and startup behavior.
5. Upgrade agentic coding workflows.
6. Upgrade research workflows.
7. Add first-class math authoring.
8. Re-audit and tune until all categories land at A+.

---

## Notes For Future Work

- Keep this plan updated as implementation lands.
- When a phase is completed, update the runtime docs immediately.
- Prefer small, verifiable steps over a large all-at-once rewrite.
