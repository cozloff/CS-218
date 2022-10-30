; *****************************************************************
;  Name: Dylan Cozloff
;  NSHE ID: 2001668380
;  Section: 1003
;  Assignment: 11
;  Description:  Uses Oa buffer to read image data, and writes data into a thumbnail 
;  CS 218 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20			; space

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

MIN_FILE_LEN	equ	5

; buffer size (part A) - DO NOT CHANGE THE NEXT LINE.
BUFF_SIZE	equ	750000

; -----
;  Variables for getImageFileName() function.

eof		db	FALSE

usageMsg	db	"Usage: ./makeThumb <inputFile.bmp> "
		db	"<outputFile.bmp>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errReadName	db	"Error, invalid source file name.  Must be '.bmp' file.", LF, NULL
errWriteName	db	"Error, invalid output file name.  Must be '.bmp' file.", LF, NULL
errReadFile	db	"Error, unable to open input file.", LF, NULL
errWriteFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Variables for setImageInfo() function.

HEADER_SIZE	equ	138

errReadHdr	db	"Error, unable to read header from source image file."
		db	LF, NULL
errFileType	db	"Error, invalid file signature.", LF, NULL
errDepth	db	"Error, unsupported color depth.  Must be 24-bit color."
		db	LF, NULL
errCompType	db	"Error, only non-compressed images are supported."
		db	LF, NULL
errSize		db	"Error, bitmap block size inconsistent.", LF, NULL
errWriteHdr	db	"Error, unable to write header to output image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for readRow() function.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE
pixelCount	dq	0

errRead		db	"Error, reading from source image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for writeRow() function.

correctRow	db TRUE

errWrite	db	"Error, writting to output image file.", LF,
		db	"Program terminated.", LF, NULL

; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE
header		resb	HEADER_SIZE

; ############################################################################

section	.text

; ***************************************************************
;  Routine to get image file names (from command line)
;	Verify files by atemptting to open the files (to make
;	sure they are valid and available).

;  Command Line format:
;	./makeThumb <inputFileName> <outputFileName>

; -----
;  Arguments:
;	- argc (value) : rdi 
;	- argv table (address) : rsi
;	- read file descriptor (address) : rdx 
;	- write file descriptor (address) : rcx 
;  Returns:
;	read file descriptor (via reference)
;	write file descriptor (via reference)
;	TRUE or FALSE

;	YOUR CODE GOES HERE

global getImageFileNames
getImageFileNames: 
push rbp 
mov rbp, rsp 
push rbx 
push r12 
push r13
push r14
mov r13, rcx
mov r14, rdx 

argumentCheck: 
	cmp rdi, 3
	je validCommand
	cmp rdi, 1 
	je usageError
	cmp rdi, 3 
	jb incompleteCommandLine
	cmp rdi, 3 
	ja extraCommandLine

incompleteCommandLine:
	mov rdi, errIncomplete
	jmp printIt

extraCommandLine:
	mov rdi, errExtra
	jmp printIt

usageError: 
	mov rdi, usageMsg
	jmp printIt

validCommand:

;----------------------------------------------------------------
; Input File 

inputTest:
	mov rbx, 0
	mov rbx, qword [rsi+8]		;Get input file command line argument

mov r10, 0
getInputDot: 
	mov al, byte [rbx + r10]
	cmp al, "."
	je inputDotFound 
	cmp al, NULL
	je errInputName
	inc r10 
	jmp getInputDot 
inputDotFound: 
	inc r10 
	mov al, byte [rbx+r10]			;Check b
	cmp al, "b"
	jne errInputName

	inc r10 
	mov al, byte [rbx+r10]		;Check m
	cmp al, "m"
	jne errInputName

	inc r10 
	mov al, byte [rbx+r10]		;Check p
	cmp al, "p"
	jne errInputName

	inc r10 
	mov al, byte [rbx+r10]		;Check NULL
	cmp al, NULL
	jne errInputName 
	jmp validInputName

errInputName:					;If invalid input 
	mov rdi, errReadName
	jmp printIt
validInputName: 
;----------------------------------------------------------------
; Output File 

outputTest:
	mov rbx, 0
	mov rbx, qword [rsi+16]		;Get input file command line argument

mov r10, 0
getOutputDot: 
	mov al, byte [rbx + r10]
	cmp al, "."
	je outputDotFound 
	cmp al, NULL
	je errOutputName
	inc r10 
	jmp getOutputDot 
outputDotFound: 
	inc r10 
	mov al, byte [rbx+r10]			;Check b
	cmp al, "b"
	jne errOutputName

	inc r10 
	mov al, byte [rbx+r10]		;Check m
	cmp al, "m"
	jne errOutputName

	inc r10 
	mov al, byte [rbx+r10]		;Check p
	cmp al, "p"
	jne errOutputName

	inc r10 
	mov al, byte [rbx+r10]		;Check NULL
	cmp al, NULL
	jne errOutputName 
	jmp validOutputName

