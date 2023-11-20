[org 0x0100]

jmp start

message1: db 'Welcome To Hangman!', 0
message2: db 'Press Any Key To', 0
message3: db 'See Rules!', 0
message4: db 'Press Any Key To Start the Play!', 0
message5: db 'Available characters!', 0
message6: db 'Hint:', 0
message7: db 'Guess: ', 0
message8: db 'Actual Word: ', 0
message9: db 'another round', 0
m9: db '(a)', 0
message10: db 'change level', 0
m10: db '(c)', 0
message11: db 'quit game', 0
m11: db '(q)', 0
message12: db 'You Quit! Game Over!', 0
r1: db 'Setup:', 0
r2: db '* Display underscores correspond to no. of letters in word', 0
r3: db 'Guessing:', 0
r4: db '* Players take turns guessing letters', 0
r5: db '* If guessed letter is in word, all instances will be filled', 0
r6: db '* If it is not in word, one part of hangman will be drawn', 0
r7: db 'Number of Incorrect Guesses:', 0
rr8: db '* Complete hangman figure consists of a knot, beam, head,', 0
rr81: db '  body, two arms and two legs', 0
rr9: db '* 7 incorrect guesses are allowed', 0
rr10: db 'Winning:', 0
rr11: db '* Player wins if guesses word before figure completes', 0
rr12: db 'Losing:', 0
rr13: db '* Player loses after 8th incorrect guess', 0
key1: db 'a b c d e f g h i j', 0
key2: db 'k l m n o p q r s', 0
key3: db 't u v w x y z', 0
err: db 'Try Again!', 0
randNum: dw 0
level: dw 0
mistakes: dw 0
corrects: dw 0;corrects jb level jitny hogy to win
inps: dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; is mai ascii rkh leni hai jo jo remove hogy uski, last index is inps+52
inpscount: dw 0;this will keep count k kitna minus krna 52 mai se aur agay checks krna in loop
level1: db 'Choose level:', 0
level2: db '1: Beginner     2: Medium       3: Hard     4: Master', 0
beginner3: db 'Calendar', 0, 'may', 0, 'Loyal', 0, 'dog', 0, 'Furry', 0, 'cat', 0, 0
medium5: db 'Music', 0, 'piano', 0, 'Fruits', 0, 'apple', 0, 'Flowers', 0, 'daisy', 0, 0
hard6: db 'Countries', 0, 'france', 0, 'Professions', 0, 'lawyer', 0, 'Colors', 0, 'orange', 0, 0
master9: db 'Stationary', 0, 'sharpener', 0, 'Study', 0, 'knowledge', 0, 'Trips', 0, 'adventure', 0, 0

clrscr:
    push es
    push ax
    push cx
    push di
    mov ax, 0xb800
    mov es, ax ; point es to video base
    xor di, di ; point di to top left column
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 2000 ; number of screen locations
    cld ; auto increment mode
    rep stosw ; clear the whole screen
    pop di
    pop cx
    pop ax
    pop es
    ret

delay:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 10
	mov cx, 10
	delay_loop:
		inner_loop:
			dec ax
			jnz inner_loop
		dec cx
		jnz delay_loop
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret

welcome:
    push bp
    mov bp, sp
    pusha
    ;x 41, y 3
    mov ax, 41
    push ax ; push x position
    mov ax, 1
    push ax ; push y position
    mov ax, 0x74
    push ax ; push attribute
    mov ax, message1
    push ax ; push address of message1
    call printstr2

    call printman

    call delay

    mov ax, 42
    push ax ; push x position
    mov ax, 3
    push ax ; push y position
    mov ax, 0xF4
    push ax ; push attribute
    mov ax, message2
    push ax ; push address of message2
    call printstr2

    mov ax, 45
    push ax ; push x position
    mov ax, 4
    push ax ; push y position
    mov ax, 0xF4
    push ax ; push attribute
    mov ax, message3
    push ax ; push address of message3
    call printstr2

    mov ah, 0 ; service 0 – get keystroke
    int 0x16

    call sound

    call printrules

    call delay

    mov ax, 30
    push ax ; push x position
    mov ax, 21
    push ax ; push y position
    mov ax, 0xEA
    push ax ; push attribute
    mov ax, message4
    push ax ; push address of message4
    call printstr2

    mov ah, 0 ; service 0 – get keystroke
    int 0x16

    call sound

    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov al, 80 ; load al with columns per row
    mov cl, 3
    mul byte cl ; multiply with y position
    add ax, 20 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov bx, 0
    l9:
        cld
        mov cx, 60 ; number of screen locations
        rep stosw
        add di, 40
        inc bx
        cmp bx, 19
        jne l9

    call removeman

    mov al, 80 ; load al with columns per row
    mov cl, 1
    mul byte cl ; multiply with y position
    add ax, 41 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 19
    rep stosw

    popa
    pop bp
    ret

