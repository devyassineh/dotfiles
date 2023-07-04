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
set autowrite
set backspace=indent,eol,start
set clipboard+=unnamed
colorscheme onedark

let mapleader=" "
let g:fzf_preview_window = ['right:50%', 'ctrl-/'] 

" keybindings leader + plugins
map <leader>n :set number!<CR>
map <leader>ss :Startify<CR>
map <leader>sf :Files<CR>
map <leader>st :Rg<CR>
map <leader>sb :Buffers<CR>
map <leader>e :Explore<CR>
map <leader>h :cd ~/github.com/yassinehaddoudi<CR>


" vim-go settings
let g:go_doc_keywordprg_enabled = 0
autocmd FileType go autocmd BufWritePre <buffer> GoImports
autocmd FileType go map <leader>d  :GoDoc<CR>

" vim-commentary settings
autocmd FileType vim setlocal commentstring=\"\ %s

" keybindings general
map <C-d> <C-d>zz
map <C-u> <C-u>zz
vnoremap K :m-2<CR>gv=gv
vnoremap J :m'>+<CR>gv=gv

" vim-lsc settings
" let g:lsc_server_commands = {'c': 'clangd', 'go': 'gopls'}
" let g:lsc_auto_map = v:true
" set completeopt-=preview
" set shortmess-=F

"vim-lsp config
nnoremap gd :LspDefinition<CR>
nnoremap <leader>ca :LspCodeAction<CR>
nnoremap K :LspHover<CR>
