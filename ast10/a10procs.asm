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
push r14 
mov rax, 0
mov r14, rdx

argumentCheck: 
	cmp rdi, 7
	je validCommand
	cmp rdi, 1
	jne invalidCommandLine
	mov rbx, qword [rsi]

	mov al, byte [rbx]			;Check .
	cmp al, "."
	jne invalidCommandLine

	mov al, byte [rbx+1]			;Check /
	cmp al, "/"
	jne invalidCommandLine

	mov al, byte [rbx+2]			;Check w
	cmp al, "w"
	jne invalidCommandLine

	mov al, byte [rbx+3]			;Check h
	cmp al, "h"
	jne invalidCommandLine

	mov al, byte [rbx+4]			;Check e
	cmp al, "e"
	jne invalidCommandLine

	mov al, byte [rbx+5]			;Check e
	cmp al, "e"
	jne invalidCommandLine

	mov al, byte [rbx+6]			;Check l
	cmp al, "l"
	jne invalidCommandLine

	mov al, byte [rbx+7]			;Check s
	cmp al, "s"
	jne invalidCommandLine

	mov al, byte [rbx+8]			;Check NULL
	cmp al, NULL
	jne invalidCommandLine

	jmp usageError

invalidCommandLine:
	mov rdi, errBadCL
	jmp printIt

usageError: 
	mov rdi, errUsage
	jmp printIt

validCommand:

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
	mov r12, 0 					
	mov r12b, byte [rbx+r13]		;Get ASCII Chararcter
	cmp r12, NULL
	je spdLoopDne				;Loop until NULL
	sub r12b, "0"

	cmp r12b, 7
	jae spdTooBig

	cmp r12b, 0
	jb spdTooSmall

	mov r9, 7
	mul r9
	add rax, r12				;Convert to integer
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
	jmp printIt
spdTooBig: 						;Too large
	mov rdi, errSpdValue
	jmp printIt
spdInRange: 

    mov dword [r14], r10d    ;Return back speed variable 
    jmp clrTest

errSPspec:					;If invalid input 
	mov rdi, errSpdSpec
	jmp printIt
	
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

	mov r13, 0 	
	mov rax, 0				;Counter 
nxtClrChar: 
	mov r12, 0 					
	mov r12b, byte [rbx+r13]		;Get ASCII Chararcter
	cmp r12, NULL
	je clrLoopDne				;Loop until NULL
	sub r12b, "0"

	cmp r12b, 7
	jae clrTooBig

	cmp r12b, 0
	jb clrTooSmall

	mov r9, 7
	mul r9
	add rax, r12				;Convert to integer
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
	jmp printIt
clrTooBig: 						;Too large
	mov rdi, errClrValue
	jmp printIt
clrInRange: 

    mov dword [rcx], r10d    ;Return back speed variable 
    jmp sizTest

errCLspec:					;If invalid input 
	mov rdi, errClrSpec
	jmp printIt

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
	mov rax, 0
nxtSizChar: 
	mov r12, 0 					
	mov r12b, byte [rbx+r13]		;Get ASCII Chararcter
	cmp r12, NULL
	je sizLoopDne				;Loop until NULL
	sub r12b, "0"

	cmp r12b, 7
	jae sizTooBig

	cmp r12b, 0
	jb sizTooSmall

	mov r9, 7
	mul r9
	add rax, r12				;Convert to integer
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
	jmp printIt
sizTooBig: 						;Too large
	mov rdi, errSizValue
	jmp printIt
sizInRange: 

    mov dword [r8], r10d    ;Return back speed variable 
    mov rax, TRUE 
	jmp trueGetParams


errSZspec:					;If invalid input 
	mov rdi, errSizSpec
	jmp printIt 

printIt:
	call printString
	mov rax, FALSE

trueGetParams: 

pop r14
pop r13
pop r12 
pop rbx 
mov rsp, rbp 
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

	cvtsi2sd xmm0, dword [speed]
	divsd xmm0, qword [scale]
	movsd qword [sStep], xmm0

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

 	mov r10d, dword [color]
	mov r11b, r10b
	mov dword [blue], r11d

	shr r10, 8
	mov r11b, r10b
	mov dword [green], r11d

	shr eax, 8
	mov r11b, r10b 
	mov dword [red], r11d

	mov edi, dword [red]
	mov esi, dword [green]
	mov edx, dword [blue]
	call glColor3ub



; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula


;	YOUR CODE GOES HERE

	mov r12, 0
	movsd xmm0, qword [fltTwo]
	mulsd xmm0, qword [pi]
	divsd xmm0, qword [tStep]
	cvtsd2si r12, xmm0
;	mov r11, r12

;---------------------------------------------------------------------------------------
; x1 / y1

	movsd xmm3, qword [t]
plotLoopOne: 
	cmp r12, 0
	jbe endPlotLoopOne

	movsd xmm0, xmm3 					;cos(t)
	call cos
	movsd qword [x], xmm0

	movsd xmm0, xmm3					;sin(t)
	call sin
	movsd qword [y], xmm0

	movsd xmm0, qword [x]
	movsd xmm1, qword [y]
	call glVertex2d

	addsd xmm3, qword [tStep]
	dec r12 
	jmp plotLoopOne
