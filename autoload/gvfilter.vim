
" Vim global plugin for continouosly filtering the current buffer by
" given filter arguments
" Last Change:  2017 Jan 05
" Maintainer:	Robert Sarkozi <sarkozi.robert@gmail.com>
" License:	GPL
" Version:	0.1.0

"container of arguments emtpy at first
let s:gvfilterArguments = []
let s:gvfilterLastCommand = ''

" GVFilter_Update - function to show current file in preview window,
" go to its end and center it
function! s:GVFilter_Update()
  edit!
  call s:GVFilter_Filter('', [])
endfunction

" gvfilter_tick - the function executed by the timer
" this function needs to be more public than script (s:) scope!
function! gvfilter#gvfilter_tick(timer_id)
  if exists('b:gvfilter_timer_id') && b:gvfilter_timer_id == a:timer_id
    if getfsize(bufname('%')) != b:gvfilter_file_size
      let b:gvfilter_file_size = getfsize(bufname('%'))
      call s:GVFilter_Update()
    endif
  endif
endfunction

" GVFilter_Start - function that starts watching the current file
function! s:GVFilter_Start()
  if len(s:gvfilterLastCommand) == 0
    echo 'GVFilter: Nothing to execute!'
  else
    let b:gvfilter_file_size = getfsize(bufname('%'))
    let b:gvfilter_timer_id = timer_start(1000, 'gvfilter#gvfilter_tick', {'repeat': -1})
    call s:GVFilter_Update()
  endif
endfunction

" GVFilter_Stop - function to stop what Start started
function! s:GVFilter_Stop()
  if exists('b:gvfilter_timer_id')
    call timer_stop(b:gvfilter_timer_id)
    unlet b:gvfilter_timer_id
    unlet b:gvfilter_file_size
  endif
endfunction

" GVFilter_FilterCurrentBuffer - function that does the main work of filtering
function! s:GVFilter_FilterCurrentBuffer(filterArguments)
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
    let s:line = getline(s:i)
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

" GVFilter_Filter - function which filters using the global or inverse (v) command
function! s:GVFilter_Filter(filterCommand, filterArguments)
  "repeat last command, if no parameters are given
  if len(a:filterCommand) == 0 && len(a:filterArguments) == 0
    if len(s:gvfilterLastCommand) == 0
      echo 'GVFilter: Nothing to execute!'
    else
      silent execute s:gvfilterLastCommand
      echo 'GVFilter: Command executed: ' . s:gvfilterLastCommand
    endif
    return
  endif

  "store arguments to be able to run it again and
  let s:len = len(a:filterArguments)
  if s:len > 0
    let s:gvfilterArguments = a:filterArguments
  endif
  let s:len = len(s:gvfilterArguments)

  let s:globalPattern = ':'. a:filterCommand . '/'
  let s:i = 0
  while s:i < s:len
    let s:argument = get(s:gvfilterArguments, s:i)
    if s:i < s:len - 1
      let s:globalPattern = s:globalPattern . s:argument . '\|' 
    else
      let s:globalPattern = s:globalPattern . s:argument
    endif
    let s:i += 1
  endwhile
  let s:globalPattern = s:globalPattern . '/d'

  if len(s:globalPattern) > 0
    let s:gvfilterLastCommand = s:globalPattern
    silent execute s:gvfilterLastCommand
    echo 'GVFilter: Command executed: ' . s:gvfilterLastCommand
  endif
endfunction
