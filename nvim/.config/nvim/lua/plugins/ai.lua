local function switch_provider(provider)
	return function()
		require("avante.api").switch_provider(provider)
	end
end

local function select_provider()
	local providers = {
		{ label = "OpenCode", value = "opencode" },
		{ label = "Claude Code", value = "claude-code" },
	}

	vim.ui.select(providers, {
		prompt = "Select Avante provider",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			require("avante.api").switch_provider(choice.value)
		end
	end)
end

return {
	{
		"ravitemer/mcphub.nvim",
		cmd = "MCPHub",
		keys = {
			{ "<leader>aM", "<cmd>MCPHub<cr>", desc = "Open MCP Hub" },
		},
		opts = {
			auto_approve = false,
			auto_toggle_mcp_servers = true,
			extensions = {
				avante = {
					enabled = true,
					make_slash_commands = true,
				},
			},
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		build = "make",
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Ask AI" },
			{ "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Chat With Codebase" },
			{ "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Edit Selection" },
			{ "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Focus AI Panel" },
			{ "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "Chat History" },
			{ "<leader>am", "<cmd>AvanteModels<cr>", desc = "Select Model" },
			{ "<leader>ao", switch_provider("opencode"), desc = "Use OpenCode" },
			{ "<leader>aC", switch_provider("claude-code"), desc = "Use Claude Code" },
			{ "<leader>ap", select_provider, desc = "Choose Provider" },
			{ "<leader>aR", "<cmd>AvanteShowRepoMap<cr>", desc = "Show Repo Map" },
			{ "<leader>as", "<cmd>AvanteStop<cr>", desc = "Stop AI Request" },
			{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Toggle AI Panel" },
		},
		opts = function()
			return {
				provider = "opencode",
				mode = "agentic",
				auto_suggestions_provider = nil,
				input = {
					provider = "snacks",
					provider_opts = {
						title = "Avante Input",
						icon = "󱙺",
					},
				},
				behaviour = {
					auto_suggestions = false,
					auto_set_highlight_group = true,
					auto_set_keymaps = false,
					auto_apply_diff_after_generation = false,
					support_paste_from_clipboard = true,
					minimize_diff = true,
					enable_token_counting = true,
					auto_add_current_file = true,
					auto_approve_tool_permissions = false,
					confirmation_ui_style = "inline_buttons",
					acp_follow_agent_locations = true,
				},
				acp_providers = {
					["opencode"] = {
						command = "opencode",
						args = { "acp" },
					},
					["claude-code"] = {
						command = "npx",
						args = { "-y", "-g", "@zed-industries/claude-code-acp" },
						env = {
							NODE_NO_WARNINGS = "1",
							ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
							ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
							ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
						},
					},
				},
				system_prompt = function()
					local prompt = {
						"You are operating inside Avante in agentic ACP mode.",
						"Prefer using available tools instead of guessing.",
						"When MCP servers are available, use the smallest sufficient tool for the task.",
						"Be explicit about risky operations and keep edits minimal.",
					}

					local ok, mcphub = pcall(require, "mcphub")
					if ok then
						local hub = mcphub.get_hub_instance()
						if hub then
							local active = hub:get_active_servers_prompt()
							if active ~= "" then
								table.insert(prompt, "")
								table.insert(prompt, active)
							end
						end
					end

					return table.concat(prompt, "\n")
				end,
				custom_tools = function()
					local ok, ext = pcall(require, "mcphub.extensions.avante")
					if ok then
						return { ext.mcp_tool() }
					end
					return {}
				end,
			}
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
			"ravitemer/mcphub.nvim",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
