print_string:
    pusha
    mov ah, 0xe
print_character:
    mov al, [bx]
    inc bx
    or al, al
    jz print_done
    int 0x10
    jmp print_character
print_done:
    popa
    ret

newline: db 0xA, 0xD