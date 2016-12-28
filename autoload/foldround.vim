let s:foldmethods = [
      \ 'manual', 'indent', 'expr',
      \ 'marker', 'syntax', 'disable'
      \]

function! s:echo(hl, msg) abort
  try
    execute 'echohl ' . a:hl
    echo a:msg
  finally
    echohl None
  endtry
endfunction

function! s:set_foldmethod(offset) abort
  if &diff
    let foldmethods = extend(['diff'], s:foldmethods)
  else
    let foldmethods = copy(s:foldmethods)
  endif
  let foldmethod = &foldenable ? &foldmethod : 'disable'
  let index = index(foldmethods, foldmethod)
  if index == -1
    let index = 0
  else
    let index += a:offset
  endif
  let index = index % len(foldmethods)
  let new_foldmethod = foldmethods[index]
  if new_foldmethod ==# 'disable'
    setlocal nofoldenable
  else
    setlocal foldenable
    let &l:foldmethod = new_foldmethod
  endif
  call s:echo('Title', printf(
        \ 'foldround: %s', new_foldmethod
        \))
endfunction

function! foldround#forward(...) abort
  let offset = get(a:000, 0, v:count1)
  call s:set_foldmethod(offset * +1)
endfunction

function! foldround#backward(...) abort
  let offset = get(a:000, 0, v:count1)
  call s:set_foldmethod(offset * -1)
endfunction
