"=============================================================================
" Name: piet.vim
" Author: mfumi
" Email: m.fumi760@gmail.com
" Description: Piet
" Last Change: 22-12-2012 
" Version: 0.10
" ----------------------------------------------------------------------------

if exists('g:loaded_piet_vim')
    finish
endif
let g:loaded_piet_vim = 1

let s:save_cpo = &cpo
set cpo&vim
" ----------------------------------------------------------------------------

let s:current_color = "nR"  " normal red
let s:prev_color = ""
let s:under_color = ""
let s:current_command = ""
let s:colors = 
   \ { "lR" : "light  red     " , "nR" : "normal red     " , "dR" : "dark   red     ",
   \   "lY" : "light  yellow  " , "nY" : "normal yellow  " , "dY" : "dark   yellow  ",
   \   "lG" : "light  green   " , "nG" : "normal green   " , "dG" : "dark   green   ",
   \   "lC" : "light  cyan    " , "nC" : "normal cyan    " , "dC" : "dark   cyan    ",
   \   "lB" : "light  blue    " , "nB" : "normal blue    " , "dB" : "dark   blue    ",
   \   "lM" : "light  magenta " , "nM" : "normal magenta " , "dM" : "dark   magenta ",
   \   "WW" : "white          ",
   \   "KK" : "black          "}
let s:colors_num = 
   \ { "lR" : ["255","192","192"] , "nR" : ["255",  "0",  "0"], "dR" : ["192",  "0",  "0"],
   \   "lY" : ["255","255","192"] , "nY" : ["255","255",  "0"], "dY" : ["192","192",  "0"],
   \   "lG" : ["192","255","192"] , "nG" : [  "0","255",  "0"], "dG" : [  "0","192",  "0"],
   \   "lC" : ["192","255","255"] , "nC" : [  "0","255","255"], "dC" : [  "0","192","192"],
   \   "lB" : ["192","192","255"] , "nB" : [  "0",  "0","255"], "dB" : [  "0",  "0","192"],
   \   "lM" : ["255","192","255"] , "nM" : ["255",  "0","255"], "dM" : ["192",  "0","192"],
   \   "WW" : ["255","255","255"],
   \   "KK" : ["0","0","0"]}
let s:colors_num_r = 
   \ { '["255","192","192"]': "lR", '["255","  0","  0"]':"nR", '["192","  0","  0"]':"dR",
   \   '["255","255","192"]': "lY", '["255","255","  0"]':"nY", '["192","192","  0"]':"dY",
   \   '["192","255","192"]': "lG", '["  0","255","  0"]':"nG", '["  0","192","  0"]':"dG",
   \   '["192","255","255"]': "lC", '["  0","255","255"]':"nC", '["  0","192","192"]':"dC",
   \   '["192","192","255"]': "lB", '["  0","  0","255"]':"nB", '["  0","  0","192"]':"dB",
   \   '["255","192","255"]': "lM", '["255","  0","255"]':"nM", '["192","  0","192"]':"dM",
   \   '["255","255","255"]': "WW",
   \   '["  0","  0","  0"]': "KK" }
let s:hi_names = 
   \{ "lR" : "PietLightRed"    , "nR" : "PietNormalRed"    , "dR" : "PietDarkRed",
   \  "lY" : "PietLightYellow" , "nY" : "PietNormalYellow" , "dY" : "PietDarkYellow",
   \  "lG" : "PietLightGreen"  , "nG" : "PietNormalGreen"  , "dG" : "PietDarkGreen",
   \  "lC" : "PietLightCyan"   , "nC" : "PietNormalCyan"   , "dC" : "PietDarkCyan",
   \  "lB" : "PietLightBlue"   , "nB" : "PietNormalBlue"   , "dB" : "PietDarkBlue",
   \  "lM" : "PietLightMagenta", "nM" : "PietNormalMagenta", "dM" : "PietDarkMagenta",
   \  "WW" : "PietWhite", "KK" : "PietBlack"}

