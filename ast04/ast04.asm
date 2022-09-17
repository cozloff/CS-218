;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 4
;  Description: Finds min, median, max, sum, and average of a list of numbers.

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----

lst		dd	4224, 1116, 1542, 1240, 1677
		dd	1635, 2420, 1820, 1246, 1333 
		dd	2315, 1215, 2726, 1140, 2565
		dd	2871, 1614, 2418, 2513, 1422 
		dd	1119, 1215, 1525, 1712, 1441
		dd	3622, 1731, 1729, 1615, 2724 
		dd	1217, 1224, 1580, 1147, 2324
		dd	1425, 1816, 1262, 2718, 1192 
		dd	1435, 1235, 2764, 1615, 1310
		dd	1765, 1954, 1967, 1515, 1556 
		dd	1342, 7321, 1556, 2727, 1227
		dd	1927, 1382, 1465, 3955, 1435 
		dd	1225, 2419, 2534, 1345, 2467
		dd	1615, 1959, 1335, 2856, 2553 
		dd	1035, 1833, 1464, 1915, 1810
		dd	1465, 1554, 1267, 1615, 1656 
		dd	2192, 1825, 1925, 2312, 1725
		dd	2517, 1498, 1677, 1475, 2034 
		dd	1223, 1883, 1173, 1350, 2415
		dd	1335, 1125, 1118, 1713, 3025
length		dd	100

lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

oddCnt		dd	0
oddSum		dd	0
oddAve		dd	0

nineCnt		dd	0
nineSum		dd	0
nineAve		dd	0

; *****************************************************************

section	.text
global _start
_start:

; ********************************************

; -----
;  Initialize lstMin, lstMax, ecx, and rsi register
mov eax, dword [lst]
mov dword [lstMin], eax
mov dword [lstMax], eax

mov ecx, dword [length]
mov rsi, 0

; -----
;  Finds lstSum, lstMin, and lstMax
lstStats: 
    mov eax, dword [lst+rsi*4]
    add dword [lstSum], eax
    cmp eax, dword [lstMin]
    jae notlstMin
    mov dword [lstMin], eax 
notlstMin:
    cmp eax, dword [lstMax]
    jbe notlstMax
    mov dword [lstMax], eax 
notlstMax:
    inc rsi
    loop lstStats

; -----
;  Finds lstAve

mov edx, 0
mov eax, dword [lstSum]
div dword [length]
mov dword [lstAve], eax

; -----
;  Finds estMed

;Sum of first and last
mov r9d, dword [lst]
mov r8d, dword [length]
sub r8d, 1 
mov ebx, dword [lst + r8d*4]
add r9d, ebx 

;Sum of 2 middle values
mov edx, 0
mov eax, dword [length]
mov ebx, 2
div ebx
mov r10d, eax 
mov r11d, dword [lst+r10d*4]
mov r12d, dword [lst+(r10d-1)*4]
add r11d, r12d 

;Sum first, last, and 2 middle values. Then divide by 4
add r9d, r11d
mov edx, 0
mov eax, r9d
mov ebx, 4
div ebx 
mov dword [estMed], eax

; -----
;  Finds oddCnt, oddSum

mov ecx, dword [length]
mov r8d, 2
mov rsi, 0 

oddStats: 
    mov ebx, dword [lst+rsi*4]
    mov edx, 0
    mov eax, dword [lst+rsi*4]
    div r8d 
    cmp edx, 1 
    jae oddNum
    inc rsi
    loop oddStats
oddNum:
    inc dword [oddCnt]
    add dword [oddSum], ebx
    inc rsi
    loop oddStats

; -----
;  Finds oddAve
mov edx, 0
mov eax, dword [oddSum]
div dword [oddCnt]
mov dword [oddAve], eax

; -----
;  Finds nineCnt, nineSum

mov ecx, dword [length]
mov r9d, 9
mov rsi, 0 

nineStats: 
    mov ebx, dword [lst+rsi*4]
    mov edx, 0
    mov eax, dword [lst+rsi*4]
    div r9d 
    cmp edx, 0 
    je nineNum
    inc rsi
    loop nineStats
    jmp breakout
nineNum:
    inc dword [nineCnt]
    add dword [nineSum], ebx
    inc rsi
    loop nineStats
breakout:

; -----
;  Finds nineAve
mov edx, 0
mov eax, dword [nineSum]
div dword [nineCnt]
mov dword [nineAve], eax

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