printman:
    ;welcome screen k liye poora banda
    ;y 20 pr straight horizontal line x 0-79
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 22
    mul byte cl ; multiply with y position
    add ax, 0 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 80 ; number of screen locations
    cld ; auto increment mode
    rep stosw
    ;y 1-21 vertical line x=4
    mov al, 80 ; load al with columns per row
    mov cl, 1
    mul byte cl ; multiply with y position
    add ax, 4 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0
    l1:
        stosw
        add di, 158
        inc cx
        cmp cx, 22
        jne l1

    call delay

    call printbeam

    call delay

    call printknot

    call delay
    
    call printhead

    call delay

    call printbody

    call delay

    call printrightarm

    call delay

    call printleftarm

    call delay

    call printrightleg

    call delay

    call printleftleg

    popa
    pop bp
    ret

printstr2:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    push ds
    pop es ; load ds in es
    mov di, [bp+4] ; point di to string
    mov cx, 0xffff ; load maximum number in cx
    xor al, al ; load a zero in al
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax ; exclude null from length
    jz exit ; no printing if string is empty
    mov cx, ax ; load string length in cx
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov al, 80 ; load al with columns per row
    mul byte [bp+8] ; multiply with y position
    add ax, [bp+10] ; add x position
    shl ax, 1 ; turn into byte offset
    mov di,ax ; point di to required location
    mov si, [bp+4] ; point si to string
    mov ah, [bp+6] ; load attribute in ah
    cld ; auto increment mode
    nextchar2:
        lodsb ; load next char in al
        stosw ; print char/attribute pair
        loop nextchar2 ; repeat for the whole string
    exit:
        pop di
        pop si
        pop cx
        pop ax
        pop es
        pop bp
        ret 8

removeman:
    push bp
    mov bp, sp
    pusha
    
    call removeleftleg

    call delay

    call removerightleg

    call delay

    call removeleftarm

    call delay

    call removerightarm

    call delay

    call removebody

    call delay

    call removehead

    call delay

    call removeknot

    call delay

    call removebeam

    popa
    pop bp
    ret

printbeam:
    ;1st wrong
    ;y = 1, x 4 - 14 horizontal
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 1
    mul byte cl ; multiply with y position
    add ax, 4 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 11 ; number of screen locations
    cld
    rep stosw
    popa
    pop bp
    ret

removebeam:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 1
    mul byte cl ; multiply with y position
    add ax, 4 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 11 ; number of screen locations
    cld
    rep stosw
    popa
    pop bp
    ret

printknot:
    ;2 wrong
    ;phanda
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 2
    mul byte cl ; multiply with y position
    add ax, 14 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    stosw
    popa
    pop bp
    ret

removeknot:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 2
    mul byte cl ; multiply with y position
    add ax, 14 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    stosw
    popa
    pop bp
    ret

printhead:
    ;3 wrong
    ;head
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 3
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 3
    cld
    rep stosw
    add di, 154
    mov cx, 3
    rep stosw
    popa
    pop bp
    ret

removehead:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 3
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 3
    cld
    rep stosw
    add di, 154
    mov cx, 3
    rep stosw
    popa
    pop bp
    ret

printbody:
    ;4 wrong
    ;body
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 5
    mul byte cl ; multiply with y position
    add ax, 14 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0
    l2:
        stosw
        add di, 158
        inc cx
        cmp cx, 5
        jne l2
    popa
    pop bp
    ret

removebody:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 5
    mul byte cl ; multiply with y position
    add ax, 14 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 0
    l21:
        stosw
        add di, 158
        inc cx
        cmp cx, 5
        jne l21
    popa
    pop bp
    ret

printrightarm:
    ;5 wrong
    ;left arm
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 6
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l3:
        stosw
        add di, 156
        inc cx
        cmp cx, 3
        jne l3
    popa
    pop bp
    ret

removerightarm:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 6
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l31:
        stosw
        add di, 156
        inc cx
        cmp cx, 3
        jne l31
    popa
    pop bp
    ret

printleftarm:
    ;6 wrong
    ;right arm
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 6
    mul byte cl ; multiply with y position
    add ax, 15 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l4:
        stosw
        add di, 160
        inc cx
        cmp cx, 3
        jne l4
    popa
    pop bp
    ret

removeleftarm:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 6
    mul byte cl ; multiply with y position
    add ax, 15 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l41:
        stosw
        add di, 160
        inc cx
        cmp cx, 3
        jne l41
    popa
    pop bp
    ret

printrightleg:
    ;7 wrong
    ;left leg
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 9
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l5:
        stosw
        add di, 156
        inc cx
        cmp cx, 3
        jne l5
    popa
    pop bp
    ret

removerightleg:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 9
    mul byte cl ; multiply with y position
    add ax, 13 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l51:
        stosw
        add di, 156
        inc cx
        cmp cx, 3
        jne l51
    popa
    pop bp
    ret