" {"command name" , [lightness change, hue change]}
let s:commands = 
    \{                    "push":       [1,0], "pop":       [2,0],
    \  "add":      [0,1], "subtract":   [1,1], "multiply":  [2,1],
    \  "divide":   [0,2], "mod":        [1,2], "not":       [2,2],
    \  "greater":  [0,3], "pointer":    [1,3], "switch":    [2,3],
    \  "duplicate":[0,4], "roll":       [1,4], "in(number)":[2,4],
    \  "in(char)": [0,5], "out(number)":[1,5], "out(char)": [2,5]}
let s:commands_r = 
    \{                      "[1,0]":"push"       , "[2,0]":"pop"       ,
    \  "[0,1]":"add"      , "[1,1]":"subtract"   , "[2,1]":"multiply"  ,
    \  "[0,2]":"divide"   , "[1,2]":"mod"        , "[2,2]":"not"       ,
    \  "[0,3]":"greater"  , "[1,3]":"pointer"    , "[2,3]":"switch"    ,
    \  "[0,4]":"duplicate", "[1,4]":"roll"       , "[2,4]":"in(number)",
    \  "[0,5]":"in(char)" , "[1,5]":"out(number)", "[2,5]":"out(char)" }

let s:hue_cycle = ["R","Y","G","C","B","M"]
let s:lightness_cycle = ["l","n","d"]

"move
function! s:correct_pos()
    let cur_col = col('.')
    if (cur_col % 2 == 0)
        call cursor(0,cur_col-1)
    endif
endfunction

function! s:move(dir)
    let s:prev_color = s:under_color
    exe "normal! ".a:dir
    call s:correct_pos()
endfunction


"color
function! s:echo_current_status()
    call s:correct_pos()
    let s:under_color = getline(".")[col(".")-1:col(".")]
    if(has_key(s:colors,s:under_color) == 0)
        let s:under_color = ""
    endif
    if (has_key(s:colors,s:current_color) == 1)
        echon s:colors[s:current_color]
        exe "echohl ".s:hi_names[s:current_color] 
        exe "echon  '".s:current_color."'"
        echohl None
        echon "   "
        echohl Statement
        exe "echon '".printf("%11s",s:current_command)."'"
        echohl None
        echon " |    "
        if(s:under_color != "")
            echon s:colors[s:under_color]
            exe "echohl ".s:hi_names[s:under_color] 
            exe "echon  '".s:under_color."'"
            echohl None
            echon "   "
            if(s:under_color != "WW" && s:under_color != "KK" && 
            \   s:prev_color != "WW" && s:prev_color != "KK")
                let lightness_change = 
                        \  index(s:lightness_cycle,s:under_color[0]) -
                        \  index(s:lightness_cycle,s:prev_color[0])
                if (lightness_change < 0)
                    let lightness_change += len(s:lightness_cycle)
                endif
                let hue_change = index(s:hue_cycle,s:under_color[1]) -
                            \    index(s:hue_cycle,s:prev_color[1])
                if (hue_change < 0)
                    let hue_change += len(s:hue_cycle)
                endif
                let key = printf("[%d,%d]",lightness_change,hue_change)
                if(has_key(s:commands_r,key) == 1)
                    echohl Statement
                    exe "echon '".s:commands_r[key]."'"
                    echohl None
                endif
            endif
        endif
    endif
endfunction

function! s:set_current_color(c)
    if (has_key(s:colors,a:c) == 1)
        let s:current_color = a:c
        let s:current_command = ""
        call s:echo_current_status()
    endif
endfunction

function! s:set_under_color()
    call s:set_current_color(s:under_color)
endfunction

function! s:set_color(dir)
    if (col('$') - col(".") == 2)
        exe "normal! 2xa".s:current_color
    else
        exe "normal! 2xi".s:current_color
    endif
    if (a:dir == "j")
        if (line(".") == line("$"))
            call append(line("$"),repeat("W",col(".")))
        else
            let l = getline(line(".")+1)
            if(len(l) < col("."))
                let l .= repeat("W",col(".")-len(l))
                call setline(line(".")+1,l)
            endif
        end
    elseif (a:dir == "k")
        if (line(".") != 1)
            let l = getline(line(".")-1)
            if(len(l) < col("."))
                let l .= repeat("W",col(".")-len(l))
                call setline(line(".")-1,l)
            endif
        endif
    elseif (a:dir == "l")
        if (col(".") == (col("$")-1))
            let l = getline(".")."WW"
            call setline(".",l)
        endif
    endif
    exe "normal! ".a:dir
    call s:correct_pos()
    let s:under_color = "WW"
