"=============================================================================
" FILE: plugin/easyoperator/phrase.vim
" AUTHOR: haya14busa
" Last Change: 10 Feb 2014.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
scriptencoding utf-8
" Load Once {{{
if expand("%:p") ==# expand("<sfile>:p")
    unlet! g:loaded_easyoperator_phrase
endif
if exists('g:loaded_easyoperator_phrase')
    finish
endif
let g:loaded_easyoperator_phrase = 1
" }}}

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Mapping:
nnoremap <Plug>(easyoperator-phrase-select)
    \ :call easyoperator#phrase#selectphrase()<CR>
onoremap <Plug>(easyoperator-phrase-select)
    \ :call easyoperator#phrase#selectphrase()<CR>
xnoremap <Plug>(easyoperator-phrase-select)
    \ <Esc>:<C-u>call easyoperator#phrase#selectphrase()<CR>

nnoremap <Plug>(easyoperator-phrase-delete)
    \ :call easyoperator#phrase#selectphrasedelete()<CR>
nnoremap <Plug>(easyoperator-phrase-yank)
    \ :call easyoperator#phrase#selectphraseyank()<CR>

let g:EasyOperator_phrase_do_mapping = get(
    \ g:, 'EasyOperator_phrase_do_mapping', 1)
if g:EasyOperator_phrase_do_mapping
        \ && !hasmapto('<Plug>(easyoperator-phrase-select)')
        \ && empty(maparg( '<Plug>(easymotion-prefix)p', 'ov'))
        \ && empty(maparg('d<Plug>(easymotion-prefix)p', 'n' ))
        \ && empty(maparg('y<Plug>(easymotion-prefix)p', 'n' ))

    if !hasmapto('<Plug>(easymotion-prefix)')
        map <Leader><Leader> <Plug>(easymotion-prefix)
    endif

    omap <silent>  <Plug>(easymotion-prefix)p <Plug>(easyoperator-phrase-select)
    xmap <silent>  <Plug>(easymotion-prefix)p <Plug>(easyoperator-phrase-select)
    nmap <silent> d<Plug>(easymotion-prefix)p <Plug>(easyoperator-phrase-delete)
    nmap <silent> y<Plug>(easymotion-prefix)p <Plug>(easyoperator-phrase-yank)
endif

" Highlight:
let s:shade_hl_first_pos = {
    \   'gui'     : ['red' , '#FFFFFF' , 'NONE']
    \ , 'cterm256': ['red' , '242'     , 'NONE']
    \ , 'cterm'   : ['red' , 'grey'    , 'NONE']
    \ }

let g:EasyOperator_phrase_first     = get(g:,
    \ 'EasyOperator_phrase_first', 'EasyOperatorFirstPhrase')
call EasyMotion#highlight#InitHL(g:EasyOperator_phrase_first,
    \ s:shade_hl_first_pos)

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}
