augroup project
  autocmd!

  autocmd FileType lua setlocal includeexpr=AwesomeIncludeexpr(v:fname)
augroup END

function! AwesomeIncludeexpr(fname)
  let line = getline('.')
  if line =~ 'home\s*..\s*"'.a:fname.'"'
    return "$HOME/".a:fname
  endif

  return a:fname
endfunction
