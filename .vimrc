for f in split(glob('$HOME/.aix/.*.vim'), '\n')
  exe 'source' f
endfor
