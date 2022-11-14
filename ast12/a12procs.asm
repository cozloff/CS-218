; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 12
;  Description:  Parallel processing program to calculate narcissistic number count. 

; -----
;  Narcissistic Numbers
;	0, 1, 2, 3, 4, 5,
;	6, 7, 8, 9, 153,
;	370, 371, 407, 1634, 8208,
;	9474, 54748, 92727, 93084, 548834,
;	1741725, 4210818, 9800817, 9926315, 24678050,
;	24678051, 88593477, 146511208, 472335975, 534494836,
;	912985153, 4679307774, 32164049650, 32164049651

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
ESC		equ	27			; escape key

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

; -----
;  Globals (used by threads)

currentIndex	dq	0
myLock			dq	0
BLOCK_SIZE		dq	1000

; -----
;  Local variables for thread function(s).

msgThread1	db	" ...Thread starting...", LF, NULL

; -----
;  Local variables for getUserArgs function

LIMITMIN	equ	1000
LIMITMAX	equ	4000000000

errUsage	db	"Usgae: ./narCounter -t <1|2|3|4|5|6> ",
		db	"-l <septNumber>", LF, NULL
errOptions	db	"Error, invalid command line options."
		db	LF, NULL
errLSpec	db	"Error, invalid limit specifier."
		db	LF, NULL
errLValue	db	"Error, limit out of range."
		db	LF, NULL
errTSpec	db	"Error, invalid thread count specifier."
		db	LF, NULL
errTValue	db	"Error, thread count out of range."
		db	LF, NULL
		
; -----
;  Local variables for sept2int function

qSeven		dq	7
tmpNum		dq	0

; ***************************************************************

section	.text

; ******************************************************************
;  Thread function, numberTypeCounter()
;	Detemrine if narcissisticCount for all numbers between
;	1 and userLimit (gloabally available)

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)

common	userLimit	1:8
common	narcissisticCount	1:8
common	narcissisticNumbers	100:8

global narcissisticNumberCounter
narcissisticNumberCounter:
push rbp
mov rbp, rsp
push rbx 
push r12
push r13
push r14
push r15

	mov rdi, msgThread1							; Prints message
	call printString

;-------------------------------------------------------------------------------------------------
; Get block of 1,000
getBlock: 
	call spinLock                   
	mov rax, qword [currentIndex]
	add rax, qword [BLOCK_SIZE]
	mov qword [currentIndex], rax    				; currentIndex += BLOCK_SIZE
	call spinUnlock       
;-------------------------------------------------------------------------------------------------

	mov rbx, qword [userLimit]
	call spinLock
	mov r9, qword [currentIndex]
	call spinUnlock
	mov rcx, 0
	sub r9, 1000
narc:
	mov r11, 10
	mov r13, 0
	mov rax, r9
numLength: 										; Gets length of current index 
	mov rdx, 0
	div r11
	inc r13
	cmp rax, 0
	jne numLength 

	cmp r13, 1 
	je singleDigit 								; Single digits are narcissistic

	mov r11, 10									
	mov r14, 0
	mov r15, 0
	mov r8, r9
narcCheck: 										; Calculates narcissistic expression
	mov rdx, 0
	mov rax, r8
	div r11
	mov r10, 1 
	mov r12, rdx  
	mov r8, rax 
	mov rax, r12 
exponent:					
	mov rdx, 0 
	mul r12
	inc r10
	cmp r10, r13
	jb exponent 
	add r14, rax 
	inc r15
	cmp r15, r13 
	jbe narcCheck

	cmp r9, r14
	je isNarc 
	jmp nextNum

singleDigit: 
	mov r14, r9

isNarc:
	call spinLock
	mov r10, qword [narcissisticCount]
	call spinUnlock

	call spinLock
	mov qword [narcissisticNumbers + r10*8], r14
	inc qword [narcissisticCount]
	call spinUnlock

nextNum: 
	inc r9

	cmp r9, rbx
 	ja narcDone

	inc rcx 
	cmp rcx, 1000
	jne narc 
	jmp getBlock

narcDone: 

pop r15
pop r14
pop r13
pop r12
pop rbx
mov rsp, rbp
pop rbp
	ret



; ******************************************************************
;  Mutex lock
;	checks lock (shared gloabl variable)
;		if unlocked, sets lock
;		if locked, lops to recheck until lock is free

global	spinLock
spinLock:
	mov	rax, 1			; Set the EAX register to 1.

lock	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
					; This will always store 1 to the lock, leaving
					;  the previous value in the RAX register.

	test	rax, rax	        ; Test RAX with itself. Among other things, this will
					;  set the processor's Zero Flag if RAX is 0.
					; If RAX is 0, then the lock was unlocked and
					;  we just locked it.
					; Otherwise, RAX is 1 and we didn't acquire the lock.

	jnz	spinLock		; Jump back to the MOV instruction if the Zero Flag is
					;  not set; the lock was previously locked, and so
					; we need to spin until it becomes unlocked.
	ret

; ******************************************************************
;  Mutex unlock
;	unlock the lock (shared global variable)

global	spinUnlock
spinUnlock:
	mov	rax, 0			; Set the RAX register to 0.

	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
	ret

; ******************************************************************
;  Function getUserArgs()
;	Get, check, convert, verify range, and return the
;	sequential/parallel option and the limit.

