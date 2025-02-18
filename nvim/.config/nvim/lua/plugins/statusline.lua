return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-lua/lsp-status.nvim" },
  config = function()
    local lsp_status = require("lsp-status")
    local function get_active_lsp()
      local clients = vim.lsp.get_active_clients()
      if #clients == 0 then return "No LSP" end
      local lsp_names = {}
      for _, client in ipairs(clients) do
        table.insert(lsp_names, client.name)
      end
      return table.concat(lsp_names, " | ")
    end

    local function is_copilot_active()
      local clients = vim.lsp.get_active_clients()
      for _, client in ipairs(clients) do
        if client.name == "copilot" then return " Copilot" end
      end
      return ""
    end

    local function is_supermaven_active()
      if package.loaded["supermaven-nvim"] then return " Supermaven" end
      return ""
    end

    require("lualine").setup({
      options = {
        theme = "tokyonight",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
        ignore_focus = { "neo-tree", "toggleterm" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { get_active_lsp, icon = "  LSP" }, -- Shows main LSP
          { is_copilot_active }, -- Shows Copilot if active
          { is_supermaven_active }, -- Shows Supermaven if active
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
