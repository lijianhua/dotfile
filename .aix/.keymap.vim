" ========================= KeyFire Setting Start =========================

" -------------- Tooling Function Binding ------------------
" Lookup HighLight Syntax Define
function! <SID>SynStack()
  echo map(synstack(line('.'),col('.')),'synIDattr(v:val, "name")')
endfunc

" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

" Space2Tab
" Tab2Space
" RetabIndent
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'ag'
    execute 'Ag '.l:pattern
  elseif a:direction == 'replace'
    execut  "%s" . '/'. l:pattern . '/'
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" -------------- Tooling Function Ending ------------------

" use vimR without keymap
" if(has("mac"))
"   nnoremap <D-2> :NERDTreeToggle<CR>
"   nnoremap <D-3> :exec exists('syntax_on') ? 'syn off': 'syn on'<CR>
"   nnoremap <D-4> mzgg=G`z
"   nnoremap <D-5> ggVG:RetabIndent<CR>
"   nnoremap <D-6> ggVG:Tab2Space<CR>
" endif
" Open a NERDTree
map <F5> :NERDTreeToggle<CR>
" Tagbar
"映射tagbar的快捷键
let g:tagbar_autofocus = 1
let g:tagbar_width=36
let g:tagbar_ctags_bin="/usr/local/bin/ctags"
map <F6> :TagbarToggle<CR>

map <F4> :call TitleDet()<cr>

function TitleDet()

    let n=1
    while n < 10
        let line = getline(n)
        if line =~ '^\#\s*\S*Last\smodified\S*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()

endfunction

function AddTitle()

    call append(1,"/**")
    call append(2," * @Author  by Li Jianhua")
    call append(3," * @Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(4," * @Filename     : ".expand("%:t"))
    call append(5," *")
    call append(6," */")
    echohl WarningMsg | echo "Successful in adding copyright." | echohl None

endf


" Normal Key Map
nnoremap U :redo<CR>
nnoremap Q :q!<CR>
nnoremap W :w!<CR>

" Window VertSplit switcher
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Set as toggle foldcomment
nnoremap zc @=((foldclosed(line('.')) < 0) ? 'zc' :'zo')<CR>
nnoremap zr zR

" Fast searcher
nnoremap z, :FZF --no-mouse .<CR>

nnoremap ' `
nnoremap ` '
nnoremap <silent> zj o<ESC>k
nnoremap <silent> zk O<ESC>j

" Format Jump
nnoremap <silent> g; g;zz
nnoremap <silent> g, g,zz

" Smooth Scroll the terminal
" nnoremap <silent> <C-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
" nnoremap <silent> <C-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(200)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(-200)<CR>

noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

if(has('mac'))
  cnoremap <A-j> <Down>
  cnoremap <A-k> <Up>
  cnoremap <A-h> <Left>
  cnoremap <A-l> <Right>
  inoremap <A-j> <Down>
  inoremap <A-k> <Up>
  inoremap <A-[> <ESC>
  inoremap <A-h> <Left>
  inoremap <A-l> <Right>
else
  " Cursor Moving
  cnoremap <A-j> <Down>
  cnoremap <A-k> <Up>
  cnoremap <A-h> <Left>
  cnoremap <A-l> <Right>
  inoremap <A-j> <Down>
  inoremap <A-k> <Up>
  inoremap <A-h> <Left>
  inoremap <A-l> <Right>

  cnoremap <M-j> <Down>
  cnoremap <M-k> <Up>
  cnoremap <M-h> <Left>
  cnoremap <M-l> <Right>
  inoremap <M-j> <Down>
  inoremap <M-k> <Up>
  inoremap <M-h> <Left>
  inoremap <M-l> <Right>
endif

" Like Emacs
inoremap <C-e> <End>
inoremap <C-f> <Home>
inoremap <C-d> <Esc>VypA
inoremap <C-w> <C-o>w
inoremap <C-b> <C-o>b

" TabLine Tab configure KeyFire
nnoremap <leader>t  :tabnew<CR>
nnoremap <leader>tt :Deol -split<CR>
nnoremap <leader>tl :tabnext<CR>
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tc :tabclose<CR>

" Buffers KeyFire
nnoremap <leader>b :Buffers<CR>

" Buftabline Config Manager

" Check Vim Syntax name Fn
nnoremap <leader>yi :call <SID>SynStack()<CR>

" Repeat Preview
nnoremap <leader>. @:
vnoremap <leader>. :normal .<CR>

" MRU
nnoremap <leader>uh :MRU<CR>

" Split faster
nnoremap <leader>\ :vs<CR>
nnoremap <leader>- :sp<CR>

" Fast to copy files path
nnoremap <leader>p "+gp
vnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>d "+d
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>cp :let @+=expand("%:p")<CR>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<CR>

" Vundle keyfire
nnoremap <leader>vi :PlugInstall<CR>
nnoremap <leader>vu :PlugUpdate<CR>

" Tabluer Format
vnoremap <leader>t :Tabularize/
vnoremap <leader>t= :Tabularize/=<CR>
vnoremap <leader>t, :Tabularize/,<CR>
vnoremap <leader>t. :Tabularize/.<CR>
vnoremap <leader>t: :Tabularize/:<CR>
vnoremap <leader>t; :Tabularize/;<CR>
vnoremap <leader>t\ :Tabularize/\|<CR>

" <leader>s: Spell checking shortcuts
" fold enable settings
nnoremap <leader>ss :setlocal spell!<CR>
nnoremap <leader>sj ]szz
nnoremap <leader>sk [szz
nnoremap <leader>sa zg]szz
nnoremap <leader>sd 1z=
nnoremap <leader>sf z=

" Multi Cursor Find
vnoremap <leader>mf :MultipleCursorsFind
vnoremap <leader>f :call VisualSelection('ag', '')<CR>
nnoremap <leader>ff ggVG:Tab2Space<CR>

" Multi Expand Region
map K <Plug>(expand_region_expand)
map J <Plug>(expand_region_shrink)

" Incsearch
" nnoremap / /\v
" vnoremap / /\v
" Ag bind \ (backward slash) to grep shortcut
"map / <Plug>(incsearch-forward)
"map ? <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)
"map \ :Ag<SPACE>

map n <Plug>(is-nohl)<Plug>(anzu-N-with-echo)
map N <Plug>(is-nohl)<Plug>(anzu-n-with-echo)

map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)



" Vim-quickhl
nmap <leader>m <Plug>(quickhl-manual-this)
xmap <leader>m <Plug>(quickhl-manual-this)
nmap <leader>M <Plug>(quickhl-manual-reset)
xmap <leader>M <Plug>(quickhl-manual-reset)

" vim-operator-flashy
" Highlight yanked area
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" Prettier
" nmap <Leader>py <Plug>(Prettier)

" jsDoc
" Gif config
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

" coc
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

vmap <leader>py  <Plug>(coc-format-selected)
xmap <leader>py  <Plug>(coc-format-selected)
nmap <leader>py  <Plug>(coc-format)

" ========================= KeyFire Setting End =========================
