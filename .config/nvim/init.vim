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
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'takac/vim-hardtime'
Plug 'itchyny/lightline.vim'
"Plug 'jiangmiao/auto-pairs'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'ActivityWatch/aw-watcher-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
"Plug 'haishanh/night-owl.vim'
Plug 'tomasiser/vim-code-dark'
"Plug 'dylanaraps/wal'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
set list listchars=nbsp:_,tab:\ \ ,trail:??

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
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
