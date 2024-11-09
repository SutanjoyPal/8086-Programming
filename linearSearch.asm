.model small
.stack 300h

.data

inputArrMsg db 0ah,0dh,'Enter array length: $'
searchmsg db 0ah,0dh,'Enter number to be searched: $'
sz db ?
val db ?
endl db 0ah,0dh,'$'

foundmsg db 0ah,0dh,'Found at index: $'
notfoundmsg db 0ah,0dh,'Not Found $'


myArray DB 10, 20, 30, 40, 50  
.code

print macro msg
    push ax
    push dx
    mov ah,09h
    lea dx,msg
    int 21h
    pop dx
    pop ax
endm


main proc 
    mov ax,@data
    mov ds,ax 

    ;print str
    lea si,myArray

    call inputArr
    xor bx,bx
    mov bl,sz
    ;call printArr
    call linearSearch
    mov ah,4ch
    int 21h

main endp

linearSearch proc
    push ax 
    push bx 
    push cx 
    push dx  
    push si

    xor cx,cx
    mov cl,sz

    print searchmsg
    call readnum
    mov dx,ax
    
    mov bx,00h
searchloop:
    mov ah,00h
    mov al,[si]
    cmp ax,dx

    jne notequal
    print foundmsg
    mov ax,bx
    call print_number
    print endl
    jmp exitSearch



notequal:
    inc bx
    inc si
    loop searchloop



    print notfoundmsg
exitSearch:
    pop si 
    pop dx 
    pop cx  
    pop bx  
    pop ax

    RET
linearSearch endp
  
inputArr proc
  print inputArrMsg
  push ax 
  push bx 
  push cx 
  push si 

  xor ax,ax
  call readnum
  mov sz,al
  mov cx,ax
  mov bx,00h

readnext:
    print endl
    call readnum
    mov si[bx], ax
    inc bx
    loop readnext

  print endl
  pop si
  pop bx 
  pop cx 
  pop ax 
  RET
inputArr endp

printArr proc 
  push ax 
  push cx  
  push dx  
  push si 

  xor cx,cx
  mov cl,sz

arrayloop:
    mov ah,00h
    mov al, [si] 
    call print_number                

    mov ah, 02h
    mov dl, 20H
    int 21H

    inc si
    loop arrayloop

  pop si
  pop dx 
  pop cx 
  pop ax

  RET
printArr endp

print_number proc
    ; Prints number in AX

    push ax            ; Save original number in AX
    push dx            ; Save DX
    push cx            ; Save CX

    mov bx, 10         ; Base for decimal
    xor dx, dx         ; Clear DX for division
    xor cx, cx         ; Clear CX for digit count

convert_loop:
    div bx             ; Divide AX by 10
    push dx            ; Push remainder (digit) onto the stack
    inc cx             ; Increment digit count
    xor dx, dx         ; Clear DX for next division
    test ax, ax        ; Check if AX is zero
    jnz convert_loop    ; Repeat until AX is zero

display_loop:
    pop dx             ; Get digit from the stack
    add dl, '0'        ; Convert digit to ASCII
    mov ah, 02h        ; Function to print character
    int 21h            ; Call DOS interrupt
    loop display_loop   ; Loop for all digits

    pop cx             ; Restore CX
    pop dx             ; Restore DX
    pop ax             ; Restore AX
    ret
print_number endp

readnum proc near
	
	push bx
	push cx
	mov cx,0ah
	mov bx,00h
loopnum: 
	mov ah,01h
	int 21h
	cmp al,'0'
	jb skip
	cmp al,'9'
	ja skip
	sub al,'0'
	push ax
	mov ax,bx
	mul cx
	mov bx,ax
	pop ax
	mov ah,00h
	add bx,ax
	jmp loopnum
skip:
	mov ax,bx
	pop cx
	pop bx
	ret
readnum endp


end main
