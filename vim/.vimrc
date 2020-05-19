"---------------------------------
"Vundle Plugin Manager
"---------------------------------

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

set nocompatible       " be improved, requred (vundle)
filetype off           " required (vundle)

" set the runtime path to include Vundle and initialize
set rtp +=~/.vim/bundle/Vundle.vim
set rtp +=/usr/local/opt/fzf

call vundle#begin()

"let vundle manage vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'w0rp/ale'               " linter
Plugin 'Valloric/YouCompleteMe' " auto complete
Plugin 'junegunn/fzf.vim'       " fzf integration
Plugin 'rust-lang/rust.vim'     " rust syntax
Plugin 'tpope/vim-vinegar'      " spice up netrw

" all of plugins above these lines
call vundle#end() " required
filetype plugin indent on  " required

"---------------------------------
" Options
"---------------------------------

" disable ale initially
let g:ale_enabled=0


" ycm close preview window after completion
let g:ycm_autoclose_preview_window_after_completion=1


" Visual -------------------------
syntax enable  " enable syntax processing
syntax on      " turn it on

" colorscheme
set background=dark
" solarized colors
colorscheme solarized8_flat
set hlsearch       " highlight search results
set ruler          " show col and line #
set relativenumber " relative number
set number         " show real line number for current line
set showmatch      " Show the matching [{(
set foldenable     " enable folding of lines
set showcmd        " show current command
set scrolloff=2    " scroll a few lines before end
set hidden         " keep buffers open
set lazyredraw     " lazy drawing
" set cc=80          " nice line at 80 characters

set listchars=tab:»·,trail:·    " show tabs/trailing spaces with better characters

" Key Remappings -------------------

" map space to ':'
noremap <space> :

" remap local leader, might want a better leader
let maplocalleader = ","

" Local Leader Maps for Plugins
" List of currently mapped "shortcuts"
" [<leader>] w show whitespace
" [<leader>] l toggle line numbers
" [<leader>] a toggle ALE linting
" [<leader>] q quickfix menu
" [<leader>] s netrw save (hack)
" [<leader>] f open a new file with FZF
" [<leader>] b search open buffers with FZF
" [<leader>] k load man page for word under cursor in new window

" show whitespace
nnoremap <silent> <localleader>w :set list!<CR>
" toggle line numbers/relative numbers
nnoremap <silent> <localleader>l :set relativenumber!<CR>:set number!<CR>
" toggle ALEFixing
nnoremap <silent> <localleader>a :ALEToggle<CR>
" quickfix menu
nnoremap <silent> <localleader>q :lop<CR>
" open new file with fzf
nnoremap <silent> <localleader>f :Files<CR>
" select open buffer with fzf
nnoremap <silent> <localleader>b :Buffers<CR>
" load man pages in new window with \K
runtime! ftplugin/man.vim


" Behavior Settings ------------------
set binary                           " don't add empty newlines at EOFs
set noeol
set backupcopy=yes                   " back up file for editing in place
set backup                           " create backup files
set backupdir=.backup,~/.vim/backup/ " backup locations
set undodir=~/.vim/undodir/          " persistant undo
set undofile                         " create the undo file

" set down here because something above is overwriting?
set tabstop=4       " width of \t
set shiftwidth=4    " indents width of 4
set softtabstop=4   " sets number of columns for tab
set expandtab       " indent with spaces

" use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"---------------------------------
" Functions
"---------------------------------

" vim/tmux navigation with C-{hjkl}
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=none
