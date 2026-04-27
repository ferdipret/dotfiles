# Historical Optimization Notes

This file is a historical audit and idea dump, not the source of truth for the current runtime config.

Use these files for the live state instead:

- `docs/index.md`
- `docs/improvement-plan.md`
- `docs/keymaps.md`
- `docs/plugins.md`

## Table of Contents

- [Startup Time Optimizations](#startup-time-optimizations)
- [Plugin Replacements & Consolidations](#plugin-replacements--consolidations)
- [Modern Alternatives](#modern-alternatives)
- [Configuration Improvements](#configuration-improvements)
- [Quick Wins](#quick-wins)

---

## Startup Time Optimizations

### Critical Issues

#### 1. Snacks.nvim Eager Loading

**Current**: `lazy = false, priority = 1000` - Loads immediately on startup

**Issue**: Snacks is a large plugin with many features. Loading it upfront adds ~50-100ms to startup.

**Fix**:

```lua
-- Option A: Lazy load on first keymap
{
  "folke/snacks.nvim",
  lazy = true,  -- Change this
  keys = { ... }, -- Already defined
}

-- Option B: Load on VeryLazy event
{
  "folke/snacks.nvim",
  event = "VeryLazy",
}
```

**Impact**: Expected **50-100ms** improvement

---

#### 2. LSP Auto-Installation on Startup

**Current**: `mason-lspconfig` has `automatic_installation = true`

**Issue**: Mason checks for missing servers on every startup.

**Fix**:

```lua
-- In lua/plugins/lsp.lua
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "vtsls", "eslint" },
  automatic_installation = false,  -- Disable this
})
```

**Impact**: **20-50ms** improvement, especially on slow networks

---

#### 3. Treesitter Ensure Installed

**Current**: Only `lua` in ensure_installed, but `auto_install = true`

**Issue**: Auto-install downloads parsers synchronously when opening new filetypes.

**Recommendation**: Pre-install parsers you commonly use:

```lua
ensure_installed = {
  "lua", "javascript", "typescript", "tsx", "html", "css",
  "json", "markdown", "elixir", "heex", "graphql"
},
auto_install = false,  -- Disable on-demand installation
```

**Impact**: Prevents **100-500ms** freezes when opening new filetypes

---

#### 4. Completion Source Overhead

**Current**: 7 completion sources active simultaneously

**Issue**: nvim-cmp queries all sources on every keystroke in insert mode.

**Fix**: Prioritize and limit sources:

```lua
sources = cmp.config.sources({
  { name = "nvim_lsp", priority = 1000 },
  { name = "luasnip", priority = 750 },
}, {
  { name = "buffer", keyword_length = 3, max_item_count = 5 },
  { name = "path", keyword_length = 3 },
  { name = "render-markdown", keyword_length = 3 },
  { name = "calc" },
})
```

**Impact**: **Noticeable** typing smoothness improvement

---

#### 5. Format on Save Timeout

**Current**: `timeout_ms = 500` with `async = false`

**Issue**: Blocks save operations for up to 500ms.

**Fix**:

```lua
format_on_save = function(bufnr)
  return {
    timeout_ms = 200,  -- Reduce timeout
    lsp_fallback = true,
    async = false,
  }
end
```

Or use async formatting:

```lua
format_on_save = nil,  -- Disable
format_after_save = {
  lsp_fallback = true,
  async = true,  -- Non-blocking
}
```

**Impact**: Faster save operations, better perceived performance

---

### Medium Priority

#### 6. Telescope FZF Native

**Current**: Uses compiled fzf-native sorter

**Already optimal**, but ensure it's compiled:

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make
```

#### 7. Avante.nvim Heavy Dependencies

**Current**: Loads on `VeryLazy` event

**Good**, but has 9 dependencies. Consider lazy-loading dependencies:

```lua
{
  "yetone/avante.nvim",
  cmd = { "AvanteAsk", "AvanteToggle" },  -- Load only on command
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
  },
}
```

---

## Plugin Replacements & Consolidations

### 1. **Remove Telescope** (Already Have Snacks Picker)

**Current**: Both `telescope.nvim` and `snacks.picker` serve the same purpose.

**Recommendation**: **Remove Telescope** and use Snacks picker exclusively.

**Why**:

- Snacks picker is faster (built on fzf-lua backend)
- You're already using Snacks for all LSP navigation
- Telescope is only loaded as dependency for Avante

**Action**:

```lua
-- Remove lua/plugins/telescope.lua entirely

-- In lua/plugins/ai.lua (Avante dependencies):
dependencies = {
  -- Remove: "nvim-telescope/telescope.nvim",
  "ibhagwan/fzf-lua",  -- Keep this, it's the backend
}
```

**Impact**: **-20MB** from plugin size, **-30ms** from startup

---

### 2. **Consolidate Git Plugins**

**Current**: `gitsigns`, `neogit`, `diffview`, plus Snacks git features

**Recommendation**: Use **Snacks for most git operations**, keep only `gitsigns` for buffer decorations.

**Why**:

- Snacks provides: git_status, git_log, git_branches, git_diff, gitbrowse, lazygit
- `neogit` and `diffview` overlap significantly
- Less plugin bloat

**Action**:

```lua
-- Keep: gitsigns.nvim (for buffer decorations)
-- Remove: neogit, diffview.nvim

-- In lua/plugins/git.lua:
return {
  {
    "lewis6991/gitsigns.nvim",
    -- ... keep existing config
  },
  -- Delete neogit and diffview specs
}
```

**Alternative**: If you prefer Neogit's interface, keep it and remove Snacks git keybindings.

**Impact**: **-15MB**, **-20ms** startup

---

### 3. **Combine Completion Plugins**

**Current**: Both `nvim-cmp` and potential future `blink.cmp` references

**Recommendation**: Stick with `nvim-cmp` (already configured well), or fully migrate to `blink.cmp`.

**Why**:

- `blink.cmp` is faster (Rust-based) but newer/less mature
- You're already using nvim-cmp with good configuration
- Don't load both

**No action needed** - just a future consideration if you explore blink.cmp.

---

### 4. **Remove Unused Plugins**

**Current**: Some plugins may not be actively used:

- `colorful-menu.nvim` - Nice-to-have, not essential
- `nvim-treesitter/playground` - Debugging tool, rarely used
- `lsp-status.nvim` - Listed in lazy-lock but not used in statusline config

**Action**: Review and remove if unused:

```bash
# Check if lsp-status is actually used:
grep -r "lsp-status" ~/.config/nvim/lua/

# If not used, remove from dependencies in statusline.lua
```

**Impact**: **-5-10ms** per removed plugin

---

## Modern Alternatives

### 1. **Replace nvim-cmp with blink.cmp**

**Why**:

- **30-50% faster** completion performance (Rust-based)
- Built-in fuzzy matching (no need for separate plugin)
- Modern, actively developed
- Better async handling

**Migration**:

```lua
-- Replace lua/plugins/completions.lua with:
{
  "saghen/blink.cmp",
  version = "v0.*",
  build = "cargo build --release",
  dependencies = { "L3MON4D3/LuaSnip" },
  opts = {
    keymap = {
      preset = "super-tab",  -- Similar to your current Tab behavior
    },
    sources = {
      default = { "lsp", "path", "luasnip", "buffer" },
    },
    snippets = {
      preset = "luasnip",
    },
    appearance = {
      use_nvim_cmp_as_default = true,  -- Migrate nvim-cmp highlights
      nerd_font_variant = "mono",
    },
  },
}
```

**Impact**: **Better typing performance**, especially in large files

---

### 2. **Replace mini.pairs with nvim-autopairs**

**Current**: `mini.pairs` for auto-pairing

**Alternative**: `nvim-autopairs` has more features (Treesitter integration, fast wrap, etc.)

**Status**: Your current setup is fine. `mini.pairs` is lighter and faster for basic pairing.

**Recommendation**: **Keep mini.pairs** unless you need advanced features.

---

### 3. **Consider mini.nvim Modules Instead of Standalone Plugins**

**Current**: You use `mini.pairs` and `mini.surround`

**Other mini.nvim modules to explore**:

- `mini.ai` - Enhanced text objects (better than targets.vim)
- `mini.comment` - Commenting (replace Comment.nvim if you add it)
- `mini.bufremove` - Smart buffer deletion (can replace Snacks.bufdelete)

**Why**: Single plugin, consistent API, very fast

---

### 4. **Replace Conform with Built-in LSP Formatting**

**Current**: `conform.nvim` with formatters + LSP fallback

**Alternative**: Use only LSP formatting with null-ls or none-ls

**Recommendation**: **Keep conform** - it's better for:

- Multiple formatters per filetype
- Non-LSP formatters (prettier, stylua)
- Better error handling

---

### 5. **Upgrade vtsls to ts_ls**

**Current**: Using `vtsls` for TypeScript

**Note**: `vtsls` is already the modern replacement for `tsserver`. You're good here.

---

## Configuration Improvements

### 1. **Add LSP on_attach Keymaps**

**Current**: Only `<leader>ca` defined globally

**Missing**: Standard LSP keymaps (hover, rename, etc.)

**Add to `lua/plugins/lsp.lua`**:

```lua
local function make_on_attach(custom_on_attach)
  return function(client, bufnr)
    -- Navic integration
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end

    -- LSP Keymaps
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)

    if custom_on_attach then
      custom_on_attach(client, bufnr)
    end
  end
end
```

---

### 2. **Optimize Snacks Dashboard Loading**

**Current**: Dashboard enabled but loads on startup

**Recommendation**: Only show dashboard when opening nvim with no file:

```lua
dashboard = {
  enabled = true,
  sections = { ... },
  -- Add autocommand to only show when appropriate
}
```

Or in your autocmds:

```lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("snacks").dashboard()
    end
  end,
})
```

---

### 3. **Add Caching for LuaSnip**

**Current**: Loads snippets from Lua files on every start

**Optimization**:

```lua
require("luasnip.loaders.from_lua").lazy_load({
  paths = "~/.config/nvim/lua/snippets"
})
```

Change `load()` to `lazy_load()` for on-demand snippet loading.

---

### 4. **Defer Non-Essential UI Plugins**

**Current**: Some UI plugins load on VeryLazy

**Recommendation**: Defer even more:

```lua
{
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",  -- Only load when LSP attaches
}

{
  "SmiteshP/nvim-navic",
  event = "LspAttach",  -- Only load when LSP attaches
}
```

---

### 5. **Optimize Avante Timeout for Non-Reasoning Models**

**Current**: 90 second timeout for all requests

**Recommendation**: Only use high timeout for reasoning models:

```lua
openai = {
  timeout = function()
    -- If using o3-mini with reasoning, use high timeout
    if vim.g.avante_reasoning_mode then
      return 90000
    end
    return 30000  -- Normal timeout for regular models
  end,
}
```

Or just reduce to 30s if you don't use reasoning features often.

---

## Quick Wins

### Immediate Actions (5 minutes)

1. **Lazy load Snacks**:

   ```lua
   -- lua/plugins/snacks/init.lua
   event = "VeryLazy",  -- Add this
   -- lazy = false,  -- Remove this
   ```

2. **Disable auto-installation**:

   ```lua
   -- lua/plugins/lsp.lua (mason-lspconfig)
   automatic_installation = false,
   ```

3. **Pre-install Treesitter parsers**:

   ```vim
   :TSInstall javascript typescript tsx html css json markdown elixir heex
   ```

4. **Reduce format timeout**:
   ```lua
   -- lua/plugins/formatter.lua
   timeout_ms = 200,  -- Change from 500
   ```

**Expected improvement**: **100-200ms** faster startup

---

### Medium Effort (30 minutes)

1. **Remove Telescope** and use only Snacks picker
2. **Remove neogit/diffview** and use Snacks git features
3. **Add LSP keymaps** to on_attach function
4. **Lazy load LuaSnip** snippets

**Expected improvement**: **150-250ms** faster startup, **-35MB** plugin size

---

### Future Considerations

1. **Migrate to blink.cmp** (when you have time to test thoroughly)
2. **Explore mini.nvim** modules for additional consolidation
3. **Profile startup time** with:
   ```bash
   nvim --startuptime startup.log
   ```
4. **Use lazy.nvim profiler**:
   ```vim
   :Lazy profile
   ```

---

## Plugin Dependency Graph

### Critical Path (Must Load First)

```
lazy.nvim (bootstrap)
└── Settings/Keymaps
    └── Snacks (if eager loaded)
        └── LSP Servers (mason, lspconfig)
            └── Completion (nvim-cmp)
                └── UI Plugins (lualine, barbar, etc.)
```

### Parallel Loading (VeryLazy)

```
- Treesitter
- Formatters (conform)
- Git plugins (gitsigns, neogit, diffview)
- AI plugins (avante)
- Utilities (which-key, trouble, dressing)
```

---

## Recommended Final Plugin List

### Essential (20 plugins)

- lazy.nvim
- tokyonight.nvim
- nvim-lspconfig + mason + mason-lspconfig
- nvim-cmp (or blink.cmp) + LuaSnip + cmp-nvim-lsp
- conform.nvim
- snacks.nvim
- nvim-treesitter + nvim-ts-autotag
- neo-tree.nvim
- lualine.nvim + bufferline.nvim + nvim-navic
- gitsigns.nvim
- which-key.nvim
- trouble.nvim
- mini.pairs
- mini.surround
- lspkind.nvim

### Optional (Remove if not used)

- telescope.nvim (use Snacks instead)
- neogit + diffview (use Snacks instead)
- avante.nvim (if not using AI chat)
- obsidian.nvim (if not using Obsidian)
- colorful-menu.nvim (nice-to-have)
- playground (dev tool)
- fzf-lua (only if using as standalone, Snacks uses it internally)

---

## Benchmarking

### Current Estimated Startup Time

- **Lazy.nvim bootstrap**: ~10ms
- **Snacks eager load**: ~80ms
- **Mason/LSP check**: ~30ms
- **Treesitter**: ~20ms
- **UI plugins**: ~40ms
- **Other plugins**: ~50ms
- **Total**: **~230ms**

### After Optimizations

- **Lazy.nvim bootstrap**: ~10ms
- **Snacks lazy load**: ~0ms (deferred)
- **Mason/LSP**: ~0ms (no auto-check)
- **Treesitter**: ~15ms (pre-installed)
- **UI plugins**: ~30ms (deferred loading)
- **Other plugins**: ~20ms (better lazy loading)
- **Total**: **~75ms**

**Expected improvement**: **~66% faster startup** (230ms → 75ms)

---

## Testing Your Changes

### Step 1: Backup Current Config

```bash
cp -r ~/.config/nvim ~/.config/nvim.backup
```

### Step 2: Apply Changes Incrementally

Start with Quick Wins, test after each change.

### Step 3: Profile Startup

```bash
nvim --startuptime startup.log
# Review startup.log to find bottlenecks
```

### Step 4: Check Lazy.nvim Profile

```vim
:Lazy profile
```

Look for plugins with:

- High load times (>10ms)
- Unnecessary eager loading (loaded = true on startup)

---

## Conclusion

### Priority Order

1. ✅ **Quick Wins** (5 min) - 100-200ms improvement
2. ✅ **Remove duplicate plugins** (30 min) - 150-250ms improvement
3. ⏳ **Migrate to modern alternatives** (1-2 hours) - Better performance
4. ⏳ **Fine-tune configuration** (ongoing) - Incremental improvements

### Expected Results

- **Startup time**: 230ms → 75ms (**66% faster**)
- **Plugin count**: 41 → ~25 (**39% reduction**)
- **Config size**: Cleaner, more maintainable
- **Performance**: Smoother typing, faster saves, better responsiveness
