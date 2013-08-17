ORG 0
BITS 16
jmp 07C0h:start

start: jmp load

; Parameter block
times 0Bh-$+start DB 0
bpbBytesPerSector:      DW 512
bpbSectorsPerCluster:   DB 1
bpbReservedSectors:     DW 1
bpbNumberOfFATs:        DB 2
bpbRootEntries:         DW 224
bpbTotalSectors:        DW 2880
bpbMedia:               DB 0xF0
bpbSectorsPerFAT:       DW 9
bpbSectorsPerTrack:     DW 18
bpbHeadsPerCylinder:    DW 2
bpbHiddenSectors:       DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber:          DB 0
bsUnused:               DB 0
bsExtBootSignature:     DB 0x29
bsSerialNumber:         DD 0xa0a1a2a3
bsVolumeLabel:          DB "MOS FLOPPY"
bsFileSystem:           DB "FAT12"

; Begin load
load:
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