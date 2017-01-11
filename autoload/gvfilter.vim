
" Vim global plugin for continuously filtering the current buffer by
" given filter arguments
" Last Change:  2017 Jan 11
" Maintainer:	Robert Sarkozi <sarkozi dot robert at gmail dot com>
" License:	GPL
" Version:	0.1.0

"container of arguments emtpy at first
let s:gvfilterArguments = []
"last command empty at first
let s:gvfilterLastCommand = ''

" GVFilter_Update - function to show current file in preview window,
" go to its end and center it
function! gvfilter#GVFilter_Update()
  call gvfilter#GVFilter_Filter('', [])
endfunction

" gvfilter_tick - the function executed by the timer
" this function needs to be more public than script (s:) scope!
function! gvfilter#gvfilter_tick(timer_id)
  if exists('b:gvfilter_timer_id') && b:gvfilter_timer_id == a:timer_id
    if g:gvfilter_onchanged == 1
      if getfsize(bufname('%')) != b:gvfilter_file_size
        let b:gvfilter_file_size = getfsize(bufname('%'))
        call gvfilter#GVFilter_Update()
      endif
    elseif g:gvfilter_onchanged == 0
      call gvfilter#GVFilter_Update()
    endif
  endif
endfunction

" GVFilter_Start - function that starts watching the current file
function! gvfilter#GVFilter_Start()
  if len(s:gvfilterLastCommand) == 0
    echo 'GVFilter: Nothing to execute!'
  else
    if g:gvfilter_onchanged == 1 && !empty(glob(bufname('%')))
      let b:gvfilter_file_size = getfsize(bufname('%'))
    endif
    if !empty(glob(bufname('%')))
      let b:gvfilter_timer_id = timer_start(g:gvfilter_timerinterval, 'gvfilter#gvfilter_tick', {'repeat': -1})
      echo 'GVFilter: Monitoring started.'
      call gvfilter#GVFilter_Update()
    else
      echo 'GVFilter: File doesn''t exist on disk! Monitoring not started.'
    endif
  endif
endfunction

" GVFilter_Stop - function to stop what Start started
function! gvfilter#GVFilter_Stop()
  if exists('b:gvfilter_timer_id')
    call timer_stop(b:gvfilter_timer_id)
    unlet b:gvfilter_timer_id
    if g:gvfilter_onchanged == 1
      unlet b:gvfilter_file_size
    endif
    echo 'GVFilter: Monitoring stopped.'
  endif
endfunction

" GVFilter_ShowLast - function to show the last executed command, if any
function! gvfilter#GVFilter_ShowLast()
  if len(s:gvfilterLastCommand) == 0
    echo 'GVFilter: No command defined!'
  else
    echo 'GVFilter: Last command: ' . s:gvfilterLastCommand
  endif
endfunction

" GVFilter_Filter - function which filters using the global or inverse (v) command
function! gvfilter#GVFilter_Filter(filterCommand, filterArguments)
  "repeat last command, if no parameters are given
  if len(a:filterCommand) == 0 && len(a:filterArguments) == 0
    if len(s:gvfilterLastCommand) == 0
      echo 'GVFilter: Nothing to execute!'
    else
      if g:gvfilter_reload == 1
        silent edit!
      endif
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
    if g:gvfilter_reload == 1
      silent edit!
    endif
    silent execute s:gvfilterLastCommand
    echo 'GVFilter: Command executed: ' . s:gvfilterLastCommand
  endif
endfunction
