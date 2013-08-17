use16
ORG 0
jmp 07C0h:start

; Messages
load_str db 'Loading second stage...', 0
boot_str db 0x0a, 'Booting to second stage...', 0

; Begin load
start:
    ; Setup data segment
    mov ax, 07C0h
    mov ds, ax

    ; Clear screen
    call cls

    ; And actually start to load..
    jmp read_sector

; Our first function: move_cursor
move_cursor:
    mov bh, 0
    mov ah, 2
    int 0x10
    ret

; Our second function: print
print:
    mov ah, 0x0E

.repeat:
    lodsb
    or al, al
    jz .done
    int 0x10 ; This outputs
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
    int 0x10
    ret

; Reset the disk
reset:
    mov ah, 0x00
    mov dl, 0x00
    int 0x13
    jc reset
    ret

; Read a sector
read_sector:
    call reset

    ; Print loading message
    mov si, load_str
    call print

    ; Setup to read
    mov bx, 0x8000
    mov es, bx
    mov bx, 0x0000

    ; Begin read
    mov ah, 2  ; Function (read)
    mov al, 24 ; 24 Sectors (12kb)
    mov ch, 0  ; Cylinder
    mov cl, 2  ; Sector
    mov dh, 0  ; Head
    mov dl, 0  ; Drive
    int 0x13
    jc read_sector

    ; Move to beginning of line
    mov dx, 0
    call move_cursor

    ; Print jump message
    mov si, boot_str
    call print

    ; Load protected mode
    ;cli
    ;lgdt [gdtr]
    ;mov eax, cr0 
    ;or al, 1
    ;mov cr0, eax

    ; Jump to protected mode
    ;jmp 08h:pmode

;pmode:
;    use32
    jmp 0x8000

; Fill up to 512 bytes
times 510-($-$$) db 0
dw 0xAA55