;  Example HLL call:
;	stat = getUserArgs(argc, argv, &parFlag, &numberLimit)

;  This routine performs all error checking, conversion of ASCII/septenary
;  to integer, verifies legal range.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;	-t <1|2|3|4|5|6> -l <septNumber>

; -----
;  Arguments:
;	1) ARGC, value						: rdi 
;	2) ARGV, address					: rsi 
;	3) thread count (dword), address	: rdx 
;	4) user limit (qword), address		: rcx 

global getUserArgs
getUserArgs: 
push rbp
mov rbp, rsp
push rbx 
push r12 
push r13
push r14
mov r13, rcx
mov r14, rdx

	cmp rdi, 5				;Check for 5 arguments 
	je validCommand
	cmp rdi, 1 				;Check if usageErr
	je usageErr
	jmp optionsErr

validCommand:

;----------------------------------------------------------------
;  Thread Count Specifier 

tSpecTest:
	mov rbx, 0
	mov rbx, qword [rsi+8]		;Get thread count specifier command line argument

	mov al, byte [rbx]			;Check -
	cmp al, "-"
	jne tSpecErr

	mov al, byte [rbx + 1]		;Check t
	cmp al, "t"
	jne tSpecErr

	mov al, byte [rbx + 2]		;Check NULL
	cmp al, NULL
	jne tSpecErr

;----------------------------------------------------------------
; Thread Count Range 

	mov rbx, 0
	mov rbx, qword [rsi+16]		;Get thread count value command line argument

	mov r10, 1
	mov al, byte [rbx]			
	cmp al, "1"
	je limitRangeGood
	inc r10 
	cmp al, "2"
	je limitRangeGood
	inc r10 
	cmp al, "3"
	je limitRangeGood
	inc r10 
	cmp al, "4"
	je limitRangeGood
	inc r10 
	cmp al, "5"
	je limitRangeGood
	inc r10 
	cmp al, "6"
	je limitRangeGood
	jmp tValueErr

limitRangeGood: 
	mov al, byte [rbx + 1]
	cmp al, NULL
	jne tValueErr

	mov qword [r14], r10		;If valid, return value 
;----------------------------------------------------------------
; Limit Specifier 

lSpecTest:
	mov rbx, 0
	mov rbx, qword [rsi+24]		;Get limit specifier command line argument

	mov al, byte [rbx]			;Check -
	cmp al, "-"
	jne lSpecErr

	mov al, byte [rbx + 1]		;Check t
	cmp al, "l"
	jne lSpecErr

	mov al, byte [rbx + 2]		;Check NULL
	cmp al, NULL
	jne lSpecErr

;----------------------------------------------------------------
; Limit Count Range 

	mov rdi, qword [rsi+32]		;SEPT Value to INT 
	mov rsi, r13 				;Address for Limit Count 
	call aSept2int

	cmp rax, TRUE				;If not TRUE, ERR
	jne lValueErr 

;----------------------------------------------------------------
; Return 
	mov rax, TRUE
	jmp testDone
usageErr: 
	mov rdi, errUsage		;"Usgae: ./narCounter -t <1|2|3|4|5|6> -l <septNumber>"
	jmp printIt
optionsErr: 
	mov rdi, errOptions		;"Error, invalid command line options."
	jmp printIt
lSpecErr: 
	mov rdi, errLSpec		;"Error, invalid limit specifier."
	jmp printIt
lValueErr: 
	mov rdi, errLValue		;"Error, limit out of range."
	jmp printIt
tSpecErr:
	mov rdi, errTSpec		;"Error, invalid thread count specifier."
	jmp printIt
tValueErr: 
	mov rdi, errTValue		;"Error, thread count out of range."
	jmp printIt
printIt:
	call printString
	mov rax, FALSE
testDone:

pop r14
pop r13
pop r12 
pop rbx
mov rsp, rbp
pop rbp
	ret

; ******************************************************************
;  Function: Check and convert ASCII/septenary to integer.

;  Example HLL Call:
;	bool = aSept2int(septStr, &num);
; -----
;  Arguments:
;	1) septStr, value					: rdi 
;	2) &num, address					: rsi 

global aSept2int 
aSept2int: 
push rbp
mov rbp, rsp
push rbx 
push r12 
push r13
push r14
mov r14, rsi

	mov rbx, rdi
	mov r13, 0 						;Counter 
nxtChar: 
	mov r12, 0 					
	mov r12b, byte [rbx+r13]		;Get ASCII Chararcter
	cmp r12, NULL
	je sepDone						;Loop until NULL
	sub r12b, "0"

	cmp r12b, 7
	jae outOfRange

	cmp r12b, 0
	jb outOfRange

	mov r9, 7
	mul r9
	add rax, r12					;Convert to integer
	inc r13
	jmp nxtChar
sepDone: 
	mov r10, rax					;Get speed integer value 

 	cmp r10, LIMITMIN				;Check if less than min
    jb outOfRange

	mov r11, LIMITMAX
    cmp r10, r11				;Check if greater than max
    ja outOfRange
    jmp sepInRange

outOfRange:						
	mov rax, FALSE 
	jmp sepFinal
sepInRange: 
    mov dword [r14], r10d    ;Return back speed variable 
    mov rax, TRUE
sepFinal: 

pop r14
pop r13
pop r12 
pop rbx
mov rsp, rbp
pop rbp
	ret






; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rbx
	ret

; ******************************************************************

