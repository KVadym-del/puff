use16                   
org 0x7C00             

start:
    cli                 ; Disable interrupts
    cld                 ; Clear direction flag
    xor ax, ax          ; Clear AX register
    mov ss, ax          ; Set stack segment to 0
    mov sp, 0x7C00      ; Set stack pointer 
    mov ds, ax          ; Set data segment to 0
    mov es, ax          ; Set extra segment to 0
    sti                 ; Re-enable interrupts

    ; Print welcome message
    mov si, welcome_msg
    call print_string

    ; Infinite loop to prevent CPU from executing random memory
    jmp $

print_string:
    mov ah, 0x0E        ; BIOS teletype output
.loop:
    lodsb               ; Load byte from SI into AL and increment SI
    or al, al           ; Check if byte is zero (end of string)
    jz .done            ; If zero, exit
    int 0x10            ; BIOS video interrupt
    jmp .loop           ; Continue printing
.done:
    ret

welcome_msg db 'Hello World!', 0

; Fill the rest of the boot sector with zeros
times 510 - ($ - $$) db 0

dw 0xAA55              ; Magic number that tells BIOS this is a boot sector
