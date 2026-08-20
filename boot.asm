[org 0x7c00] ; offset into memory where we live
[bits 16] ; generate 16-bit real-mode code

start: ; name of 0x7c00
    xor ax, ax ; zero several registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; stack grows down

    mov [BOOT_DRIVE], dl ; save the boot drive number for later use

    mov bx, MSG_LOADING
    call print_f

    ; reset the disk
    xor ah, ah
    int 0x13

    ; load stage2 from disk using INT 13h
    mov ah, 0x02 ; Read Sectors instruction
    mov al, 8 ; num sectors (4KB)
    mov ch, 0 ; cylinder number
    mov cl, 2 ; (block?) selector number (1 this boot, 2 stage2 start)
    mov dh, 0 ; head number
    ; leave brittney alone mov dl, 0x80 ; drive number (wot QEMU seez)
    mov dl, [BOOT_DRIVE]
    mov bx, 0x7e00 ; DESTINATION
    int 0x13 ; copy disk sectors to ram
    jc disk_error ; did it work?

    mov bx, MSG_OK
    call print_f

    jmp 0x0000:0x7e00 ; jump to our above loaded DESTINATION

disk_error:
    mov bx, MSG_ERROR
    call print_f
    jmp $

%include "print_f.asm"

MSG_LOADING :    db 'Loading stage2...', 0
MSG_OK      :    db ' OK', 13, 10, 0 ; CR LF NUL
MSG_ERROR   :    db 'Disk Error!', 0

BOOT_DRIVE: db 0 ; save the boot drive number for later use

times 510-($-$$) db 0
dw 0xaa55 ; padding and signature
