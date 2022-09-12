; *****************************************************************
;  Name: 
;  NSHE ID: 
;  Section: 
;  Assignment: 3
;  Description: 



; -----
;  Write a simple assembly language program to compute a series
;  of provided formulas.

;  Focus on learning basic arithmetic operations
;  (add, subtract, multiply, and divide).
;  Ensure understanding of signed and unsigned operations.

; *****************************************************************
;  Data Declarations (provided).

section	.data
; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data declarations
bNum1		db	11
bNum2		db	15
bNum3		db	26
bNum4		db	37
bNum5		db	33
bNum6		db	-17
bNum7		db	-29
bNum8		db	-40
bAns1		db	0
bAns2		db	0
bAns3		db	0
bAns4		db	0
bAns5		db	0
bAns6		db	0
bAns7		db	0
bAns8		db	0
bAns9		db	0
bAns10		db	0
wAns11		dw	0
wAns12		dw	0
wAns13		dw	0
wAns14		dw	0
wAns15		dw	0
bAns16		db	0
bAns17		db	0
bAns18		db	0
bRem18		db	0
bAns19		db	0
bAns20		db	0
bAns21		db	0
bRem21		db	0

; word data declarations
wNum1		dw	229
wNum2		dw	467
wNum3		dw	1738
wNum4		dw	2210
wNum5		dw	375
wNum6		dw	-234
wNum7		dw	-361
wNum8		dw	-418
wAns1		dw	0
wAns2		dw	0
wAns3		dw	0
wAns4		dw	0
wAns5		dw	0
wAns6		dw	0
wAns7		dw	0
wAns8		dw	0
wAns9		dw	0
wAns10		dw	0
dAns11		dd	0
dAns12		dd	0
dAns13		dd	0
dAns14		dd	0
dAns15		dd	0
wAns16		dw	0
wAns17		dw	0
wAns18		dw	0
wRem18		dw	0
wAns19		dw	0
wAns20		dw	0
wAns21		dw	0
wRem21		dw	0

; double-word data declarations
dNum1		dd	136789
dNum2		dd	31342
dNum3		dd	1815
dNum4		dd	61569
dNum5		dd	42617
dNum6		dd	-1345
dNum7		dd	-2733
dNum8		dd	-4256
dAns1		dd	0
dAns2		dd	0
dAns3		dd	0
dAns4		dd	0
dAns5		dd	0
dAns6		dd	0
dAns7		dd	0
dAns8		dd	0
dAns9		dd	0
dAns10		dd	0
qAns11		dq	0
qAns12		dq	0
qAns13		dq	0
qAns14		dq	0
qAns15		dq	0
dAns16		dd	0
dAns17		dd	0
dAns18		dd	0
dRem18		dd	0
dAns19		dd	0
dAns20		dd	0
dAns21		dd	0
dRem21		dd	0

; quadword data declarations
qNum1		dq	246793
qNum2		dq	115732
qNum3		dq	1526241
qNum4		dq	254879
qNum5		dq	317517
qNum6		dq	-222147
qNum7		dq	-216517
qNum8		dq	-445758
qAns1		dq	0
qAns2		dq	0
qAns3		dq	0
qAns4		dq	0
qAns5		dq	0
qAns6		dq	0
qAns7		dq	0
qAns8		dq	0
qAns9		dq	0
qAns10		dq	0
dqAns11		ddq	0
dqAns12		ddq	0
dqAns13		ddq	0
dqAns14		ddq	0
dqAns15		ddq	0
qAns16		dq	0
qAns17		dq	0
qAns18		dq	0
qRem18		dq	0
qAns19		dq	0
qAns20		dq	0
qAns21		dq	0
qRem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ********************************************
; Byte Operations

; unsigned byte additions
;	bAns1  = bNum1 + bNum2
;	bAns2  = bNum1 + bNum3
;	bAns3  = bNum3 + bNum4



; -----
; signed byte additions
;	bAns4  = bNum5 + bNum6
;	bAns5  = bNum5 + bNum1



; -----
; unsigned byte subtractions
;	bAns6  = bNum1 - bNum2
;	bAns7  = bNum2 - bNum4
;	bAns8  = bNum4 - bNum3



; -----
; signed byte subtraction
;	bAns9  = bNum5 - bNum3
;	bAns10 = bNum6 – bNum2



; -----
; unsigned byte multiplication
;	wAns11 = bNum2 * bNum3
;	wAns12 = bNum3 * bNum4
;	wAns13 = bNum1 * bNum4



; -----
; signed byte multiplication
;	wAns14 = bNum5 * bNum3
;	wAns15 = bNum5 * bNum6



