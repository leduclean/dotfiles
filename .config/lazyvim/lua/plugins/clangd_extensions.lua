return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" }, -- lazy-load
    opts = {
      ast = {
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "none",
      },
      symbol_info = {
        border = "none",
      },
    },
  },
}
