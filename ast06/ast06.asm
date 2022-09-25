; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 6
;  Description:	Simple assembly language program to calculate 
;		the diameters if a circle for a series of circles.
;		The circle radii lengths are provided as septenary values
;		represented as ASCII characters and must be converted into
;		integer in order to perform the calculations.

; =====================================================================
;  STEP #2
;  Macro to convert ASCII/septenary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	aSept2int  <string>, <integer>

;  Example usage:
;	aSept2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered before the address is copied into
;  another register (if desired).

%macro	aSept2int	2

;	STEP #2
;	YOUR CODE GOES HERE
	push	rax			; save altered registers (cautionary)
	push	rdi
	push	r8
	push	r9
	push	rcx

mov rdi, 0 

%%skipBlnks: 
    mov cl, byte [%1+rdi]
    cmp cl, " "
	jne %%nxt
    inc rdi 
    jmp %%skipBlnks
%%nxt: 
    mov r8d, 1 
    cmp cl, "-"
    jne %%isP
    mov r8d, -1
	inc rdi
	mov eax, 0
	jmp %%nxtChar
%%isP: 
    mov eax, 0
	inc rdi
%%nxtChar: 
    mov ecx, 0 
    mov cl, byte [%1+rdi]
    cmp cl, NULL
    je %%charLoopDne
    sub cl, "0"
    mov r9d, 7
    mul r9d
    add eax, ecx
	inc rdi
    jmp %%nxtChar
%%charLoopDne: 
	imul r8d 
	mov dword [%2], eax

	pop	rcx
	pop	r9
	pop	r8
	pop	rdi
	pop	rax	

%endmacro

; =====================================================================
;  Macro to convert integer to septenary value in ASCII format.
;  Reads <integer>, converts to ASCII/septenary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aSept	<integer-value>, <string-address>

