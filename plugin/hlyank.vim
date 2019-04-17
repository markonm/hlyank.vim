if !exists("##TextYankPost") || !has('timers') || exists('g:loaded_hlyank_plugin')
  finish
endif
let g:loaded_hlyank_plugin = 1

let s:cpo_save = &cpo
set cpo-=C

augroup HighlightYank
  autocmd!
  autocmd TextYankPost * call hlyank#debounce_hl()
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
