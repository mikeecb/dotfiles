"
" Plugins
"
call plug#begin('~/.vim/plugged')
" Vim plugins using vim-plug plugin manager
Plug 'FooSoft/vim-argwrap'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'edkolev/tmuxline.vim'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf'
Plug 'leafgarland/typescript-vim'
Plug 'honza/vim-snippets'
Plug 'whiteinge/diffconflicts'
Plug 'rhysd/git-messenger.vim'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
" Run the following to install coc.nvim extensions
" :CocInstall coc-json coc-tsserver coc-snippets
call plug#end()


"
" Vim setup
"
" Enable file detection
filetype on
" Map the leader key to ','
let mapleader = ","
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand('$HOME/.vim/undo_dir')
    if !isdirectory(undo_dir)
        call mkdir(undo_dir, "", 0700)
    endif
    set undodir=$HOME/.vim/undo_dir
    set undofile
endif
" Coc.nvim default configuration
" If hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" Resolve git diff conflicts
nmap <leader>d :DiffConflicts<CR>


"
" Navigation
"
" Remove arrow key bindings
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
" Change active pane selection
map <silent> <c-k> :wincmd k<CR>
map <silent> <c-j> :wincmd j<CR>
map <silent> <c-h> :wincmd h<CR>
map <silent> <c-l> :wincmd l<CR>
" Navigate between tabs
nmap <silent> gn :tabnext<CR>
nmap <silent> gb :tabprevious<CR>
" Open NERDTree navigation pane
map <leader>n :NERDTreeToggle<CR>
" goto (d)efinition, (t)ype definition, (i)mplementation or (r)eference
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Tab to next snippet placeholder or shift tab to go to previous
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


"
" Search
"
" Search and open file using fzf
nmap <leader>f :FZF <CR>
" Use ag instead of ack
if executable('ag')
    let g:ackprg = 'ag'
endif
" Don't print search output to the console when running ag within vim
function Search(string) abort
  let saved_shellpipe = &shellpipe
  let &shellpipe = '>'
  try
    execute 'Ack!' shellescape(a:string, 1)
  finally
    let &shellpipe = saved_shellpipe
  endtry
endfunction
" Search for the word underneath the cursor
map <leader>x :call Search("<cword>")<CR>
" The :vnoremap command maps // in visual mode to run the commands y/<C-R>"<CR>
" which copies the visually selected text, then starts a search command and
" pastes the copied text into the search. <C-R> represents Ctrl-R and <CR>
" represents carriage return (Enter).
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>


"
" Text editing
" 
" Break long lines
" <leader>gq<Space>
"
" Autocorrect suggestions
" z=
"
" Wrap or unwrap args in bracket using ArgWrap
map <silent> <leader>a :ArgWrap<CR>
" Always add a trailing comma to the last line of wrapped args
let g:argwrap_tail_comma = 1
" Rename the word under the cursor
map <leader>rn <Plug>(coc-rename)
" Format the currently selected text
map <leader>p <Plug>(coc-format-selected)


"
" User interface
"
" Enable syntax highlighting
syntax on
" Basics
set t_Co=256
set backspace=2
set wrap
set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set number
set ruler
set wildmenu
set incsearch
set ignorecase
set wildmode=list:longest
set hlsearch
set laststatus=2
set mouse=a
set noerrorbells
set visualbell
set scrolloff=3
" Always show signcolumns
set signcolumn=yes
" Underline lines longer than 80 characters
hi OverLength cterm=underline
match OverLength /\%80v.\+/
" Open tagbar when opening a file on the left
let g:tagbar_left = 1
autocmd FileType * nested :call tagbar#autoopen()
" Highlight trailing spaces and tabs
set list lcs=trail:·,tab:\ \ 
" Vim gutter colors
hi GitGutterAdd ctermfg=green guifg=darkgreen
hi GitGutterChange ctermfg=yellow guifg=darkyellow
hi GitGutterDelete ctermfg=red guifg=darkred
hi GitGutterChangeDelete ctermfg=yellow guifg=darkyellow
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'Visual', 'Visual', 'Normal'],
  \ 'bg+':     ['bg', 'Visual', 'Visual'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" Typescript tagbar support
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'V:varlambdas',
    \ 'm:members',
    \ 't:types',
    \ 'i:interfaces',
    \ 'e:enums',
		\ 'I:imports',
  \ ]
\ }
" Go tagbar support
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
" Underline words that were incorrectly spelled
set spell
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
hi SpellBad cterm=undercurl gui=undercurl
" Use K to show code documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Lightline color scheme
let g:lightline = {
  \ 'colorscheme': 'wombat',
\ }
