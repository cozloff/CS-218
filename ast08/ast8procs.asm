; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 8
;  Description: Functions to do basic operations on a list of numbers.


; -----------------------------------------------------------------
;  Write some assembly language functions.

;  The function, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  Note, the median is determined after the list is sorted.
;	This function must call the lstSum() and lstAvergae()
;	functions to get the corresponding values.
;	The lstAvergae() function must call the lstSum() function.

;  The function, linearRegression(), computes the linear regression of
;  the two data sets.  Summation and division performed as integer.

; *****************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for shellSort() function (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0

lowTest		dq	4000000000
highTest	dq	5000000000
; -----
;  Local variables for basicStats() function (if any)

; -----------------------------------------------------------------

section	.bss

; -----
;  Local variables for linearRegression() function (if any).

qSum		resq	1
dSum		resd	1

; *****************************************************************

section	.text

; --------------------------------------------------------
;  Shell sort function (form asst #7).
;	Updated to sort in descending order.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)

global	shellSort
shellSort:

;	YOUR CODE GOES HERE

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
	mov dword [h], ebx					;h should be 364 

outsideWhile:
	cmp dword [h], 0 					;while( h > 0 ) {
	jle doneSort						;should loop 6 times

	mov r9d, dword [h]					;for (i = h-1; i < a.length; i++) 
	dec r9d 
	mov dword [i], r9d
forLoop1:
	mov r10d, esi
	cmp dword [i], r10d 		
	jge exitForLoop1

	mov r11d, dword [i]				;tmp = a[i]
	mov r8d, dword [edi+r11d*4]
	mov dword [tmp], r8d

	mov dword [j], r11d				;j = i

	mov r8d, dword [i]					;for( j = i; (j >= h) && (a[j-h] > tmp); j = j - h) {
	mov dword [j], r8d
forLoop2:
	mov r9d, dword [h]
	cmp dword [j], r9d 
	jl exitForLoop2
	mov r10d, dword [j]
	sub r10d, r9d
	mov r11d, dword [edi+r10d*4]
	cmp r11d, dword [tmp]
	jge exitForLoop2

	mov r8d, dword [j]				;a[j-h]
	sub r8d, dword [h]
	mov r9d, dword [edi+r8d*4]

	mov r10d, dword [j]				;a[j] = a[j-h]
	mov dword [edi+r10d*4], r9d 

	mov r8d, dword [h]				;j = j - h
	sub dword [j], r8d
	jmp forLoop2
exitForLoop2:


	mov r9d, dword [tmp]			;a[j] = tmp
	mov r10d, dword [j]
	mov dword [edi+r10d*4], r9d
	inc dword [i]					;i++
	jmp forLoop1
exitForLoop1:


	mov r8d, 3
	mov edx, 0
	mov eax, dword [h]
	div r8d
	mov dword [h], eax
	jmp outsideWhile
doneSort:

	ret

; --------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)

global basicStats
basicStats:

;	YOUR CODE GOES HERE
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

; --------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	sum (in eax)


global	lstSum
lstSum:

;	YOUR CODE GOES HERE

mov rcx, rsi
mov eax, 0
mov r10d, 0

stats: 
    mov r11d, dword [edi+r10d*4]
    add eax, r11d
    inc r10d
    loop stats

	ret

; --------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	average (in eax)


global	lstAve
lstAve:

;	YOUR CODE GOES HERE

call lstSum
cdq
idiv rsi

	ret

; --------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).
;  Due to the data sizes, the summation for the dividend (top)
;  MUST be performed as a quad-word.

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - edx
;	4) xList average, value - ecx
;	5) yList average, value - r8d
;	6) b0, address - r9
;	7) b1, address - stack, rpb+16

;  Returns:
;	b0 and b1 via reference

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
		mov dword [qSum], eax
		mov dword [qSum + 4], edx
		add r13, qword [qSum]
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

; ********************************************************************************