printleftleg:
    ;8 wrong
    ;right leg
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 9
    mul byte cl ; multiply with y position
    add ax, 15 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l6:
        stosw
        add di, 160
        inc cx
        cmp cx, 3
        jne l6
    popa
    pop bp
    ret

removeleftleg:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 9
    mul byte cl ; multiply with y position
    add ax, 15 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x7F20 ; space char in normal attribute
    mov cx, 0 ; number of screen locations
    l61:
        stosw
        add di, 160
        inc cx
        cmp cx, 3
        jne l61
    popa
    pop bp
    ret

printrules:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xb800
    mov es, ax ; point es to video base

    ;color box 18 lines
    mov al, 80 ; load al with columns per row
    mov cl, 3
    mul byte cl ; multiply with y position
    add ax, 20 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x1020 ; space char in normal attribute
    mov bx, 0
    cld
    l8:
        mov cx, 60 ; number of screen locations
        rep stosw ; clear the whole screen
        inc bx
        add di, 40
        cmp bx, 18
        jne l8

    call delay

    mov ax, 20
    push ax ; push x position
    mov ax, 3
    push ax ; push y position
    mov ax, 0x1E 
    push ax ; push attribute
    mov ax, r1
    push ax ; push address of r1
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 4
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, r2
    push ax ; push address of r2
    call printstr2

    call delay

    mov ax, 20
    push ax ; push x position
    mov ax, 6
    push ax ; push y position
    mov ax, 0x1E 
    push ax ; push attribute
    mov ax, r3
    push ax ; push address of r3
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 7
    push ax ; push y position
    mov ax, 0x1F
    push ax ; push attribute
    mov ax, r4
    push ax ; push address of r4
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 8
    push ax ; push y position
    mov ax, 0x1F
    push ax ; push attribute
    mov ax, r5
    push ax ; push address of r5
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 9
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, r6
    push ax ; push address of r6
    call printstr2

    call delay

    mov ax, 20
    push ax ; push x position
    mov ax, 11
    push ax ; push y position
    mov ax, 0x1E 
    push ax ; push attribute
    mov ax, r7
    push ax ; push address of r7
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 12
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, rr8
    push ax ; push address of rr8
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 13
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, rr81
    push ax ; push address of rr81
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 14
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, rr9
    push ax ; push address of rr9
    call printstr2

    call delay

    mov ax, 20
    push ax ; push x position
    mov ax, 16
    push ax ; push y position
    mov ax, 0x1E 
    push ax ; push attribute
    mov ax, rr10
    push ax ; push address of rr10
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 17
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, rr11
    push ax ; push address of rr11
    call printstr2

    call delay

    mov ax, 20
    push ax ; push x position
    mov ax, 19
    push ax ; push y position
    mov ax, 0x1E 
    push ax ; push attribute
    mov ax, rr12
    push ax ; push address of rr12
    call printstr2

    mov ax, 20
    push ax ; push x position
    mov ax, 20
    push ax ; push y position
    mov ax, 0x1F 
    push ax ; push attribute
    mov ax, rr13
    push ax ; push address of rr13
    call printstr2

    popa
    pop bp
    ret

printalpha:
    ;print a, b, c, ... , z
    push bp
    mov bp, sp
    pusha
    mov ax, 41
    push ax ; push x position
    mov ax, 4
    push ax ; push y position
    mov ax, 0x74
    push ax ; push attribute
    mov ax, message5
    push ax ; push address of message5
    call printstr2

    mov ax, 41
    push ax ; push x position
    mov ax, 10
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, key1
    push ax ; push address of key1
    call printstr2

    mov ax, 42
    push ax ; push x position
    mov ax, 12
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, key2
    push ax ; push address of key2
    call printstr2

    mov ax, 44
    push ax ; push x position
    mov ax, 14
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, key3
    push ax ; push address of key3
    call printstr2

    mov ax, 45
    push ax ; push x position
    mov ax, 7
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, message6
    push ax ; push address of message6
    call printstr2

    popa
    pop bp
    ret
    ;x 37-44
    ;y 20-23

