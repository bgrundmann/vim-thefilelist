function! thefilelist#Refresh()
  pedit TheFileList
  wincmd P
  setlocal buftype=nofile modifiable noswapfile 
  silent! read !hg status -A -q -u
  if v:shell_error 
    normal! 1Gdd
    silent! read !find . \( -type d -name .hg -prune \) -o \( -type f -print \)
  else
    " remove hg status indicator 
    silent! %s/^. //
  endif
  " read !... leaves a blank line at the beginning
  silent! normal! 1Gdd
  " turn / into space -- this assumes gdefault is set 
  silent! %s/\// /
  nohlsearch
  setlocal buftype=nofile bufhidden=hide noswapfile nowrap nomodifiable 
endfunction

function! thefilelist#Display()
  let n = bufexists("TheFileList")
  if n ==# 0 
    silent! pedit TheFileList
    wincmd P
    noremap <buffer> <cr> :call thefilelist#Open()<cr>
    noremap <buffer> <C-L> :call thefilelist#Refresh()<cr>
  endif
  " Always refresh the file list if it is less than a 1000 lines
  if line('$') <# 1000 
    call thefilelist#Refresh()
  endif
endfunction

function! thefilelist#Open()
  let l=getline('.')
  let filename=substitute(l, ' ', '/', 'g')
  wincmd c
  silent! execute 'tabe ' . filename
endfunction
