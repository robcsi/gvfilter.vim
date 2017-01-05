
" Vim global plugin for continouosly filtering the current buffer by
" given filter arguments
" Last Change:  2017 Jan 05 
" Maintainer:	Robert Sarkozi <sarkozi.robert@gmail.com>
" License:	GPL
" Version:	0.1.0

if exists("g:loaded_gvfilter")
  finish
endif
let g:loaded_gvfilter = 1

let s:save_cpo = &cpo
set cpo&vim

" adding example commands and mappings
command! -nargs=+ VFilter :call s:GVFilter_Filter('v', [<f-args>])
command! -nargs=+ GFilter :call s:GVFilter_Filter('g', [<f-args>])
command! -nargs=0 GVFilterRepeatLast :call s:GVFilter_Filter('', [])
command! -nargs=0 GVFilterStart :call s:GVFilter_Start()
command! -nargs=0 GVFilterStop :call s:GVFilter_Stop()

let &cpo = s:save_cpo
unlet s:save_cpo
