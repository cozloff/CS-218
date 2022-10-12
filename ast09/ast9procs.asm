; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID:2001668380
;  Section: 1003
;  Assignment: 9
;  Description: Does a plethora of functions called from a c++ file. 

; -----------------------------------------------------------------------------
;  Write assembly language functions.

;  Function, shellSort(), sorts the numbers into ascending
;  order (small to large).  Uses the shell sort algorithm
;  modified to sort in ascending order.

;  Function lstSum() to return the sum of a list.

;  Function lstAverage() to return the average of a list.
;  Must call the lstSum() function.

;  Fucntion basicStats() finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  The median is determined after the list is sorted.
;  Must call the lstSum() and lstAverage() functions.

;  Function linearRegression() computes the linear regression.
;  for the two data sets.  Must call the lstAverage() function.

;  Function readSeptNum() should read a septenary number
;  from the user (STDIN) and perform apprpriate error checking.


; ******************************************************************************

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Define program specific constants.

SUCCESS 	equ	0
NOSUCCESS	equ	1
OUTOFRANGEMIN	equ	2
OUTOFRANGEMAX	equ	3
INPUTOVERFLOW	equ	4
ENDOFINPUT	equ	5

LIMIT		equ	1510

MIN		equ	-100000
MAX		equ	100000

BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...


; ******************************************************************************

section	.text

; -----------------------------------------------------------------------------
;  Read an ASCII septenary number from the user.

;  Return codes:
;	SUCCESS			Successful conversion
;	NOSUCCESS		Invalid input entered
;	OUTOFRANGEMIN		Input below minimum value
;	OUTOFRANGEMAX		Input above maximum value
;	INPUTOVERFLOW		User entry character count exceeds maximum length
;	ENDOFINPUT		End of the input

