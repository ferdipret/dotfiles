return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",  -- Accept suggestion (like VS Code)
          clear_suggestion = "<C-]>",   -- Clear inline suggestion
          accept_word = "<C-j>",        -- Accept one word at a time
        },
        disable_inline_completion = false,  -- Keep inline completion
        disable_keymaps = false,            -- Keep Supermaven's default keymaps
      })
    end,
  },
}
