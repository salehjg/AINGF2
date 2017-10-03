reset: 	ljmp start                       
i_ext0: ljmp j_ext0                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
i_tim0: ljmp j_tim0              
	nop                                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
i_ext1: ljmp j_ext1                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
i_tim1: ljmp j_tim1              
	nop                                     
	nop                                     
	nop                                     
	nop                                     
	nop                                     
i_siu: 	ljmp j_siu                       

start:	mov 0aah,#00h
	mov 0bah,#00h
	mov 09Dh,#00h

	mov sp, #70h                            
	mov tmod, #00100010b                    
	mov th0, #0f0h                          
	mov tl0, #0f0h                          
	mov ip, #00000000b                      
	mov ie, #10000010b                      
	mov tcon, #00010000b                    

	mov a, #56h		; A = 56h
	mov 20h, a		; <20h> = 56h
	mov 56h, #0aah		; <56h> = AAh
	mov r1, a		; R1 = 56h
	mov a, @r1		; A = AAh
	mov 21h, @r1		; <21h> = AAh
	add a, @r1		; A = 54h, CY=1
	mov 22h, a		; <22h> = 54h
	subb a, @r1		; A = A9h, CY=1
	subb a, #10h
	subb a, r1
	subb a, 20h
	mov 23h, a
	dec a
	addc a, #23h
	add a, #0ffh
	addc a, @r1
	add a, r1
	addc a, 22h
	add a, 23h
	addc a, r1
	inc a
	mov 24h, a
	clr a
	mov 25h, a
	inc r0
	mov 26h, r0
	inc 56h
	inc @r1
	mov 27h, @r1
	dec r4	
	mov 28h, r4
	dec 23h
	dec @r1
	mov dptr, #1234h
	inc dptr
	mov a, 20h
	mov b, r1
	mul ab
	mov 29h, a
	mov 2ah, b
	inc b
	div ab
	mov 2bh, a
	mov 2ch, b
	add a, #56h
	da a
	mov 2dh, a
	anl a, r1
	anl a, #0feh
	mov 2eh, a
	orl a, r1
	anl a, @r1
	mov 2fh, a
	orl 30h, a
	mov 31h, #0aah
	anl 31h, a
	anl a, 31h
	orl a, #45h
	mov 32h, a
	anl 0e0h, #0ffh
	mov 33h, a
	orl a, 20h
	orl a, @r1
	mov 34h, a
	orl 34h, #0ffh
	xrl a, r4
	xrl a, 21h
	mov 35h, a
	xrl a, @r1
	xrl a, #34h
	mov 36h, a
	setb rs1
	mov r5, #96h
	xrl 15h, #0e8h
	xrl 15h, a
	clr rs1
	cpl a
	rl a
	setb c
	rrc a
	clr c
	rlc a
	rl a
	swap a
	mov 37h, a
	mov @r1, 15h
	mov 38h, @r1
	mov @r1, #88h
	mov 39h, @r1
	mov sp, #70h
	push 20h
	pop 3ah
	xch a, r5
	xch a, 3bh
	xch a, @r1
	mov 3bh, a
	xchd a, @r1
	mov 3ch, a
	cpl c
	mov 20h, c
	cpl 20h
	anl c, 31h
	orl c, 32h
	jc n1
	mov 3dh, #0ffh
n1:	anl c,/45h
	orl c,/44h
	jnc n2
	mov 3eh, #0ffh
n2:	mov c, 34h
	mov 35h, c
	jb 35h, n3
	mov 3fh, #0ffh
n3:	jnb 35h, n4
	mov 40h, #0ffh
n4:	jbc 36h, n5
	mov 41h, #0ffh
n5:	acall c1
	mov 42h, #88h
	ajmp j1
c1:	ret
j1:	lcall c2
	mov 43h, #98h
	ljmp j2
c2:	ret
j2:	jnz j3
	mov 44h, #0ffh
j3:	jz j4
	mov 45h, #0ffh
j4:	mov r4, #00h
	djnz r4, j5
	mov 46h, #0ffh
j5:	djnz 04h, j6
	mov 47h, #0ffh
j6: 	mov a, #0ffh
	cjne a, 04h, j7
	mov 48h, #0ffh
j7:	mov 49h, psw
	cjne a, #0ffh, j8
	mov 4ah, #0ffh
j8:	mov 4bh, psw
	cjne r4, #0ffh, j9
	mov 4ch, #0ffh
j9:	mov 4dh, psw
	cjne @r1, #98h, j10
	mov 4eh, #0ffh
j10:	mov 4fh, psw
	nop
	sjmp j11
	mov 4ch, #0ffh
j11:    mov a, #54h
        movx @r1, a
	movx @dptr, a
	clr  a
	movx a, @r1
	mov  50h, a
	clr a
	movx a,@dptr
	mov 51h, a
	mov a, r4
	mov 52h, a
	mov dptr, #0ffffh
	inc dptr
	mov 53h, dpl
	mov 54h, dph
	mov a,@r1
	mov 55h, a
	mov a, #01h
	movc a, @a+pc
	mov 56h, a
	mov a, 30h
	movc a, @a+dptr
	mov 57h, a
	rr a
	mov 58h, a
	jmp ende
	
j_ext0: reti                     
                                        
j_tim0: clr tr0
	mov ie, #00001010b   
	mov tl0, #0cch                   
	reti                                    
                                        
j_ext1: reti                     
                                        
j_tim1: reti                                    
                                        
j_siu: 	reti                             
	
ende:	jmp $

	end