;  Example usage:
;	int2aSept	dword [diamsArrays+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aSept	2

;	STEP #5
;	YOUR CODE GOES HERE
push	rax			; save altered registers (cautionary)
push	rsi
push	r8
push 	r11
push	r10
push	rcx
push	rdx 

mov rsi, 0 
mov ecx, STR_LENGTH-2 
%%initStrng: 
	mov byte [%2+rsi], " " 
	inc rsi
	loop %%initStrng
mov byte [%2+STR_LENGTH-1], NULL

mov r11d, -1
cmp %1, 0
jge %%postv
mov r10b, "-"
mov eax, %1
imul r11d
jmp %%negatv
%%postv: 
	mov eax, %1
	mov r10b, "+"
%%negatv:

mov rsi, STR_LENGTH-2
mov r8d, 7

%%bsSvn: 
	cdq
	idiv r8d   
	add edx, "0"
	mov byte [%2+rsi], dl
	dec rsi
	cmp eax, 0 
	je %%dimSumDon
	jmp %%bsSvn
%%dimSumDon: 
	mov byte [%2+rsi], r10b

pop		rdx 
pop		rcx
pop		r10
pop	 	r11
pop		r8
pop		rsi
pop		rax	

%endmacro

; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers (cautionary)
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Initialized variables.

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

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

NUMS_PER_LINE	equ	4


; -----
;  Assignment #6 Provided Data

STR_LENGTH	equ	12			; chars in string, with NULL

septRadii	db	"         +5", NULL, "        +10", NULL, "        +16", NULL
			db	"        +24", NULL, "        +35", NULL, "        +46", NULL
			db	"        +55", NULL, "        +63", NULL, "       +106", NULL
			db	"       +143", NULL, "       +144", NULL, "       +155", NULL
			db	"      -2542", NULL, "      -1610", NULL, "      -1361", NULL
			db	"       +266", NULL, "       +330", NULL, "       +421", NULL
			db	"       +502", NULL, "       +516", NULL, "       +642", NULL
			db	"      +1161", NULL, "      +1135", NULL, "      +1246", NULL
			db	"      -1116", NULL, "      -1000", NULL, "       -136", NULL
			db	"      +1540", NULL, "      +1651", NULL, "      +2151", NULL
			db	"      +2161", NULL, "     +10063", NULL, "     -11341", NULL
			db	"     +12224", NULL
aSeptLength	db	"        +46", NULL
length		dd	0

diamSum		dd	0
diamAve		dd	0
diamMin		dd	0
diamMax		dd	0

; -----
;  Misc. variables for main.

hdr		db	"-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Diameter Calculations", LF, LF
		db	"Diameters: ", LF, NULL
shdr		db	LF, "Diameters Sum:  ", NULL
avhdr		db	LF, "Diameters Ave:  ", NULL
minhdr		db	LF, "Diameters Min:  ", NULL
maxhdr		db	LF, "Diameters Max:  ", NULL

newLine		db	LF, NULL
spaces		db	"   ", NULL

ddTwo		dd	2

; =====================================================================
;  Uninitialized variables

section	.bss

tmpInteger	resd	1				; temporaty value

diamsArray	resd	34

lenString	resb	STR_LENGTH
tempString	resb	STR_LENGTH			; bytes

diamSumString	resb	STR_LENGTH
diamAveString	resb	STR_LENGTH
diamMinString	resb	STR_LENGTH
diamMaxString	resb	STR_LENGTH

; **************************************************************

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

printString	hdr

; -----
;  STEP #1
;	Convert integer length, in ASCII septenary format to integer.
;	Do not use macro here...
;	Read string aSeptLength1, convert to integer, and store in length

;	YOUR CODE GOES HERE

mov rdi, 0 

skipBlanks: 
    mov cl, byte [aSeptLength+rdi]
    cmp cl, " "
    jne next 
    inc rdi 
    jmp skipBlanks
next: 
    mov r8d, 1 
    cmp cl, "-"
    jne isPos
    mov r8d, -1
	inc rdi
	mov eax, 0 
	jmp nextChar
isPos: 
    mov eax, 0
	inc rdi
nextChar: 
    mov ecx, 0 
    mov cl, byte [aSeptLength+rdi]
    cmp cl, NULL
    je charLoopDone
    sub cl, "0"
    mov r9d, 7
    mul r9d
    add eax, ecx
	inc rdi
    jmp nextChar
charLoopDone: 
	imul eax, r8d 
	mov dword [length], eax

; -----
;  Convert radii from ASCII/septenary format to integer.
;  STEP #2 must complete before this code.

	mov	ecx, dword [length]
	mov	rdi, 0					; index for radii
	mov	rbx, septRadii
cvtLoop:
	push	rbx					; safety push's
	push	rcx
	push	rdi
	aSept2int	rbx, tmpInteger
	pop	rdi
	pop	rcx
	pop	rbx

	mov	eax, dword [tmpInteger]
	mul	dword [ddTwo]				; diam = radius * 2
	mov	dword [diamsArray+rdi*4], eax
	add	rbx, STR_LENGTH

	inc	rdi
	dec	ecx
	cmp	ecx, 0
	jne	cvtLoop
;
; -----
;  Display each the diamsArray (four per line).

	mov	ecx, dword [length]
	mov	rsi, 0
	mov	r12, 0
printLoop:
	push	rcx					; safety push's
	push	rsi
	push	r12

	mov	eax, dword [diamsArray+rsi*4]
	int2aSept	eax, tempString

	printString	tempString
	printString	spaces

	pop	r12
	pop	rsi
	pop	rcx

	inc	r12
	cmp	r12, 4
	jne	skipNewline
	mov	r12, 0
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  STEP #3
;	Find diamaters array stats (sum, min, max, and average).
;	Reads data from diamsArray (set above).

;	YOUR CODE GOES HERE

mov eax, dword [diamsArray]
mov dword [diamMin], eax
mov dword [diamMax], eax

mov ecx, dword [length]
mov rsi, 0

; -----
;  Finds diamSum, diamMin, and diamMax
diamStats: 
    mov eax, dword [diamsArray+rsi*4]
    add dword [diamSum], eax
    cmp eax, dword [diamMin]
    jge notdiamMin
    mov dword [diamMin], eax 
notdiamMin:
    cmp eax, dword [diamMax]
    jle notdiamMax
    mov dword [diamMax], eax 
notdiamMax:
    inc rsi
    loop diamStats

; -----
;  Finds diamAve

mov eax, dword [diamSum]
cdq
idiv dword [length]
mov dword [diamAve], eax

; -----
;  STEP #4
;	Convert sum to ASCII/septenary for printing.
;	Do not use macro here...

	printString	shdr

;	Read diamsArray sum inetger (set above), convert to
;		ASCII/septenary and store in diamSumString.

;	YOUR CODE GOES HERE

mov rsi, 0 
mov ecx, STR_LENGTH-2 
initializeString: 
	mov byte [diamSumString+rsi], " " 
	inc rsi
	loop initializeString 
mov byte [diamSumString+STR_LENGTH-1], NULL

mov r9d, -1
cmp dword [diamSum], 0
jge isPositive
mov r10b, "-"
mov eax, dword [diamSum]
imul r9d 
jmp isNegative
isPositive: 
	mov eax, dword [diamSum]
	mov r10b, "+"
isNegative: 

mov rsi, STR_LENGTH-2
mov r8d, 7

baseSeven: 
	cdq
	idiv r8d   
	add edx, "0"
	mov byte [diamSumString+rsi], dl
	dec rsi
	cmp eax, 0 
	je diamSumDone
	jmp baseSeven
diamSumDone: 
	mov byte [diamSumString+rsi], r10b



;	print the diamSumString (set above).
	printString	diamSumString

; -----
;  Convert average, min, and max integers to ASCII/septenary for printing.
;  STEP #5 must complete before this code.

	printString	avhdr
	int2aSept	dword [diamAve], diamAveString
	printString	diamAveString

	printString	minhdr
	int2aSept	dword [diamMin], diamMinString
	printString	diamMinString

	printString	maxhdr
	int2aSept	dword [diamMax], diamMaxString
	printString	diamMaxString

	printString	newLine
	printString	newLine

; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

