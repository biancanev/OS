[bits 16]
[org 0x7c00]
    xor ax, ax          
    mov ds, ax          
    mov bx, boot_string ;test print with booting message
    call print_string   ;print the statement
    ;We are now setting up disk reading
    mov [BOOT_DRIVE], dl
    mov bp, 0x8000      ;move stack out of the way
    mov sp, bp          ;match stack pointer

    mov bx, 0x9000
    mov dh, 1
    mov dl, [BOOT_DRIVE]
    call disk_load

    call switch_to_pm
    jmp $

%include "boot\string.asm"
%include "boot\hex.asm"
%include "boot\disk.asm"
%include "boot\gdt.asm"
%include "boot\protected_mode.asm"
%include "boot\pm_print.asm"

BEGIN_PM:
    mov ebx, pm_string
    call print_string_pm
    jmp $

BOOT_DRIVE: db 0x00

boot_string: db "Booting OS...", 0xA, 0xD, 0

pm_string: db "Switching to 32-bit mode", 0xA, 0xD, 0

    times 510-($-$$) db 0
    dw 0xaa55

    times 256 dw 0xdada
    times 256 dw 0xface