errOutputName:					;If invalid input 
	mov rdi, errWriteName
	jmp printIt
validOutputName: 

	mov r12, rsi

	;attempt to open input file
	mov rax, SYS_open
	mov rdi, qword [r12+8]
	mov rsi, O_RDONLY
	syscall 
	cmp rax, 0
	jl inFileOpenErr 
	mov qword [r14], rax

	;attempt to open output file
	mov rax, SYS_creat
	mov rdi, qword [r12+16]
	mov rsi, S_IRUSR | S_IWUSR
	syscall 
	cmp rax, 0
	jl outFileOpenErr 
	mov qword [r13], rax

	mov rax, TRUE
	jmp testDone

inFileOpenErr: 
	mov rdi, errReadFile
	jmp printIt
outFileOpenErr:
	mov rdi, errWriteFile
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

; ***************************************************************
;  Read, verify, and set header information

;  HLL Call:
;	bool = setImageInfo(readFileDesc, writeFileDesc,
;		&picWidth, &picHeight, thumbWidth, thumbHeight)

;  If correct, also modifies header information and writes modified
;  header information to output file (i.e., thumbnail file).

; -----
;  2 -> BM				(+0)
;  4 file size				(+2)
;  4 skip				(+6)
;  4 header size			(+10)
;  4 skip				(+14)
;  4 width				(+18)
;  4 height				(+22)
;  2 skip				(+26)
;  2 depth (16/24/32)			(+28)
;  4 compression method code		(+30)
;  4 bytes of pixel data		(+34)
;  skip remaing header entries

; -----
;   Arguments:
;	- read file descriptor (value)  : rdi
;	- write file descriptor (value) : rsi
;	- old image width (address)		: rdx
;	- old image height (address)	: rcx 
;	- new image width (value)		: r8
;	- new image height (value)		: r9

;  Returns:
;	file size (via reference)
;	old image width (via reference)
;	old image height (via reference)
;	TRUE or FALSE


;	YOUR CODE GOES HERE

global setImageInfo
setImageInfo:
push rbp 
mov rbp, rsp 
push rbx  
push r12
push r13
mov rbx, rdx
mov r12, rcx
mov r13, rsi

	mov rax, SYS_read 					;Read header into buffer
	mov rdi, rdi
	mov rsi, header 
	mov rdx, HEADER_SIZE
	syscall

	cmp rax, 0 
	jl HdrErr

	mov r10, 0 
	mov r10d, dword [header+18]			;Get width 
	mov dword [rbx], r10d

	mov r11, 0 
	mov r11d, dword [header+22]			;Get height 
	mov dword [r12], r11d

	mov r10, 0 							;Check signature (BM)
	mov r10w, word [header]
	cmp r10w, "BM"
	jne FileTypeErr

	mov r10, 0 							;Check color depth (24)
	mov r10w, word [header+28]
	cmp r10w, 24
	jne DepthErr

	mov r10, 0 							;Check compression (0) 
	mov r10d, dword [header+30]
	cmp r10d, 0
	jne CompTypeErr

	mov r10, 0 							;Check bitmap block size consistency file size = header size + image size 
	mov r10d, dword [header+34]
	mov r11d, dword [header+10]
	add r10d, r11d
	cmp r10d, dword [header+2]
	jne SizeErr
;-------------------------------------------- Correct 
	mov dword [header+18], r8d ; Set Width
	mov dword [header+22], r9d ; Set Height

	mov r10d, 3
	mov eax, r8d
	mul r9d
	mul r10d 
	add eax, dword [header+10]
	mov dword [header+2], eax   ; Set file size (w * h * 3 + headersize)

	mov rax, SYS_write 			; Write updated header to output file 
	mov rdi, r13 
	mov rsi, header 
	mov rdx, HEADER_SIZE
	syscall 

	cmp rax, 0 
	jl WriteHdrErr

	mov rax, TRUE
	jmp imageInfoDone

HdrErr: 
	mov rdi, errReadHdr			;"Error, unable to read header from source image file."
	jmp printImageInfoErr
FileTypeErr:
	mov rdi, errFileType		;"Error, invalid file signature."
	jmp printImageInfoErr	
DepthErr: 
	mov rdi, errDepth			;"Error, unsupported color depth.  Must be 24-bit color."
	jmp printImageInfoErr
CompTypeErr:	
	mov rdi, errCompType		;"Error, only non-compressed images are supported."
	jmp printImageInfoErr
SizeErr: 	
	mov rdi, errSize			;"Error, bitmap block size inconsistent."
	jmp printImageInfoErr
WriteHdrErr:
	mov rdi, errWriteHdr		;"Error, unable to write header to output image file."
	jmp printImageInfoErr
printImageInfoErr:
	mov rax, FALSE
	call printString			;"Program terminated."

imageInfoDone:

pop r13
pop r12
pop rbx 
mov rsp, rbp 
pop rbp
	ret