; -----
; unsigned byte division
;	bAns16 = bNum1 / bNum4
;	bAns17 = bNum2 / bNum3
;	bAns18 = wAns13 / bNum2
;	bRem18 = wAns13 % bNum2



; -----
; signed byte division
;	bAns19 = bNum6 / bNum2
;	bAns20 = bNum6 / bNum4
;	bAns21 = wAns14 / bNum2
;	bRem21 = wAns14 % bNum2




; ********************************************
; Word Operations	

; unsigned word additions
;	wAns1  = wNum1 + wNum2
;	wAns2  = wNum1 + wNum3
;	wAns3  = wNum3 + wNum4



; -----
; signed word additions
;	wAns4  = wNum5 + wNum6
;	wAns5  = wNum5 + wNum3



; -----
; unsigned word subtractions
;	wAns6  = wNum2 - wNum1
;	wAns7  = wNum4 - wNum2
;	wAns8  = wNum1 - wNum3



; -----
; signed word subtraction
;	wAns9  = wNum5 - wNum6
;	wAns10 = wNum5 - wNum3



; -----
; unsigned word multiplication
;	dAns11 = wNum1 * wNum3
;	dAns12 = wNum3 * wNum4
;	dAns13 = wNum2 * wNum3



; -----
; signed word multiplication
;	dAns14  = wNum5 * wNum6
;	dAns15  = wNum6 * wNum1



; -----
; unsigned word division
;	wAns16 = wNum2 / wNum3
;	wAns17 = wNum4 / wNum1
;	wAns18 = dAns13 / wNum1
;	wRem18 = dAns13 % wNum1



; -----
; signed word division
;	wAns19 = wNum5 / wNum1
;	wAns20 = wNum5 / wNum3
;	wAns21 = dAns14 / wNum1
;	wRem21 = dAns14 % wNum1




; ********************************************
; Double-Word Operations

; unsigned double word additions
;	dAns1  = dNum2 + dNum3
;	dAns2  = dNum3 + dNum4
;	dAns3  = dNum2 + dNum4



; -----
; signed double word additions
;	dAns4  = dNum5 + dNum6
;	dAns5  = dNum5 + dNum2



; -----
; unsigned double word subtractions
;	dAns6  = dNum1 - dNum4
;	dAns7  = dNum4 - dNum3
;	dAns8  = dNum3 - dNum2



; -----
; signed double word subtraction
;	dAns9  = dNum5 - dNum6
;	dAns10 = dNum5 - dNum2



; -----
; unsigned double word multiplication
;	qAns11  = dNum2 * dNum2
;	qAns12  = dNum1 * dNum2
;	qAns13  = dNum2 * dNum4



; -----
; signed double word multiplication
;	qAns14  = dNum5 * dNum6
;	qAns15  = dNum5 * dNum2



; -----
; unsigned double word division
;	dAns16 = dNum1 / dNum4
;	dAns17 = dNum3 / dNum2
;	dAns18 = qAns13 / dNum2
;	dRem18 = modulus (qAns13 / dNum2)



; -----
; signed double word division
;	dAns19 = dNum5 / dNum2 
;	dAns20 = dNum5 / dNum6
;	dAns21 = qAns15 / dNum4
;	dRem21 = qAns15 % dNum4




; ***************************************** 
; QuadWord Operations

; unsigned quadword additions 
;	qAns1  = qNum1 + qNum2 
;	qAns2  = qNum3 + qNum2 
;	qAns3  = qNum3 + qNum1



; ----- 
; signed quadword additions 
;	qAns4  = qNum6 + qNum7 
;	qAns5  = qNum5 + qNum8 



; ----- 
; unsigned quadword subtractions 
;	qAns6  = qNum3 - qNum1 
;	qAns7  = qNum4 - qNum2 
;	qAns8  = qNum4 - qNum1 



; ----- 
; signed quadword subtraction 
;	qAns9  = qNum7 - qNum6 
;	qAns10 = qNum8 - qNum7 



; ----- 
; unsigned quadword multiplication 
;	dqAns11  = qNum4 * qNum3 
;	dqAns12  = qNum3 * qNum4 
;	dqAns13  = qNum2 * qNum2 



; ----- 
; signed quadword multiplication 
;	dqAns14  = qNum6 * qNum7 
;	dqAns15  = qNum5 * qNum8 



; ----- 
; unsigned quadword division 
;	qAns16 = qNum3 / qNum1 
;	qAns17 = qNum4 / qNum3
;	qAns18 = dqAns11 / qNum3 
;	qRem18 = dqAns11 % qNum3 



; ----- 
; signed quadword division 
;	qAns19 = qNum5 / qNum6
;	qAns20 = qNum8 / qNum7
;	qAns21 = dqAns12 / qNum8
;	qRem21 = dqAns12 % qNum8




; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall

