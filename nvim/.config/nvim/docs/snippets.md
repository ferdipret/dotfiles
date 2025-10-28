# Neovim Snippets Reference

## How Snippets Work

Snippets are powered by **LuaSnip** and integrated with **blink.cmp**.

### Usage

1. Type the snippet trigger (prefix)
2. Snippet appears in completion menu
3. Press `<Tab>` to expand
4. Press `<Tab>` to jump to next placeholder
5. Press `<S-Tab>` to jump to previous placeholder

### Keybindings

- `<Tab>` - Expand snippet or jump forward
- `<S-Tab>` - Jump backward in snippet
- `<C-Space>` - Show completion menu (includes snippets)

---

## HEEx/Phoenix Snippets

### EEx Basics

- `ee` - EEx Output Tag
  ```heex
  <%= cursor %>
  ```

- `eex` - EEx Execute Tag (no output)
  ```heex
  <% cursor %>
  ```

- `eec` - EEx Comment (not rendered)
  ```heex
  <%!-- cursor --%>
  ```

---

### Control Flow

- `eif` - If Statement
  ```heex
  <%= if condition do %>
    body
  <% end %>
  ```

- `eife` - If-Else Statement
  ```heex
  <%= if condition do %>
    true_branch
  <% else %>
    false_branch
  <% end %>
  ```

- `efor` - For Loop
  ```heex
  <%= for item <- collection do %>
    body
  <% end %>
  ```

---

### Phoenix Components

#### Basic Components

- `comp` - Function Component (self-closing)
  ```heex
  <.component_name prop={value} />
  ```

- `link` - Phoenix Link
  ```heex
  <.link navigate={~p"/path"}>text</.link>
  ```

#### Forms & Inputs

- `form` - Phoenix Form
  ```heex
  <.form :let={f} for={@changeset} phx-submit="action">
    fields
    <.button>Save</.button>
  </.form>
  ```

- `input` - Input Field
  ```heex
  <.input field={f[:field_name]} type="text" label="Label" />
  ```

#### Buttons

- `btn` - Basic Button
  ```heex
  <.button>text</.button>
  ```

- `btnc` - Button with Click Event
  ```heex
  <.button phx-click="event_name">text</.button>
  ```

---

### LiveView Bindings

- `pc` - phx-click Binding
  ```heex
  phx-click="event_name"
  ```

- `ps` - phx-submit Binding
  ```heex
  phx-submit="event_name"
  ```

- `pch` - phx-change Binding
  ```heex
  phx-change="event_name"
  ```

---

### Utilities

- `at` - Access Template Assign
  ```heex
  @variable
  ```

- `slot` - Render Slot
  ```heex
  <%= render_slot(@slot_name) %>
  ```

---

## Adding Custom Snippets

Snippets are defined in `lua/snippets/heex.lua` using LuaSnip format.

### Example: Adding a New Snippet

```lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Add to the return table:
s("trigger", fmt([[
<.component>
  {}
</.component>]], { i(1) }))
```

### Placeholder Syntax

- `{}` - Placeholder position
- `i(1)` - First tab stop
- `i(2)` - Second tab stop
- `i(1, "default")` - Tab stop with default text

### Multi-line Snippets

Use `[[...]]` for multi-line strings:

```lua
s("trigger", fmt([[
line 1 with {}
line 2 with {}
line 3]], { i(1), i(2) }))
```

---

## Snippet Locations

- **HEEx/Phoenix**: `lua/snippets/heex.lua`
- **Future additions**: Create new files in `lua/snippets/`

All `.lua` files in `lua/snippets/` are automatically loaded by LuaSnip.

---

## Notes

- Snippets only appear for their specific filetypes
- HEEx snippets work in `.heex` files
- Press `<C-Space>` if snippets don't appear automatically
- Snippets integrate with LSP completions in the same menu