endfunction

function! s:change_color(command)
    if (has_key(s:commands,a:command) == 1)
        if(s:current_color != "WW" && s:current_color != "KK")
            let new_lightness = (index(s:lightness_cycle,s:current_color[0]) + 
                    \   s:commands[a:command][0]) % len(s:lightness_cycle) 
            let new_hue = (index(s:hue_cycle,s:current_color[1]) + 
                    \   s:commands[a:command][1]) % len(s:hue_cycle) 
            let s:current_color = 
                    \ s:lightness_cycle[new_lightness].s:hue_cycle[new_hue]
            let s:current_command = a:command
            call s:echo_current_status()
        endif
    endif
endfunction

function! s:piet_edit()
    "misc
    nnoremap <silent> <buffer> c :call<space><SID>set_under_color()<CR>
    nnoremap <silent> <buffer> H :call<space><SID>set_color("2h")<CR>
    nnoremap <silent> <buffer> J :call<space><SID>set_color("j")<CR>
    nnoremap <silent> <buffer> L :call<space><SID>set_color("l")<CR>
    nnoremap <silent> <buffer> K :call<space><SID>set_color("k")<CR>
    nnoremap <silent> <buffer> a la
    let i = char2nr(" ")
    while( i < char2nr("z"))
        silent exe "inoremap <silent> <buffer> ".nr2char(i) ." <NOP>"
        let i += 1
    endwhile

    "command
    let command_maps = {
                    \                  "push":        "U", "pop":       "OO",
                    \ "add":      "+", "subtract":    "-", "multiply":   "*",
                    \ "divide":   "/", "mod":         "%", "not":        "N",
                    \ "greater":  ">", "pointer":     "P", "switch":     "S",
                    \ "duplicate":"D", "roll":        "R", "in(number)":"IN",
                    \ "in(char)":"IC", "out(number)":"ON", "out(char)": "OC"}
    for c in keys(command_maps)
        exe "nnoremap <silent> <buffer> ".command_maps[c] ." :call <SID>change_color('".c."')<CR>"
    endfor

    "move
    nnoremap <silent> <buffer> <C-v> <C-v>l
    nnoremap <silent> <buffer> l :call<space><SID>move("2l")<CR>
    nnoremap <silent> <buffer> h :call<space><SID>move("h")<CR>
    nnoremap <silent> <buffer> k :call<space><SID>move("k")<CR>
    nnoremap <silent> <buffer> j :call<space><SID>move("j")<CR>
    nnoremap <silent> <buffer> v vl
    nnoremap <silent> <buffer> <C-v> <C-v>l
    nnoremap <silent> <buffer> x 2x
    vnoremap <silent> <buffer> l 2l
    vnoremap <silent> <buffer> h 2h
    inoremap <silent> <buffer> <BS> <BS><BS>
    inoremap <silent> <buffer> <ESC> <ESC>h

    " red,yellow,green,cyan,blue,magenta
    for C in s:hue_cycle
        let c = tolower(C)
        exe "inoremap <silent> <buffer> "."<c-".c.">"      ." l".C
        exe "inoremap <silent> <buffer> ".c                ." n".C
        exe "inoremap <silent> <buffer> ".C                ." d".C
        exe "nnoremap <silent> <buffer> "."<C-c><C-".c.">" ." :call <SID>set_current_color('l".C."')<CR>"
        exe "nnoremap <silent> <buffer> "."<C-c>".c        ." :call <SID>set_current_color('n".C."')<CR>"
        exe "nnoremap <silent> <buffer> "."<C-c>".C        ." :call <SID>set_current_color('d".C."')<CR>"
        exe "nmap     <silent> <buffer> "."r<C-".c.">"     ." vr<C-".c.">"
        exe "nmap     <silent> <buffer> "."r".c            ." vlr".c
        exe "nmap     <silent> <buffer> "."r".C            ." vlr".C
        exe "vnoremap <silent> <buffer> "."r<C-".c.">"     ." mZrz:%s/zz/l".C."/g<CR>`Zh"
        exe "vnoremap <silent> <buffer> "."r".c            ." mZrz:%s/zz/n".C."/g<CR>`Zh"
        exe "vnoremap <silent> <buffer> "."r".C            ." mZrz:%s/zz/d".C."/g<CR>`Zh"
    endfor

    "white
    inoremap <silent> <buffer> w WW
    nnoremap <silent> <buffer> <C-c>w :call <SID>set_current_color('WW')<CR>
    nmap <silent> <buffer> rw vrw
    vnoremap <silent> <buffer> rw mZrz:%s/zz/WW/g<CR>`Zh
    "black
    inoremap <silent> <buffer> k KK
    nnoremap <silent> <buffer> <C-c>k :call <SID>set_current_color('KK')<CR>
    nmap <silent> <buffer> rk vrk
    vnoremap <silent> <buffer> rk mZrz:%s/zz/KK/g<CR>`Zh

    augroup PietAutoCmd
        autocmd!
        autocmd CursorMoved <buffer> call s:echo_current_status()
    augroup END
    setl ft=piet