endPlotLoopOne:

;---------------------------------------------------------------------------------------
; x2 / y2

	mov r12, r11
	movsd xmm3, qword [t]
plotLoopTwo: 
	cmp r12, 0
	jbe endPlotLoopTwo

	movsd xmm0, qword [t]				;cos(t)/3
	call cos 
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltTwo]			;2cos(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]

	addsd xmm0, qword [fltTmp1]			;cos(t)/3 + 2cos(2πs)/3
	movsd qword [x], xmm0

	movsd xmm0, qword [t]				;sin(t)/3
	call sin 
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltTwo]			;2sin(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]

	addsd xmm0, qword [fltTmp1]			;sin(t)/3 + 2sin(2πs)/3
	movsd qword [y], xmm0

	movsd xmm0, qword [x]
	movsd xmm1, qword [y]
	call glVertex2d

	addsd xmm3, qword [tStep]
	dec r12 
	jmp plotLoopTwo
endPlotLoopTwo:

;---------------------------------------------------------------------------------------
; x3 / y3

	mov r12, r11
	movsd xmm3, qword [t]
plotLoopThree: 
	cmp r12, 0
	jbe endPlotLoopThree

	movsd xmm0, qword [fltTwo]			;2cos(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tcos(4πs)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	addsd xmm0, qword [fltTmp1]			;2cos(2πs)/3 + tcos(4πs)/6π
	movsd qword [x], xmm0


	movsd xmm0, qword [fltTwo]			;2sin(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tsin(4πs)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	subsd xmm0, qword [fltTmp1]			;2sin(2πs)/3 - tsin(4πs)/6π
	movsd qword [y], xmm0

	movsd xmm0, qword [x]
	movsd xmm1, qword [y]
	call glVertex2d

	addsd xmm3, qword [tStep]
	dec r12 
	jmp plotLoopThree
endPlotLoopThree:

;---------------------------------------------------------------------------------------
; x4 / y4

	mov r12, r11
	movsd xmm3, qword [t]
plotLoopFour: 
	cmp r12, 0
	jbe endPlotLoopFour

	movsd xmm0, qword [fltTwo]			;2cos(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tcos(4πs + 2π/3)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd xmm2, qword [fltTwo]
	mulsd xmm2, qword [pi] 
	divsd xmm2, qword [fltThree]
	addsd xmm0, xmm2
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	addsd xmm0, qword [fltTmp1]			;2cos(2πs)/3 + tcos(4πs + 2π/3)/6π
	movsd qword [x], xmm0

	movsd xmm0, qword [fltTwo]			;2sin(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tsin(4πs + 2π/3)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd xmm2, qword [fltTwo]
	mulsd xmm2, qword [pi] 
	divsd xmm2, qword [fltThree]
	addsd xmm0, xmm2
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	subsd xmm0, qword [fltTmp1]			;2sin(2πs)/3 + tsin(4πs + 2π/3)/6π
	movsd qword [x], xmm0

	movsd xmm0, qword [x]
	movsd xmm1, qword [y]
	call glVertex2d

	addsd xmm3, qword [tStep]
	dec r12 
	jmp plotLoopFour
endPlotLoopFour:

;---------------------------------------------------------------------------------------
; x5 / y5

	mov r12, r11
	movsd xmm3, qword [t]
plotLoopFive: 
	cmp r12, 0
	jbe endPlotLoopFive

	movsd xmm0, qword [fltTwo]			;2cos(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tcos(4πs - 2π/3)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd xmm2, qword [fltTwo]
	mulsd xmm2, qword [pi] 
	divsd xmm2, qword [fltThree]
	subsd xmm0, xmm2
	movsd qword [fltTmp2], xmm0
	call cos
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	addsd xmm0, qword [fltTmp1]			;2cos(2πs)/3 + tcos(4πs - 2π/3)/6π
	movsd qword [x], xmm0

	movsd xmm0, qword [fltTwo]			;2sin(2πs)/3
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [fltTwo]
	divsd xmm0, qword [fltThree]
	movsd qword [fltTmp1], xmm0

	movsd xmm0, qword [fltFour]			;tsin(4πs - 2π/3)/6π
	mulsd xmm0, qword [pi]
	mulsd xmm0, qword [s]
	movsd xmm2, qword [fltTwo]
	mulsd xmm2, qword [pi] 
	divsd xmm2, qword [fltThree]
	subsd xmm0, xmm2
	movsd qword [fltTmp2], xmm0
	call sin
	mulsd xmm0, qword [t]
	movsd xmm1, qword [fltSix]
	mulsd xmm1, qword [pi]
	divsd xmm0, xmm1

	subsd xmm0, qword [fltTmp1]			;2sin(2πs)/3 + tsin(4πs - 2π/3)/6π
	movsd qword [x], xmm0

	movsd xmm0, qword [x]
	movsd xmm1, qword [y]
	call glVertex2d

	addsd xmm3, qword [tStep]
	dec r12 
	jmp plotLoopFive
endPlotLoopFive:


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

