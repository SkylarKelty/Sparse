; Load our text
welcome_str db 'Welcome to Sparse!', 0

; Move to beginning of line
mov dx, 0
call move_cursor

; Print it
mov si, welcome_str
call print

; Loop here
jmp $