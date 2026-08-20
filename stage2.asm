[org 0x7e00]
[bits 16]

stage2: ; name of 0x7e00
    mov bx, MSG_REAL
    call print_f

    ; enable a20 legacy stuff 8086
    in  al, 0x92
    or  al, 00000010b
    and al, 11111110b
    out 0x92, al

    ; load Global Descriptor Table (GDT) for protected mode
    lgdt [gdt_descriptor] ; tell the CPU where the GDT is

    ; protection on
    mov eax, cr0 ; Control Register
    or  eax, 1 ; set Protection Enable bit
    mov cr0, eax ; CPU in Protected Mode baby

    jmp 0x08:protected_mode

%include "print_f.asm"
%include "gdt.asm"

MSG_REAL: db 'stage2 16-bit REAL mode', 13, 10, 0


; 32-bits protected yo
[bits 32]
protected_mode:
    mov ax, 0x10 ; gdt_data skeletor
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000 ; somewhere

    extern kerenel_main
    call kerenel_main

;    mov edi, 0xB8000 ; VGA text buffer
;    mov esi, MSG_PROT
;    mov ah, 0x86 ; color
;
;.print_loop:
;    lodsb ; load byte from [esi] into al, increment esi
;    test al, al ; looking for NUL byte
;    jz .done
;    mov [edi], ax
;    add edi, 2 ; 2 for character al and color ah
;    jmp .print_loop
;
;.done:
    cli
    hlt
    jmp $

MSG_PROT: db 'stage2 32-bit PROTECTED mode VGA BUFFER', 0
