"=============================================================================
" FILE: autoload/easyoperator/phrase.vim
" AUTHOR: haya14busa
" Last Change: 03 Feb 2014.
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
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Main:
function! easyoperator#phrase#selectphrase() "{{{
    " Save
    call s:save_values()
    let orig_pos = [line('.'), col('.')]

    let chars = s:GetSearchChar2(0)
    if empty(chars)
        return
    endif
    " TODO: convet regexp
    let re = chars[0] . '\|' . chars[1]

    call EasyMotion#highlight#add_color_group({
        \ g:EasyOperator_phrase_first : 5
        \ })

    " First
    let is_cancelled = EasyMotion#User(re, 0, 2, 0)
    if is_cancelled
        keepjumps call cursor(orig_pos[0], orig_pos[1])
        call s:restore_values()
        return 1
    endif

    let pos1 = [line('.'), col('.')]
    keepjumps call cursor(orig_pos[0], orig_pos[1])

    call EasyMotion#highlight#add_highlight(
        \ '\%'. pos1[0] .'l\%' . pos1[1] . 'c', g:EasyOperator_phrase_first)

    " Second
    let is_cancelled = EasyMotion#User(re, 0, 2, 0)
    if is_cancelled
        keepjumps call cursor(orig_pos[0], orig_pos[1])
        call s:restore_values()
        return 1
    else
        normal! v
        keepjumps call cursor(pos1[0], pos1[1])
        normal! o
        call s:restore_values()
        return 0
    endif
endfunction "}}}
function! easyoperator#phrase#selectphrasedelete() "{{{
    let orig_pos = [line('.'), col('.')]

    " If cancelled?
    if easyoperator#phrase#selectphrase()
        keepjumps call cursor(orig_pos[0], orig_pos[1])
    endif

    " Prepare the number of lines "{{{
    let start_of_line = line("v")
    normal! o
    let end_of_line = line("v")
    "}}}
    normal! d
    if orig_pos[0] < max([start_of_line,end_of_line])
        keepjumps call cursor(orig_pos[0], orig_pos[1])
    else
        " if you delete phrase above cursor line and phrase is over lines
        keepjumps call cursor(orig_pos[0]-abs(end_of_line-start_of_line), orig_pos[1])
    endif
endfunction "}}}
function! easyoperator#phrase#selectphraseyank() "{{{
    let orig_pos = [line('.'), col('.')]

    call easyoperator#phrase#selectphrase()
    normal! y
    keepjumps call cursor(orig_pos[0], orig_pos[1])
endfunction "}}}

" Helper:
function! s:save_values() "{{{
    let s:save_enter_jump_first = g:EasyMotion_enter_jump_first
    let g:EasyMotion_enter_jump_first = 0
    let g:EasyMotion_ignore_exception = 1
endfunction "}}}
function! s:restore_values() "{{{
    let g:EasyMotion_enter_jump_first = s:save_enter_jump_first
    let g:EasyMotion_ignore_exception = 0
    call EasyMotion#highlight#delete_highlight()
endfunction "}}}

function! s:Message(message) " {{{
    echo 'EasyMotion: ' . a:message
endfunction " }}}
function! s:Prompt(message) " {{{
    echohl Question
    echo a:message . ': '
    echohl None
endfunction " }}}
function! s:GetChar() " {{{
    " [[deprecated]] -> EasyMotion#command_line#GetInput()
    let char = getchar()
    if char == 27
        " Escape key pressed
        redraw
        call s:Message('Cancelled')
        return ''
    endif
    return nr2char(char)
endfunction " }}}
function! s:GetSearchChar2(visualmode) " {{{
    " For selectlines and selectphrase
    let chars = []
    for i in [1, 2]
        redraw

        call s:Prompt('Search for character ' . i)
        let char = s:GetChar()

        " Check that we have an input char
        if empty(char)
            " Restore selection
            if ! empty(a:visualmode)
                silent exec 'normal! gv'
            endif
            return ''
        endif
        call add(chars, char)
    endfor
    return chars
endfunction " }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}
