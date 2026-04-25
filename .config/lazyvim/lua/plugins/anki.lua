-- ~/.config/nvim/lua/plugins/anki.lua
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false, -- chargé au démarrage pour éviter les problèmes de dépendances
  },
  {
    "rareitems/anki.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "L3MON4D3/LuaSnip" },
    lazy = false,
    opts = {
      tex_support = true,
    },

    config = function(_, opts)
      local ok, anki_mod = pcall(require, "anki")
      if not ok then
        vim.notify("Impossible to get the anki api", vim.log.levels.ERROR)
        return
      end

      anki_mod.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          local ls = require("luasnip")
          local s = ls.snippet
          local sn = ls.snippet_node
          local t = ls.text_node
          local i = ls.insert_node
          local d = ls.dynamic_node

          local function cloze_fixed(_, _, _, _)
            return sn(nil, {
              t("{{c1::"),
              i(1, "Cloze text"),
              t("}}"),
              i(0),
            })
          end

          local snippets = {
            Bold = s("b", { t("<b>"), i(1, "Bold Text"), t("</b>"), i(0) }),
            Italic = s("i", { t("<i>"), i(1, "Italic Text"), t("</i>"), i(0) }),
            Underline = s("u", { t("<u>"), i(1, "Underline Text"), t("</u>"), i(0) }),
            Cloze = s("c1", d(1, cloze_fixed, {})),
          }

          for _, snip in pairs(snippets) do
            ls.add_snippets("tex", { snip })
          end

          local opts = { buffer = true }

          vim.keymap.set("i", "<leader>b", function()
            ls.snip_expand(snippets.Bold)
          end, opts)

          vim.keymap.set("i", "<C-i>", function()
            ls.snip_expand(snippets.Italic)
          end, opts)

          vim.keymap.set("i", "<C-u>", function()
            ls.snip_expand(snippets.Underline)
          end, opts)

          vim.keymap.set("i", "<C-c>", function()
            ls.snip_expand(snippets.Cloze)
          end, opts)
        end,
      })
      local function open_tmp_anki_buffer()
        local ext = ".anki"
        local tmp = vim.fn.tempname() .. ext

        vim.cmd("edit " .. vim.fn.fnameescape(tmp))

        if opts.tex_support then
          vim.bo.filetype = "tex"
        else
          vim.bo.filetype = "anki"
        end
      end

      local has_telescope = pcall(require, "telescope")
      if has_telescope then
        local api = require("anki.api")

        local function picker_dynamic(title, fetch_items, on_select)
          local ok, items = pcall(fetch_items)
          if not ok then
            vim.notify("Immpossible to get the items " .. tostring(items), vim.log.levels.ERROR)
            return
          end

          require("telescope.pickers")
            .new({}, {
              prompt_title = title,
              finder = require("telescope.finders").new_table({ results = items }),
              sorter = require("telescope.config").values.generic_sorter({}),
              attach_mappings = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                actions.select_default:replace(function()
                  local sel = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  on_select(sel[1])
                end)
                return true
              end,
            })
            :find()
        end

        local function add_anki_card_via_telescope()
          local okd, decks = pcall(api.deckNames)
          if not okd then
            vim.notify("API can't reach decks" .. tostring(decks), vim.log.levels.ERROR)
            return
          end

          picker_dynamic("Select Deck", api.deckNames, function(deck)
            picker_dynamic("Select Note Type", api.modelNames, function(model)
              open_tmp_anki_buffer()
              vim.schedule(function()
                anki_mod.ankiWithDeck(deck, model)
              end)
            end)
          end)
        end

        vim.keymap.set("n", "<leader>ac", function()
          add_anki_card_via_telescope()
        end, { desc = "Add Anki card via Telescope" })
      else
        vim.notify("Telescope non installé — picker Anki désactivé", vim.log.levels.INFO)
      end

      vim.keymap.set("n", "<leader>an", function()
        open_tmp_anki_buffer()
      end, { desc = "Open temporary .anki buffer" })
      vim.keymap.set("n", "<C-CR>", function()
        vim.cmd("write")
        anki_mod.send(nil)
      end)
    end,
  },
}
