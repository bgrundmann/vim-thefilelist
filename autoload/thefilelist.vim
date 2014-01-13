function! thefilelist#Refresh()
  pedit TheFileList
  wincmd P
  setlocal buftype=nofile modifiable noswapfile 
  silent! read !hg status -A -q -u
  if v:shell_error 
    normal! 1Gdd
    silent! read !find . \( -type d -name .hg -prune \) -o \( -type f -print \)
  endif
  normal! 1Gdd
  silent! %s/^. //
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
  wincmd gf
  tabprev
  wincmd P
  wincmd c
  tabnext
endfunction
