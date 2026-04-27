# Configuration Improvement Plan

[<- Back to Index](index.md)

This roadmap tracks the remaining work to turn the config into an A+ setup for:

- everyday software engineering
- agentic coding and repo exploration
- academic AI research
- math-heavy drafting and note-taking

---

## Current Baseline

Already completed:

- docs and runtime behavior were reconciled
- `maplocalleader` was standardized to `m`
- Supermaven was removed
- keymaps were reorganized around clearer namespaces
- `which-key` was upgraded with icons and better labels
- localleader workflows were added for notes, Typst, and LaTeX
- Avante was given first-class AI shortcuts
- Typst, LaTeX, test, and lint foundations were added

This means the next roadmap should focus less on cleanup and more on finishing the experience.

---

## Target Outcome

The target state is:

- **Architecture**: A+
- **Docs and config trustworthiness**: A+
- **Keymap discoverability and mnemonics**: A+
- **Agentic coding support**: A+
- **Research and note-taking**: A+
- **Math authoring**: A+
- **Performance and lazy-loading**: A+
- **Portability**: A

---

## Guiding Principles

1. Runtime config and docs must stay aligned.
2. One clear workflow per surface beats overlapping tools.
3. Global leader is for cross-project actions; local leader is for filetype workflows.
4. Research buffers and coding buffers can have different defaults.
5. External toolchains must be documented as clearly as plugin setup.
6. New features should be added in small, verifiable slices.

---

## Phase 1: Finish External Toolchains

Priority: highest

### Goals

- make the configured research and math workflows fully usable on the machine
- eliminate the remaining gap between configured support and installed binaries

### Work Items

- install a working LaTeX toolchain with `latexmk`
- install a PDF viewer for `vimtex` such as `zathura` or `okular`
- ensure `typst` is installed through `mise`
- make sure Mason has `texlab` and `tinymist` installed
- document the exact install commands for the local platform

### Success Criteria

- `:VimtexCompile` works without `latexmk is not executable`
- `:VimtexView` opens the generated PDF
- Typst preview and Typst LSP work in a fresh session

---

## Phase 2: Research Writing Ergonomics

Priority: high

### Goals

- make markdown, Typst, and LaTeX buffers feel intentional for long-form writing
- reduce friction when reading papers, drafting notes, and editing equations

### Work Items

- add filetype-local writing defaults for markdown and note buffers
- tune conceal, wrap, spell, and text width behavior by filetype
- add a dedicated research or writing mode for prose-heavy buffers
- improve note templates for papers, literature reviews, experiment logs, and reading notes
- consider bibliography and citation helpers if paper-writing becomes frequent

### Success Criteria

- markdown, Typst, and LaTeX all feel comfortable for sustained writing
- research notes and draft documents share clear, consistent workflows

---

## Phase 3: Agentic Coding Depth

Priority: high

### Goals

- improve the loop of ask -> search -> edit -> lint -> test -> debug -> review
- make the AI and quality tooling feel like one coherent system

### Work Items

- add richer Avante workflows for edit, review, explain, and fix flows
- refine the `<leader>a*` namespace and which-key descriptions
- add session or workspace persistence with `auto-session` or `resession`
- deepen DAP support with real language-specific launch configs and keymaps
- consider adding `flash.nvim` and `mini.ai`

### Success Criteria

- AI shortcuts are memorable and useful in day-to-day work
- debugging and session restore feel integrated
- large-repo navigation and assisted refactoring feel fast

---

## Phase 4: Workflow Consolidation

Priority: medium

### Goals

- reduce overlap between tools that solve the same problem
- make ownership of each workflow obvious

### Work Items

- decide whether `nvim-cmp` remains the long-term completion engine or whether to migrate fully to `blink.cmp`
- keep Snacks as the primary picker surface and reduce Telescope to dependency-only use where possible
- decide whether ToggleTerm or Snacks terminal is the long-term terminal UX
- decide whether Trouble remains a separate diagnostics surface or whether Snacks covers enough
- remove any now-stale plugin references and dependencies after those decisions are made

### Success Criteria

- one obvious picker workflow
- one obvious completion workflow
- one obvious terminal and diagnostics workflow

---

## Phase 5: Performance And Startup Discipline

Priority: medium

### Goals

- keep the richer workflow set responsive
- ensure expensive features are deferred until they are useful

### Work Items

- profile startup again now that more workflows are installed
- revisit eager loading for Snacks, VimTeX, Treesitter, and completion
- move any remaining eager secondary features to `ft`, `cmd`, or `keys` loading where safe
- tighten parser and LSP install strategy if startup cost grows

### Success Criteria

- startup remains fast and predictable
- no high-cost plugin loads earlier than it needs to

---

## Phase 6: Final Re-Audit

Priority: medium

### Goals

- do one final pass for coherence, trust, and polish
- close the gap between "good personal config" and "A+ system"

### Work Items

- re-audit keymaps, docs, and plugin overlap
- verify coding, research, and math workflows end-to-end
- update docs where implementation has shifted
- capture any last cleanup tasks discovered during daily use

### Success Criteria

- docs stay authoritative
- keymaps are easy to remember and browse
- coding, research, and math workflows all feel first-class

---

## Success Metrics

The config reaches the target state when:

- docs are trustworthy and current
- keymaps are mnemonic and discoverable
- coding, debugging, linting, testing, and AI assistance form a coherent loop
- research writing feels intentionally supported, not merely tolerated
- math-heavy work is first-class in both rough notes and formal drafts
- the external toolchain is documented clearly enough that setup is repeatable

---

## Notes For Future Work

- update this plan as each phase lands
- keep commits small and verifiable
- update runtime docs in the same change as behavior changes
- document reusable project-level Avante rules and skill-like workflows once the ACP/MCP stack settles