chooselevel:
    push bp
    mov bp, sp
    pusha
    mov ax, 41
    push ax ; push x position
    mov ax, 4
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, level1
    push ax ; push address of level1
    call printstr2

    mov ax, 25
    push ax ; push x position
    mov ax, 7
    push ax ; push y position
    mov ax, 0x74 
    push ax ; push attribute
    mov ax, level2
    push ax ; push address of level2
    call printstr2

    l10:
        mov ah, 0 ; service 0 – get keystroke
        int 0x16
        in al, 0x60
        cmp al, 0x02
        je valid
        cmp al, 0x03
        je valid
        cmp al, 0x04
        je valid
        cmp al, 0x05
        je valid
        call sound
        call sound
        call sound
        call sound
        mov ax, 43
        push ax ; push x position
        mov ax, 10
        push ax ; push y position
        mov ax, 0xF4 
        push ax ; push attribute
        mov ax, err
        push ax ; push address of err
        call printstr2
        jmp l10
    valid:
        ;now level is stored in al
        call sound
        mov ah, 0
        dec ax
        mov [bp+4], ax
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        mov cl, 10
        mul byte cl ; multiply with y position
        add ax, 43 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 10 ; number of screen locations
        cld ; auto increment mode
        rep stosw

        mov al, 80 ; load al with columns per row
        mov cl, 4
        mul byte cl ; multiply with y position
        add ax, 41 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 13 ; number of screen locations
        cld ; auto increment mode
        rep stosw

        mov al, 80 ; load al with columns per row
        mov cl, 7
        mul byte cl ; multiply with y position
        add ax, 25 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 55 ; number of screen locations
        cld ; auto increment mode
        rep stosw


    popa
    pop bp
    ret

GenRandNum:
    push bp
    mov bp,sp;
    push cx
    push ax
    push dx;

    MOV AH, 00h ; interrupts to get system time
    INT 1AH ; CX:DX now hold number of clock ticks since midnight
    mov ax, dx
    xor dx, dx; 
    mov cx, 3;
    div cx ; here dx contains the remainder of the division - from 0 to 2

    ; add dl, '0' ; to ascii from '0' to '2'

    mov word[randNum],dx;

    pop dx;
    pop ax;
    pop cx;
    pop bp;
    ret

printdashes:
    push bp
    mov bp, sp
    pusha

    mov ax, 39
    push ax ; push x position
    mov ax, 9
    push ax ; push y position
    mov ax, 0x74
    push ax ; push attribute
    mov ax, message7
    push ax ; push address of message1
    call printstr2

    cmp word [bp+4], 1
    je length31
    cmp word [bp+4], 2
    je length51
    cmp word [bp+4], 3
    je length61
    cmp word [bp+4], 4
    je length91

    length31:
        push 3 ; number of screen locations
        jmp l13

    length51:
        push 5 ; number of screen locations
        jmp l13

    length61:
        push 6 ; number of screen locations
        jmp l13

    length91:
        push 9 ; number of screen locations
        jmp l13

    l13:
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        mov cl, 9
        mul byte cl ; multiply with y position
        add ax, 46 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x742D
        pop cx
        cld ; auto increment mode
        rep stosw

    popa
    pop bp
    ret 2

printhint:
    push bp
    mov bp, sp
    sub sp, 2
    pusha
    mov ax, [bp+6];y
    mov [bp-2], ax
    ;bp+4 = 1,2,3,4
    call GenRandNum;after it variable randnum wil have 0,1,2
    ;formula:after ignoring Randnum*2 zeros there will be hint print it
    push ds
    pop es

    cmp word [bp+4], 1
    je length3
    cmp word [bp+4], 2
    je length5
    cmp word [bp+4], 3
    je length6
    cmp word [bp+4], 4
    je length9

    length3:
        mov di, beginner3 ; point di to string
        jmp l11

    length5:
        mov di, medium5
        jmp l11

    length6:
        mov di, hard6
        jmp l11

    length9:
        mov di, master9
        jmp l11

    l11:
        mov ax, [randNum]
        mov cx, 2
        mul cx
        mov bx, ax
        inc bx
        push ds
        pop es
        l12:
            dec bx;
            mov cx, 0xffff ; load maximum number in cx
            xor al, al ; load a zero in al
            repne scasb ; find zero in the string
            mov ax, 0xffff ; load maximum number in ax
            sub ax, cx ; find change in cx
            dec ax ; exclude null from length
            jz exit2 ; no printing if string is empty
            mov cx, ax ; load string length in cx
            cmp bx, 0
            jne l12

            ;di pointed right
            ;print till next zero
            mov [bp+6], di
            sub di, cx
            dec di

            mov ax, 0xb800
            mov es, ax ; point es to video base
            ;mov ds, ax
            mov al, 80 ; load al with columns per row
            mul byte [bp-2] ; multiply with y position
            add ax, 50 ; add x position
            shl ax, 1 ; turn into byte offset
            mov si, di ; point si to string
            mov di, ax ; point di to required location
            mov ah, 0x74 ; load attribute in ah
            cld ; auto increment mode
            nextchar22:
                lodsb ; load next char in al
                stosw ; print char/attribute pair
                loop nextchar22 ; repeat for the whole string
        exit2:
            popa
            mov sp, bp
            pop bp
            ret 2

