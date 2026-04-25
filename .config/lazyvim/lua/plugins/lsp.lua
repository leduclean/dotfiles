return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ada_language_server = {},
      clangd = {
        keys = {
          { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        init_options = {
          clangdFileStatus = true,
          completion = {
            detailedLabel = true,
            generateDoxygenComment = true,
          },
        },
      },
      rust_analyzer = {
        root_markers = { "cwd" },
      },
    },
  },
}