; -----
;  Call:
;	status = readSeptNum(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr - rdi

;  Returns:
;	number read (stored in qword [rdi])
;	status code (stored in rax)


;	YOUR CODE GOES HERE
global readSeptNum
readSeptNum:
push rbp
mov rbp, rsp 
sub rsp, BUFFSIZE+5
push rbx
push r12
push r13   

    mov dword [rbp - (BUFFSIZE+4)], 7
    mov r12, rdi

    lea rbx, byte [rbp - BUFFSIZE] ;beginning of 50 byte buffer
    mov r13, 0 

    readCharacters:
        ;read chr
        mov rax, SYS_read 
        mov rdi, STDIN
        lea rsi, byte [rbp -(BUFFSIZE+5)]
        mov rdx, 1
        syscall

        ;if chr = LF => exit loop 
        mov al, byte [rbp -(BUFFSIZE+5)]
        cmp al, LF
        je readDone

        ;if (i<BUFFSIZE - 1) => don't store in buffer
        cmp r13, BUFFSIZE - 1 
        ja readCharacters
        mov byte[rbx + r13], al
        inc r13
        jmp readCharacters

    readDone: 
        cmp r13, BUFFSIZE 
        jb checkInput 
        mov rax, INPUTOVERFLOW
        jmp readFuncDone 

    checkInput: 
        cmp r13, 0
        je endInput
        mov byte [rbx + r13], NULL 
        jmp convertDeci

    endInput:
        mov rax, ENDOFINPUT
        jmp readFuncDone

    convertDeci:

    mov r13, 0 
    skipBlnks: 
        mov cl, byte [rbx + r13]
        cmp cl, " "
        jne nxt
        inc r13 
        jmp skipBlnks
    nxt: 
        mov r8, 1 
        cmp cl, "+"
        je isP
        cmp cl, "-"
        je isN
        jmp invalidChr
    isN:
        mov r8, -1
        inc r13
        mov rax, 0
        jmp nxtChar
    isP: 
        mov rax, 0
        inc r13
    nxtChar: 
        mov rcx, 0 
        mov cl, byte [rbx+r13]
        cmp cl, NULL
        je charLoopDne
        sub cl, "0"

        cmp cl, 7
        jae invalidChr

        cmp cl, 0
        jb invalidChr

        mov r9, 7
        mul r9
        add rax, rcx
        inc r13
        jmp nxtChar
    charLoopDne: 
        imul r8 
        mov r10, rax
        jmp rangeCheck

    invalidChr: 
        mov rax, NOSUCCESS
        jmp readFuncDone

    rangeCheck:

    cmp r10, MIN 
    jl tooSmall

    cmp r10, MAX
    jg tooBig
    jmp inRange

    tooSmall:
        mov rax, OUTOFRANGEMIN
        jmp readFuncDone
    tooBig: 
        mov rax, OUTOFRANGEMAX
        jmp readFuncDone
    inRange: 

    mov qword [r12], r10    ;moving into number variable 
    mov rax, SUCCESS        ;Return Success

    readFuncDone:


pop r13
pop r12
pop rbx 
mov rsp, rbp 
pop rbp
    ret

; -----------------------------------------------------------------------------
;  Shell sort function.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns:
;	sorted list (list passed by reference)


;	YOUR CODE GOES HERE

global shellSort
shellSort:
push rbp
mov rbp, rsp
push r12
push r13
push r14 
push r15

mov r12, 0
mov r13, 0
mov r14, 0


mov eax, 1								;h = 1
mov r8d, 3
setH:									;while ( (h*3+1) < a.length) 
	imul r8d 							;h = 3 * h + 1;
	add eax, 1
	cmp eax, esi	
	jge doneSetH
	mov ebx, eax
	jmp setH
doneSetH:
	mov r12d, ebx					;h should be 364 

outsideWhile:
	cmp r12d, 0 					;while( h > 0 ) {
	jle doneSort						;should loop 6 times

	mov r9d, r12d					;for (i = h-1; i < a.length; i++) 
	dec r9d 
	mov r13d, r9d
forLoop1:
	mov r10d, esi
	cmp r13d, r10d 		
	jge exitForLoop1

	mov r11d, r13d				;tmp = a[i]
	mov r8d, dword [edi+r11d*4]
	mov r15d, r8d

	mov r14d, r11d				;j = i

	mov r8d, r13d					;for( j = i; (j >= h) && (a[j-h] > tmp); j = j - h) {
	mov r14d, r8d
forLoop2:
	mov r9d, r12d
	cmp r14d, r9d 
	jl exitForLoop2
	mov r10d, r14d
	sub r10d, r9d
	mov r11d, dword [edi+r10d*4]
	cmp r11d, r15d
	jge exitForLoop2

	mov r8d, r14d				;a[j-h]
	sub r8d, r12d
	mov r9d, dword [edi+r8d*4]

	mov r10d, r14d				;a[j] = a[j-h]
	mov dword [edi+r10d*4], r9d 

	mov r8d, r12d				;j = j - h
	sub r14d, r8d
	jmp forLoop2
exitForLoop2:


	mov r9d, r15d			;a[j] = tmp
	mov r10d, r14d
	mov dword [edi+r10d*4], r9d
	inc r13d					;i++
	jmp forLoop1
exitForLoop1:


	mov r8d, 3
	mov edx, 0
	mov eax, r12d
	div r8d
	mov r12d, eax
	jmp outsideWhile
doneSort:

pop r15
pop r14
pop r13
pop r12
pop rbp
    ret

; -----------------------------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  HLL Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)



;	YOUR CODE GOES HERE

global basicStats
basicStats:
push rbp
mov rbp, rsp

	mov r10, rsi 					; min
	dec r10 
	mov r11, qword [rdi+r10*4] 
	mov qword [rdx], r11

	mov r10, 2						; med
	mov rdx, 0
	mov rax, rsi
	div r10
	cmp rdx, 0
	je evenLen
	mov r11, qword [rdi+rax*4]
	mov qword [rcx], r11
	jmp done
	evenLen:
		mov r10d, dword [edi+eax*4]
		mov r11d, dword [edi+(eax-1)*4]
		add r10d, r11d
		mov r11d, 2
		mov eax, r10d 
		cqo
		idiv r11d 
		mov qword [rcx], rax 
	done:

	mov r11, qword [rdi] 			; max
	mov qword [r8], r11

	call lstSum 					; sum
	mov dword [r9], eax 

	call lstAve						; ave
	mov r10, qword [rbp+16]
	mov qword [r10], rax

pop rbp

    ret

; -----------------------------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	sum (in eax)



;	YOUR CODE GOES HERE

global lstSum
lstSum: 
mov rcx, rsi
mov eax, 0
mov r10d, 0

stats: 
    mov r11d, dword [edi+r10d*4]
    add eax, r11d
    inc r10d
    loop stats

    ret

; -----------------------------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	average (in eax)



;	YOUR CODE GOES HERE

global lstAve
lstAve: 
call lstSum
cdq
idiv rsi
    ret

; -----------------------------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address
;	2) yList, address
;	3) length, value
;	4) xList average, value
;	5) yList average, value
;	6) b0, address
;	7) b1, address

;  Returns:
;	b0 and b1 via reference



;	YOUR CODE GOES HERE

global linearRegression
linearRegression:
push rbp
mov rbp, rsp 
push rbx
push r12	
push r13
push r14
push r15

;----------------------------------------------------
; TOP 
	mov r10, 0
	mov r11, 0
	mov r12, rdx 
	mov rax, 0
	mov rbx, 0
	top: 
		mov r11d, dword [esi+ebx*4]		;(yi - y)
		sub r11d, r8d

		mov r10d, dword [edi+ebx*4]		;(xi - x)
		sub r10d, ecx

		mov eax, r10d
		imul r11d
;		mov dword [qSum], eax
;		mov dword [qSum + 4], edx
;		add r13, qword [qSum]
		inc rbx 
		cmp rbx, r12
		jne top
;----------------------------------------------------
; BOTTOM 
	mov rbx, 0
	mov r10, 0
	mov r11, 0
	mov rax, 0
	bottom: 
		mov eax, dword [edi+ebx*4]
		sub eax, ecx 
		imul eax 
		add r10, rax 
		inc rbx
		cmp rbx, r12
		jne bottom
;----------------------------------------------------
; SET B1
	;mov r10d, dword [dSum]
	mov rax, r13 ;top value
	cqo
	idiv r10 ;bottom value
	mov r11d, dword [rbp + 16]
	mov dword [r11d], eax
	mov r15d, eax
;----------------------------------------------------
; B0
	imul rcx
	mov r11, r8
	sub r11, rax
	mov qword [r9], r11
	mov r11d, dword [rbp + 16]
	mov dword [r11d], r15d

;----------------------------------------------------
pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp
    ret

; -----------------------------------------------------------------------------

