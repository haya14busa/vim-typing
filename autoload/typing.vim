"=============================================================================
" FILE: typing.vim
" AUTHOR: haya14busa
" Last Change: 02-Jan-2014.
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
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

function! typing#init(use_range, first_line, last_line) "{{{
    " :h a:firstline
    " :h a:lastline
    " echom 'a:firstline: ' a:firstline
    let config = {}
    if a:use_range !=# -1
        let config.range = {
            \ 'first' : a:first_line,
            \ 'last'  : a:last_line,
            \ }
    endif
    let config.filetype = &filetype
    let text = typing#get_text(config)
    call typing#open(text)
endfunction "}}}

function! typing#get_text(config) "{{{
    if has_key(a:config, 'range')
        return getline(a:config.range.first,
                    \  a:config.range.last)
    else
        return getline(1,'$')
    endif
endfunction "}}}

" Buffer: Open & Close {{{
function! typing#open(text) "{{{
    call typing#_open_text(a:text)
    call typing#_open_input()
    call typing#setautocmd()
    nnoremap <buffer> q :call typing#close()<CR>
    startinsert!
endfunction "}}}
function! typing#_open_text(text) "{{{
    call s:bm_text.open('typing:text')
    call typing#reset()
    call typing#setautocmd()
    call typing#draw_text(a:text)
    setlocal nomodifiable
endfunction "}}}

function! typing#draw_text(text) "{{{
    put = a:text
    exec "1 delete _"
endfunction "}}}

function! typing#_open_input() "{{{
    call s:bm_input.open('typing:input')
    call typing#reset()
endfunction "}}}

function! typing#close() "{{{
    call s:bm_text.close()
    call s:bm_input.close()
    echo 'End'
endfunction "}}}
function! typing#_close_text() "{{{
    cal s:bm_text.close()
endfunction "}}}
function! typing#_close_input() "{{{
    cal s:bm_input.close()
endfunction "}}}

function! typing#is_open() "{{{
    " open -> 1, close -> 0
    " :h tabpagebuflist()
    " :h bufnr()
    return typing#_is_open_text() || typing#_is_open_input()
endfunction "}}}
function! typing#_is_open_text() "{{{
    return index(tabpagebuflist(),bufnr('typing:text')) >=# 0
endfunction "}}}
function! typing#_is_open_input() "{{{
    return index(tabpagebuflist(),bufnr('typing:input')) >=# 0
endfunction "}}}

function! typing#reset() "{{{
    setlocal modifiable
    silent % delete _
    setlocal filetype=typing
    setlocal buftype=nofile
    setlocal number
    nnoremap <buffer> q :call typing#close()<CR>
endfunction "}}}
"}}}

" Match? {{{
function! typing#is_match_whole() "{{{
    " :h getbufline()
    " getbufline({expr}, {lnum} [, {end}])
    let text_content = typing#_get_text_content() "list
    let input_content = typing#_get_input_content() "list

    if len(text_content) !=# len(input_content)
        return 0
    endif

    for lnum in range(max([len(text_content), len(input_content)]))
        if typing#get_linediff_index(lnum) !=# -1
            return 0
        endif
    endfor
    return 1
endfunction "}}}

function! typing#_get_text_content() "{{{
    let buf_num = bufnr('typing:text')
    return getbufline(buf_num, 1 , '$')
endfunction "}}}

function! typing#_get_input_content() "{{{
    let buf_num = bufnr('typing:input')
    return getbufline(buf_num, 1 , '$')
endfunction "}}}

function! typing#get_linediff_index(lnum) "{{{
    " l -> line
    let l_text_content = typing#_get_text_content()[a:lnum]
    let l_input_content = typing#_get_input_content()[a:lnum]
    return s:S.diffidx(l_text_content, l_input_content)
endfunction "}}}

" }}}

" Autocommands {{{
" :h TextChanged , :h TextChangedI
function! typing#setautocmd() "{{{
    augroup plugin-typing
        autocmd!
        autocmd CursorMovedI,InsertLeave,TextChanged
            \ <buffer> call typing#check()
    augroup END
endfunction "}}}

" }}}

function! typing#check() "{{{
    let is_match = typing#is_match_whole()
    if is_match ==# 1
        exec 'normal! \<Esc>'
        call typing#reset()
        echom 'End!'
        return
    endif
endfunction
"}}}

" Creates a new Vital object {{{
let s:V = vital#of('vim-typing')

" BufferManager
" :h vital-vim-buffer_manager.txt
let s:BM = s:V.import('Vim.BufferManager')
let s:bm_text = s:BM.new()
let s:bm_input = s:BM.new()
call s:bm_text.config({
      \   'range' : 'tabpage',
      \   'opener' : 'tabnew'
      \ })

call s:bm_input.config({
    \   'range' : 'tabpage',
    \   'opener' : 'belowright split'
    \ })

" String
" :h vital-data-string.txt
let s:S = s:V.import('Data.String')

" Random
" :h vital-random-xor128.txt
let s:X = s:V.import('Random.Xor128')

"}}}

" Test of Vital Import {{{
function! typing#TestBufferManager() "{{{
    " creates new manager
	let m = s:BM.new()
	" opens a new buffer named 'Test' to a new window
	call m.open('Test')
    " gets the config value
    echom m.config('range')
    return m.config('range') " -> 'tabpage'
endfunction "}}}
function! typing#TestDataString() "{{{
	return s:S.replace("fooba.bazbar", "ba.", "zzz")
	" -> foozzzbazbar
endfunction "}}}
function! typing#TestRandom() "{{{
    return s:X.rand()
endfunction "}}}
"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}

" __END__
" vim: foldmethod=marker
