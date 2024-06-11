[bits 16]
[org 0x7c00]
KERNEL_OFSSET equ 0x1000

    xor ax, ax          
    mov ds, ax          
    mov bx, boot_string ;test print with booting message
    call print_string   ;print the statement
    ;We are now setting up disk reading
    mov [BOOT_DRIVE], dl
    mov bp, 0x9000      ;move stack out of the way
    mov sp, bp          ;match stack pointer

    mov bx, 0x9000
    mov dh, 1
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]
    call print_hex

    call load_kernel

    call switch_to_pm
    jmp $

%include "boot\string.asm"
%include "boot\hex.asm"
%include "boot\disk.asm"
%include "boot\gdt.asm"
%include "boot\pm_print.asm"
%include "boot\protected_mode.asm"

load_kernel:
    mov bx, kernel_msg
    call print_string

    mov bx, KERNEL_OFSSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, pm_string
    call print_string_pm
    jmp $

BOOT_DRIVE: db 0x00

boot_string: db "Booting OS...", 0xA, 0xD, 0
kernel_msg: db "Loading kernel into memory", 0xA, 0xD, 0
pm_string: db "Switching to 32-bit mode", 0xA, 0xD, 0

    times 510-($-$$) db 0
    dw 0xaa55

    times 256 dw 0xdada
    times 256 dw 0xface
