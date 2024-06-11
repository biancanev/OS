disk_load:
    push dx
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02

    int 0x13

    jc disk_error
    pop dx
    cmp dh, al
    jne disk_error
    call disk_successful
    ret

disk_error:
    mov bx, disk_error_msg
    call print_string 
    mov dl, ah
    mov dh, 0
    call print_hex
    jmp $

disk_successful:
    mov bx, disk_success_msg
    call print_string
    ret

disk_error_msg: db "Disk read error: ", 0
disk_success_msg: db "Disk successfully read...", 0xA, 0xD, 0
