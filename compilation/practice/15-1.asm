;���ݶεĶ���
;--------------------------------------------------
datarea  segment
;��ҳ�˵���ʾ
mess db '	**************************************************************************',0ah,0dh
	 db '	*		   welcome you! 												 *',0ah,0dh
	 db '	*		   this is hanoi game											 *',0ah,0dh
	 db '	*		   you can know how many times when you play this game			 *',0ah,0dh
	 db '	*		   the case by HE RUIRUI										 *',0ah,0dh
	 db '	*		   XueHao is 41012186											 *',0ah,0dh
	 db '	**************************************************************************','$';
bin   dw 0	;��bin��ʼ��Ϊ0
chnum db 10 dup('0'),'$';��chnum����洢�ռ�
one   dw 'A'    ;��������
two   dw 'B'
three dw 'C'
strshow  db '-->$'   ;���ӷ���
chline	 db 0dh,0ah,'$'
prompt	 db 'Please input the plate number(1-99):$';��ʾ���
chtimes1 db 0dh,0ah,'You have moved $';��ʾ���
chtimes2 db 'times',0dh,0ah,'$'
inputlist	label byte
maxlen	 db 3
actlen	 db 0
chinput  db 3 dup ('0'),'$'
multfact dw 1
datarea ends

;-----------------------------------------------------
;����εĶ���
code  segment

main  proc far			;������
assume	 cs:code,ds:datarea
start:
	  mov	ax,datarea	;�����ݶ��͵�dx
	  mov	ds,ax
	  lea	dx, mess	;���mess
	  mov	ah,09h
	  int	21h
loopagain:
	  
   	  mov dl,0dh		;����ָ��
      mov ah,2
      int 21h
      mov dl,0ah
      mov ah,2
	  int 21h
	  lea	dx,prompt	;���prompt
	  mov	ah,09h
	  int	21h
	  lea	dx,inputlist	;���inputlist
	  mov	ah,0ah
	  int	21h
	  call	asctobin	;����asctobin
	  mov	ax,1		;��һ�͵�ax
	  cmp	ax,bin		;�Ƚ�bin��ax
	  ja	loopagain	;���������ת��loopagain
	  mov	ax,99		;��99�͵�ax
	  cmp	bin,ax		;�Ƚ�ax��bin
	  ja	loopagain	;���������ת��loopagain
	  push	bin			;ѹջ����
	  push	one
	  push	two
	  push	three
	  lea	dx,chline	;��chline����dx
	  mov	ah,09h		;���ָ��
	  int	21h
	  call	hanoi		;����Hanoi
	  lea	dx,chtimes1	;��chtimes�����
	  mov	ah,09h
	  int	21h
	  mov	cx,0010		;��10�͵�cx
	  lea	si,chnum	;��chnum�͵�si
shownum:			;����
	  cmp	byte ptr [si],'0'
	  je	notadd
	  add	byte ptr [si],48
notadd:
	  inc	si
	  loop	shownum
	  lea	dx,chnum
	  mov	ah,09h
	  int	21h
	  lea	dx,chtimes2
	  mov	ah,09h
	  int	21h
	  mov	bin,0
	  mov	actlen,0
	  mov	[chinput],'0'
	  mov	[chinput+1],'0'
	  mov	cx,0010
	  lea	si,chnum
put0:
	  mov	byte ptr [si],'0'
	  inc	si
	  loop	put0
	  jmp	loopagain
loopend:
	  mov	ah,4ch
	  int	21h
	  main	endp
	  
	  
asctobin proc  near		;�ӳ���
	  push	ax
	  push	cx
	  cmp	actlen,0
	  je	loopend
	  cmp	actlen,1
	  je	l2
	  jmp	l3
l2:			;��һ����ִ��
	  xor	ah,ah
	  mov	al,[chinput]
	  sub	al,48
	  add	bin,ax
	  jmp	out1
l3:			;������������ִ��
	  xor	ah,ah
	  mov	al,[chinput+1]
	  sub	al,48
	  add	bin,ax
	  mov	al,[chinput]
	  sub	al,48
	  mov	cl,10
	  mul	cl
	  add	bin,ax
out1:
	  pop	cx
	  pop	ax
	  ret
	  asctobin	endp
	  
	  
hanoi proc	near		;��ŵ��
	  push	ax
	  push	dx
	  push	bp
	  mov	bp,sp
	  mov	ax,1
	  cmp	ax,word ptr [bp+14]
	  je	equal
	  jmp	unequal
equal:
	  lea	si,chnum+10
loopnum0:		;������̵ĳ���
	  xor	ah,ah
	  dec	si
	  mov	al,[si]
	  add	al,1
	  aaa
	  mov	[si],al
	  cmp	ah,1
	  je	loopnum0
	  mov	dx,word ptr[bp+12]
	  mov	ah,2
	  int	21h
	  lea	dx,strshow
	  mov	ah,09h
	  int	21h
	  mov	dx,word ptr [bp+8]
	  mov	ah,02h
	  int	21h
	  lea	dx,chline
	  mov	ah,09h
	  int	21h
	  jmp	exit
unequal:		;�������ִ��
	  mov	ax,[bp+14]
	  sub	ax,1
	  push	ax
	  push	[bp+12]
	  push	[bp+8]
	  push	[bp+10]
	  call	hanoi
	  lea	si,chnum+10
loopnum1:	;������λ��ʱִ��
	  xor	ah,ah
	  dec	si
	  mov	al,[si]
	  add	al,1
	  aaa
	  mov	[si],al
	  cmp	ah,1
	  je	loopnum1
	  mov	dx,word ptr [bp+12]
	  mov	ah,2
	  int	21h
	  lea	dx,strshow
	  mov	ah,09h
	  int	21h
	  mov	dx,word ptr [bp+8]
	  mov	ah,02h
	  int	21h
	  lea	dx,chline
	  mov	ah,09h
	  int	21h
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
	  hanoi endp
	  
	  code	ends
;---------------------------------------
			end   start
