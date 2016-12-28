" Vim global plugin for continouosly filtering the current buffer by
" given filter arguments
" Last Change:  2016 Dec 28 
" Maintainer:	Robert Sarkozi <sarkozi.robert@gmail.com>
" License:	This file is placed in the public domain.
" Version:	0.1.0

if exists("g:loaded_refilter")
  finish
endif
let g:loaded_refilter = 1

let s:save_cpo = &cpo
set cpo&vim

"The functionality BEGIN ++++++++++++++++++++++++++++++++++++++++++

" ReFilter_Update - function to show current file in preview window,
" go to its end and center it
function! s:ReFilter_Update()
  pedit!
  normal G
  normal zz
endfunction

" refilter_tick - the function executed by the timer
" this function needs to be more public than script (s:) scope!
function! refilter#refilter_tick(timer_id)
  if exists('b:refilter_timer_id') && b:refilter_timer_id == a:timer_id
    if getfsize(bufname('%')) != b:refilter_file_size
      let b:refilter_file_size = getfsize(bufname('%'))
      call s:ReFilter_Update()
    endif
  endif
endfunction

" ReFilter_Start - function that starts watching the current file
function! s:ReFilter_Start()
  let b:refilter_file_size = getfsize(bufname('%'))
  let b:refilter_timer_id = timer_start(1000, 'refilter#refilter_tick', {'repeat': -1})
  call s:ReFilter_Update()
endfunction

" ReFilter_Stop - function to stop what Start started
function! s:ReFilter_Stop()
  if exists('b:refilter_timer_id')
    call timer_stop(b:refilter_timer_id)
    unlet b:refilter_timer_id
    unlet b:refilter_file_size
  endif
endfunction

" ReFilter_FilterCurrentBuffer - function that does the main work of filtering
function! s:ReFilter_FilterCurrentBuffer(filterArguments)
  if len(a:filterArguments) == 0
    return
  endif

  let s:end = line('$')

  if s:end == 1
    return
  endif

  normal gg

  let s:i = 1
  while s:i <= s:end
    "echo s:i
    let s:line = getline(s:i)
    "echo s:line
    "echo s:end
    let s:matches = 0
    for s:argument in a:filterArguments
      if s:line =~ s:argument
        let s:matches = 1
        break
      endif
    endfor
    if s:matches == 1
      " skip to next line
      let s:i = s:i + 1
      normal j
    else
      " delete current line and start over
      normal dd
      let s:end = line('$')
    endif
  endwhile
endfunction

"The functionality END ++++++++++++++++++++++++++++++++++++++++++

" adding example command and mapping
command! -nargs=+ ReFilter :call s:ReFilter_FilterCurrentBuffer([<f-args>])

let &cpo = s:save_cpo
unlet s:save_cpo