guesschar:
    push bp
    mov bp, sp
    sub sp, 2
    pusha
    ;bp+4 is di of word to search
    mov di, [bp+4]
    continue:
        ;firstly check on base of level if corrects = 3,5,6,9 then wingame sr wrna continue
        cmp word [level], 1
        je length311
        cmp word [level], 2
        je length511
        cmp word [level], 3
        je length611
        cmp word [level], 4
        je length911

        invalid1:
            call sound
            call sound
            call sound
            call sound
            mov ax, 45
            push ax ; push x position
            mov ax, 18
            push ax ; push y position
            mov ax, 0xF4 
            push ax ; push attribute
            mov ax, err
            push ax ; push address of err
            call printstr2
            jmp still

        length311:
            cmp word [corrects], 3
            jne still
            push di
            call wingame
            jmp ee
        
        length511:
            cmp word [corrects], 5
            jne still
            push di
            call wingame
            jmp ee

        length611:
            cmp word [corrects], 6
            jne still
            push di
            call wingame
            jmp ee

        length911:
            cmp word [corrects], 9
            jne still
            push di
            call wingame
            jmp ee       


        still:

            mov ah, 0 ; service 0 – get keystroke
            int 0x16
            ; ; ; ; ; abhi is pr validation lganay ka not to be repeated
            ; ; ; ; ; accept only A-Z
            cmp al, 0x61
            jb invalid1
            cmp al, 0x7a
            ja invalid1
            push ax
            push di
            mov ax, 0xb800
            mov es, ax ; point es to video base
            mov al, 80 ; load al with columns per row
            mov cl, 18
            mul byte cl ; multiply with y position
            add ax, 45 ; add x position
            shl ax, 1 ; turn into byte offset
            mov di, ax ; point es to video base
            mov ax, 0x7F20 ; space char in normal attribute
            mov cx, 10 ; number of screen locations
            cld ; auto increment mode
            rep stosw
            pop di
            pop ax
            ; accept only the unique inputs
            mov bx, 0;inc 2 ka hoga aur jb tk bx inpscount na hojaye check it
            l15:
                push ax
                push di
                mov ax, 0xb800
                mov es, ax ; point es to video base
                mov al, 80 ; load al with columns per row
                mov cl, 18
                mul byte cl ; multiply with y position
                add ax, 45 ; add x position
                shl ax, 1 ; turn into byte offset
                mov di, ax ; point es to video base
                mov ax, 0x7F20 ; space char in normal attribute
                mov cx, 10 ; number of screen locations
                cld ; auto increment mode
                rep stosw
                pop di
                pop ax
                add bx, 2; not even 1 input is stored
                mov si, 50
                sub si, [inpscount]
                mov dx, [inps + si + bx]
                cmp al, dl
                je invalid2
                mov cx, [inps + 50]
                cmp word [inps + si + bx], cx
                jne l15

            push 0
            push ax
            push di
            call cmpstr
            pop word [bp-2]
            cmp word [bp-2], 0
            je agai
            call sound
            jmp continue

            agai:
                call sound
                call sound
                call sound
                call sound
                push 1
                push ax
                push di
                call wronginput
                pop word [bp-2]
                cmp word [bp-2], 1
                je continue

            ee:
                popa
                mov sp, bp
                pop bp
                ret 2

        invalid2:
            call sound
            call sound
            call sound
            call sound
            mov ax, 45
            push ax ; push x position
            mov ax, 18
            push ax ; push y position
            mov ax, 0xF4 
            push ax ; push attribute
            mov ax, err
            push ax ; push address of err
            call printstr2
            jmp still

cmpstr:
    ;input a word to bool output and character to search and di of word to search
    push bp
    mov bp, sp
    pusha

    mov di, [bp+4]
    mov ax, [bp+6]
    push ax 

    ;word to find ki length find kr li
    push ds
    pop es
    mov cx, 0xffff ; load maximum number in cx
    xor al, al ; load a zero in al
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax ; exclude null from length
    jz exit3 ; no printing if string is empty
    mov cx, ax ; load string length in cx

    ;ab di wapis start pr le jao by subtracting length
    sub di, cx
    dec di
    pop ax

    ;ab cx times means length times do: load es:di in bl 2.cmp al, bl je
    l14:
        push ds
        pop es
        mov bl, [es:di]
        cmp al, bl
        je match
        inc di
        dec cx
        cmp cx, 0
        jne l14
        jmp ruko1

    match:
        inc word [corrects]
        ;start of dash se utna agay k curr di - input
        mov word [bp+8], 1
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        push cx
        mov cl, 9
        mul byte cl ; multiply with y position
        add ax, 46 ; add x position
        shl ax, 1 ; turn into byte offset
        push di
        sub di, [bp+4]
        add ax, di
        add di, ax
        mov bh, 0x74
        mov ax, bx
        stosw
        pop di
        pop cx
        inc di
        dec cx
        cmp cx, 0
        jne l14

    ruko1
        cmp word [bp+8], 1
        jne exit3
        push ax
        call removealpha

    exit3:
        popa
        mov sp, bp
        pop bp
        ret 4

