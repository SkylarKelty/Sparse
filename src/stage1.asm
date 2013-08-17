ORG 0
BITS 16
jmp 07C0h:start

start: jmp load

; Messages
welcome_str db 'Welcome to Sparse!', 0
load_str db 0x0a, 'Loading second stage...', 0

; Begin load
load:
    ; Set up 8K stack space after this bootloader
    mov ax, 07C0h
    add ax, 544
    mov ss, ax
    mov sp, 4096

    ; Set data segment to where we are loaded
    mov ax, 07C0h
    mov ds, ax

    ; Clear screen
    call cls

    ; Print welcome
    mov si, welcome_str
    call print

    ; Move to beginning of line
    mov dx, 0
    call move_cursor

    ; Print loading message
    mov si, load_str
    call print

    ; Loop
    jmp $


; Our first function: move_cursor
move_cursor:
    mov bh, 0
    mov ah, 2
    int 10h
    ret

; Our second function: print
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

; Our third function: clear screen
cls:
    mov dx, 0
    call move_cursor
    mov ah, 6
    mov al, 0
    mov bh, 7
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 10h
    ret

; Fill up to 512 bytes
times 510-($-$$) db 0
dw 0xAA55