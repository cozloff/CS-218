###########################################################################
#  Name: Dylan Cozloff
#  NSHE ID: 2001668380
#  Section: 1003
#  Assignment: MIPS #1
#  Description: Simple MIPS program to calculate the area of hexagons


################################################################################
#  data segment

.data

sideLens:
	.word	  15,   25,   33,   44,   58,   69,   72,   86,   99,  101
	.word	 369,  374,  377,  379,  382,  384,  386,  388,  392,  393
	.word	 501,  513,  524,  536,  540,  556,  575,  587,  590,  596
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	 107,  121,  137,  141,  157,  167,  177,  181,  191,  199
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	 202,  209,  215,  219,  223,  225,  231,  242,  244,  249
	.word	 203,  215,  221,  239,  248,  259,  262,  274,  280,  291
	.word	 251,  253,  266,  269,  271,  272,  280,  288,  291,  299
	.word	1469, 2474, 3477, 4479, 5482, 5484, 6486, 7788, 8492

apothemLens:
	.word	  32,   51,   76,   87,   90,  100,  111,  123,  132,  145
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	 782,  795,  807,  812,  827,  847,  867,  879,  888,  894
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	1782, 2795, 3807, 3812, 4827, 5847, 6867, 7879, 7888, 1894
	.word	 206,  212,  222,  231,  246,  250,  254,  278,  288,  292
	.word	 332,  351,  376,  387,  390,  400,  411,  423,  432,  445
	.word	  10,   12,   14,   15,   16,   22,   25,   26,   28,   29
	.word	 400,  404,  406,  407,  424,  425,  426,  429,  448,  492
	.word	 457,  487,  499,  501,  523,  524,  525,  526,  575,  594
	.word	1912, 2925, 3927, 4932, 5447, 5957, 6967, 7979, 7988

hexAreas:
	.space	436

len:	.word	109

haMin:	.word	0
haEMid:	.word	0
haMax:	.word	0
haSum:	.word	0
haAve:	.word	0

LN_CNTR	= 7

# -----

hdr:	.ascii	"MIPS Assignment #1 \n"
	.ascii	"Program to calculate area of each hexagon in a series "
	.ascii	"of hexagons. \n"
	.ascii	"Also finds min, est mid, max, sum, and average for the "
	.asciiz	"hexagon areas. \n\n"

new_ln:	.asciiz	"\n"
blnks:	.asciiz	"  "

a1_st:	.asciiz	"\nHexagon min = "
a2_st:	.asciiz	"\nHexagon emid = "
a3_st:	.asciiz	"\nHexagon max = "
a4_st:	.asciiz	"\nHexagon sum = "
a5_st:	.asciiz	"\nHexagon ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# --------------------------------------------------


#	YOUR CODE GOES HERE

#---------------------------------------------------------------------
# Calculate Areas 

	la	$a0, blnks
	li	$v0, 4
	syscall				# print "  "

	li $t5, 0 				#Loop counter 
	lw $t6, len 			#Loop counter condition 

	la $t0, sideLens 		# Get sideLens Array Address
	la $t1, apothemLens 	# Get apothemLens Array Address
	la $t2, hexAreas 		# Get hexAreas Array Address
calculateArea:
 
	lw $t3, ($t0)			# Get Value at sideLens index 
	lw $t4, ($t1)			# Get Value at apothemLens index 

	mul $t7, $t3, $t4 		# Calculation
	div $t7, $t7, 2
	mul $t7, $t7, 6 

	sw $t7, ($t2) 			# Store in unitialized hexAreas Array 

	lw	$a0, ($t2)
	li	$v0, 1
	syscall				    #Print List

	add $t0, $t0, 4			# Get next index of sideLens Array 
	add $t1, $t1, 4			# Get next index of apothemLens Array 
	add $t2, $t2, 4			# Get next index of hexAreas Array 
	add $t5, $t5, 1			# Increment Loop Counter 

	rem $t9, $t5, 7 
	bnez $t9, notNewLine
	la	$a0, new_ln			# print a newline
	li	$v0, 4
	syscall
	notNewLine:

	bge $t5, $t6, skpblnks 	
	la	$a0, blnks
	li	$v0, 4
	syscall							# print "  "

	blt $t5, $t6, calculateArea 	# Loop 
skpblnks:

#---------------------------------------------------------------------
# Calculate haMin, haMax, haSum 

	li $t5, 0 				#Loop counter 
	li $t2, 0
	lw $t6, len 			#Loop counter condition 

	la $t0, hexAreas 		# Get hexAreas Array Address
stats: 
	lw $t1, ($t0)			# Get Value at sideLens index
	add $t2, $t2, $t1 		# Add to total sum 

	bge $t1, $t3, notMin	# If not min jump
	sw $t1, haMin			# Set new min
	lw $t3, haMin
notMin:
	ble $t1, $t4, notMax	# If not max jump
	sw $t1, haMax			# Set new max
	lw $t4, haMax
notMax:
    add $t0, $t0, 4			# Get next index of hexAreas Array 
	add $t5, $t5, 1			# Increment Loop Counter 
    blt $t5, $t6, stats 	# Loop 

	sw $t2, haSum
#---------------------------------------------------------------------
# Calculate haAve

	lw $t0, haSum 			# Sum 
	lw $t1, len
	div $t2, $t0, $t1 		# Divided by length
	sw $t2, haAve 

#---------------------------------------------------------------------
# Calculate hEMid 

#Sum of first and last
la $t0, hexAreas 			
lw $t6, ($t0)				# First Element 

lw $t1, len
sub $t1, $t1, 1 
mul $t1, $t1, 4 
add $t0, $t0, $t1 
lw $t7, ($t0) 				# Second Element

add $t6, $t6, $t7 			# Sum of first and last

# Sum of first, last, and middle
la $t0, hexAreas
lw $t1, len 
div $t1, $t1, 2 
mul $t1, $t1, 4 
add $t0, $t0, $t1 
lw $t8, ($t0) 				# Middle Element

add $t6, $t6, $t8 			# Sum of first, last, and middle 

# Divide by 3 
div $t6, $t6, 3 
sw $t6, haEMid



##########################################################
#  Display results.

#  Print hexAreas.

	# lw	$a0, hexAreas
	# li	$v0, 1
	# syscall				# hexAreas

#---------------------------------------------

	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, haMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "emid = "

	lw	$a0, haEMid
	li	$v0, 1
	syscall				# print emid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, haMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, haSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, haAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

