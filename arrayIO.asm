.model small
.stack 300h

.data
;str db 0ah,0dh,'Hello World$'

myArray DB 10, 20, 30, 40, 50  
len EQU $ - myArray  
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
    mov cx,05d
    mov bx,05d
    lea si,myArray

    call printArr

    mov ah,4ch
    int 21h

main endp


printArr proc 
  push ax 
  push cx  
  push dx  
  push si 

  mov cx,bx

arrayloop:
    mov ah,00h
    mov al, [si] 
    call writenum                  

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


writenum PROC near
   ; this procedure will display a decimal number
   ; input : AX
   ; output : none

   push bx                        ; push BX onto the STACK
   push cx                        ; push CX onto the STACK
   push dx                        ; push DX onto the STACK

   XOR CX, CX                     ; clear CX
   MOV BX, 10                     ; set BX=10

   @OUTPUT:                       ; loop label
     XOR DX, DX                   ; clear DX
     DIV BX                       ; divide AX by BX
     PUSH DX                      ; push DX onto the STACK
     INC CX                       ; increment CX
     OR AX, AX                    ; take OR of Ax with AX
   JNE @OUTPUT                    ; jump to label @OUTPUT if ZF=0

   MOV AH, 2                      ; set output function

   @DISPLAY:                      ; loop label
     POP DX                       ; pop a value from STACK to DX
     OR DL, 30H                   ; convert decimal to ascii code
     INT 21H                      ; print a character
   LOOP @DISPLAY                  ; jump to label @DISPLAY if CX!=0

   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP BX                         ; pop a value from STACK into BX

   RET                            ; return control to the calling procedure
writenum ENDP

end main
