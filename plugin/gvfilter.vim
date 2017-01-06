
" Vim global plugin for continuously filtering the current buffer by
" given filter arguments
" Last Change:  2017 Jan 05 
" Maintainer:	Robert Sarkozi <sarkozi.robert at gmail dot com>
" License:	GPL
" Version:	0.1.0

if exists("g:loaded_gvfilter")
  finish
endif
let g:loaded_gvfilter = 1

let s:save_cpo = &cpo
set cpo&vim

" adding example commands and mappings
command! -nargs=+ GVFilterGFilter :call gvfilter#GVFilter_Filter('g', [<f-args>])
command! -nargs=+ GVFilterVFilter :call gvfilter#GVFilter_Filter('v', [<f-args>])
command! -nargs=0 GVFilterRepeatLast :call gvfilter#GVFilter_Update()
command! -nargs=0 GVFilterStart :call gvfilter#GVFilter_Start()
command! -nargs=0 GVFilterStop :call gvfilter#GVFilter_Stop()

let &cpo = s:save_cpo
unlet s:save_cpo
