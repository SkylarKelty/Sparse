ORG 0
BITS 16
jmp 07C0h:start

; Begin load
start:
    ; Set up 4K stack space after this bootloader
    ; (4096 + 512) / 16 bytes per paragraph
    mov ax, 07C0h
    add ax, 288
    mov ss, ax
    mov sp, 4096

    ; Set data segment to where we are loaded
    mov ax, 07C0h
    mov ds, ax

    mov si, text_string
    call print

    jmp $ ; Infinite loop!

    text_string db 'Welcome to Sparse!', 0

; Our first function: print!
print:
    mov ah, 0Eh

.repeat:
    lodsb
    cmp al, 0
    je .done
    int 10h ; This outputs
    jmp .repeat

.done:
    ret

; Fill up to 512 bytes
times 510-($-$$) db 0
dw 0xAA55