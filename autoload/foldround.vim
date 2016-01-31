let s:valid_foldmethods = [
      \ 'disable',
      \ 'manual', 'indent', 'expr',
      \ 'marker', 'syntax', 'diff',
      \]
if !exists('s:rules')
  let s:rules = []
endif

function! s:echo(hl, msg) abort
  try
    execute 'echohl ' . a:hl
    echo a:msg
  finally
    echohl None
  endtry
endfunction

function! s:echomsg(hl, msg) abort
  try
    execute 'echohl ' . a:hl
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction

function! s:validate_foldmethod(method) abort
  if index(s:valid_foldmethods, a:method) == -1
    throw printf(
          \ 'foldround: "%s" is not a valid foldmethod. See :help foldround#register()',
          \ a:method,
          \)
  endif
endfunction

function! s:register_rule(rule, foldmethods) abort
  try
    call map(copy(a:foldmethods), 's:validate_foldmethod(v:val)')
    call add(s:rules, [a:rule, a:foldmethods])
  catch /^foldround:/
    call s:echomsg('ErrorMsg', v:exception)
  endtry
endfunction

function! s:find_foldmethods() abort
  if exists('b:_foldround_foldmethods')
    return b:_foldround_foldmethods
  endif
  let filename = expand('%:p')
  for [rule, foldmethods] in reverse(deepcopy(s:rules))
    if filename =~# rule
      return [rule, copy(foldmethods)]
    endif
  endfor
  return ['default', copy(s:valid_foldmethods)]
endfunction

function! s:set_foldmethod(offset, rule, foldmethods) abort
  if &diff
    if index(a:foldmethods, 'diff') == -1
      call s:echo('WarningMsg',
            \ 'foldround: "diff" is not found in available foldmethods.'
            \)
      return
    endif
    let foldmethods = copy(a:foldmethods)
  else
    let foldmethods = filter(
          \ copy(a:foldmethods),
          \ 'v:val !=# "diff"',
          \)
  endif
  let foldmethod = &foldenable ? &foldmethod : 'disable'
  let index = index(foldmethods, foldmethod)
  if index == -1
    " Add the current foldmethod and store in buffer local variable
    let b:_foldround_foldmethods = [foldmethod] + foldmethods
    let index = 0
  else
    let index += a:offset
  endif
  let index = index >= len(foldmethods) ? 0 : index
  let index = index < 0 ? len(foldmethods) - 1 : index
  let new_foldmethod = foldmethods[index]
  if new_foldmethod ==# 'disable'
    setlocal nofoldenable
  else
    setlocal foldenable
    let &l:foldmethod = new_foldmethod
  endif
  if a:rule ==# 'default'
    call s:echo('Title', printf(
          \ 'foldround: %s', new_foldmethod
          \))
  else
    call s:echo('Title', printf(
          \ 'foldround: %s (''%s'')', new_foldmethod, a:rule
          \))
  endif
endfunction

function! foldround#register(rule, methods) abort
  call s:register_rule(a:rule, a:methods)
endfunction

function! foldround#forward(...) abort
  let offset = get(a:000, 0, v:count1)
  let [rule, foldmethods] = s:find_foldmethods()
  call s:set_foldmethod(offset * +1, rule, foldmethods)
endfunction

function! foldround#backward(...) abort
  let offset = get(a:000, 0, v:count1)
  let [rule, foldmethods] = s:find_foldmethods()
  call s:set_foldmethod(offset * -1, rule, foldmethods)
endfunction
