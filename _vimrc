set nu
set rnu
syntax on
set grepprg=rg\ --vimgrep

autocmd FileType rust set efm=%-Gerror:\ could\ not\ compile\ %.%#,%Eerror%.%#:\ %m,%Z%.%#-->\ %f:%l:%c,%-G%.%#
autocmd FileType rust set makeprg=cargo\ build 
autocmd FileType rust set formatprg=rustfmt

autocmd FileType go set efm=%f:%l:%c:\ %m,%-G%.%#
autocmd FileType rust set makeprg=go\ build .
autocmd FileType go set formatprg=gofmt