endfunction

function! s:check_size()
    let lines = getline(1,line("$"))
    let width = len(lines[0])
    if (width % 2 != 0)
        return 0
    endif
    for l in lines[1:]
        if len(l) != width
            return 0 "no
        endif
    endfor
    return 1 "ok
endfunction

function! s:save_as_ppm(name,...)
    " codel size
    if(a:0 >= 2)
        let cx = a:1
        let cy = a:2
        if(cx < 0 || cy < 0)
            echohl Error
            echo   "invalid codel size"
            echohl None
            return 
        endif
    else
        let cx = 1 "default size
        let cy = 1
    endif
    
    if(s:check_size() == 0)
        echohl Error
        echo   "this file is not square"
        echohl None
        return 
    endif

    let width = col("$")-1
    let height = line("$")
    let f = []
    call add(f,"P3")
    call add(f,"# a piet program ".a:name)
    call add(f,printf("%d %d",(width/2)*cx,(height*cy)))
    call add(f,"255")
    let cnt = 0
    let t = ""
    for _l in getline(0,line("$"))
        for i in range(cy)
            let l = _l
            while(len(l))
                let c = l[0:1]
                let l = l[2:]
                for j in range(cx)
                    if(has_key(s:colors_num,c))
                        let t .= printf("%3s %3s %3s ",s:colors_num[c][0],
                                    \s:colors_num[c][1],s:colors_num[c][2])
                        let cnt += 1
                        if(cnt % 5 == 0)
                            call add(f,t)
                            let t = ""
                        endif
                    else
                        echohl Error
                        echo   "this file is not for piet"
                        echo   "invalid color: ".c
                        echohl None
                        return 
                    endif
                endfor
            endwhile
        endfor
    endfor
    if(t != "")
        call add(f,t)
    endif
    call writefile(f,a:name)
    echo "done."
endfunction

