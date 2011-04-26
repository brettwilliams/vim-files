"  If you are using VIM and you don't understand folds, do :set fdm=manual
"  to see the contents of my file expanded normally
""""""
"""""""""""   First, don't set anything for older versions, it's not worth
"""""""""""   keeping track--I can live without advanced features for the few
"""""""""""   times I'm stuck with one.
if v:version > 630
  set nocompatible                  " Use Vim defaults, not compat with VI
  filetype off
  call pathogen#runtime_append_all_bundles() 
  call pathogen#helptags() 
  let g:mapleader = ";"
  " SETTING OPTIONS      {{{
  set background=dark               " set background to dark
  set tags=tags
  set backspace=indent,eol,start    " ability to backspace over line break
  set confirm                       " confirms exit/write 
  set formatoptions=cq              " how autowrapping is formatted:
  "c = wrap comments acc. to sw, 
  "a = auto format paragraphs on the fly
  "q = allow formatting with gq
  "2 = use 2nd line of paragraph for indent
  "n = recognize numbered lists
  set tabstop=8                     " set tab stop--I don't use them but..
  set shiftwidth=2                  " set width in autoindent
  "set noerrorbells                  " turn off error bells
  set directory=$HOME/tmp           " Place all swap files in $HOME/tmp
  set expandtab                     " If using autoindent, do not use tabs
  set ruler                         " put coordinates of cursor on screen
  set incsearch                     " while typing search, show match automatic
  set hlsearch                      " highlight other matches
  set dictionary=$HOME/.vim/dictionary   " lookup words using  in insert mode 
  set suffixes=.o,.dvi,.tar,.zip    " in :e ignore filename with these suffixes
  set nostartofline                 " with page commands do not do a 0
  set splitbelow
  set autochdir
  set splitright
  set wildmode=longest,list
  set autoindent
  set nosmartindent                  " This is more trouble than it is worth
  "set textwidth=76
  set ignorecase
  set smartcase
  "set nowrap
  set showmatch
  set showcmd
  set foldmethod=marker             "auto fold on markers by default
  "set foldmethod=syntax             
  "set foldcolumn=4
  set listchars=tab:>-,eol:$,trail:~
  set autoread

  " filetype goodies
  filetype on
  filetype indent on
  filetype plugin on
  syntax enable
  syntax on
  " }}}

  " FILETYPE SETTINGS and AUTOCMDS       {{{
  "get different extensions for C++
  autocmd BufNewFile,BufReadPost *.h        setf cpp 
  autocmd BufNewFile,BufReadPost *.i        setf cpp 
  autocmd BufNewFile,BufReadPost *.gmake    setf make 
  autocmd BufNewFile,BufReadPost *.t2t      setf txt2tags
  autocmd BufNewFile,BufReadPost *.fte      setf fte
  autocmd BufNewFile,BufReadPost *.qqq      setf make

  "FTE template hooks
  autocmd BufNewFile * call ReadFTETemplate()

  " Big file handling
  if !exists("my_auto_commands_loaded")
        let my_auto_commands_loaded = 1
        " Large files are > 10M
        " Set options:
        "     eventignore+=FileType (no syntax highlighting etc
        "            assumes FileType always on)
        "       noswapfile (save copy of file)
        "       bufhidden=unload (save memory when other file is viewed)
        "       buftype=nowritefile (is read-only)
        "       undolevels=-1 (no undo possible)
        let g:LargeFile = 1024 * 1024 * 10
        augroup LargeFile
        autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
        augroup END
endif

  " }}}

  " This should work for any terminal I might use
  if has("gui_running")
    set t_Co=256
    colorscheme solarized 
    "set guifont="Bitstream Vera Sans Mono 10"          " set font
    set guioptions=agml        " set autoselect,menubar,right-scroll
    set mousehide              " hide mouse pointer while typing
  else
    if exists('$MRXVT_TABTITLE')
      set t_Co=256
    endif
    colorscheme solarized
  endif

  " DEFINING FUNCTIONS AND COMMANDS                    {{{
  function ReadFTETemplate()
    "This function loads a skeleton and automatically
    "expands it.  Used with new files.
    let ft=strlen(&ft) ? &ft : 'unknown'
    if !exists('$VIMTEMPLATES')
      let $VIMTEMPLATES=$HOME.'/.vim/templates'
    end
    let templatefile=$VIMTEMPLATES.'/'.ft.'.fte'
    if filereadable(templatefile)
      execute '0r '.templatefile
      execute '.,$FTE'
    end
  endfunction

  " This function gives a query-replace functionality
  function Replace(confirm_requested)
    let pattern = input("Replace: ")
    let subs = input("With: ")
    let cmd = '%s/'.pattern.'/'.subs.'/g' 
    if a:confirm_requested
      let cmd = cmd.'c'
    endif
    execute cmd
  endfunction

  function Toggle_Paste()
    if &paste
      set nopaste
    else
      set paste
    endif
  endfunction

  " COMMANDS
  " Delete buffer without changing window
  command Kwbd enew|bw #|bn
  " }}}
  
  " KEY MAPPINGS             {{{
  " remap bd to invoke Kwbd
  map bd :Kwbd<CR>
  "the following gives word completion in insert mode, and indentation in 
  "command mode
  inoremap <tab> <c-p>
  noremap <tab> ==

  "These bindings make for quick navigation between frames
  map <C-J> <C-W>j
  map <C-K> <C-W>k
  map <c-h> <c-w>h
  map <c-l> <c-w>l

  noremap v {gq}

  "make . not move the point
  "this one doesn't modify the z mark
  noremap . .`[

  " I hate the 'K' built-in, which does a man on the current word
  map K <Nop>
  " I don't use the > built-in either, as I use Tab for indenting according
  " to mode
  map > <Nop>

  " set up so that searches appear in the middle of the screen
  " reserve z mark for last search result
  noremap n nmzz.`z
  noremap N Nmzz.`z
  noremap * *mzz.`z
  noremap # #mzz.`z

  "These let me things a line up or down, preserving indentation
  " move the current line up or down
  nmap <C-Down>  :m+<CR>==
  nmap <C-Up> :m-2<CR>==
  imap <C-Down>  <C-O>:m+<CR><C-O>==
  imap <C-Up> <C-O>:m-2<CR><C-O>==
  " move the selected block up or down
  vmap <C-Down>  :m'>+<CR>gv=gv
  vmap <C-Up> :m'<-2<CR>gv=gv
  
  "These give emacs-style replace, 1 passed in gives query
  map <F7> :call Replace(1)<CR>
  map <F8> :call Replace(0)<CR>

  vmap <Leader>a :call Align("f=")<CR>

  map <Leader>h :noh<CR>
  map <Leader>s :call Toggle_Paste()<CR>
  " Ok, really funky stuff here
  map <space> i
  map <c-space> <esc>
  " }}}

  " MISCELLANEOUS GLOBAL STUFF           {{{

  """"""""""""""""""" wizard settings
  if exists("$WD_LOCAL_SOURCE_DIR")
    let tagsfile = $WD_LOCAL_SOURCE_DIR . "/tags"
    execute "set tags=".tagsfile
    if exists("$WD_TOOL_NAME")
      autocmd BufEnter * let &titlestring = toupper($WD_TOOL_NAME) . ":   " . expand("%")
    endif
  endif
  let g:Doxy_FormatDate = "%d %b %Y"
  " }}}
endif
"	vim61:fdm=marker