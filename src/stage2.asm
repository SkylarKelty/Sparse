jmp run

; Load our text
stage_str db 'Welcome to second stage!', 0

; Prints the text then exits
run:
    ; Move to beginning of line
    mov dx, 0
    call move_cursor

    ; Print it
    mov si, stage_str
    call print

    ; Loop here
    jmp $

times 1024-($-$$) db 0