removealpha:
    push bp
    mov bp, sp
    pusha
    ;if input matches any character of word then put space in keyboard at that place
    ;parameter: character [bp+4]
    ;hard code: x, y
    ;now board mai se character remove krna hai
    ;chars 1. 19 2. 17 3. 13

    cmp byte [bp+4], 0x73
    ja keyy3
    cmp byte [bp+4], 0x6A
    ja keyy2
    push ds
    pop es
    mov cx, 0xffff ; load maximum number in cx
    mov ax, [bp+4]
    mov di, key1
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax
    push ax
    mov cx, 0
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov al, 80 ; load al with columns per row
    mov cl, 10
    mul byte cl ; multiply with y position
    pop bx
    add bx, 41
    add ax, bx ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax
    mov ax, 0x7F20
    mov [es:di], ax
    jmp lk

    keyy2:
    push ds
    pop es
    mov cx, 0xffff ; load maximum number in cx
    mov ax, [bp+4]
    mov di, key2
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax
    push ax
    mov cx, 0
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov al, 80 ; load al with columns per row
    mov cl, 12
    mul byte cl ; multiply with y position
    pop bx
    add bx, 42
    add ax, bx ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax
    mov ax, 0x7F20
    mov [es:di], ax
    jmp lk

    keyy3:
    push ds
    pop es
    mov cx, 0xffff ; load maximum number in cx
    mov ax, [bp+4]
    mov di, key3
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax
    push ax
    mov cx, 0
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov al, 80 ; load al with columns per row
    mov cl, 14
    mul byte cl ; multiply with y position
    pop bx
    add bx, 44
    add ax, bx ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax
    mov ax, 0x7F20
    mov [es:di], ax    

    lk:
        mov ah, 0
        mov al, [bp+4]
        mov word [inps], ax
        push inps
        push 26
        call bubblesort
        add word [inpscount], 2
        popa
        mov sp, bp
        pop bp
        ret 2

bubblesort:
    push bp ; save old value of bp
    mov bp, sp ; make bp our reference point
    sub sp, 2 ; make two byte space on stack
    push ax ; save old value of ax
    push bx ; save old value of bx
    push cx ; save old value of cx
    push si ; save old value of si
    mov bx, [bp+6] ; load start of array in bx
    mov cx, [bp+4] ; load count of elements in cx
    dec cx ; last element not compared
    shl cx, 1 ; turn into byte count
    mainloop: mov si, 0 ; initialize array index to zero
    mov word [bp-2], 0 ; reset swap flag to no swaps
    innerloop: mov ax, [bx+si] ; load number in ax
    cmp ax, [bx+si+2] ; compare with next number
    jbe noswap ; no swap if already in order
    xchg ax, [bx+si+2] ; exchange ax with second number
    mov [bx+si], ax ; store second number in first
    mov word [bp-2], 1 ; flag that a swap has been done
    noswap: add si, 2 ; advance si to next index
    cmp si, cx ; are we at last index
    jne innerloop ; if not compare next two
    cmp word [bp-2], 1 ; check if a swap has been done
    je mainloop ; if yes make another pass
    pop si ; restore old value of si
    pop cx ; restore old value of cx
    pop bx ; restore old value of bx
    pop ax ; restore old value of ax
    mov sp, bp ; remove space created on stack
    pop bp ; restore old value of bp
    ret 4

wronginput:
    push bp
    mov bp, sp
    pusha
    mov di, [bp+4]
    mov ax, [bp+6]
    push ax
    call removealpha
    inc word [mistakes]

    cmp word [mistakes], 1
    je beamify
    cmp word [mistakes], 2
    je knotify
    cmp word [mistakes], 3
    je headify
    cmp word [mistakes], 4
    je bodify
    cmp word [mistakes], 5
    je righthandify
    cmp word [mistakes], 6
    je lefthandify
    cmp word [mistakes], 7
    je rightlegify
    cmp word [mistakes], 8
    je gameover

    beamify:
        call printbeam
        jmp endify
    knotify:
        call printknot
        jmp endify
    headify:
        call printhead
        jmp endify
    bodify:
        call printbody
        jmp endify
    lefthandify:
        call printleftarm
        jmp endify
    righthandify:
        call printrightarm
        jmp endify
    rightlegify:
        call printrightleg
        jmp endify
    gameover:
        mov word [bp+8], 0
        call printleftleg
        push di
        call endgame

    endify:
        popa
        mov sp, bp
        pop bp
        ret 4

endgame:
    push bp
    mov bp, sp
    pusha
    call delay
    push word [bp+4]
    call saaf
    ;bara sa OUT!

    ;O
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 20
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 10
    rep stosw

    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 20
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 10
    rep stosw

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 20
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    mb1:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb1

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 28
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    mb2:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb2

    ;U
    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 31
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 10
    rep stosw

    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 31
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 7
    mb3:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb3

    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 39
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 7
    mb4:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb4

    ;T
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 42
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 9
    rep stosw

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 46
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 7
    mb5:
        stosw
        add di, 158
        dec bx
        cmp bx, 0
        jne mb5

    ;!
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 52
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    mb6:
        stosw
        add di, 158
        dec bx
        cmp bx, 0
        jne mb6

    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 52
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    stosw

    popa
    mov sp, bp
    pop bp
    ret 2

