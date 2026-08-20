print_f:
    pusha
    mov ah, 0x0e

.main:
    mov al, [bx]
    cmp al, 0
    je .end
    int 0x10
    inc bx
    jmp .main

.end:
    popa
    ret
