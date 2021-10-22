" ================ General Config ====================

" set number                      "Line numbers are good
"set relativenumber
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
"set mouse-a

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","

" =============== Plugins =================
"https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/plugins.lua
call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'

"Plug 'sheerun/vim-polyglot'
"Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

"Plug 'jiangmiao/auto-pairs'
Plug 'windwp/nvim-autopairs'

"Plug 'mhinz/vim-startify' "start screen

"Plug 'junegunn/goyo.vim' "distraction free writing
"Plug 'junegunn/limelight.vim' "distraction, free writing with goyo

"https://github.com/hoob3rt/lualine.nvim
"https://github.com/romgrk/barbar.nvim
Plug 'itchyny/lightline.vim'

" file explorer
Plug 'kyazdani42/nvim-tree.lua'

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

Plug 'chipsenkbeil/distant.nvim'

" Terminal
"https://github.com/akinsho/toggleterm.nvim
"https://github.com/voldikss/vim-floaterm

" Snippet engine
Plug 'hrsh7th/vim-vsnip'
" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

Plug 'simrat39/rust-tools.nvim'

"Plug 'haishanh/night-owl.vim'
Plug 'tomasiser/vim-code-dark'
"Plug 'dylanaraps/wal'

" Debugger"
" https://github.com/mfussenegger/nvim-dap"

call plug#end()

set termguicolors
colorscheme codedark
let g:lightline = { 'colorscheme': 'codedark' }

" vimwiki
set nocompatible
filetype plugin on
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]
"autocmd FileType vimwiki set ft=markdown
" gem install gollum

set completeopt=menu,menuone,noselect

lua << EOF
  local lspkind = require('lspkind')
  local cmp = require('cmp')
  -- a revoir
  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }
  })
  require('lspconfig').bashls.setup({})
  require('lspconfig').rust_analyzer.setup({})
  require('rust-tools').setup(opts)

  require "lsp_signature".setup()

  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
    },
  }

  -- you need setup cmp first put this after cmp.setup()
  require('nvim-autopairs').setup{}
  require("nvim-autopairs.completion.cmp").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    auto_select = true, -- automatically select the first item
    insert = false, -- use insert confirm behavior instead of replace
    map_char = { -- modifies the function or method delimiter by filetypes
      all = '(',
      tex = '{'
      }
    })

  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      prompt_prefix = ' >',
      color_devicons = true,

      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

      mappings = {
        -- maapings allows to be able to add custom behavior ontop of the fuzzy findings
        i = {
          ["<C-h>"] = "which_key",
          ["<C-x>"] = false,
          ["<C-q>"] = actions.send_to_qflist,
        }
      }
    },
    extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
    }
  }
  require('telescope').load_extension('fzy_native')


  require('gitsigns').setup {
    yadm = { enable = true }
  }

  require'nvim-tree'.setup {}
EOF

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.local/share/nvim/backups > /dev/null 2>&1
  set undodir=~/.local/share/nvim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set laststatus=2
set modelines=5
set vb t_vb=
set nojoinspaces
set display+=lastline

" Display tabs and trailing spaces visually
set list listchars=nbsp:_,tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

"set foldmethod=indent   "fold based on indent
set foldmethod=expr "treesitter-based folding
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
set inccommand=split

" =============== Terminal Mode =====================
tnoremap <Esc><Esc> <C-\><C-n>

" ==== Undo break points
"inoremap , ,<c-g>u
"inoremap . .<c-g>u
"inoremap ! !<c-g>u
"inoremap ? ?<c-g>u

" === Telescope ============
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" === Nvim tree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
