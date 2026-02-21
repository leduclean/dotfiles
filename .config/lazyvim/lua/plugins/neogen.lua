vim.keymap.set("n", "<leader>d", function()
  require("neogen").generate()
end, { noremap = true, silent = true, desc = "Generate docblock with Neogen" })
