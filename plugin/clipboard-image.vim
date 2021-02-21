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

" Create vim command
command! PasteImg :lua require'clipboard-image.paste'.paste_img()
command! -range DeleteImg :lua require'clipboard-image.delete'.delete_img()

let &cpo = s:save_cpo
unlet s:save_cpo