function! s:read_from_ppm(name,...)
    new
    let f = readfile(a:name)
    if (f[0] != "P3")
        echoerr "the file is not ppm(P3)"
        return
    endif
    let i = 1
    while(f[i][0] == "#") "skip comment
        let i = i+1
    endwhile
    let size = split(f[i])
    if (len(size) != 2)
        echoerr "the file is not ppm(P3)"
        retur
    endif
    let width  = size[0]
    let height = size[1]
    while(f[i][0] == "#") "skip comment
        let i = i+1
    endwhile
    let i += 1
    if (f[i] != "255") " number of colors
        echohl WarningMsg 
        echo "number of colors is expected to 255"
        echohl None
    endif
    let i = i+1

    let w_cnt = 0
    let h_cnt = 0
    let buffer = []
    let rgb = []
    let t = ""
    for l in f[i :]
        if (l[0] == "#") "skip comment
            continue
        endif
        for c in split(l)
            call add(rgb,c)
            if(len(rgb) == 3)
                let key = printf('["%3d","%3d","%3d"]',rgb[0],rgb[1],rgb[2])
                if (has_key(s:colors_num_r,key))
                    let t .= s:colors_num_r[key]
                else
                    " unknown color are treated as white
                    let t .= "WW" 
                endif
                let w_cnt += 1
                let rgb = []
                if(w_cnt >= width)
                    call add(buffer,t)
                    let t = ""
                    let w_cnt = 0
                    let h_cnt += 1
                endif
            endif
        endfor
    endfor
    if(h_cnt != height)
        echoerr "invalid ppm"
        return
    endif

    " codel size
    if(a:0 >= 2)
        let cx = a:1
        let cy = a:2
        if(cx < 0 || cy < 0)
            echoerr "invalid codel size"
            return 
        endif
    else
        "guess
        "look about the smallest continuous pixels
        let x_min = 100000
        let y_min = 100000

        let y = 0
        while (y < height)
            let x = 2
            let prev_color = buffer[y][0:1]
            let cnt = 1
            while (x < width*2)
                if(buffer[y][x : x+1] == prev_color)
                    let cnt += 1
                else
                    if(cnt < x_min)
                        let x_min = cnt
                    endif
                    let prev_color = buffer[y][x : x+1]
                    let cnt = 1
                endif
                let x += 2
            endwhile
            let y += 1
        endwhile
        if(cnt < x_min)
            let x_min = cnt
        endif

        let x = 0
        while (x < width*2)
            let y = 1
            let prev_color = buffer[0][x : x+1]
            let cnt = 1
            while (y < height)
                if(buffer[y][x : x+1] == prev_color)
                    let cnt += 1
                else
                    if(cnt < y_min)
                        let y_min = cnt
                    endif
                    let prev_color = buffer[y][x : x+1]
                    let cnt = 1
                endif
                let y += 1
            endwhile
            let x += 2
        endwhile
        if(cnt < y_min)
            let y_min = cnt
        endif

        let cx = x_min
        let cy = y_min
    endif

    "lowering
    let new_buffer = []
    let y = 0
    while (y < height)
        let x = 0
        let t = ""
        while (x < width*2)
            let t .= buffer[y][x : x+1]
            let x += cx*2
        endwhile
        call add(new_buffer,t)
        let y += cy
    endwhile

    " %d _
    call setline(1,new_buffer)
    call s:piet_edit()
endfunction


" I consulted the npiet source for this
let s:piet_interpreter = {}

function! s:piet_interpreter.new()
    let obj = deepcopy(self)
    let ret = obj.init()
    if (ret == -1)
        return 0
    endif
    call remove(obj,"new")
    call remove(obj,"init")
    return obj
endfunction

function! s:piet_interpreter.init()
    let self.x = 0
    let self.y = 0
    let self.next_x = 0
    let self.next_y = 0
    let self.width = (col("$")-1)/2
    let self.height = line("$")
    let self.stack = []
    let self.sp = 0
    let self.dp = "r"
    let self.cc = "l"

    let self.cells = []
    let lines = getline(1,line("$"))
    for l in lines
        let x = 0
        let cs = []
        while x < len(l)
            let c = l[x : x+1]
            if !has_key(s:colors,c)
                " error
                return -1
            endif
            let cs += [c]
            let x += 2
        endwhile
        let self.cells += [cs]
    endfor
endfunction

function! s:piet_interpreter.check(x,y)
    return (a:x >= 0 && a:y >= 0 && a:x < self.width && a:y < self.height)
endfunction

function! s:piet_interpreter.get_cell(x,y)
    if (self.check(a:x,a:y))
        return self.cells[a:y][a:x]
    else
        return ""
    endif
endfunction

function! s:piet_interpreter.set_cell(x,y,c)
    if (self.check(a:x,a:y))
        let self.cells[a:y][a:x] = a:c
    else
        echoerr printf("<set cell> error: out of range (x,y)",a:x,a:xy)
    endif
endfunction

function! s:piet_interpreter.dp_dx()
    if (self.dp == "l")
        return -1
    elseif (self.dp == "r")
        return 1
    else
        return 0
    endif
endfunction

function! s:piet_interpreter.dp_dy()
    if (self.dp == "u")
        return -1
    elseif (self.dp == "d")
        return 1
    else
        return 0
    endif
endfunction

function! s:piet_interpreter.toggle_cc()
    if (self.cc == "r")
        let self.cc = "l"
    else
        let self.cc = "r"
    endif
endfunction

function! s:piet_interpreter.turn_dp()
    if (self.dp == "r")
        let self.dp = "d"
    elseif (self.dp == "d")
        let self.dp = "l"
    elseif (self.dp == "l")
        let self.dp = "u"
    else
        let self.dp = "r"
    endif
