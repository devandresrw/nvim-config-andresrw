-- Inicializar Packer si no está instalado
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Cargar Packer
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'         -- Plugin manager
  use 'nvim-lua/plenary.nvim'          -- Dependencia para algunos plugins

  -- Explorador de archivos
  use 'preservim/nerdtree'             -- NERDTree para navegación de archivos

  -- Git integration
  use 'tpope/vim-fugitive'             -- Git commands en nvim

  -- Autocompletion
  use {'neoclide/coc.nvim', branch = 'release'}  -- Autocompletado avanzado

  -- Syntax Highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- Resaltado de sintaxis

  -- Status line
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- Tema
  use 'navarasu/onedark.nvim'            -- Tema Onedark

  -- Comentarios rápidos
  use 'tpope/vim-commentary'

  -- GitHub Copilot
  use {
    'github/copilot.vim',
    config = function()
      -- Desactivar el mapeo por defecto de la tecla Tab para Copilot
      vim.g.copilot_no_tab_map = true

      -- Mapea una tecla para aceptar sugerencias en el modo de inserción
      vim.api.nvim_set_keymap('i', '<C-Space>', 'copilot#Accept("<CR>")', { noremap = true, silent = true, expr = true })

      -- Mapea Ctrl + g para abrir y cerrar el panel de Copilot
      vim.api.nvim_set_keymap('n', '<C-g>', ':Copilot panel<CR>', { noremap = true, silent = true })
    
      -- Mapea Ctrl + y para abrir el chat de Copilot
      vim.api.nvim_set_keymap('n', '<C-y>', ':Copilot chat<CR>', { noremap = true, silent = true })
    end
  }

  -- Delimitadores de bloques de código y visualización de indentación
  use 'windwp/nvim-autopairs'            -- Auto-cierre de llaves, paréntesis, etc.
  -- use 'p00f/nvim-ts-rainbow'             -- Resalta pares de paréntesis y corchetes (deshabilitado temporalmente)
  use {'lukas-reineke/indent-blankline.nvim', tag = 'v2.20.8'}  -- Mostrar líneas de indentación

  -- Snippets para React, Next.js, y Nest.js
  use 'rafamadriz/friendly-snippets'   -- Colección de snippets para diferentes lenguajes
  use 'L3MON4D3/LuaSnip'               -- Snippet engine

  -- Instalar automáticamente Packer si no está instalado
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Opciones básicas
vim.opt.number = true                   -- Mostrar números de línea
vim.opt.relativenumber = true           -- Números relativos
vim.opt.expandtab = true                -- Usar espacios en lugar de tabs
vim.opt.shiftwidth = 2                  -- Espacios por indentación
vim.opt.tabstop = 2                     -- Tamaño de tabulaciones
vim.opt.cursorline = true               -- Resaltar línea actual

-- Configurar tema
vim.cmd('colorscheme onedark')

-- Configuración de Coc.nvim (Autocompletado)
vim.cmd([[
  " Use <Tab> and <S-Tab> to navegar por el popup menu
  inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  " Usar Enter para confirmar selección en el popup de autocompletado
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

  " Instalar extensiones predeterminadas de Coc
  let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css', 'coc-html', 'coc-tailwindcss', 'coc-eslint', 'coc-prettier']
]])

-- Ejecutar ESLint y Prettier al guardar
vim.cmd([[
  " Usa ESLint para arreglar errores cuando guardas el archivo
  autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx EslintFixAll

  " Usa Prettier para formatear el archivo
  autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx CocCommand prettier.formatFile
]])

-- Configuración de Treesitter (Resaltado de sintaxis)
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "typescript", "tsx", "html", "css", "json"}, -- lenguajes que usas
  highlight = {
    enable = true,  -- habilitar resaltado
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,  -- Soporte de indentación
  },
  -- rainbow = {
  --   enable = true,  -- Resaltado de pares (deshabilitado temporalmente)
  --   extended_mode = true,
  -- }
}

-- Configuración de autopairs
require('nvim-autopairs').setup{}

-- Configuración de indent-blankline
require("indent_blankline").setup {
  char = '│',            -- Caracter de indentación
  show_current_context = true,                   -- Mostrar el bloque de código actual
  show_current_context_start = true,                -- Subraya el inicio del bloque de código
}

-- Snippets para React, Next.js, y Nest.js
require("luasnip.loaders.from_vscode").lazy_load()

-- Comando para abrir y cerrar NERDTree
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
