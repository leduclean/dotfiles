return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    file_types = { "markdown", "anki" },
    latex = { enabled = true },
    completions = { lsp = { enabled = true } },
  },
}