endfunction

function! s:piet_interpreter.turn_dp_inv()
    if (self.dp == "r")
        let self.dp = "u"
    elseif (self.dp == "u")
        let self.dp = "l"
    elseif (self.dp == "l")
        let self.dp = "d"
    else
        let self.dp = "r"
    endif
endfunction

" find a edge in dp/cc direction
let s:MARK = "XX"
function! s:piet_interpreter.check_connected_cell(x,y)
    let c = self.get_cell(a:x,a:y)
    
    if (c == ""  || c != self.current_color || c == s:MARK)
        return -1
    endif

    let found = 0

    if (self.dp == 'l' && a:x <= self.next_x)  " left
        if( a:x < self.next_x
\       ||  (self.cc == 'l' && a:y > self.next_y)
\       ||  (self.cc == 'r' && a:y < self.next_y))
            let found = 1
        endif
    elseif (self.dp == 'r' && a:x >= self.next_x)  " right
        if( a:x > self.next_x
\       ||  (self.cc == 'l' && a:y < self.next_y)
\       ||  (self.cc == 'r' && a:y > self.next_y))
            let found = 1
        endif
    elseif (self.dp == 'u' && a:y <= self.next_y)  " up
        if( a:y < self.next_y
\       ||  (self.cc == 'l' && a:x < self.next_x)
\       ||  (self.cc == 'r' && a:x > self.next_x))
            let found = 1
        endif
    elseif (self.dp == 'd' && a:y >= self.next_y)  " down
        if( a:y > self.next_y
\       ||  (self.cc == 'l' && a:x > self.next_x)
\       ||  (self.cc == 'r' && a:x < self.next_x))
            let found = 1
        endif
    endif

    if (found)
        let self.next_x = a:x
        let self.next_y = a:y
    endif

    call self.set_cell(a:x,a:y,s:MARK)

    let self.num_current_cells += 1

    call self.check_connected_cell(a:x+1,a:y+0)
    call self.check_connected_cell(a:x+0,a:y+1)
    call self.check_connected_cell(a:x-1,a:y+0)
    call self.check_connected_cell(a:x+0,a:y-1)

    return 0
endfunction

function! s:piet_interpreter.reset_connected_cell(x,y)
    let c = self.get_cell(a:x,a:y)

    if (c == ""  || c != s:MARK)
        return -1
    endif

    call self.set_cell(a:x,a:y,self.current_color)

    call self.reset_connected_cell(a:x+1,a:y+0)
    call self.reset_connected_cell(a:x+0,a:y+1)
    call self.reset_connected_cell(a:x-1,a:y+0)
    call self.reset_connected_cell(a:x+0,a:y-1)
endfunction

function! s:piet_interpreter.piet_walk_border_do()
    let self.num_current_cells = 0
    let r = self.check_connected_cell(self.x,self.y)
    if (r >= 0)
        call self.reset_connected_cell(self.x,self.y)
    else
        echoerr "internal error"
    endif
    return r
endfunction

