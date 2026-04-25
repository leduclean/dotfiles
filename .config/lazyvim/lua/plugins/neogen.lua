return {
  "danymat/neogen",
  keys = {
    {
      "<leader>d",
      function()
        require("neogen").generate()
      end,
      desc = "Generate docblock",
    },
    {
      "<leader>cn",
      nil,
    },
  },
}
