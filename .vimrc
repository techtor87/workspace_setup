set nocompatible
" source $VIMRUNTIME/vimrc_example.vim
if !empty(glob("~/.vim/autoload/pathogen.vim"))
   execute pathogen#infect()
endif

" zo - open fold
" zc - close fold
" za - toggle fold
" zf - add fold
" zd - delete fold
" zR - open all folds
" zM - close all folds

" Basic Options {{{
set encoding=utf-8

" leader is ,
let mapleader=","
nnoremap ; :

set autoread      " refresh files changed in background if no edits
set nobackup
set nowritebackup
set noswapfile
set ruler
set relativenumber
set number
set visualbell
set cursorline     " highlight current line
set lazyredraw     " redraw screen only when needed
set clipboard=unnamed

set scrolloff=5

" write to root files silently
command W :execute ':silent w ~sudo tee % > /dev/null' | :edit!

set softtabstop=3 shiftwidth=3 expandtab

if has("gui_running")
   set guioptions-=T
   set guioptions-=r
   set guifont=Consolas:h9:cDEFAULT
endif

colorscheme slate

syntax on          " enable syntax processing
filetype plugin on
filetype plugin indent on

set wildignore+=*\\tmp\\*,*.so,*.swp,*.zip,*.o
" }}}
" Search {{{
set incsearch        " search as characters are entered
set hlsearch         " highlight matches
set ignorecase       " ignore case for search
set smartcase        " search for case if used in search term
" turn off search highlighting. For when finished with search
nnoremap <leader><space> :nohlsearch<CR>

" center search results
" nnoremap n nzz
" nnoremap N Nzz

nnoremap <C-n> /<C-r><C-w><CR>

set wildmenu
set wildmode=full
" }}}
" Folding {{{
set modelines=1
set foldmethod=indent
if (expand('%') == '.vimrc')
   setlocal foldmethod=marker
   setlocal foldlevel=0
endif
set foldenable
set foldlevel=99
set foldnestmax=20
set showmatch        " highlight matching [{()}]
" }}}
" Marking {{{
" DOES NOT SEEM TO WORK
" source ~/.vim/showmarks.vim
" let g:showmarks_enable=0
" <leader>mt - toggle on/off
" <leader>mm - place next mark
" <leader>ma - clear marks
" <leader>mh - clears a mark
" }}}
" Movement {{{
" move to ends of line
nnoremap B ^
nnoremap E $

" disable arrow keys in insert mode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" }}}
" Hidden Characters {{{
nmap <leader>l :set list!<CR>
set listchars=eol:¬
set listchars+=tab:>-
set listchars+=trail:·
set listchars+=precedes:·
set listchars+=conceal:·
set listchars+=nbsp:¿
" }}}
" Functions {{{
map <C-S-/> <C-R>=CommentFunc()<CR>
function! CommentFunc()
   let m = visualMode()
   if m ==# 'v'
      echo 'visual'
   elseif m == 'V'
      echo 'line-visual'
   elseif m == "\<C-V>"
      echo 'block visual'
   endif
endfunction

" Strip extra whitespace on save
function! StripTrailingWhitespaces()
   " save last search & cursor position
   let _s=@/
   let l = line(".")
   let c = col(".")
   %s/\s\+$//e
   let @/=_s
   call cursor(l, c)
endfunction
autocmd BufWritePre * :call StripTrailingWhitespaces()

" set g:multi_cursor_exit_from_visual_mode=0
" set g:multi_cursor_exit_from_insert_mode=0

" }}}
" Key Mapping {{{
map <F7> <Esc>:setlocal spell spelllang=en_us<CR>
map <S-F7> <Esc>:setlocal nospell<CR>
" z= on misspelled word brings up possible list

map <F11> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

" edit vimr/bashrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>rv :source $MYVIMRC<CR>
" }}}
" GVIM on Windows {{{
" don't close gvim on q
"cnoremap q<CR> bw<CR>
"cnoremap e<SPACE> tabe<SPACE>

"map <C-TAB> :tabn<CR>
"map <C-S-TAB> :tabp<CR>
"noremap <F4> :tabs<CR>:tabn<SPACE>

"CtrlP for GVim
"let g:ctrlp_cmd = 'CtrlP'
"let g:ctrlp_match_window = 'bottom,order:ttb'
"let g:ctrlp_switch_buffer = 0
"let g:ctrlp_root_markers = ['makeit']
"let g:ctrlp_working_path_mode = 'c'
"let g:ctrlp_by_filename = 1
"let g:ctrlp_show_hidden = 1
"let g:ctrlp_max_files = 0

"autocmd vimenter * NERDTree

"autocmd vimenter * cd Z:\gcf_featSHPT_2

"set path=Z:\sCT\**
"set path+=Z:\search\**
" }}}
" Pymode {{{
let g:pymode = 1
let g:pymode_warnings = 1
let g:pymode_paths = []
" let g:pymode_optinos = 1
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 6

" }}}
" BASH IDE {{{
let g:BASH_AuthorName   = 'G. Faulconbridge'"
let g:BASH_Email        = 'gregory.faulconbridge@ge.com'
let g:BASH_Company      = 'General Electric Transportation'
"}}}
" vim:foldmethod=marker:foldlevel=0