function! s:piet_interpreter.step()
    let self.current_color = self.get_cell(self.x,self.y)
    let white_crossed = (self.current_color == "WW")
    let toggle_cnt = 0

    if (self.current_color == "KK") "black
        "error
        echoerr "we are at black cell..."
        return -1
    endif

    " try
    for i in range(8)
        let self.next_x = self.x
        let self.next_y = self.y
        if (self.current_color == "WW")
            let self.num_current_cells = 1
        else
            let r = self.piet_walk_border_do()
            if (r < 0)
                return -1
            endif
        endif
        let adj_x = self.next_x + self.dp_dx()
        let adj_y = self.next_y + self.dp_dy()
        let adj_color = self.get_cell(adj_x,adj_y)

        " white
        if (adj_color == "WW")
            while (adj_color == "WW")
                let adj_x = adj_x + self.dp_dx()
                let adj_y = adj_y + self.dp_dy()
                let adj_color = self.get_cell(adj_x,adj_y)
            endwhile
            if ((adj_color != "") && (adj_color != "KK"))
                "find a valid cell
                let white_crossed = 1
            else
                if (!self.stay_white)
                     " follow 'Clarification of white block behaviour
                     " (added 25 January, 2008)'
                     " this behavior is same as 'npiet -v11' (npiet ver1.3)
                     " this is default
                    let white_crossed = 1
                    let visited = []
                    while (adj_color == "" || adj_color == "KK")
                        let adj_color = "WW"
                        let adj_x -= self.dp_dx()
                        let adj_y -= self.dp_dy()
                        call self.turn_dp()
                        call self.toggle_cc()

                        let current = [adj_x,adj_y,self.dp,self.cc]
                        for v in visited
                            if v == current
                                return -1
                            endif
                        endfor

                        let visited += [current]
                        while (adj_color == "WW")
                            let adj_x += self.dp_dx()
                            let adj_y += self.dp_dy()
                            let adj_color = self.get_cell(adj_x,adj_y)
                        endwhile
                    endwhile
                else
                    let white_crossed = 1
                    let adj_color = "WW"
                    let adj_x -= self.dp_dx()
                    let adj_y -= self.dp_dy()
                endif
            endif
        endif

        if (adj_color == "" || adj_color == "KK" )
            " we hit something black or a wall
            if (self.current_color == "WW")
                call self.toggle_cc()
                call self.turn_dp()
            else
                if ((toggle_cnt % 2) == 0)
                    call self.toggle_cc()
                else
                    call self.turn_dp()
                endif
            endif
            let toggle_cnt += 1
        else
            if (!white_crossed)
                call self.action(adj_color)
            endif
            let self.x = adj_x
            let self.y = adj_y
            return 0
        endif
    endfor

    " tries exausted
    return -1
endfunction

function! s:piet_interpreter.run()
    while(1)
        if( self.step() != 0)
            " program end
            return 
        endif
    endwhile
endfunction

" commands
" NOTE: any operations which cannot be performed are simply ignored 
"       (ex: when stack is empty)
function! s:piet_interpreter.nop()
    " nop
endfunction

function! s:piet_interpreter.push()
    if (len(self.stack) < (self.sp+1))
        let self.stack += [self.num_current_cells]
    else
        let self.stack[self.sp] = self.num_current_cells
    endif
    let self.sp += 1
endfunction

function! s:piet_interpreter.pop()
    if (self.sp > 0)
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.add()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        let self.stack[self.sp-2] = b + a
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.subtract()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        let self.stack[self.sp-2] = b - a
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.multiply()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        let self.stack[self.sp-2] = b * a
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.divide()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        if (a == 0)
            " this behavior is same as npiet
            let self.stack[self.sp-2] = 99999999
        else
            let self.stack[self.sp-2] = b / a
        endif
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.mod()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        let self.stack[self.sp-2] = b % a
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.not()
    if (self.sp > 0)
        let self.stack[self.sp-1] = !self.stack[self.sp-1]
    endif
endfunction

function! s:piet_interpreter.greater()
    if (self.sp >= 2)
        let a = self.stack[self.sp-1]
        let b = self.stack[self.sp-2]
        let self.stack[self.sp-2] = b > a
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.pointer()
    if (self.sp > 0)
        let cnt = self.stack[self.sp-1] 
        if cnt > 0
            let i = cnt % 4
            while i > 0
                call self.turn_dp()
                let i -= 1
            endwhile
        else
            let i = (-cnt) % 4
            while i > 0
                call self.turn_dp_inv()
                let i -= 1
            endwhile
        endif
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.switch()
    if (self.sp > 0)
        if (self.stack[self.sp-1] % 2)
            call self.toggle_cc()
        endif
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.duplicate()
    if (self.sp > 0)
        if (len(self.stack) < (self.sp+1))
            let self.stack += [self.stack[self.sp-1]]
        else
            let self.stack[self.sp] = self.stack[self.sp-1]
        endif
        let self.sp += 1
    endif
endfunction

