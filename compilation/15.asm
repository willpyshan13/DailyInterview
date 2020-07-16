assume	 cs:code,ds:data
;���ݶεĶ���
;--------------------------------------------------
data  segment
	mess		db 5 dup (0ah,0dh)
				db 14 dup ('              |                       |                       |                ',0ah,0dh)				
				db '   -----------|----------- -----------|----------- -----------|-----------     ',0ah,0dh
				db '          Tower A                 Tower B                 Tower C              ','$';
	bin   		dw 6				;��bin��ʼ��
	one  		dw 28;,15    	;������
	two  		dw 76;,19
	three	dw 124;,19
data ends
;-----------------------------------------------------
;����εĶ���
code  segment
start:	  
	;����
	mov ax,600h
	mov bh,07h
	xor cx,cx
	mov dx,184fh
	int 10h
	;���ù��λ��
	mov ah,2
	mov bh,0
	mov dx,0
	int 10h

	mov	ax,data		;�����ݶ��͵�dx
	mov	ds,ax
	lea	dx, mess	;���mess
	mov	ah,09h
	int	21h

	mov ax,0b800h
	mov es,ax	
	mov di,160*7+28
	mov al,2
	mov ah,01100000b
	call rect
	mov di,160*9+28
	mov al,3
	mov ah,01010000b
	call rect
	mov di,160*11+28
	mov al,4
	mov ah,00110000b
	call rect
	mov di,160*13+28
	mov al,5
	mov ah,00010000b
	call rect
	mov di,160*15+28
	mov al,6
	mov ah,00100000b
	call rect
	mov di,160*17+28
	mov al,7
	mov ah,01000000b
	call rect	  

	push	bin			;ѹջ����
	push	one
	push	two
	push	three
	call	hanoi		;����Hanoi
		  
	mov	ah,4ch
	int	21h	  

;��ŵ��	
hanoi:		
		push	ax
		push	dx
		push	bp
		mov	bp,sp
		mov	ax,1
		cmp	ax,word ptr [bp+14]
		je	equal
		jmp	unequal
	equal:	  ;�����ִ��
		mov	ax,word ptr[bp+12]
		mov	bx,word ptr [bp+8]
		call moverect
		jmp	exit
	unequal:		;�������ִ��
		mov	ax,[bp+14]
		sub	ax,1
		push	ax
		push	[bp+12]
		push	[bp+8]
		push	[bp+10]
		call	hanoi

		mov	ax,word ptr [bp+12]
		mov	bx,word ptr [bp+8]
		call moverect

		mov	ax,[bp+14]
		sub	ax,1
		push	ax
		push	[bp+10]
		push	[bp+12]
		push	[bp+8]
		call	hanoi
	exit:
		pop	bp
		pop	dx
		pop	ax
		ret	8
	  
;�ӳ��򣺻��ƾ���
;������	es:[di]��������λ��
;		al���γ���
;		ah������ɫ
rect:	;�ӳ���
		push ax
		push bx
		push cx
		push di
		
		mov bl,ah
		mov ah,0
		sub di,ax
		sub di,ax
		mov cx,ax
		add cx,ax
		add cx,1
	rect_1:
		mov byte ptr es:[di+1],bl
		mov byte ptr es:[di+160+1],bl
		add di,2
		loop rect_1
		
	rect_over:
		pop di
		pop cx
		pop bx
		pop ax
		ret
	  
;�ӳ����ƶ�����
;����	al=A��	
;		ah=A��
;		bl=C��
;		bh=C��
moverect:
		call delay
		push ax
		push bx
		push cx
		push dx
					
		mov dl,al
		mov dh,0
		mov si,dx
		mov cx,0
	moverect_3:	
		mov dl,es:[si+1]
		cmp dl,07h
		jne moverect_2
		cmp cx,19
		je moverect_2
		add si,160
		add cx,1
		jmp 	moverect_3
	moverect_2:
		sub si,22	
	
		mov dl,bl
		mov dh,0
		mov di,dx
		mov cx,0
	moverect_4:	
		mov dl,es:[di+1]
		cmp dl,07h
		jne moverect_5
		cmp cx,19
		je moverect_5
		add di,160
		add cx,1
		jmp 	moverect_4
	moverect_5:
		sub di,22
		sub di,320	
		
		mov cx,23		
		moverect_1:
			mov al,es:[si+1]
			mov es:[di+1],al
			mov al,es:[si+160+1]
			mov es:[di+160+1],al
			mov byte ptr es:[si+1],111b
			mov byte ptr es:[si+160+1],111b
			add di,2
			add si,2
		loop moverect_1
				
		pop dx
		pop cx		
		pop bx
		pop ax
		ret

;�ӳ�����ʱ
delay:
	push cx
	mov cx,0ffh
	run1:
	push cx
	mov cx,0fffh
	run2:
	loop run2
	pop cx
	loop run1
	pop cx
	ret		
		
code	ends
;---------------------------------------
end   start
