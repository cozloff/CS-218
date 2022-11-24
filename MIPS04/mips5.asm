###########################################################################
#  Name: 
#  NSHE ID: 
#  Section: 
#  Assignment: MIPS #5
#  Description: 


###########################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0
COORD_MAX = 100

# -----
#  Variables for main

hdr:		.ascii	"\n**********************************************\n"
		.ascii	"\nMIPS Assignment #5\n"
		.asciiz	"Count Grid Paths Program\n"

startRow:	.word	0
startCol:	.word	0
endRow:		.word	0
endCol:		.word	0

totalCount:	.word	0

endMsg:		.ascii	"\nYou have reached recursive nirvana.\n"
		.asciiz	"Program Terminated.\n"

# -----
#  Local variables for prtResults() function.

cntMsg1:	.asciiz	"\nFrom a start coordinate of ("
cntMsgComma:	.asciiz	","
cntMsg2:	.asciiz	"), to an end coordinate of ("
cntMsg3:	.asciiz	"), \nthere are "
cntMsg4:	.asciiz	" ways traverse the grid.\n"

# -----
#  Local variables for readCoords() function.

strtRowPmt:	.asciiz	"  Enter Start Coordinates ROW: "
strtColPmt:	.asciiz	"  Enter Start Coordinates COL: "

endRowPmt:	.asciiz	"  Enter End Coordinates ROW: "
endColPmt:	.asciiz	"  Enter End Coordinates COL: "

err0:		.ascii	"\nError, invalid coordinate value.\n"
		.asciiz	"Please re-enter.\n"

err1:		.ascii	"\nError, end coordinates must be > then "
		.ascii	"the start coordinates. \n"
		.asciiz	"Please re-enter.\n"

spc:		.asciiz	"   "

# -----
#  Local variables for prtNewline function.

newLine:	.asciiz	"\n"


###########################################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Function to read and return initial coordinates.

	la	$a0, startRow
	la	$a1, startCol
	la	$a2, endRow
	la	$a3, endCol
	jal	readCoords

# -----
#  countPaths - determine the number of possible
#		paths through a two-dimensional grid.
#	returns integer answer.

#  HLL Call:
#	totalCount = countPaths(startRow, startCol, endRow, endCol)

	lw	$a0, startRow
	lw	$a1, startCol
	lw	$a2, endRow
	lw	$a3, endCol
	jal	countPaths
	sw	$v0, totalCount

# ----
#  Display results (formatted).

	lw	$a0, startRow
	lw	$a1, startCol
	lw	$a2, endRow
	lw	$a3, endCol
	subu	$sp, $sp, 4
	lw	$t0, totalCount
	sw	$t0, ($sp)
	jal	prtResults
	addu	$sp, $sp, 4

# -----
#  Done, show message and terminate program.

	li	$v0, 4
	la	$a0, endMsg
	syscall

	li	$v0, 10
	syscall					# all done...
.end main

# =========================================================================
#  Very simple function to print a new line.
#	Note, this routine is optional.

.globl	prtNewline
.ent	prtNewline
prtNewline:
	la	$a0, newLine
	li	$v0, 4
	syscall

	jr	$ra
.end	prtNewline

# =========================================================================
#  Function to print final results (formatted).

# -----
#    Arguments:
#	startRow, value
#	startCol, value
#	endRow, value
#	endCol, value
#	totalCount, value
#    Returns:

.globl	prtResults
.ent	prtResults
prtResults:


#	YOUR CODE GOES HERE



	jr	$ra
.end	prtResults

# =========================================================================
#  Prompt for and read start and end coordinates.
#  Also, must ensure that:
#	each value is between 0 and COORD_MAX
#	start coordinates are < end coordinates

# -----
#    Arguments:
#	startRow, address
#	startCol, address
#	endRow, address
#	endCol, address
#    Returns:
#	startRow, startCol, endRow, endCol via reference

.globl	readCoords
.ent	readCoords
readCoords:


#	YOUR CODE GOES HERE





	jr	$ra
.end	readCoords

#####################################################################
#  Function to recursivly determine the number of possible
#  paths through a two-dimensional grid.
#  Only allowed moves are one step to the right or one step down.  

#  HLL Call:
#	totalCount = countPaths(startRow, startCol, endRow, endCol)

# -----
#  Arguments:
#	startRow, value
#	startCol, value
#	endRow, value
#	endCol, value

#  Returns:
#	$v0 - paths count

.globl	countPaths
.ent	countPaths
countPaths:


#	YOUR CODE GOES HERE




	jr	$ra
.end countPaths

#####################################################################

