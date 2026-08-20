; minimal flat GDT for 32-bit protected mode

gdt_start:

gdt_null:
    dd 0
    dd 0

gdt_code: ; skeletor 0x08
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b ; access byte
    ;  00000001 accessed
    ;  00000010 readable?
    ;  00000100 conforming
    ;  00001000 executable
    ;  00010000 type (1 for code/data)
    ;  00100000 privilege level 00 = ring 0
    ;  01000000 priv
    ;  00000000 present
    db 11001111b ; flags byte
    ;  00000001
    ;  00000010
    ;  00000100
    ;  00001000
    ;  00010000
    ;  00100000 long mode (0 = 32-bit protected)
    ;  01000000 size (1 = 32-bits)
    ;  10000000 granularity (1 = 4K)
    db 0x00

gdt_data: ; skeletor 0x10
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b ; same but different
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1
    dd gdt_start
