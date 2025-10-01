" ---------- gestionnaire de plugins (vim-plug) ----------
call plug#begin('~/.config/nvim/plugged')

" essentials
Plug 'wbthomason/packer.nvim' " optionnel si tu veux packer (garde si tu utilises packer)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP & installer de serveurs
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Rust helpers
Plug 'simrat39/rust-tools.nvim'

" Completion + sources
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Optional : diagnostics UI
Plug 'folke/trouble.nvim'

" Coloration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'navarasu/onedark.nvim'

call plug#end()

" ---------- Options utiles ----------
set relativenumber
set number
set noswapfile
set nobackup
set undofile
set updatetime=300             " plus réactif pour diagnostics & lsp
set signcolumn=yes

" ---------- Lua config pour nvim-cmp, mason, lsp, rust-tools ----------
lua << EOF
-- safe requires
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then return end
local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then return end
local lspconfig
if vim and vim.lsp and vim.lsp.config then
  lspconfig = vim.lsp.config
else
  local ok, mod = pcall(require, "lspconfig")
  if not ok then return end
  lspconfig = mod
end
local rt_ok, rust_tools = pcall(require, "rust-tools")
local cmp_ok, cmp = pcall(require, "cmp")
local luasnip_ok, luasnip = pcall(require, "luasnip")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

-- mason setup (install / manage LSP binaries)
mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "rust_analyzer" }, -- mason name ; installe rust-analyzer
  automatic_installation = true,
})

-- nvim-cmp setup
if cmp_ok then
  cmp.setup({
    snippet = {
      expand = function(args)
        if luasnip_ok then luasnip.lsp_expand(args.body) end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    }),
  })
end

-- capability for LSP from cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- common on_attach pour mappings LSP
local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs, desc)
    if desc then desc = "LSP: "..desc end
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true })
  end
  -- mappings (normal mode)
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition')
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation')
  buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
  buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code action')
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'References')
  buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>', 'Format')
end

-- setup rust-tools (si installé)
if rt_ok then
  rust_tools.setup({
    server = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy", -- "clippy" donne lint + warnings
          },
        }
      }
    },
    tools = {
      autoSetHints = false,
      hover_actions = { auto_focus = true },
      runnables = { use_telescope = true },
    },
  })
else
  -- fallback: configure rust_analyzer via lspconfig si rust-tools non installé
  if lspconfig.rust_analyzer then
    lspconfig.rust_analyzer.setup{
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

-- Diagnostics: config globale
vim.diagnostic.config({
  virtual_text = {
    prefix = '',             -- petit marqueur devant le texte
    spacing = 0,              -- espace entre le texte du code et le virtual text
    severity = { min = vim.diagnostic.severity.HINT }, -- afficher tout
  },
  signs = true,               -- afficher dans la signcolumn
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError",   { fg = "#ff6b6b", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",    { fg = "#ffcc66", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",    { fg = "#81a1c1", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",    { fg = "#b48ead", bg = "NONE" })

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust"},
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true }
}


EOF



lua << EOF
vim.cmd[[colorscheme onedark]]
EOF
" ---------- Quelques mappings utiles en Vim (hors lua) ----------
" ouvrir la fenêtre des diagnostics
nnoremap <leader>e :lua vim.diagnostic.open_float()<CR>
" naviguer entre les diagnostics
nnoremap [d :lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d :lua vim.diagnostic.goto_next()<CR>

" ---------- Instructions d'installation rapides ----------
" Après avoir collé ce fichier :
" 1) Installer vim-plug si pas encore fait :
"    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" 2) Installer les plugins :
"    nvim +'PlugInstall --sync' +qa
"
" 3) Ouvrir nvim et lancer : :Mason
"    Dans la UI Mason, installer 'rust-analyzer' (ou faire :MasonInstall rust-analyzer)
"
" 4) Installer côté toolchain Rust (local) :
"    rustup component add rustfmt clippy
"
" 5) Facultatif : installer cargo-mods / autres outils selon tes besoins
"
" Maintenant ouvre un projet Rust (avec Cargo.toml) — rust-analyzer sera activé,
" tu auras diagnostics (erreurs/warnings) et autocomplétion de style VS Code.
