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

	BrickColor dw ?
	BrickX dw ?
	BrickY dw ?
	BrickWidth dw 10
	BrickLength dw 20
	BricksInRow dw 10
	
	BrickLvl4Color dw 14
	BrickLvl4X dw 14,44,74,104,134,164,194,224,254,284
	BrickLvl4Y dw 85
	
	BrickLvl3Color dw 48
	BrickLvl3X dw 14,44,74,104,134,164,194,224,254,284
	BrickLvl3Y dw 65

	BrickLvl2Color dw 11
	BrickLvl2X dw 14,44,74,104,134,164,194,224,254,284
	BrickLvl2Y dw 45

	BrickLvl1Color dw 40
	BrickLvl1X dw 14,44,74,104,134,164,194,224,254,284
	BrickLvl1Y dw 25



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
	call PrintBar
	pop ax
	
	call PrintBricksLvl1
	call PrintBricksLvl2
	call PrintBricksLvl3
	call PrintBricksLvl4

	mov ah,1
	int 16h
	jz MainLoop
	mov ah,0
	int 16h
	cmp ah,1h
	je exit
	cmp ah,1Eh
	je MoveLeft
	cmp ah,20h
	je MoveRight
	jmp MainLoop
	
MoveLeft:
	call LeftMove
	jmp MainLoop
	
MoveRight:
	call RightMove
	jmp MainLoop
	
	
	
	
; --------------------------
; Your code here
; --------------------------

	
exit:
	call SetText

	mov ax, 4c00h
	int 21h
	
proc PrintBricksLvl4
	push ax
	push cx
	push si

	mov ax,[BrickLvl4Color]
	mov [BrickColor],ax

	mov ax,[BrickLvl4Y]
	mov [BrickY],ax

	xor cx,cx
	xor si,si

	mov cx, [BricksInRow]
	@@PrintEachBrick:

		mov ax,[BrickLvl4X+si]
		mov [BrickX],ax
		cmp [BrickX],0
		je @@Skip

			call PrintBrick
		@@Skip:
		add si,2
		loop @@PrintEachBrick

	pop si
	pop cx
	pop ax
	ret
endp

proc PrintBricksLvl3
	push ax
	push cx
	push si

	mov ax,[BrickLvl3Color]
	mov [BrickColor],ax

	mov ax,[BrickLvl3Y]
	mov [BrickY],ax

	xor cx,cx
	xor si,si

	mov cx, [BricksInRow]
	@@PrintEachBrick:

		mov ax,[BrickLvl3X+si]
		mov [BrickX],ax
		cmp [BrickX],0
		je @@Skip

			call PrintBrick
		@@Skip:
		add si,2
		loop @@PrintEachBrick

	pop si
	pop cx
	pop ax
	ret
endp

proc PrintBricksLvl2
	push ax
	push cx
	push si

	mov ax,[BrickLvl2Color]
	mov [BrickColor],ax

	mov ax,[BrickLvl2Y]
	mov [BrickY],ax

	xor cx,cx
	xor si,si

	mov cx, [BricksInRow]
	@@PrintEachBrick:

		mov ax,[BrickLvl2X+si]
		mov [BrickX],ax
		cmp [BrickX],0
		je @@Skip

			call PrintBrick
		@@Skip:
		add si,2
		loop @@PrintEachBrick

	pop si
	pop cx
	pop ax
	ret
endp

proc PrintBricksLvl1
	push ax
	push cx
	push si

	mov ax,[BrickLvl1Color]
	mov [BrickColor],ax

	mov ax,[BrickLvl1Y]
	mov [BrickY],ax

	xor cx,cx
	xor si,si

	mov cx, [BricksInRow]
	@@PrintEachBrick:

		mov ax,[BrickLvl1X+si]
		mov [BrickX],ax
		cmp [BrickX],0
		je @@Skip

			call PrintBrick
		@@Skip:
		add si,2
		loop @@PrintEachBrick

	pop si
	pop cx
	pop ax
	ret
endp

proc LeftMove
	push ax
	mov ax,[BackgroundColor]
	mov [PrintColor],ax
	call PrintBar
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
	call PrintBar
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

 

proc PrintBar
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

proc PrintBrick
	push ax
	push cx
	push dx
	push si

	mov ax, [BrickColor]
	mov cx,[BrickX]
	mov dx, [BrickY]
	mov si,[BrickLength]
	call DrawHorizontalLine
	
	mov di,[BrickLength]
	mov si,[BrickWidth]
@@Fill:
	call DrawVerticalLine
	inc cx
	dec di
	cmp di,0
	jne @@Fill
	
	mov cx, [BrickX]
	mov si,[BrickLength]
	add dx,[BrickWidth]
	call DrawHorizontalLine
@@exit:
	pop si
	pop dx
	pop	cx
	pop ax
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
