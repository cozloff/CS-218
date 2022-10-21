; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 10
;  Description:  Uses OpenGL to display a wheel 

; -----
;  Function: getParams
;	Gets, checks, converts, and returns command line arguments.

;  Function drawWheels()
;	Plots functions

; ---------------------------------------------------------

;	MACROS (if any) GO HERE


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program specific constants.

SPD_MIN		equ	1
SPD_MAX		equ	50			; 101(7) = 50

CLR_MIN		equ	0
CLR_MAX		equ	0xFFFFFF		; 0xFFFFFF = 262414110(7)

SIZ_MIN		equ	100			; 202(7) = 100
SIZ_MAX		equ	2000			; 5555(7) = 2000

; -----
;  Local variables for getParams functions.

STR_LENGTH	equ	12

errUsage	db	"Usage: ./wheels -sp <septNumber> -cl <septNumber> "
		db	"-sz <septNumber>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL

errSpdSpec	db	"Error, speed specifier incorrect."
		db	LF, NULL
errSpdValue	db	"Error, speed value must be between 1 and 101(7)."
		db	LF, NULL

errClrSpec	db	"Error, color specifier incorrect."
		db	LF, NULL
errClrValue	db	"Error, color value must be between 0 and 262414110(7)."
		db	LF, NULL

errSizSpec	db	"Error, size specifier incorrect."
		db	LF, NULL
errSizValue	db	"Error, size value must be between 202(7) and 5555(7)."
		db	LF, NULL

; -----
;  Local variables for drawWheels routine.

t		dq	0.0			; loop variable
s		dq	0.0
tStep		dq	0.001			; t step
sStep		dq	0.0
x		dq	0			; current x
y		dq	0			; current y
scale		dq	7500.0			; speed scale

fltZero		dq	0.0
fltOne		dq	1.0
fltTwo		dq	2.0
fltThree	dq	3.0
fltFour		dq	4.0
fltSix		dq	6.0
fltTwoPiS	dq	0.0

pi		dq	3.14159265358

fltTmp1		dq	0.0
fltTmp2		dq	0.0

red		dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255


; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern	glutInit, glutInitDisplayMode, glutInitWindowSize, glutInitWindowPosition
extern	glutCreateWindow, glutMainLoop
extern	glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern	glutSwapBuffers, gluPerspective, glutPostRedisplay
extern	glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern	glClear, glLoadIdentity, glMatrixMode, glViewport
extern	glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern	glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d

extern	cos, sin


; ******************************************************************
;  Function getParams()
;	Gets draw speed, draw color, and screen size
;	from the command line arguments.

;	Performs error checking, converts ASCII/septenary to integer.
;	Command line format (fixed order):
;	  "-sp <septNumber> -cl <septNumber> -sz <septyNumber>"

; -----
;  Arguments:
;	ARGC, double-word, value : rdi 
;	ARGV, double-word, address : rsi 
;	speed, double-word, address : rdx 
;	color, double-word, address : rcx 
;	size, double-word, address : r8

; Returns:
;	speed, color, and size via reference (of all valid)
;	TRUE or FALSE

;	YOUR CODE GOES HERE

global getParams
getParams:
push rbp 
mov rbp, rsp 
push rbx 
push r12 
push r13

argumentCheck: 
	cmp rdi, 7
	jne invalidCommandLine

invalidCommandLine:
	mov rdi, errBadCL
	mov rax, FALSE
	jmp printString

;----------------------------------------------------------------
; Speed 

spdTest:
	mov rbx, 0
	mov rbx, qword [rsi+8]		;Get -sp specifier 

	mov al, byte [rbx]			;Check -
	cmp al, "-"
	jne errSPspec

	mov al, byte [rbx+1]		;Check s
	cmp al, "s"
	jne errSPspec

	mov al, byte [rbx+2]		;Check p
	cmp al, "p"
	jne errSPspec

	mov al, byte [rbx+3]		;Check NULL
	cmp al, NULL
	jne errSPspec 

	mov rbx, qword [rsi + 16] 	;Get Sept-ASCII speed value 

	mov r13, 0 					;Counter 
nxtSpdChar: 
	mov rcx, 0 					
	mov cl, byte [rbx+r13]		;Get ASCII Chararcter
	cmp cl, NULL
	je spdLoopDne				;Loop until NULL
	sub cl, "0"

	cmp cl, 7
	jae errSPspec

	cmp cl, 0
	jb errSPspec

	mov r9, 7
	mul r9
	add rax, rcx				;Convert to integer
	inc r13
	jmp nxtSpdChar
spdLoopDne: 
	mov r10, rax				;Get speed integer value 
	jmp spdRangeCheck

spdRangeCheck:
 	cmp r10, SPD_MIN			;Check if greater than min
    jl spdTooSmall

    cmp r10, SPD_MAX				;Check if greater than max
    jg spdTooBig
    jmp spdInRange

spdTooSmall:						;Too small
	mov rdi, errSpdValue
	mov rax, FALSE
	jmp printString
spdTooBig: 						;Too large
	mov rdi, errSpdValue
	mov rax, FALSE
	jmp printString
spdInRange: 

    mov dword [rdx], r10d    ;Return back speed variable 
    jmp clrTest

errSPspec:					;If invalid input 
	mov rdi, errSpdSpec
	mov rax, FALSE
	jmp printString
	
