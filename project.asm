IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
	PlayerBarY dw 185
	PlayerBarX dw 129
	PlayerBarColor dw 15
	PlayerBarWidth dw 5
	PlayerBarLength dw 40

	PrintColor dw ?

	BackgroundColor dw 0

; --------------------------
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	;Init for all
	call SetGraph
	;call ResetBackground
MainLoop:

	push ax
	mov ax,[PlayerBarColor]
	mov [PrintColor],ax
	call DrawRectangle
	pop ax
	

	mov ah,1
	int 16h
	jz MainLoop
	mov ah,0
	int 16h
	cmp ah,1h
	je exit
	cmp ah,1Eh
	je @@MoveLeft
	cmp ah,20h
	je @@MoveRight
	jmp MainLoop
	
@@MoveLeft:
	call LeftMove
	jmp MainLoop
	
@@MoveRight:
	call RightMove
	jmp MainLoop
	
	
@@skip:	
	
	
; --------------------------
; Your code here
; --------------------------

	
exit:
	call SetText

	mov ax, 4c00h
	int 21h
	

proc LeftMove
	push ax
	mov ax,[BackgroundColor]
	mov [PrintColor],ax
	call DrawRectangle
	mov ax,[PlayerBarX]
	dec ax
	dec ax
	mov [PlayerBarX],ax
	pop ax
	
	ret
endp

proc RightMove
	push ax
	mov ax,[BackgroundColor]
	mov [PrintColor],ax
	call DrawRectangle
	mov ax,[PlayerBarX]
	inc ax
	inc ax
	mov [PlayerBarX],ax
	pop ax
	
	ret
endp

proc SetGraph
	mov ax,13h
	int 10h
	ret
endp

proc SetText
	mov ax,2
	int 10h
	ret
endp

 

proc DrawRectangle
	mov ax, [PrintColor]
	mov cx,[PlayerBarX]
	mov dx, [PlayerBarY]
	mov si,[PlayerBarLength]
	call DrawHorizontalLine
	
	mov di,[PlayerBarLength]
	mov si,[PlayerBarWidth]
@@Fill:
	call DrawVerticalLine
	inc cx
	dec di
	cmp di,0
	jne @@Fill
	
	mov cx, [PlayerBarX]
	mov si,[PlayerBarLength]
	add dx,[PlayerBarWidth]
	call DrawHorizontalLine
@@exit:
	ret
endp

proc DrawHorizontalLine
	push cx
	push si

	mov ah,0Ch
	mov bh,0
@@print_line:	
	int 10h

	dec si
	inc cx
	cmp si,0
	jne @@print_line

@@exit:
	pop si
	pop cx
	ret 
endp

proc DrawVerticalLine
	push dx
	push si

	mov ah,0Ch
	mov bh,0
@@print_line:	
	int 10h

	dec si
	inc dx
	cmp si,0
	jne @@print_line

@@exit:
	pop si
	pop dx
	ret 
endp

proc ResetBackground
	push cx
	push bx
	push ax
	

	
	mov cx,200
	@@loop1:
		mov bx,cx
		mov cx,320
		@@loop2:
			
			mov dx,bx
			mov bh,0h
			mov al,15
			mov ah,0ch
			int 10h
			

			loop @@loop2
		mov cx,bx
		loop @@loop1
	

	
	pop ax
	pop bx
	pop cx
	
	ret
endp

proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   mov dl, ','
       mov ah, 2h
	   int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal

END start
