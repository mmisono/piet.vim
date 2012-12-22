" Vim syntax file
" Language:	piet-vim

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

"red
syn match PietLightRed              "lR"
syn match PietNormalRed             "nR"
syn match PietDarkRed               "dR"
"yellow
syn match PietLightYellow           "lY"
syn match PietNormalYellow          "nY"
syn match PietDarkYellow            "dY"
"green
syn match PietLightGreen            "lG"
syn match PietNormalGreen           "nG"
syn match PietDarkGreen             "dG"
"cyan
syn match PietLightCyan             "lC"
syn match PietNormalCyan            "nC"
syn match PietDarkCyan              "dC"
"blue
syn match PietLightBlue             "lB"
syn match PietNormalBlue            "nB"
syn match PietDarkBlue              "dB"
"magenta
syn match PietLightMagenta          "lM"
syn match PietNormalMagenta         "nM"
syn match PietDarkMagenta           "dM"
"white
syn match PietWhite                 "WW"
syn match PietBlack                 "KK"


hi PietLightRed      ctermfg=lightred ctermbg=lightred guifg=#ffc0c0 guibg=#ffc0c0
hi PietNormalRed     ctermfg=red ctermbg=red guifg=#ff0000 guibg=#ff0000
hi PietDarkRed       ctermfg=darkred ctermbg=darkred guifg=#c00000 guibg=#c00000

hi PietLightYellow   ctermfg=lightyellow ctermbg=lightyellow guifg=#ffffc0 guibg=#ffffc0
hi PietNormalYellow  ctermfg=yellow ctermbg=yellow guifg=#ffff00 guibg=#ffff00
hi PietDarkYellow    ctermfg=darkyellow ctermbg=darkyellow guifg=#c0c000 guibg=#c0c000

hi PietLightGreen    ctermfg=lightgreen ctermbg=lightgreen guifg=#c0ffc0 guibg=#c0ffc0
hi PietNormalGreen   ctermfg=green ctermbg=green guifg=#00ff00 guibg=#00ff00
hi PietDarkGreen     ctermfg=darkgreen ctermbg=darkgreen guifg=#00c000 guibg=#00c000

hi PietLightCyan     ctermfg=lightcyan ctermbg=lightcyan guifg=#c0ffff guibg=#c0ffff
hi PietNormalCyan    ctermfg=cyan ctermbg=cyan guifg=#00ffff guibg=#00ffff
hi PietDarkCyan      ctermfg=darkcyan ctermbg=darkcyan guifg=#00c0c0 guibg=#00c0c0

hi PietLightBlue     ctermfg=lightblue ctermbg=lightblue guifg=#c0c0ff guibg=#c0c0ff
hi PietNormalBlue    ctermfg=blue ctermbg=blue guifg=#0000ff guibg=#0000ff
hi PietDarkBlue      ctermfg=darkblue ctermbg=darkblue guifg=#0000c0 guibg=#0000c0

hi PietLightMagenta  ctermfg=lightmagenta ctermbg=lightmagenta guifg=#ffc0ff guibg=#ffc0ff
hi PietNormalMagenta ctermfg=magenta ctermbg=magenta guifg=#ff00ff guibg=#ff00ff
hi PietDarkMagenta   ctermfg=darkmagenta ctermbg=darkmagenta guifg=#c000c0 guibg=#c000c0

hi PietWhite         ctermfg=white ctermbg=white guifg=#ffffff guibg=#ffffff
hi PietBlack         ctermfg=black ctermbg=black guifg=#000000 guibg=#000000

let b:current_syntax = "piet"
