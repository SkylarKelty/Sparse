jmp run

; Load our text
welcome_str db 'Welcome to Sparse!', 0

; Prints the text then exits
run:
    ; Move to beginning of line
    mov dx, 0
    call move_cursor

    ; Print it
    mov si, welcome_str
    call print

    ; Loop here
    jmp $

times 1024-($-$$) db 0