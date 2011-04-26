function! Max(num1, num2)
  if a:num1 > a:num2
    let bigger = a:num1
  else
    let bigger = a:num2
  endif
  return bigger
endfunction

function! Min(num1, num2)
  if a:num1 < a:num2
    let smaller = a:num1
  else
    let smaller = a:num2
  endif
  return smaller
endfunction

function! Align_To_Col(colnum)
  if col(".") < a:colnum
    let diff = a:colnum - col(".")
    exe "normal " . diff . "i \<esc>l"
  else
    let diff = col(".") - a:colnum
    exe "normal " . diff . "X"
  endif
endfunction

function! Align(...) range
  let index   = 1
  let lastcol = 1
  while index <= a:0
    let n      = a:firstline
    let maxcol = 0
    while n <= a:lastline
      exe "normal " . n . "G" . lastcol . "|" . a:{index}
      let col1 = col(".")
      exe "normal ge"
      let col2 = col(".") + 2
      let maxcol = Max( maxcol, Min( col1, col2 ) )
      let n = n + 1
    endwhile
    let n = a:firstline
    while n <= a:lastline
      exe "normal " . n . "G" . lastcol . "|" . a:{index}
      call Align_To_Col( maxcol )
      let n = n + 1
    endwhile
    let lastcol = maxcol
    let index = index + 1
  endwhile
endfunction