wingame:
    push bp
    mov bp, sp
    pusha
    call delay
    push word [bp+4]
    call saaf
    ;bara sa won!

    ;W
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 20
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 8
    lb:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne lb

    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 29
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 8
    lb1:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne lb1

    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 22
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    stosw
    sub di, 160
    stosw
    sub di, 160
    stosw
    sub di, 160
    stosw
    add di, 160
    stosw
    add di, 160
    stosw
    add di, 160
    stosw


    ;O
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 32
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 8
    rep stosw

    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 32
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov cx, 8
    rep stosw

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 32
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    mb7:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb7

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 38
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    mb8:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb8

    ;N
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 41
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 8
    mb9:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne mb9

    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 49
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 8
    lb3:
        mov cx, 2
        rep stosw
        add di, 156
        dec bx
        cmp bx, 0
        jne lb3

    mov al, 80
    mov cl, 13
    mul byte cl
    add ax, 43
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    lb4:
        stosw
        add di, 160
        dec bx
        cmp bx, 0
        jne lb4

    ;!
    mov al, 80
    mov cl, 12
    mul byte cl
    add ax, 52
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    mov bx, 6
    lb2:
        stosw
        add di, 158
        dec bx
        cmp bx, 0
        jne lb2

    mov al, 80
    mov cl, 19
    mul byte cl
    add ax, 52
    shl ax, 1
    mov di, ax
    mov ax, 0xB020
    stosw


    popa
    mov sp, bp
    pop bp
    ret 2

saaf:
    push bp
    mov bp, sp
    pusha
    mov ax, 0xB800
    mov es, ax
    mov al, 80
    mov cl, 4
    mul byte cl
    add ax, 38
    shl ax, 1
    mov di, ax
    mov ax, 0x7F20
    mov bx, 17
    lab:
        mov cx, 42
        rep stosw
        add di, 76
        dec bx
        cmp bx, 0
        jne lab

    mov ax, 39
    push ax ; push x position
    mov ax, 9
    push ax ; push y position
    mov ax, 0x74
    push ax ; push attribute
    mov ax, message8
    push ax ; push address of message1
    call printstr2

    mov di, [bp+4]
    push ds
    pop es
    mov cx, 0xffff ; load maximum number in cx
    xor al, al ; load a zero in al
    repne scasb ; find zero in the string
    mov ax, 0xffff ; load maximum number in ax
    sub ax, cx ; find change in cx
    dec ax ; exclude null from length
    mov cx, ax ; load string length in cx

    sub di, cx
    dec di
    mov si, di
    push cx
    mov ax, 0xb800
    mov es, ax ; point es to video base=
    mov al, 80 ; load al with columns per row
    mov cl, 9
    mul byte cl ; multiply with y position
    add ax, 52 ; add x position
    shl ax, 1 ; turn into byte offset
    mov si, di ; point si to string
    mov di, ax ; point di to required location
    mov ah, 0x74 ; load attribute in ah
    pop cx
    cld ; auto increment mode
    nextchar222:
        lodsb ; load next char in al
        stosw ; print char/attribute pair
        loop nextchar222 ; repeat for the whole string

    mov ax, 0xB800
    mov es, ax
    mov al, 80
    mov cl, 11
    mul byte cl
    add ax, 19
    shl ax, 1
    mov di, ax
    mov ax, 0x4020
    mov bx, 10
    lab1:
        mov cx, 49
        rep stosw
        add di, 62
        dec bx
        cmp bx, 0
        jne lab1

    mov ax, 54
    push ax ; push x position
    mov ax, 12
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, message9
    push ax ; push address of message3
    call printstr2

    mov ax, 59
    push ax ; push x position
    mov ax, 13
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, m9
    push ax ; push address of message3
    call printstr2


    mov ax, 54
    push ax ; push x position
    mov ax, 15
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, message10
    push ax ; push address of message3
    call printstr2

    mov ax, 59
    push ax ; push x position
    mov ax, 16
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, m10
    push ax ; push address of message3
    call printstr2


    mov ax, 56
    push ax ; push x position
    mov ax, 18
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, message11
    push ax ; push address of message3
    call printstr2

    mov ax, 59
    push ax ; push x position
    mov ax, 19
    push ax ; push y position
    mov ax, 0xB0
    push ax ; push attribute
    mov ax, m11
    push ax ; push address of message3
    call printstr2
    
    popa
    mov sp, bp
    pop bp
    ret 2

