.model small
.stack 300h
.data

sizemsg db 0ah,0dh,'Enter Array Size: $'
sz db ?


.code

main proc
    call readnum
    mov dx,ax
    xor ax,ax
    mov ah,02h
    int 21h

    endProg:
    mov ah,4ch
    int 21h
main endp

readnum proc
    push bx
    push cx
    push dx
    mov bx,00h
    mov cx,0ah

readloop:
        xor ax,ax
        mov ah,01h
        int 21h 
        cmp al,'0'
        jl exit
        cmp al,'9'
        jg exit
        sub ax,'0'
        mov dx,ax
        mov ax,bx
        mul cx
        add ax,dx
        mov bx,ax
        jmp readloop
    


exit:
    mov ax,bx
    pop dx
    pop cx
    pop bx
    RET
readnum endp

writenum proc
    push ax
    push bx
    push cx
    push dx

    mov bx,0ah
    mov cx,00h
    

numberToDigit:
        xor dx,dx
        div bx
        push dx   ;dx stores remainder
        inc cx
        cmp ax,00h
        jne numberToDigit

writeloop:
        pop dx
        add dl,'0'
        mov ah,02h
        int 21h
        loop writeloop


    






    pop ax
    pop bx
    pop cx
    pop dx
    RET
writenum endp


end main

