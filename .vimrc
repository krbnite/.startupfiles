" Package Manager: Pathogen
execute pathogen#infect()

" Indentation Control
"   Many people use 4 spaces (ew) for tab; I use 2
"    -- importantly, tab must/should be remapped to spaces
set expandtab    " Enter spaces when tab is pressed
set tabstop=2    " tab = this # of spaces 
set softtabstop=2
set shiftwidth=2

" Much of this originally by:	Bram Moolenaar <Bram@vim.org>
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start


"--I can use this if I ever start using GIT regularly--"
"set nobackup            " No need since 
"set nowritebackup       "   I use git for version control

set history=500		" keep 500 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching (like in a browser)
set number              " show line numbers in left margin
set nuw=1               " hug line numbers to left wall

"Change color of numbers:
highlight LineNr ctermfg=white
"1,7,22,24,

" Don't use Ex mode, use Q for formatting
map Q gq  

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" - - - - - - - - - - - -
" Some additional commands for VIM-LATEX usage
" From:
" http://vim-latex.sourceforge.net/documentation/latex-suite/recommended-settings.html
"
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
" Tex-9 also needs this
let g:tex_flavor='latex'

"if has("unix") && match(system("uname"),'Darwin') != -1
"  " It's a Mac!
"  let g:Tex_ViewRule_pdf = 'open -a Preview.app'
"endif   

" Tex-9 Dictionary
let g:tex_nine_config = {'compiler': 'pdflatex',
    \'viewer': {'app': 'open','target': 'pdf'}
    \}
" This makes it so spellcheck in Tex-9 doesn't work within commented sections
"let g:tex_comment_nospell= 1
" 
" - - - - - - - - - - - - - - - - - - - - - - - -
"
" Some cool mappings & Stuff 
 " insert single char under cursor and return to command mode
nmap gi i_<Esc>r
" insert single char after cursor and return to command mode
nmap ga a_<Esc>r
" Y comes default as synonym for yy, but should be synonym for y$
" since D is syn of d$ and C is syn c$
map Y y$
" Switch on/off numbers/noNumbers
map <Space>n :let &number=1-&number<CR>
" Change buffers without having to save every time
set hidden
" Make tab completion more verbose and useful!
set wildmenu
" When writing documents (e.g., LaTeX) where lines wrap, one must often use gj
" and gk instead of j and k. But on ordinary lines, gj and gk perform exactly
" like j and k. So why not just remap j and k to gj and gk? When lines do not
" wrap, you won't notice a difference; when lines do wrap, you won't go
" insane!
nmap j gj
nmap k gk
" Make changing window panes easier!
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-_> <C-W>_
" Paste a Yank easier than "0p
nmap <Space>p "0p
nmap <Space>P "0P
" Create vertical space
nmap <Space>o o<Esc>
nmap <Space>O O<Esc>
" Close a split buffer without closing the split window
nmap <Space>d :bp\|bd #<CR>
" spell .tex files
autocmd BufRead,BufNewFile *.tex setlocal spell
" word completion in .tex files (must be used in conjunction w/ above cmd)
set complete+=kspell
" clear whole line independent of cursor position
nmap d<space> 0D
" Make search case-insensitive
set ignorecase
" Mod to ignorecase: lowercase search is case-insensitive while
" the inclusion of any upper cases makes search case-sensitive
set smartcase
" For regular expressions, turn magic on
set magic
" Go to first non-blank character
nmap <Space>0 ^
" Spell Checking
" Toggle betwen spell check and no-spell-check
map <leader>ss :setlocal spell!<cr>
" More intuitive spell-check mappings
" spellcheck next:              ]s
" spellcheck previous:          [s
" Add word to dictionary:       zg
" Spellcheck word suggestions:  z=

" Make <Esc> a little more convenient
inoremap <S-Tab> <Esc>
inoremap <C-z> <Esc> 
inoremap <C-v> <Esc>
" <C-z> immediately exits you out of VIM, which is
"   a nightmare; so I just remap it stop that.

set pastetoggle=<C-p>
"----------------------------------------------------------------------
" The NERDTree
"----------------------------------------------------------------------
" Automatically open NERDtree upon opening a file
autocmd vimenter * NERDTree
" Automatically open NERDTree upon opening Vim (no files specified)
autocmd StdinReadPre * let s: std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") |  NERDTree | endif
" Toggle NERDTree's visual existence
map <C-n> :NERDTreeToggle<CR>
" Have NERDTree buffer close when last file is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Give NERDTree cooler arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


"----------------------------------------------------------------------
" Syntastic
"----------------------------------------------------------------------
"The 8 commands were rec'd for newbs in Syntastic help file
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"----------------------------------------------------------------------
" Solarized ColorScheme
"----------------------------------------------------------------------
set t_Co=256
let g:solarized_termcolors=256

"  ewwwww, it isn't working properly at all (2017-02-09)
"syntax enable
"set background=dark
"colorscheme solarized

"----------------------------------------------------------------------
" HELP
"----------------------------------------------------------------------
" These commands are located in ~/.vim/ftplugin/help.vim
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
" Press 'Enter' on help link to jump to its contents
"nnoremap <buffer> <CR> <C-]>
" Press 'Delete' (backspace) to return from jump
"nnoremap <buffer> <BS> <C-T>