sound:
    push ax
    push bx
    push cx
    mov al, 182
    out 43h, al
    mov ax, 4560	
    out 42h, al
    mov al, ah
    out 42h, al
    in al, 61h	
    or al, 00000011b
    out 61h, al
    mov bx, 25

    pause1:
        mov cx, 6000

    pause2:
        dec cx
        jne pause2
        dec bx
        jne pause1
        in al, 61h	
        and al, 11111100b
        out 61h, al
        
    pop cx
    pop bx
    pop ax
    ret

firstplay:
    push bp
    mov bp, sp
    pusha
    call clrscr
    call welcome
    push 0
    call chooselevel
    pop ax;1,2,3,4
    mov [level], ax
    call printalpha
    push word[level]
    call printdashes
    push 7; passing y and this space will be used further in sr
    push word[level]
    call printhint
    call guesschar

    validate:
        mov ah, 0 ; service 0 – get keystroke
        int 0x16
        cmp al, 0x61
        je round
        cmp al, 0x63
        je chnlev
        cmp al, 0x71
        je q
        call sound
        call sound
        call sound
        call sound
        mov ax, 69
        push ax ; push x position
        mov ax, 16
        push ax ; push y position
        mov ax, 0xF4 
        push ax ; push attribute
        mov ax, err
        push ax ; push address of err
        call printstr2
        jmp validate
        
    round:
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        mov cl, 16
        mul byte cl ; multiply with y position
        add ax, 69 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 10 ; number of screen locations
        cld ; auto increment mode
        rep stosw
        call around
        jmp validate

    chnlev:
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        mov cl, 16
        mul byte cl ; multiply with y position
        add ax, 69 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 10 ; number of screen locations
        cld ; auto increment mode
        rep stosw
        call chnglev
        jmp validate

    q:
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov al, 80 ; load al with columns per row
        mov cl, 16
        mul byte cl ; multiply with y position
        add ax, 69 ; add x position
        shl ax, 1 ; turn into byte offset
        mov di, ax ; point es to video base
        mov ax, 0x7F20 ; space char in normal attribute
        mov cx, 10 ; number of screen locations
        cld ; auto increment mode
        rep stosw
        call sound
        call clrscr
        call printman
        mov ax, 39
        push ax ; push x position
        mov ax, 9
        push ax ; push y position
        mov ax, 0x74 
        push ax ; push attribute
        mov ax, message12
        push ax ; push address of err
        call printstr2


    emp:
        popa
        mov sp, bp
        pop bp
        ret

around:
    push bp
    mov bp, sp
    pusha
    call clrscr
    mov word [corrects], 0
    mov word [mistakes], 0
    mov word [inpscount], 0
    mov bx, 0
    res:
        mov word [inps + bx], 0
        add bx, 2
        cmp bx, 52
        jna res
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;y 20 pr straight horizontal line x 0-79
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 22
    mul byte cl ; multiply with y position
    add ax, 0 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 80 ; number of screen locations
    cld ; auto increment mode
    rep stosw
    ;y 1-21 vertical line x=4
    mov al, 80 ; load al with columns per row
    mov cl, 2
    mul byte cl ; multiply with y position
    add ax, 4 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0
    ll1:
        stosw
        add di, 158
        inc cx
        cmp cx, 20
        jne ll1
    call printalpha
    push word[level]
    call printdashes
    push 7; passing y and this space will be used further in sr
    push word[level]
    call printhint
    call guesschar

    popa
    mov sp, bp
    pop bp
    ret

chnglev:
    push bp
    mov bp, sp
    pusha

    call clrscr
    mov word [corrects], 0
    mov word [mistakes], 0
    mov word [inpscount], 0
    mov bx, 0
    res1:
        mov word [inps + bx], 0
        add bx, 2
        cmp bx, 52
        jna res1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;y 20 pr straight horizontal line x 0-79
    mov ax, 0xB800
    mov es, ax
    mov al, 80 ; load al with columns per row
    mov cl, 22
    mul byte cl ; multiply with y position
    add ax, 0 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 80 ; number of screen locations
    cld ; auto increment mode
    rep stosw
    ;y 1-21 vertical line x=4
    mov al, 80 ; load al with columns per row
    mov cl, 2
    mul byte cl ; multiply with y position
    add ax, 4 ; add x position
    shl ax, 1 ; turn into byte offset
    mov di, ax ; point es to video base
    mov ax, 0x0020 ; space char in normal attribute
    mov cx, 0
    ll2:
        stosw
        add di, 158
        inc cx
        cmp cx, 20
        jne ll2
    push 0
    call chooselevel
    pop ax;1,2,3,4
    mov [level], ax
    call printalpha
    push word[level]
    call printdashes
    push 7; passing y and this space will be used further in sr
    push word[level]
    call printhint
    call guesschar

    popa
    mov sp, bp
    pop bp
    ret

start:
    call firstplay
    jmp terminate
    ;at the end take an input do you want to play another round whether player win or loose, ask this question

terminate:
    mov ax,0x4c00
    int 0x21