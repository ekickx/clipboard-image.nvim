" Prevent loading plugin twice
if exists('g:clipboard_image_loaded') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

if !has('nvim')
  echohl Error
  echom "Sorry this plugin only works with neovim version that support lua"
  echohl clear
  finish
endif

lua require'clipboard-image'.setup()
let g:clipboard_image_loaded = 1

" Command completion
function! s:pickers_list(n)
  let l:pickerslist = luaeval('require("clipboard-image.pick").get_pickers_list()')
  if a:n == 0 
    return l:pickerslist
  endif
endfunction

function! s:picker_completion(arg,line,pos)
  let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
  let n = len(l) - index(l, 'PasteImgPickers') - 2
  return s:pickers_list(n)
endfunction

function! s:picker_completion2(arg,line,pos)
  let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
  let n = len(l) - index(l, 'PasteImgPick') - 1
  return s:pickers_list(n)
endfunction

" Create vim command
command! PasteImg :lua require'clipboard-image.paste'.paste_img()
command! -nargs=* -complete=customlist,s:picker_completion PasteImgPickers :lua require'clipboard-image.pick'.pick(<f-args>)
command! -nargs=* -complete=file PasteImgPick :PasteImgPickers default <f-args>

let &cpo = s:save_cpo
unlet s:save_cpo