; ***************************************************************
;  Return a row from read buffer
;	This routine performs all buffer management

; ----
;  HLL Call:
;	bool = readRow(readFileDesc, picWidth, rowBuffer[]);

;   Arguments:
;	- read file descriptor (value) : rdi
;	- image width (value)		   : rsi
;	- row buffer (address)		   : rdx
;	- test argument (address)      : rcx
;  Returns:
;	TRUE or FALSE

; -----
;  This routine returns TRUE when row has been returned
;	and returns FALSE if there is no more data to
;	return (i.e., all data has been read) or if there
;	is an error on read (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.


;	YOUR CODE GOES HERE

global readRow
readRow: 
push rbp 
mov rbp, rsp 
push rbx  
push r12
push r13 
push r14						
push r15						
mov r13, rdx					; Row Buffer 
mov r15, rcx					; Test Counter
mov r14, 0						; Row Counter 
;----------------------------------------------------------
; Calculate row length 
	mov r10, 3
	mov rax, rsi 				; image width (value)
	mul r10
	mov rbx, rax 				; row length (width * 3) 
;----------------------------------------------------------
; Check buffer full 

	mov r10, qword [buffMax]					; if curr >= buffMax refill buffer
	cmp qword [curr], r10	
	jae refillBuffer				
	jmp bufferToRow

;----------------------------------------------------------
; Refill Buffer
refillBuffer:
	cmp qword [wasEOF], TRUE	; If you already reached EOF, quit program 
	je readEOF 

	mov rax, SYS_read 			; Read image data into buffer 
	mov rdi, rdi 
	mov rsi, buffer 
	mov rdx, BUFF_SIZE 
	syscall					

	cmp rax, 0 					; Read Error 
	jl ReadErr

	cmp rax, BUFF_SIZE			; If buffer doesn't completely refill, mark you have reached the EOF
	jl setEOF 

	mov qword [curr], 0 		; Reset Buffer counter 
	jmp bufferToRow

setEOF: 
	mov qword [wasEOF], TRUE 		; Last buffer refill
	mov qword [buffMax], rax 		; Set buffMax to remaining file size 
	mov qword [curr], 0 			; Reset Buffer counter 

;----------------------------------------------------------
; Buffer to Row 

bufferToRow: 
	mov r12, qword [curr]
	mov r11b, byte [buffer + r12]
	mov byte [r13 + r14], r11b

	inc r14
	inc qword [curr]

	mov r10, qword [buffMax]
	cmp qword [curr], r10
	jae refillBuffer

	cmp r14, rbx
	jae rowRead
	jmp bufferToRow  

;----------------------------------------------------------
; Return 

ReadErr:
	mov rdi, errRead			;"Error, reading from source image file."
	jmp readRowErr
readRowErr:
	mov rax, FALSE
	call printString			

readEOF:
	mov r10d, dword [curr]		; Read to EOF 
	mov dword [r15], r10d
	; mov byte [r13 + r14], NULL
	mov rax, FALSE
	jmp readDone
rowRead: 
	mov r10d, dword [curr]		; Row Read, File Incomplete 
	mov dword [r15], r10d
	inc r14
	; mov byte [r13 + r14], NULL
	mov rax, TRUE 
readDone: 

pop r15
pop r14
pop r13
pop r12
pop rbx 
mov rsp, rbp 
pop rbp
	ret



; ***************************************************************
;  Write image row to output file.
;	Writes exactly (width*3) bytes to file.
;	No requirement to buffer here.

; -----
;  HLL Call:
;	bool = writeRow(writeFileDesc, picWidth, rowBuffer);

;  Arguments are:
;	- write file descriptor (value) : rdi
;	- image width (value)			: rsi
;	- row buffer (address)			: rdx 

;  Returns:
;	N/A

; -----
;  This routine returns TRUE when row has been written
;	and returns FALSE only if there is an
;	error on write (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.


;	YOUR CODE GOES HERE

global writeRow
writeRow:
push rbp 
mov rbp, rsp 
push rbx  
push r12
push r13
push r14 

mov r14, rdx 
mov r12, rsi
sub r12, 1
mov r13, 0

;------------------------------------------------------------------------------------
; Write Loop 

writeLoop:

	mov rax, SYS_write 			
	mov rdi, rdi				; File descriptor 
	mov rsi, r14				; Row buffer 
	mov rdx, 3					; Size of read 
	syscall 

	cmp rax, 0 					; Error check 
	jl WriteErr

	inc r13						; Row Counter 
	add r14, 3					; Get next pixel 
	cmp r13, r12				
	jbe writeLoop
	jmp rowWritten
;------------------------------------------------------------------------------------
; Return 

WriteErr:
	mov rdi, errWrite		;"Error, writting to output image file."
	jmp writeRowErr
writeRowErr:
	mov rax, FALSE
	call printString		;"Program terminated."		

rowWritten: 
	mov rax, TRUE 

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