function! s:piet_interpreter.roll()
    if (self.sp >= 2)
        let roll = self.stack[self.sp-1]
        let depth = self.stack[self.sp-2]
        if (depth > 0)
            let self.sp -= 2
            if(self.sp >= depth)
                if (roll > 0)
                    let i = 0
                    while i < roll
                        let val = self.stack[self.sp-1]
                        let j = 0
                        while j < depth -1
                            let self.stack[self.sp-j-1] 
                                        \ = self.stack[self.sp-j-2]
                            let j += 1
                        endwhile
                        let self.stack[self.sp-depth] = val
                        let i += 1
                    endwhile
                else
                    let i = 0
                    let roll = -roll
                    while i < roll
                        let val = self.stack[self.sp-depth]
                        let j = 0
                        while j < depth -1
                            let self.stack[self.sp-depth+j] 
                                        \ = self.stack[self.sp-depth+j+1]
                            let j += 1
                        endwhile
                        let self.stack[self.sp-1] = val
                        let i += 1
                    endwhile
                endif
            endif
        endif
    endif
endfunction

function! s:piet_interpreter.in_number()
    let n = str2nr(input("number> "))
    echo "\n"
    if (len(self.stack) < (self.sp+1))
        let self.stack += [n]
    else
        let self.stack[self.sp] = n
    endif
    let self.sp += 1
endfunction

function! s:piet_interpreter.in_char()
    echon "char> "
    let c = getchar()
    echon nr2char(c)
    echo "\n"
    if (len(self.stack) < (self.sp+1))
        let self.stack += [c]
    else
        let self.stack[self.sp] = c
    endif
    let self.sp += 1
endfunction

function! s:piet_interpreter.out_number()
    if (self.sp > 0)
        echon self.stack[self.sp-1]
        let self.sp -= 1
    endif
endfunction

function! s:piet_interpreter.out_char()
    if (self.sp > 0)
        echon nr2char(self.stack[self.sp-1])
        let self.sp -= 1
    endif
endfunction

let s:piet_interpreter.commands = 
    \[[s:piet_interpreter.nop       , s:piet_interpreter.push      , s:piet_interpreter.pop],
    \ [s:piet_interpreter.add       , s:piet_interpreter.subtract  , s:piet_interpreter.multiply],
    \ [s:piet_interpreter.divide    , s:piet_interpreter.mod       , s:piet_interpreter.not],
    \ [s:piet_interpreter.greater   , s:piet_interpreter.pointer   , s:piet_interpreter.switch],
    \ [s:piet_interpreter.duplicate , s:piet_interpreter.roll      , s:piet_interpreter.in_number],
    \ [s:piet_interpreter.in_char   , s:piet_interpreter.out_number, s:piet_interpreter.out_char]]

function! s:piet_interpreter.action(adj_color)
    let lightness_change = index(s:lightness_cycle,a:adj_color[0]) -
                \  index(s:lightness_cycle,self.current_color[0])
    let hue_change = index(s:hue_cycle,a:adj_color[1]) -
                \    index(s:hue_cycle,self.current_color[1])
    if (lightness_change < 0)
        let lightness_change += len(s:lightness_cycle)
    endif
    if (hue_change < 0)
        let hue_change += len(s:hue_cycle)
    endif
    " echo s:commands_r[printf("[%d,%d]",lightness_change,hue_change)]
    call call(self.commands[hue_change][lightness_change],[],self)
endfunction


function! s:piet_run(...)
    let check = s:check_size()
    if (check != 0)
        let interpreter = s:piet_interpreter.new()
    endif
    if (check == 0 || type(interpreter) == type(0))
        echoerr "this file is not for piet"
    else
    if (a:0 >= 1) && (a:1 == "-stay")
        let interpreter.stay_white = 1
    else
        let interpreter.stay_white= 0
    endif
    call interpreter.run()
    endif
endfunction

function! s:piet_edit_off()
    " scamp
    exe "imapclear <buffer>"
    exe "vmapclear <buffer>"
    exe "nmapclear <buffer>"
    augroup PietAutoCmd
        autocmd! * <buffer>
    augroup END
endfunction

command! -nargs=0 PietEdit    call s:piet_edit()
command! -nargs=0 PietEditOff call s:piet_edit_off()
command! -nargs=? PietRun     call s:piet_run(<f-args>)
command! -nargs=+ -complete=file SaveAsPPM   call s:save_as_ppm(<f-args>)
command! -nargs=+ -complete=file ReadFromPPM call s:read_from_ppm(<f-args>)
" ----------------------------------------------------------------------------

let &cpo = s:save_cpo
unlet s:save_cpo
