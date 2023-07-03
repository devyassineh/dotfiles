"call plug#begin()
"Plug 'joshdick/onedark.vim'
"Plug 'mhinz/vim-startify'
"Plug 'junegunn/fzf.vim' 
"Plug 'junegunn/fzf', {'do' : { -> fzf#install() } } 
"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-commentary'
"Plug 'jiangmiao/auto-pairs'
"Plug 'sirver/ultisnips'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'
"Plug 'fatih/vim-go'
"call plug#end()

syntax enable
filetype plugin on
set mouse=a
set cursorline
set hlsearch
set nocompatible
set noerrorbells
set path+=**
set wildmenu
set termguicolors
set incsearch
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set autoindent
set showmatch
set hidden
set backspace=indent,eol,start
set clipboard=unnamedplus
colorscheme onedark

let mapleader=" "
let g:fzf_preview_window = ['right:50%', 'ctrl-/'] 

" keybindings general
map <C-d> <C-d>zz
map <C-u> <C-u>zz
vnoremap J :m+1<CR>gv=gv
vnoremap K :m-2<CR>gv=gv

" keybindings leader + plugins
map <leader>n :set number!<CR>
map <leader>ss :Startify<CR>
map <leader>sf :Files<CR>
map <leader>st :Rg<CR>
map <leader>sb :Buffers<CR>
map <leader>e :Explore<CR>
map K :LspHover<CR>
map gd :LspDefinition<CR>
map <leader>ca :LspCodeAction<CR>

" filetype specifiy settings
autocmd FileType go autocmd BufWritePre <buffer> GoImports
autocmd FileType go map K :GoDoc<CR>
autocmd FileType vim setlocal commentstring="
autocmd FileType c unmap K
