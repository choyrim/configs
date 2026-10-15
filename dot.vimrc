" ~/.vimrc - Vim setup tuned for Python, plugins via vim-plug

set nocompatible
let mapleader = ' '           " must be set before any <leader> mapping

" --- Plugins (vim-plug) --------------------------------------------------
" Add Plug lines below, then run :PlugInstall. plug#end() also turns on
" filetype plugin indent and syntax.
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'          " async linting/fixing (works with ruff)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " fuzzy finder + binary
Plug 'junegunn/fzf.vim'            " :Files, :Rg, :Buffers
Plug 'tpope/vim-fugitive'          " git
Plug 'tpope/vim-commentary'        " gcc to toggle comments
Plug 'patstockwell/vim-monokai-tasty'  " colorscheme
call plug#end()

" --- General -------------------------------------------------------------
set encoding=utf-8
set hidden                      " switch buffers without saving first
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamed           " yank/paste via the macOS clipboard
set updatetime=300
set wildmenu wildmode=longest:full,full
set scrolloff=5
set splitright splitbelow

" Persistent undo; keep swap/backup files out of the working tree
silent! call mkdir(expand('~/.vim/undo'), 'p')
silent! call mkdir(expand('~/.vim/swap'), 'p')
set undofile undodir=~/.vim/undo//
set directory=~/.vim/swap//
set nobackup nowritebackup

" --- Display -------------------------------------------------------------
set number relativenumber
set cursorline
set showmatch
set laststatus=2
set ruler showcmd
set signcolumn=yes
set list listchars=tab:»\ ,trail:·,nbsp:␣
if has('termguicolors') | set termguicolors | endif
silent! colorscheme vim-monokai-tasty

" --- Search --------------------------------------------------------------
set incsearch hlsearch
set ignorecase smartcase
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" --- Indentation defaults ------------------------------------------------
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set autoindent

" --- Python --------------------------------------------------------------
augroup python_settings
  autocmd!
  " PEP 8 indentation; ruler at 88 to match black/ruff's default line length
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType python setlocal textwidth=88 colorcolumn=89
  autocmd FileType python setlocal foldmethod=indent foldlevel=99
  " Run the current file with python3
  autocmd FileType python nnoremap <buffer> <leader>r :w<CR>:!python3 %<CR>
augroup END

" ALE: lint with ruff as you edit; on save, apply ruff's fixes then format
let g:ale_linters = {'python': ['ruff']}
let g:ale_fixers = {'python': ['ruff', 'ruff_format']}
let g:ale_fix_on_save = 1
" Projects whose code isn't ruff-formatted yet; fix these by hand with :ALEFix
augroup ale_no_fix_on_save
  autocmd!
  autocmd BufNewFile,BufRead ~/bb/cem-dtb-integration/* let b:ale_fix_on_save = 0
augroup END
nmap ]e <Plug>(ale_next_wrap)
nmap [e <Plug>(ale_previous_wrap)

" Strip trailing whitespace on save
augroup strip_whitespace
  autocmd!
  autocmd BufWritePre *.py,*.toml,*.yaml,*.yml,*.md
        \ let s:view = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(s:view)
augroup END

" --- Convenience mappings ------------------------------------------------
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
