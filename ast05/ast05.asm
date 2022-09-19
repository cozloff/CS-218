;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 5
;  Description: Finds stats like area and volume on rectangular prisms.

; --------------------------------------------------------------

section	.data

; -----
;  Define constants.

NULL		    equ	0			; end of string

TRUE		    equ	1
FALSE		    equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	    equ	60			; call code for terminate

; -----
;  Provided Data

lengths		dd	 1355,  1037,  1123,  1024,  1453
            dd	 1115,  1135,  1123,  1123,  1123
            dd	 1254,  1454,  1152,  1164,  1542
            dd	-1353,  1457,  1182, -1142,  1354
            dd	 1364,  1134,  1154,  1344,  1142
            dd	 1173, -1543, -1151,  1352, -1434
            dd	 1134,  2134,  1156,  1134,  1142
            dd	 1267,  1104,  1134,  1246,  1123
            dd	 1134, -1161,  1176,  1157, -1142
            dd	-1153,  1193,  1184,  1142

widths		dw	  367,   316,   542,   240,   677
            dw	  635,   426,   820,   146,  -333
            dw	  317,  -115,   226,   140,   565
            dw	  871,   614,   218,   313,   422	
            dw	 -119,   215,  -525,  -712,   441
            dw	 -622,  -731,  -729,   615,   724
            dw	  217,  -224,   580,   147,   324
            dw	  425,   816,   262,  -718,   192
            dw	 -432,   235,   764,  -615,   310
            dw	  765,   954,  -967,   515

heights		db	   42,    21,    56,    27,    35
            db	  -27,    82,    65,    55,    35
            db	  -25,   -19,   -34,   -15,    67
            db	   15,    61,    35,    56,    53
            db	  -32,    35,    64,    15,   -10
            db	   65,    54,   -27,    15,    56
            db	   92,   -25,    25,    12,    25
            db	  -17,    98,   -77,    75,    34
            db	   23,    83,   -73,    50,    15
            db	   35,    25,    18,    13

count		dd	49

vMin		dd	0
vEstMed		dd	0
vMax		dd	0
vSum		dd	0
vAve		dd	0

saMin		dd	0
saEstMed	dd	0
saMax		dd	0
saSum		dd	0
saAve		dd	0

; -----
; Additional variables (if any)



; --------------------------------------------------------------
; Uninitialized data

section	.bss

volumes		    resd	49
surfaceAreas	resd	49

; *****************************************************************

section	.text
global _start
_start:

; ********************************************

; -----
;  Finds volumes

mov ecx, dword [count]
mov rsi, 0

volumeLoop:
    mov eax, dword [lengths+rsi*4]
    movsx r8d, byte [heights+rsi]
    imul r8d
    movsx r9d, word [widths+rsi*2]
    imul r9d
    mov dword [volumes+rsi*4], eax

    inc rsi
    loop volumeLoop

; -----
;  Finds surfaceAreas

mov ecx, dword [count]
mov ebx, 2
mov rsi, 0

surfaceAreaLoop: 
    mov eax, dword [lengths+rsi*4]
    imul ebx
    movsx r8d, word [widths+rsi*2]
    imul r8d
    mov dword [surfaceAreas+rsi*4], eax

    mov eax, dword [lengths+rsi*4]
    imul ebx
    movsx r8d, byte [heights+rsi]
    imul r8d
    add dword [surfaceAreas+rsi*4], eax

    movsx eax, word [widths+rsi*2]
    imul ebx
    movsx r8d, byte [heights+rsi]
    imul r8d
    add dword [surfaceAreas+rsi*4], eax

    inc rsi
    loop surfaceAreaLoop

; -----
;  Initialize vMin, vMax, ecx, and rsi register
mov eax, dword [volumes]
mov dword [vMin], eax
mov dword [vMax], eax

mov ecx, dword [count]
mov rsi, 0

; -----
;  Finds vSum, vMin, and vMax
volumeStats: 
    mov eax, dword [volumes+rsi*4]
    add dword [vSum], eax
    cmp eax, dword [vMin]
    jge notvMin
    mov dword [vMin], eax 
notvMin:
    cmp eax, dword [vMax]
    jle notvMax
    mov dword [vMax], eax 
notvMax:
    inc rsi
    loop volumeStats

; -----
;  Finds lstAve

mov eax, dword [vSum]
cdq
idiv dword [count]
mov dword [vAve], eax

; -----
;  Finds estMed

;Sum of first and last
mov r9d, dword [volumes]
mov r8d, dword [count]
sub r8d, 1 
mov ebx, dword [volumes + r8d*4]
add r9d, ebx 

;Find middle value
mov eax, dword [count]
cdq
mov ebx, 2
idiv ebx
mov r10d, eax 
mov r11d, dword [volumes+r10d*4]

;Sum first, last, and middle value. Then divide by 3
add r9d, r11d
mov eax, r9d
cdq
mov ebx, 3
idiv ebx 
mov dword [vEstMed], eax

; -----
;  Initialize saMin, saMax, ecx, and rsi register
mov eax, dword [surfaceAreas]
mov dword [saMin], eax
mov dword [saMax], eax

mov ecx, dword [count]
mov rsi, 0

; -----
;  Finds saSum, saMin, and saMax
surfaceAreaStats: 
    mov eax, dword [surfaceAreas+rsi*4]
    add dword [saSum], eax
    cmp eax, dword [saMin]
    jge notsaMin
    mov dword [saMin], eax 
notsaMin:
    cmp eax, dword [saMax]
    jle notsaMax
    mov dword [saMax], eax 
notsaMax:
    inc rsi
    loop surfaceAreaStats

; -----
;  Finds saAve

mov eax, dword [saSum]
cdq
idiv dword [count]
mov dword [saAve], eax

; -----
;  Finds estMed

;Sum of first and last
mov r9d, dword [surfaceAreas]
mov r8d, dword [count]
sub r8d, 1 
mov ebx, dword [surfaceAreas + r8d*4]
add r9d, ebx 

;Find middle value
mov eax, dword [count]
cdq
mov ebx, 2
idiv ebx
mov r10d, eax 
mov r11d, dword [surfaceAreas+r10d*4]

;Sum first, last, and middle value. Then divide by 3
add r9d, r11d
mov eax, r9d
cdq
mov ebx, 3
idiv ebx 
mov dword [saEstMed], eax

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall