###########################################################################
#  Name: Dylan Cozloff
#  NSHE ID: 2001668380
#  Section: 1003
#  Assignment: MIPS #4
#  Description: Program to calculate the Manhattan distance.

#  MIPS assembly language program to calculate
#  the Manhattan Distance between two grids.

###########################################################
#  data segment

.data

hdr:	.ascii	"\nMIPS Assignment #4\n"
	.asciiz	"Program to Calculate Manhattan Distance.\n\n"

# -----
#  Game boards.

goalAMsg:	.asciiz	"3x3 Goal Board #1"

boardAsize:	.word	3
goalA:		.word	1, 2, 3
		.word	4, 5, 6
		.word	7, 8, 0

boardA0msg:	.asciiz	"3x3 Game Board 0"
boardA0:	.word	1, 2, 0
		.word	4, 5, 3
		.word	7, 8, 6

boardA1msg:	.asciiz	"3x3 Game Board 1"
boardA1:	.word	0, 1, 3
		.word	4, 2, 5
		.word	7, 8, 6

boardA2msg:	.asciiz	"3x3 Game Board 2"
boardA2:	.word	4, 1, 2
		.word	5, 8, 3
		.word	7, 0, 6

boardA3msg:	.asciiz	"3x3 Game Board 3"
boardA3:	.word	0, 5, 2
		.word	1, 8, 3
		.word	4, 7, 6

boardA4msg:	.asciiz	"3x3 Game Board 4"
boardA4:	.word	4, 1, 3
		.word	0, 2, 6
		.word	7, 5, 8

boardA5msg:	.asciiz	"3x3 Game Board 5"
boardA5:	.word	1, 2, 3
		.word	0, 7, 6
		.word	5, 4, 8

boardA6msg:	.asciiz	"3x3 Game Board 6"
boardA6:	.word	2, 3, 5
		.word	1, 0, 4
		.word	7, 8, 6 

boardA7msg:	.asciiz	"3x3 Game Board 7"
boardA7:	.word	1, 0, 2
		.word	7, 5, 4
		.word	8, 6, 3

boardA8msg:	.asciiz	"3x3 Game Board 8"
boardA8:	.word	8, 1, 3
		.word	4, 0, 2
		.word	7, 6, 5

boardA9msg:	.asciiz	"3x3 Game Board 9"
boardA9:	.word	3, 5, 6
		.word	1, 4, 0
		.word	0, 7, 2

boardA10msg:	.asciiz	"3x3 Game Board 10"
boardA10:	.word	5, 6, 2
		.word	1, 8, 4
		.word	7, 3, 0

boardA11msg:	.asciiz	"3x3 Game Board 11"
boardA11:	.word	2, 8, 5
		.word	0, 1, 7
		.word	4, 3, 6

boardA12msg:	.asciiz	"3x3 Game Board 12"
boardA12:	.word	8, 0, 5
		.word	2, 1, 7
		.word	4, 3, 6

boardA13msg:	.asciiz	"3x3 Game Board 13"
boardA13:	.word	1, 2, 7
		.word	0, 4, 3
		.word	6, 5, 8

boardA14msg:	.asciiz	"3x3 Game Board 14"
boardA14:	.word	1, 6, 4
		.word	7, 0, 8
		.word	2, 3, 5

boardA15msg:	.asciiz	"3x3 Game Board 15"
boardA15:	.word	5, 1, 3
		.word	4, 7, 0
		.word	8, 6, 1

boardA16msg:	.asciiz	"3x3 Game Board 16"
boardA16:	.word	4, 8, 2
		.word	3, 6, 5
		.word	1, 7, 0

boardA17msg:	.asciiz	"3x3 Game Board 17"
boardA17:	.word	2, 4, 5
		.word	0, 1, 7
		.word	3, 8, 6

boardA18msg:	.asciiz	"3x3 Game Board 18"
boardA18:	.word	5, 0, 4
		.word	2, 3, 8
		.word	7, 1, 6

boardA19msg:	.asciiz	"3x3 Game Board 19"
boardA19:	.word	5, 7, 4
		.word	3, 0, 8
		.word	1, 6, 2

boardA20msg:	.asciiz	"3x3 Game Board 20"
boardA20:	.word	5, 8, 7
		.word	1, 4, 6
		.word	3, 0, 2

boardA21msg:	.asciiz	"3x3 Game Board 21"
boardA21:	.word	0, 5, 7
		.word	2, 4, 1
		.word	3, 6, 8

boardA22msg:	.asciiz	"3x3 Game Board 22"
boardA22:	.word	8, 7, 6
		.word	5, 4, 3
		.word	2, 1, 0

boardA23msg:	.asciiz	"3x3 Game Board 23"
boardA23:	.word	1, 2, 3
		.word	4, 5, 6
		.word	8, 7, 9

boardA24msg:	.asciiz	"3x3 Game Board 24"
boardA24:	.word	1, 2, 3
		.word	8, 0, 4
		.word	7, 6, 5

# -----

goalBMsg:	.asciiz	"3x3 Goal Board #2"

boardBsize:	.word	3
goalB:		.word	1, 2, 3
		.word	8, 0, 4
		.word	7, 6, 5

boardB0msg:	.asciiz	"3x3 Game Board 0"
boardB0:	.word	1, 2, 0
		.word	4, 5, 3
		.word	7, 8, 6

boardB1msg:	.asciiz	"3x3 Game Board 1"
boardB1:	.word	0, 1, 3
		.word	4, 2, 5
		.word	7, 8, 6

boardB2msg:	.asciiz	"3x3 Game Board 2"
boardB2:	.word	4, 1, 2
		.word	5, 8, 3
		.word	7, 0, 6

boardB3msg:	.asciiz	"3x3 Game Board 3"
boardB3:	.word	0, 5, 2
		.word	1, 8, 3
		.word	4, 7, 6

# -----

goalCMsg:	.asciiz	"4x4 Goal Board #1"

boardCsize:	.word	4
goalC:		.word	 1,  2,  3,  4
		.word	 5,  6,  7,  8
		.word	 9, 10, 11, 12
		.word	13, 14, 15,  0

boardC0msg:	.asciiz	"4x4 Game Board 0"
boardC0:	.word	 0,  1,  2,  3
		.word	 5,  6,  7,  4
		.word	 9, 10, 11,  8
		.word	13, 14, 15, 12

boardC1msg:	.asciiz	"4x4 Game Board 1"
boardC1:	.word	 2, 12,  0,  3
		.word	13,  6, 14,  4
		.word	 9, 10, 15,  8
		.word	 5,  7, 11, 15

boardC2msg:	.asciiz	"4x4 Game Board 2"
boardC2:	.word	 3,  6,  2,  0
		.word	13,  9,  8, 12
		.word	14, 10,  7, 15
		.word	 5,  1, 11,  4

boardC3msg:	.asciiz	"4x4 Game Board 3"
boardC3:	.word	 0, 15, 14, 13
		.word	12, 11, 10,  9
		.word	 8,  7,  6,  5
		.word	 4,  3,  2,  1

# -----

goalDMsg:	.asciiz	"4x4 Goal Board #2"

boardDsize:	.word	4
goalD:		.word	15, 14, 13, 12
		.word	11, 10,  9,  8
		.word	 7,  6,  5,  4
		.word	 3,  2,  1,  0

boardD0msg:	.asciiz	"4x4 Game Board 0"
boardD0:	.word	 0,  1,  2,  3
		.word	 5,  6,  7,  4
		.word	 9, 10, 11,  8
		.word	13, 14, 15, 12

boardD1msg:	.asciiz	"4x4 Game Board 1"
boardD1:	.word	 2, 12,  0,  3
		.word	13,  6, 14,  4
		.word	 9, 10, 15,  8
		.word	 5,  7, 11,  1

boardD2msg:	.asciiz	"4x4 Game Board 2"
boardD2:	.word	 3,  6,  2,  0
		.word	13,  9,  8, 12
		.word	14, 10,  7, 15
		.word	 5,  2, 11,  4

boardD3msg:	.asciiz	"4x4 Game Board 3"
boardD3:	.word	 0, 15, 14, 13
		.word	12, 11, 10,  9
		.word	 8,  7,  6,  5
		.word	 4,  3,  2,  1

# -----

goalEMsg:	.asciiz	"5x5 Goal Board #1"

boardEsize:	.word	5
goalE:		.word	 1,  2,  3,  4,  5
		.word	 6,  7,  8,  9, 10
		.word	11, 12, 13, 14, 15
		.word	16, 17, 18, 19, 20
		.word	21, 22, 23, 24,  0

boardE0msg:	.asciiz	"5x5 Game Board 0"
boardE0:	.word	 0,  1,  2,  3, 16
		.word	 5,  6,  7,  4, 17
		.word	 9, 10, 11,  8, 18
		.word	13, 14, 15, 12, 19
		.word	20, 24, 21, 23, 22

boardE1msg:	.asciiz	"5x5 Game Board 1"
boardE1:	.word	 2, 16, 12,  0,  3
		.word	20,  9, 22, 15,  1
		.word	13,  6, 14, 17,  4
		.word	18, 21, 10, 23,  8
		.word	 5,  7, 19, 11, 24

boardE2msg:	.asciiz	"5x5 Game Board 2"
boardE2:	.word	20,  3,  6,  2,  0
		.word	24,  5,  9, 21, 22
		.word	13, 19, 22,  8, 12
		.word	14, 23, 10,  7, 15
		.word	21, 19,  1, 11,  4

boardE3msg:	.asciiz	"5x5 Game Board 3"
boardE3:	.word	 0, 15, 14, 13, 16
		.word	12, 19, 10,  9,  3
		.word	18, 11,  7,  5,  2
		.word	 8, 20,  6, 21, 24
		.word	 4, 23, 22,  1, 17

boardE4msg:	.asciiz	"5x5 Game Board 4"
boardE4:	.word	 2, 16, 12,  0,  3
		.word	20,  9, 22, 15,  1
		.word	13,  6, 14, 17,  4
		.word	18, 20, 10, 23,  8
		.word	 5,  7, 19, 11, 24

# -----

goalFMsg:	.asciiz	"6x6 Goal Board #1"

boardFsize:	.word	6
goalF:		.word	 1,  2,  3,  4,  5, 6
		.word	 7,  8,  9, 10, 11, 12
		.word	13, 14, 15, 16, 17, 18
		.word	19, 20, 21, 22, 23, 24
		.word	25, 26, 27, 28, 29, 30
		.word	31, 32, 33, 34, 35,  0

boardF0msg:	.asciiz	"6x6 Game Board 0"
boardF0:	.word	 0,  1,  2,  3,  4, 28
		.word	 5,  6,  7, 34, 17, 27
		.word	 9, 10, 32,  8, 18, 25
		.word	29, 31, 11, 33, 16, 20
		.word	13, 14, 15, 12, 19, 30
		.word	35, 24, 21, 23, 26, 22

boardF1msg:	.asciiz	"6x6 Game Board 1"
boardF1:	.word	 2, 16, 27, 12,  0, 34
		.word	18, 28, 21, 10, 23,  8
		.word	20, 31, 22, 35, 29,  1
		.word	13, 26,  6, 14, 17,  4
		.word	30,  9, 32,  7,  3, 15
		.word	25,  5, 33, 19, 11, 24

boardF2msg:	.asciiz	"6x6 Game Board 2"
boardF2:	.word	20,  3,  6,  2,  0, 25
		.word	 1, 31, 14, 33, 34,  1
		.word	24, 29,  5,  9, 21, 22
		.word	26, 13, 19, 22,  8, 12
		.word	32, 23, 10, 28,  7, 15
		.word	27, 21, 19, 30, 11,  4

# -----
#  Local variables for displayBoard() function.

brdSection:	.asciiz	"************************************\n"
brdHdr:		.asciiz	"------------------------------------\n"
newLine:	.asciiz	"\n"
bar:		.asciiz	" | "
blnk:		.asciiz	" "
dashes:		.asciiz " ----"

# -----
#  Local variables for makeCalls() function.

badBoardMsg:	.asciiz	"Error, invalid board."

# -----
#  Local variables for manhattanDistance() function.

MDmsg:		.asciiz	"Manhattan Distance: "
mandist: 	.word	0

# -----
#  Local variables for validateBoard() function.

TRUE = 1
FALSE = 0

.align 4
tstArr:		.space		400


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalA
	lw	$a1, boardAsize
	la	$a2, goalAMsg
	jal	displayBoard

	la	$a0, goalA
	la	$a1, boardA0
	lw	$a2, boardAsize
	la	$a3, boardA0msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA1
	lw	$a2, boardAsize
	la	$a3, boardA1msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA2
	lw	$a2, boardAsize
	la	$a3, boardA2msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA3
	lw	$a2, boardAsize
	la	$a3, boardA3msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA4
	lw	$a2, boardAsize
	la	$a3, boardA4msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA5
	lw	$a2, boardAsize
	la	$a3, boardA5msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA6
	lw	$a2, boardAsize
	la	$a3, boardA6msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA7
	lw	$a2, boardAsize
	la	$a3, boardA7msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA8
	lw	$a2, boardAsize
	la	$a3, boardA8msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA9
	lw	$a2, boardAsize
	la	$a3, boardA9msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA10
	lw	$a2, boardAsize
	la	$a3, boardA10msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA11
	lw	$a2, boardAsize
	la	$a3, boardA11msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA12
	lw	$a2, boardAsize
	la	$a3, boardA12msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA13
	lw	$a2, boardAsize
	la	$a3, boardA13msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA14
	lw	$a2, boardAsize
	la	$a3, boardA14msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA15
	lw	$a2, boardAsize
	la	$a3, boardA15msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA16
	lw	$a2, boardAsize
	la	$a3, boardA16msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA17
	lw	$a2, boardAsize
	la	$a3, boardA17msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA18
	lw	$a2, boardAsize
	la	$a3, boardA18msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA19
	lw	$a2, boardAsize
	la	$a3, boardA19msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA20
	lw	$a2, boardAsize
	la	$a3, boardA20msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA21
	lw	$a2, boardAsize
	la	$a3, boardA21msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA22
	lw	$a2, boardAsize
	la	$a3, boardA22msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA23
	lw	$a2, boardAsize
	la	$a3, boardA23msg
	jal	makeCalls

	la	$a0, goalA
	la	$a1, boardA24
	lw	$a2, boardAsize
	la	$a3, boardA24msg
	jal	makeCalls

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalB
	lw	$a1, boardBsize
	la	$a2, goalBMsg
	jal	displayBoard

	la	$a0, goalB
	la	$a1, boardB0
	lw	$a2, boardBsize
	la	$a3, boardB0msg
	jal	makeCalls

	la	$a0, goalB
	la	$a1, boardB1
	lw	$a2, boardBsize
	la	$a3, boardB1msg
	jal	makeCalls

	la	$a0, goalB
	la	$a1, boardB2
	lw	$a2, boardBsize
	la	$a3, boardB2msg
	jal	makeCalls

	la	$a0, goalB
	la	$a1, boardB3
	lw	$a2, boardBsize
	la	$a3, boardB3msg
	jal	makeCalls

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalC
	lw	$a1, boardCsize
	la	$a2, goalCMsg
	jal	displayBoard

	la	$a0, goalC
	la	$a1, boardC0
	lw	$a2, boardCsize
	la	$a3, boardC0msg
	jal	makeCalls

	la	$a0, goalC
	la	$a1, boardC1
	lw	$a2, boardCsize
	la	$a3, boardC1msg
	jal	makeCalls

	la	$a0, goalC
	la	$a1, boardC2
	lw	$a2, boardCsize
	la	$a3, boardC2msg
	jal	makeCalls

	la	$a0, goalC
	la	$a1, boardC3
	lw	$a2, boardCsize
	la	$a3, boardC3msg
	jal	makeCalls

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalD
	lw	$a1, boardDsize
	la	$a2, goalDMsg
	jal	displayBoard

	la	$a0, goalD
	la	$a1, boardD0
	lw	$a2, boardDsize
	la	$a3, boardD0msg
	jal	makeCalls

	la	$a0, goalD
	la	$a1, boardD1
	lw	$a2, boardDsize
	la	$a3, boardD1msg
	jal	makeCalls

	la	$a0, goalD
	la	$a1, boardD2
	lw	$a2, boardDsize
	la	$a3, boardD2msg
	jal	makeCalls

	la	$a0, goalD
	la	$a1, boardD3
	lw	$a2, boardDsize
	la	$a3, boardD3msg
	jal	makeCalls

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalE
	lw	$a1, boardEsize
	la	$a2, goalEMsg
	jal	displayBoard

	la	$a0, goalE
	la	$a1, boardE0
	lw	$a2, boardEsize
	la	$a3, boardE0msg
	jal	makeCalls

	la	$a0, goalE
	la	$a1, boardE1
	lw	$a2, boardEsize
	la	$a3, boardE1msg
	jal	makeCalls

	la	$a0, goalE
	la	$a1, boardE2
	lw	$a2, boardEsize
	la	$a3, boardE2msg
	jal	makeCalls

	la	$a0, goalE
	la	$a1, boardE3
	lw	$a2, boardEsize
	la	$a3, boardE3msg
	jal	makeCalls

	la	$a0, goalE
	la	$a1, boardE4
	lw	$a2, boardEsize
	la	$a3, boardE4msg
	jal	makeCalls

# -----
#  Display goal board
#  Display game boards and distances

	la	$a0, brdSection
	li	$v0, 4
	syscall					# print header

	la	$a0, goalF
	lw	$a1, boardFsize
	la	$a2, goalFMsg
	jal	displayBoard

	la	$a0, goalF
	la	$a1, boardF0
	lw	$a2, boardFsize
	la	$a3, boardF0msg
	jal	makeCalls

	la	$a0, goalF
	la	$a1, boardF1
	lw	$a2, boardFsize
	la	$a3, boardF1msg
	jal	makeCalls

	la	$a0, goalF
	la	$a1, boardF2
	lw	$a2, boardFsize
	la	$a3, boardF2msg
	jal	makeCalls

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall
.end main

######################################################################
#  Function to make calls...

# -----
#  Arguments
#	$a0 - goal board address
#	$a1 - board address
#	$a2 - board order
#	$a3 - board title message

.globl	makeCalls
.ent	makeCalls
makeCalls:
	subu	$sp, $sp, 28			#  Save registers.
	sw	$s0, ($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s4, 12($sp)
	sw	$s5, 16($sp)
	sw	$s6, 20($sp)
	sw	$ra, 24($sp)

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3

	move	$a0, $s1
	move	$a1, $s2
	move	$a2, $s3
	jal	displayBoard

	move	$a0, $s1
	move	$a1, $s2
	jal	validateBoard

	beq	$v0, TRUE, showDist

	li	$v0, 4
	la	$a0, badBoardMsg
	syscall

	li	$v0, 4
	la	$a0, newLine
	syscall
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	makeCallsDone

showDist:
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	jal	manhattanDistance

makeCallsDone:
	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s4, 12($sp)
	lw	$s5, 16($sp)
	lw	$s6, 20($sp)
	lw	$ra, 24($sp)
	add	$sp, $sp, 28

	jr	$ra
.end	makeCalls

######################################################################
#  Function to print a formatted game board.

# -----
#  Formula for multiple dimension array indexing:
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize

# -----
#  Arguments:
#	$a0 - board address
#	$a1 - order (size) of the board
#	$a2 - title address

.globl	displayBoard
.ent	displayBoard
displayBoard:

	subu $sp, $sp, 16 			# preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	addu $fp, $sp, 16 			# set frame pointer

	move	$s0, $a0			# move into preserved registers
	move	$s1, $a1
	move	$s2, $a2

# Display Board ----------------------

	la	$a0, brdHdr 			# ---------------------------------------------
	li	$v0, 4
	syscall
	la	$a0, ($s2)				# Header
	li	$v0, 4
	syscall
	la	$a0, newLine			# /n
	li	$v0, 4
	syscall
	la	$a0, newLine			# /n
	li	$v0, 4
	syscall
	li $t0, 0 
	topDash: 					# --- --- --- 
		la	$a0, dashes	
		li	$v0, 4
		syscall
		add $t0, $t0, 1
		blt $t0, $s1, topDash	# Allocates dashes by array order 
		la	$a0, newLine	
		li	$v0, 4
		syscall					# /n

# Print Grid ----------------------------------

	li $t0, 0					# Row Counter
	j startGrid
	barRow:
		bge $t0, $s1, gridDone
		la	$a0, newLine		# /n				
		li	$v0, 4
		syscall
	startGrid:
		la	$a0, bar			# |	
		li	$v0, 4
		syscall
	li $t1, 0					# Column Counter 
	barCol: 

# Access Array ----------------------------------
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize

		mul $t3, $t0, $s1 		# r * colSize 
		add $t3, $t3, $t1   	# (r * colSize + c)
		mul $t3, $t3, 4 		# (r * colSize + c) * dataSize
		add $t3, $t3, $s0		# addr(r,c) = baseAddr + (r * colSize + c) * dataSize

		lw $t4, ($t3)		
		bgt $t4, 9, doubleD		# Check if double digit number to add extra space 
		la	$a0, blnk	
		li	$v0, 4
		syscall					# " "
	doubleD:
		lw $a0, ($t3)			# Skip " " if double digit 
		li	$v0, 1			
		syscall					# Put into grid by arr [r] [c] 
#--------------------------------------------------

		la	$a0, bar			# |
		li	$v0, 4
		syscall

		add $t1, $t1, 1			# column ++
		blt $t1, $s1, barCol	# Next column if less than order 
		add $t0, $t0, 1			#row ++
		j barRow				# Next row if last column

	gridDone: 
		la	$a0, newLine		# /n
		li	$v0, 4
		syscall

	li $t0, 0
	bottomDash: 					# --- --- --- 
		la	$a0, dashes	
		li	$v0, 4
		syscall
		add $t0, $t0, 1
		blt $t0, $s1, bottomDash	# Allocates dashes by array order
		la	$a0, newLine	
		li	$v0, 4
		syscall						# /n
		la	$a0, newLine	
		li	$v0, 4
		syscall						# /n

	lw $s0, 0($sp)	# restore registers 
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addu $sp, $sp, 16
	jr $ra
.end displayBoard

######################################################################
#  Function to compute the manhattan distance
#  between two game boards.

# -----
#  Formula for multiple dimension array indexing:
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize

# -----
#    Arguments:
#	$a0 - goal board address
#	$a1 - board address
#	$a2 - order (size) of the board

#    Returns:
#	nothing

.globl	manhattanDistance
.ent	manhattanDistance
manhattanDistance:

	subu $sp, $sp, 20 # preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	addu $fp, $sp, 20 # set frame pointer

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	li 		$s3, 0
	li 		$t0, 0

# Manhattan Distance -----------------------------
	li $t5, 0						# Row Counter ( y = t5 )
	j goalArr
	goalRow:
		bge $t5, $s2, goalDone
	goalArr:
	li $t6, 0						# Column Counter ( x = t6 ) 
	goalCol: 
# Access Goal Array ----------------------------------
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize
		mul $t7, $t5, $s2 			# r * colSize 
		add $t7, $t7, $t6   		# (r * colSize + c)
		mul $t7, $t7, 4 			# (r * colSize + c) * dataSize
		add $t7, $t7, $s0			# addr(r,c) = baseAddr + (r * colSize + c) * dataSize

		lw $t8, ($t7)				# arr [r] [c]

		beqz $t8, skipZero

# Search Coordinates ----------------------------------
	li $t0, 0						# Row Counter ( y = t0 )
	j searchArr
	searchRow:
		bge $t0, $s2, searchDone
	searchArr:
	li $t1, 0						# Column Counter ( x = t1 ) 
	searchCol: 
# Access Search Array ----------------------------------
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize
		mul $t3, $t0, $s2 			# r * colSize 
		add $t3, $t3, $t1   		# (r * colSize + c)
		mul $t3, $t3, 4 			# (r * colSize + c) * dataSize
		add $t3, $t3, $s1			# addr(r,c) = baseAddr + (r * colSize + c) * dataSize

		lw $t4, ($t3)				# arr [r] [c]
		beq $t4, $t8, searchDone  	# found search coordinates 
# Next Search Index-------------------------------------
		add $t1, $t1, 1				# column ++
		blt $t1, $s2, searchCol		# Next column if less than order 
		add $t0, $t0, 1				#row ++
		j searchRow					# Next row if last column
	searchDone: 
# Manhattan Calculations -------------------------------

	li $t7, 0 
	sub $t3, $t6, $t1
	bltz $t3, absoluteValueX
	sub $t4, $t5, $t0
	bltz $t4, absoluteValueY
	j positive
	absoluteValueX: 
		sub $t3, $t7, $t3
		sub $t4, $t5, $t0
		bltz $t4, absoluteValueY
		j positive
	absoluteValueY:
		sub $t4, $t7, $t4
	positive: 
	add $t9, $t4, $t3 
	add $s3, $s3, $t9
	skipZero: 

# Next Goal Index------------------------------------
		add $t6, $t6, 1				# column ++
		blt $t6, $s2, goalCol		# Next column if less than order 
		add $t5, $t5, 1				#row ++
		j goalRow					# Next row if last column
	goalDone: 

	
		la	$a0, MDmsg				# display manhattan distance				
		li	$v0, 4
		syscall
		move	$a0, $s3			# display manhattan distance				
		li	$v0, 1
		syscall
		la	$a0, newLine	# /n			
		li	$v0, 4
		syscall
		la	$a0, newLine	# /n			
		li	$v0, 4
		syscall


	lw $s0, 0($sp)	# restore registers 
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addu $sp, $sp, 20
	jr $ra
.end	manhattanDistance

######################################################################
#  Validate board
#	Must have numbers 1 to (order^2)-1
#	Each must appear only once.

#  Arguments:
#	$a0 - board address
#	$a1 - board order

#  Returns:
#	$v0 TRUE or FALSE

.globl	validateBoard
.ent	validateBoard
validateBoard:

	subu $sp, $sp, 12 # preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	addu $fp, $sp, 12 # set frame pointer

	move	$s0, $a0
	move	$s1, $a1

# Hash out tstArr --------------------------------------
	la $t7, tstArr
	li $t0, 0 					# tstArr Counter 
	li $t1, 99   				# Hash
	hashOut: 
		sw $t1, ($t7) 
		add $t7, $t7, 4			# 100 in every array spot
		add $t0, $t0, 1 		# tstArr ++
		blt $t0, 400, hashOut
# Read in tstArr ---------------------------------------
	li $t0, 0					# Row Counter
	j valArr
	valRow:
		bge $t0, $s1, valDone
	valArr:
	li $t1, 0					# Column Counter 
	valCol: 
# Access Array -----------------------------------------
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize
		mul $t3, $t0, $s1 		# r * colSize 
		add $t3, $t3, $t1   	# (r * colSize + c)
		mul $t3, $t3, 4 		# (r * colSize + c) * dataSize
		add $t3, $t3, $s0		# addr(r,c) = baseAddr + (r * colSize + c) * dataSize

# Store in Test Array ----------------------------------
		la $t7, tstArr
		lw $t4, ($t3)			# arr [r] [c] 
		
		mul $t5, $t4, 4 		# arr [r][c] value into tstArr [value]
		add $t7, $t7, $t5 
		lw $t9, ($t7) 
		beq $t9, $t4, failure 	# if tstArr [value] already has value it fails
		sw $t4, ($t7)
#--------------------------------------------------
		add $t1, $t1, 1			# column ++
		blt $t1, $s1, valCol	# Next column if less than order 
		add $t0, $t0, 1			#row ++
		j valRow				# Next row if last column
	valDone: 

	li $t0, 0 
	validateOrder: 
		la $t7, tstArr
		mul $t1, $t0, 4 		# arr [r][c] value into tstArr [value]
		add $t7, $t7, $t1 
		lw $t9, ($t7)
		bne $t9, $t0, failure
		add $t0, $t0, 1 
		blt $t0, $s1, validateOrder
		li $v0, TRUE
		j doneValidating
	failure: 
 		li	$v0, FALSE
	doneValidating: 

	lw $s0, 0($sp)	# restore registers 
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addu $sp, $sp, 12
	jr $ra
.end validateBoard

######################################################################

