
" Vim global plugin for continuously filtering the current buffer by
" given filter arguments
" Last Change:  2017 Jan 11
" Maintainer:	Robert Sarkozi <sarkozi dot robert at gmail dot com>
" License:	GPL
" Version:	0.1.0

if exists("g:loaded_gvfilter")
  finish
endif
let g:loaded_gvfilter = 1

let s:save_cpo = &cpo
set cpo&vim

" how oftern should the timer tick, in miliseconds
" default: 1000, in miliseconds
let g:gvfilter_timerinterval = 1000

" whether or not to reload the file before executing the next command
" default: 1 - enabled
let g:gvfilter_reload = 1

" whether to reload the file only when it's changed or always
" default: 0 - always; set to 1 to only reload if file changed
let g:gvfilter_onchanged = 0

" adding example commands and mappings
command! -nargs=+ GVFilterGFilter :call gvfilter#GVFilter_Filter('g', [<f-args>])
command! -nargs=+ GVFilterVFilter :call gvfilter#GVFilter_Filter('v', [<f-args>])
command! -nargs=0 GVFilterRepeatLast :call gvfilter#GVFilter_Update()
command! -nargs=0 GVFilterStart :call gvfilter#GVFilter_Start()
command! -nargs=0 GVFilterStop :call gvfilter#GVFilter_Stop()
command! -nargs=0 GVFilterShowLast :call gvfilter#GVFilter_ShowLast()

let &cpo = s:save_cpo
unlet s:save_cpo
