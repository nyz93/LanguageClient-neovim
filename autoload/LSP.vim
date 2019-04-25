" TODO: make buffer aware.
"
function! LSP#reresolve(path)
	if get(g:, "LanguageClient_unresolveFilenames")
		let l:real_pwd = trim(system("pwd"), "\r\n ")
		let l:resolved_pwd = getcwd()
		if l:real_pwd != l:resolved_pwd
			return substitute(a:path, "^" . l:real_pwd, l:resolved_pwd, "")
		else
			return a:path
		endif
	else
		return a:path
	endif
endfunction
function! LSP#unresolve(path)
	if get(g:, "LanguageClient_unresolveFilenames")
		let l:real_pwd = trim(system("pwd"), "\r\n ")
		let l:resolved_pwd = getcwd()
		if l:real_pwd != l:resolved_pwd
			return substitute(a:path, "^" . l:resolved_pwd, l:real_pwd, "")
		else
			return a:path
		endif
	else
		return a:path
	endif
endfunction
function! LSP#filename() abort
    " When executing autocommand, `%` might have already changed.
    let l:filename = expand('<afile>:p')
    if !l:filename
        let l:filename = expand('%:p')
    endif
    return LSP#unresolve(l:filename)
endfunction

" This function will return buffer text as required by LSP.
"
" The main difference with getbufline is that it checks fixendofline settings
" and add extra line at ending if appropriate.
function! LSP#text(...) abort
    let l:buf = get(a:000, 0, '')

    let l:lines = getbufline(l:buf, 1, '$')
    if len(l:lines) > 0 && l:lines[-1] !=# '' && &fixendofline
        let l:lines += ['']
    endif
    return l:lines
endfunction

function! LSP#line() abort
    return line('.') - 1
endfunction

function! LSP#character() abort
    return col('.') - 1
endfunction

function! LSP#range_start_line() abort
    let l:lnum = v:lnum ? v:lnum : getpos("'<")[1]
    return l:lnum - 1
endfunction

function! LSP#range_end_line() abort
    if v:lnum
        return v:lnum - 1 + v:count
    endif

    return getpos("'>")[1]
endfunction

function! LSP#viewport() abort
    return {
        \ 'start': line('w0') - 1,
        \ 'end': line('w$'),
        \ }
endfunction

function! LSP#position() abort
	return {
		\ 'line': LSP#line(),
		\ 'character': LSP#character(),
		\ }
endfunction
