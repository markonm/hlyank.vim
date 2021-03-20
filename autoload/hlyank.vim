let s:cpo_save = &cpo
set cpo-=C

function! hlyank#debounce_hl() abort
  if v:event.operator isnot 'y'
    return
  endif
  if exists('s:timer_start_hl')
    call timer_stop(s:timer_start_hl)
  endif
  let type = v:event.regtype
  let pos = [line("'["), col("'["), line("']"), col("']")]
  let reg = v:event.regcontents
  let s:timer_start_hl = timer_start(1, {-> <sid>highlight(pos, type, reg)})
endfunction

function! s:highlight(pos, type, reg) abort
  let pos = [line("'["), col("'["), line("']"), col("']")]
  if pos !=# a:pos
    return
  endif
  if a:type[0] == ''
    let id = matchadd('Visual', '\v%\V')
  elseif a:type ==# 'V'
    let id = matchadd('Visual', printf('\v%%>%dl%%<%dl',
          \ pos[0] - 1, pos[2] + 1))
  else
    if pos[0] == pos[2]
      let id = matchadd('Visual', printf('\v%%%dl%%%dc\_.{%d}',
            \ pos[0], pos[1], strchars(a:reg[0])))
    else
      let id = matchadd('Visual', printf('\v%%%dl%%%dc\_.{-}%%%dl%%%dc.=',
            \ pos[0], pos[1], pos[2], pos[3]))
    endif
  endif
  if has('patch-8.1.1741')
    let winid = win_getid()
    call timer_start(200, {-> matchdelete(id, winid)})
  else
    call timer_start(200, {-> matchdelete(id)})
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
