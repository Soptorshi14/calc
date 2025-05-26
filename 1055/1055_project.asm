.model small
.stack 100h

.data
    ; Display Messages
    banner db 10,13, '*** Simple Two-Digit Calculator ***', 10,13
           db '1. Add',10,13
           db '2. Subtract',10,13
           db '3. Multiply',10,13
           db '4. Divide',10,13
           db '5. Quit',10,13
           db 'Choose an option: $'

    askFirst db 10,13,'Enter first number (10-99): $'
    askSecond db 10,13,'Enter second number (10-99): $'
    showResult db 10,13,'Answer: $'
    divZeroMsg db 10,13,'Oops! Cannot divide by zero.$'
    wrongOption db 10,13,'Invalid choice. Try again.$'
    waitMsg db 10,13,10,13,'Press any key to return...$'

    ; Variables
    numA db 0
    numB db 0
    finalResult dw 0
    userOption db 0

.code
start:
    mov ax, @data
    mov ds, ax

main_menu:
    call clear_screen
    lea dx, banner
    call show_text

    call get_option
    cmp userOption, '1'
    je add_nums
    cmp userOption, '2'
    je sub_nums
    cmp userOption, '3'
    je mul_nums
    cmp userOption, '4'
    je div_nums
    cmp userOption, '5'
    je quit_program

    lea dx, wrongOption
    call show_text
    call pause
    jmp main_menu

add_nums:
    call fetch_inputs
    mov al, numA
    add al, numB
    mov ah, 0
    mov finalResult, ax
    call show_output
    jmp main_menu

sub_nums:
    call fetch_inputs
    mov al, numA
    sub al, numB
    cbw
    mov finalResult, ax
    call show_output
    jmp main_menu

mul_nums:
    call fetch_inputs
    mov al, numA
    mul numB
    mov finalResult, ax
    call show_output
    jmp main_menu

div_nums:
    call fetch_inputs
    cmp numB, 0
    je div_error
    mov ax, 0
    mov al, numA
    div numB
    mov finalResult, ax
    call show_output
    jmp main_menu

div_error:
    lea dx, divZeroMsg
    call show_text
    call pause
    jmp main_menu

quit_program:
    mov ax, 4c00h
    int 21h

; === Procedures ===

clear_screen proc
    mov ax, 0003h
    int 10h
    ret
clear_screen endp

get_option proc
    mov ah, 01h
    int 21h
    mov userOption, al
    ret
get_option endp

fetch_inputs proc
    ; First number
    lea dx, askFirst
    call show_text
    call read_number
    mov numA, al

    ; Second number
    lea dx, askSecond
    call show_text
    call read_number
    mov numB, al
    ret
fetch_inputs endp

read_number proc
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, al
    mov al, 10
    mul bl
    mov bl, al

    mov ah, 01h
    int 21h
    sub al, 30h
    add al, bl
    ret
read_number endp

show_output proc
    lea dx, showResult
    call show_text
    mov ax, finalResult
    call print_number
    call pause
    ret
show_output endp

pause proc
    lea dx, waitMsg
    call show_text
    mov ah, 01h
    int 21h
    ret
pause endp

print_number proc
    mov bx, 10
    mov cx, 0
    cmp ax, 0
    jge cont
    mov dl, '-'
    mov ah, 02h
    int 21h
    neg ax

cont:
    mov cx, 0
again:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne again

print_loop:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop print_loop
    ret
print_number endp

show_text proc
    mov ah, 09h
    int 21h
    ret
show_text endp

end start