;----------------------------------------------------------------
; Color 

clrTest:
	mov rbx, 0
	mov rbx, qword [rsi+24]		;Get -cl specifier 

	mov al, byte [rbx]			;Check -
	cmp al, "-"
	jne errCLspec

	mov al, byte [rbx+1]		;Check c
	cmp al, "c"
	jne errCLspec

	mov al, byte [rbx+2]		;Check l
	cmp al, "l"
	jne errCLspec

	mov al, byte [rbx+3]		;Check NULL
	cmp al, NULL
	jne errCLspec 

	mov rbx, qword [rsi + 32] 	;Get Sept-ASCII color value 

	mov r13, 0 					;Counter 
nxtClrChar: 
	mov rcx, 0 					
	mov cl, byte [rbx+r13]		;Get ASCII Chararcter
	cmp cl, NULL
	je clrLoopDne				;Loop until NULL
	sub cl, "0"

	cmp cl, 7
	jae errCLspec

	cmp cl, 0
	jb errCLspec

	mov r9, 7
	mul r9
	add rax, rcx				;Convert to integer
	inc r13
	jmp nxtClrChar
clrLoopDne: 
	mov r10, rax				;Get speed integer value 
	jmp clrRangeCheck

clrRangeCheck:
 	cmp r10, CLR_MIN			;Check if greater than min
    jl clrTooSmall

    cmp r10, CLR_MAX				;Check if greater than max
    jg clrTooBig
    jmp clrInRange

clrTooSmall:						;Too small
	mov rdi, errClrValue
	mov rax, FALSE
	jmp printString
clrTooBig: 						;Too large
	mov rdi, errClrValue
	mov rax, FALSE
	jmp printString
clrInRange: 

    mov dword [rcx], r10d    ;Return back speed variable 
    jmp sizTest

errCLspec:					;If invalid input 
	mov rdi, errClrSpec
	mov rax, FALSE
	jmp printString

;----------------------------------------------------------------
; Size 

sizTest:
	mov rbx, 0
	mov rbx, qword [rsi+40]		;Get -sz specifier 

	mov al, byte [rbx]			;Check -
	cmp al, "-"
	jne errSZspec

	mov al, byte [rbx+1]		;Check s
	cmp al, "s"
	jne errSZspec

	mov al, byte [rbx+2]		;Check z
	cmp al, "z"

	jne errSZspec

	mov al, byte [rbx+3]		;Check NULL
	cmp al, NULL
	jne errSZspec 

	mov rbx, qword [rsi + 48] 	;Get Sept-ASCII color value 

	mov r13, 0 					;Counter 
nxtSizChar: 
	mov rcx, 0 					
	mov cl, byte [rbx+r13]		;Get ASCII Chararcter
	cmp cl, NULL
	je sizLoopDne				;Loop until NULL
	sub cl, "0"

	cmp cl, 7
	jae errSZspec

	cmp cl, 0
	jb errSZspec

	mov r9, 7
	mul r9
	add rax, rcx				;Convert to integer
	inc r13
	jmp nxtSizChar
sizLoopDne: 
	mov r10, rax				;Get speed integer value 
	jmp sizRangeCheck

sizRangeCheck:
 	cmp r10, SIZ_MIN			;Check if greater than min
    jl sizTooSmall

    cmp r10, SIZ_MAX				;Check if greater than max
    jg sizTooBig
    jmp sizInRange

sizTooSmall:						;Too small
	mov rdi, errSizValue
	mov rax, FALSE
	jmp printString
sizTooBig: 						;Too large
	mov rdi, errSizValue
	mov rax, FALSE
	jmp printString
sizInRange: 

    mov dword [r8], r10d    ;Return back speed variable 
    mov rax, TRUE 

errSZspec:					;If invalid input 
	mov rdi, errSizSpec
	mov rax, FALSE
	jmp printString 

pop r13
pop r12 
pop rbx 
pop rsp, rbp 
pop rbp
	ret



; ******************************************************************
;  Draw wheels function.
;	Plot the provided functions (see PDF).

; -----
;  Arguments:
;	none -> accesses global variables.
;	nothing -> is void

; -----
;  Gloabl variables Accessed:

common	speed		1:4			; draw speed, dword, integer value
common	color		1:4			; draw color, dword, integer value
common	size		1:4			; screen size, dword, integer value

global drawWheels
drawWheels:
	push	rbp

; do NOT push any additional registers.
; If needed, save regitser to quad variable...

; -----
;  Set draw speed step
;	sStep = speed / scale

;	YOUR CODE GOES HERE

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);
	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set draw color(r,g,b)
;	uses glColor3ub(r,g,b)

;	YOUR CODE GOES HERE

; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula


;	YOUR CODE GOES HERE


; -----
;  Display image

	call	glEnd
	call	glFlush

; -----
;  Update s, s += sStep;
;  if (s > 1.0)
;	s = 0.0;

	movsd	xmm0, qword [s]			; s+= sStep
	addsd	xmm0, qword [sStep]
	movsd	qword [s], xmm0

	movsd	xmm0, qword [s]
	movsd	xmm1, qword [fltOne]
	ucomisd	xmm0, xmm1			; if (s > 1.0)
	jbe	resetDone

	movsd	xmm0, qword [fltZero]
	movsd	qword [sStep], xmm0
resetDone:

	call	glutPostRedisplay

; -----

	pop	rbp
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

