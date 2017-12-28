set nocompatible
filetype off

" Vundle
if has('win32')
  set rtp+=~/AppData/Local/nvim/bundle/Vundle.vim
  call vundle#begin('~/AppData/Local/nvim/bundle')
else
  set rtp+=~/.config/nvim/bundle/Vundle.vim
  call vundle#begin('~/.config/nvim/bundle')
endif

Plugin 'VundleVim/Vundle.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'mileszs/ack.vim'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'mhinz/vim-signify'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vimwiki/vimwiki'

Plugin 'mustache/vim-mustache-handlebars'
Plugin 'tpope/vim-markdown'
Plugin 'petrbroz/vim-glsl'
Plugin 'rhysd/vim-clang-format'
Plugin 'rust-lang/rust.vim'
Plugin 'cespare/vim-toml'
Plugin 'tpope/vim-fugitive'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'fatih/vim-go'

call vundle#end()

" Generic settings
set enc=utf-8
set relativenumber
set number
set nowrap
au InsertEnter * :set norelativenumber
au InsertLeave * set number | :set relativenumber
au FileType make set noexpandtab
au FileType rust set ts=4 sw=4 sts=4
au FileType c set ts=2 sw=2 sts=2
au BufRead,BufNewFile *.rs set ts=4 sw=4 sts=4
au BufRead,BufNewFile *.c set ts=2 sw=2 sts=2
au BufRead,BufNewFile *.h set ts=2 sw=2 sts=2
set nobackup
set noswapfile
set mouse=n
set path+=**
set wildmenu
filetype indent plugin on
syn on

" Eyecandy
set cursorline
color jellybeans
set fillchars=vert:\ 
hi NonText guifg=bg

" Statusline
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline ctermbg=magenta guibg=magenta cterm=NONE gui=NONE
  elseif a:mode == 'r'
    hi statusline ctermbg=blue guibg=blue cterm=NONE gui=NONE
  else
    hi statusline ctermbg=red guibg=red cterm=NONE gui=NONE
  endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline ctermbg=green guibg=green cterm=NONE gui=NONE
hi statusline ctermbg=green guibg=green cterm=NONE gui=NONE

function! ScmStatus()
  let head = '-'
  if exists('b:git_dir')
    let head = fugitive#head()
  endif
  return '⌥('.head.')'
endfunction
set statusline=
set statusline+=[%n]\ %f
set statusline+=%m%r
set statusline+=\ %{ScmStatus()}
set statusline+=%=
set statusline+=%y
set statusline+=┊%P[%c@%l/%L]

" Tags
function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let cmd = 'ctags -a ' . f
  call DelTagOfFile(f)
  let resp = system(cmd)
endfunction
autocmd BufWritePost *.c,*.cpp,*.php,*.js,*.jsx,*.html,*.go call UpdateTags()
nnoremap <c-k> g<c-]>
vnoremap <c-k> g<c-]>

" Markdown
let g:markdown_fenced_languages = ['html']

" GLSL
au BufNewFile,BufRead *.glsl set filetype=glsl
au BufNewFile,BufRead *.frag set filetype=glsl
au BufNewFile,BufRead *.vert set filetype=glsl

" Paste with indentation
nnoremap p p=`[

" 'Normal' copy/paste
nnoremap <C-X> "+x
inoremap <C-X> "+x
vnoremap <C-X> "+x
nnoremap <C-C> "+y
inoremap <C-C> "+y
vnoremap <C-C> "+y
nnoremap <C-V> "+p=`[
inoremap <C-V> "+p=`[
vnoremap <C-V> "+p=`[

" NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowLineNumbers = 1
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenPreviewSplit='gs'
let NERDTreeMapOpenVSplit='i'
let NERDTreeMapOpenPreviewVSplit='gi'

" Tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

" Splits
set splitbelow
set splitright
nnoremap <C-Y> :vert res +10<CR>
nnoremap <C-O> :vert res -10<CR>

let mapleader=','

" Make
" nnoremap <Leader>m :silent make\|redraw\|cwindow<CR>

" Clang format
let g:clang_format#style_options = {
  \ 'AccessModifierOffset': -4,
  \ 'AlignAfterOpenBracket': 'DontAlign',
  \ 'AlignConsecutiveAssignments': 'false',
  \ 'AlignOperands': 'true',
  \ 'AlignTrailingComments': 'false',
  \ 'AllowAllParametersOfDeclarationOnNextLine': 'false',
  \ 'AllowShortBlocksOnASingleLine': 'false',
  \ 'AllowShortCaseLabelsOnASingleLine': 'false',
  \ 'AllowShortFunctionsOnASingleLine': 'None',
  \ 'AllowShortIfStatementsOnASingleLine': 'false',
  \ 'AllowShortLoopsOnASingleLine': 'false',
  \ 'AlwaysBreakAfterReturnType': 'None',
  \ 'AlwaysBreakTemplateDeclarations': 'false',
  \ 'BinPackArguments': 'true',
  \ 'BinPackParameters': 'true',
  \ 'BreakBeforeBinaryOperators': 'NonAssignment',
  \ 'BreakBeforeBraces': 'Custom',
  \ 'BraceWrapping': {
    \ 'AfterClass': 'false',
    \ 'AfterControlStatement': 'false',
    \ 'AfterEnum': 'false',
    \ 'AfterFunction': 'false',
    \ 'AfterNamespace': 'false',
    \ 'AfterObjCDeclaration': 'false',
    \ 'AfterStruct': 'false',
    \ 'AfterUnion': 'false',
    \ 'BeforeCatch': 'false',
    \ 'BeforeElse': 'false',
    \ 'IndentBraces': 'false',
    \ },
  \ 'BreakBeforeTernaryOperators': 'true',
  \ 'ColumnLimit': 0,
  \ 'ContinuationIndentWidth': 2,
  \ 'Cpp11BracedListStyle': 'false',
  \ 'DerivePointerAlignment': 'false',
  \ 'IndentCaseLabels': 'true',
  \ 'IndentWidth': 2,
  \ 'IndentWrappedFunctionNames': 'false',
  \ 'KeepEmptyLinesAtTheStartOfBlocks': 'false',
  \ 'MaxEmptyLinesToKeep': 1,
  \ 'PointerAlignment': 'Right',
  \ 'SpaceAfterCStyleCast': 'false',
  \ 'SpaceBeforeAssignmentOperators': 'true',
  \ 'SpaceBeforeParens': 'ControlStatements',
  \ 'SpaceInEmptyParentheses': 'false',
  \ 'SpacesInCStyleCastParentheses': 'false',
  \ 'SpacesInContainerLiterals': 'false',
  \ 'SpacesInParentheses': 'false',
  \ 'SpacesInSquareBrackets': 'false',
  \ 'Standard': 'Cpp11',
  \ 'UseTab': 'Never',
  \ }
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_formatexpr = 1
autocmd FileType c ClangFormatAutoEnable

" Rust
let g:rustfmt_autosave = 1