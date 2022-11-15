###########################################################################
#  Name: Dylan Cozloff
#  NSHE ID: 2001668380
#  Section: 1003
#  Assignment: MIPS #2
#  Description: Simple MIPS program to calculate 3D hexagonal prisms


###########################################################
#  data segment

.data

apothems:	.word	  110,   114,   113,   137,   154
		.word	  131,   113,   120,   161,   136
		.word	  114,   153,   144,   119,   142
		.word	  127,   141,   153,   162,   110
		.word	  119,   128,   114,   110,   115
		.word	  115,   111,   122,   133,   170
		.word	  115,   123,   115,   163,   126
		.word	  124,   133,   110,   161,   115
		.word	  114,   134,   113,   171,   181
		.word	  138,   173,   129,   117,   193
		.word	  125,   124,   113,   117,   123
		.word	  134,   134,   156,   164,   142
		.word	  206,   212,   112,   131,   246
		.word	  150,   154,   178,   188,   192
		.word	  182,   195,   117,   112,   127
		.word	  117,   167,   179,   188,   194
		.word	  134,   152,   174,   186,   197
		.word	  104,   116,   112,   136,   153
		.word	  132,   151,   136,   187,   190
		.word	  120,   111,   123,   132,   145

bases:		.word	  233,   214,   273,   231,   215
		.word	  264,   273,   274,   223,   256
		.word	  157,   187,   199,   111,   123
		.word	  124,   125,   126,   175,   194
		.word	  149,   126,   162,   131,   127
		.word	  177,   199,   197,   175,   114
		.word	  244,   252,   231,   242,   256
		.word	  164,   141,   142,   173,   166
		.word	  104,   146,   123,   156,   163
		.word	  121,   118,   177,   143,   178
		.word	  112,   111,   110,   135,   110
		.word	  127,   144,   210,   172,   124
		.word	  125,   116,   162,   128,   192
		.word	  215,   224,   236,   275,   246
		.word	  213,   223,   253,   267,   235
		.word	  204,   229,   264,   267,   234
		.word	  216,   213,   264,   253,   265
		.word	  226,   212,   257,   267,   234
		.word	  217,   214,   217,   225,   253
		.word	  223,   273,   215,   206,   213

heights:	.word	  117,   114,   115,   172,   124
		.word	  125,   116,   162,   138,   192
		.word	  111,   183,   133,   130,   127
		.word	  111,   115,   158,   113,   115
		.word	  117,   126,   116,   117,   227
		.word	  177,   199,   177,   175,   114
		.word	  194,   124,   112,   143,   176
		.word	  134,   126,   132,   156,   163
		.word	  124,   119,   122,   183,   110
		.word	  191,   192,   129,   129,   122
		.word	  135,   226,   162,   137,   127
		.word	  127,   159,   177,   175,   144
		.word	  179,   153,   136,   140,   235
		.word	  112,   154,   128,   113,   132
		.word	  161,   192,   151,   213,   126
		.word	  169,   114,   122,   115,   131
		.word	  194,   124,   114,   143,   176
		.word	  134,   126,   122,   156,   163
		.word	  149,   144,   114,   134,   167
		.word	  143,   129,   161,   165,   136

hexVolumes:	.space	400

len:		.word	100

volMin:		.word	0
volEMid:	.word	0
volMax:		.word	0
volSum:		.word	0
volAve:		.word	0

LN_CNTR	= 4


# -----

hdr:	.ascii	"MIPS Assignment #2 \n"
	.ascii	"  Hexagonal Volumes Program:\n"
	.ascii	"  Also finds minimum, middle value, maximum, \n"
	.asciiz	"  sum, and average for the volumes.\n\n"

a1_st:	.asciiz	"\nHexagon Volumes Minimum = "
a2_st:	.asciiz	"\nHexagon Volumes Est Med  = "
a3_st:	.asciiz	"\nHexagon Volumes Maximum = "
a4_st:	.asciiz	"\nHexagon Volumes Sum     = "
a5_st:	.asciiz	"\nHexagon Volumes Average = "

newLn:	.asciiz	"\n"
blnks:	.asciiz	"  "

# ##########################################################
#  text/code segment

# --------------------
#  Compute volumes:
#  Then find middle, max, sum, and average for volumes.

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# -------------------------------------------------------


#	YOUR CODE GOES HERE

# Calculate Areas 

	la	$a0, blnks
	li	$v0, 4
	syscall				# print "  "

	li $t5, 0 				# Counter 
	lw $t6, len 			# Counter condition 

	la $t0, bases 		    # Get sideLens Array Address
	la $t1, apothems 	    # Get apothemLens Array Address
	la $t2, hexVolumes 		# Get hexAreas Array Address
	la $t3, heights  	    # Get heights Array Address
calculateVolume:
 
	lw $t4, ($t0)			# Get Value at bases index 
	lw $t7, ($t1)			# Get Value at apothemLens index 
	lw $t8, ($t3)			# Get Value at heights index


	mul $t7, $t7, $t4 		# Calculation
	mul $t8, $t8, $t7
	mul $t8, $t8, 3 

	sw $t8, ($t2) 			# Store in unitialized hexVolumes Array 

	lw	$a0, ($t2)
	li	$v0, 1
	syscall				    # Print List

	add $t0, $t0, 4			# Get next index of bases Array 
	add $t1, $t1, 4			# Get next index of apothemLens Array 
	add $t2, $t2, 4			# Get next index of hexVolumes Array 
	add $t3, $t3, 4			# Get next index of hexVolumes Array 
	add $t5, $t5, 1			# Increment Loop Counter 

	rem $t9, $t5, 4 
	bnez $t9, notNewLine
	la	$a0, newLn			# print a newline
	li	$v0, 4
	syscall
	notNewLine:

	bge $t5, $t6, skpblnks 	
	la	$a0, blnks
	li	$v0, 4
	syscall							# print "  "

	blt $t5, $t6, calculateVolume 	# Loop 
skpblnks:

# ---------------------------------------------------------------------
# Calculate haMin, haMax, haSum 

	li $t5, 0 				# Loop counter 
	li $t2, 0
	lw $t6, len 			# Loop counter condition 

	la $t0, hexVolumes 		# Get hexVolumes Array Address
stats: 
	lw $t1, ($t0)			# Get Value at hexVolumes index
	add $t2, $t2, $t1 		# Add to total sum 

	bge $t1, $t3, notMin	# If not min jump
	sw $t1, volMin			# Set new min
	lw $t3, volMin
notMin:
	ble $t1, $t4, notMax	# If not max jump
	sw $t1, volMax			# Set new max
	lw $t4, volMax
notMax:
    add $t0, $t0, 4			# Get next index of hexVolumes Array 
	add $t5, $t5, 1			# Increment Loop Counter 
    blt $t5, $t6, stats 	# Loop 

	sw $t2, volSum
# ---------------------------------------------------------------------
# Calculate volAve

	lw $t0, volSum 			# Sum 
	lw $t1, len
	div $t2, $t0, $t1 		# Divided by length
	sw $t2, volAve 

# ---------------------------------------------------------------------
# Calculate hEMid 

# Sum of first and last
la $t0, hexVolumes 			
lw $t6, ($t0)				# First Element 

lw $t1, len
sub $t1, $t1, 1 
mul $t1, $t1, 4 
add $t0, $t0, $t1 
lw $t7, ($t0) 				# Second Element

add $t6, $t6, $t7 			# Sum of first and last

# Sum of first, last, and middle
la $t0, hexVolumes
lw $t1, len 
div $t1, $t1, 2 
mul $t1, $t1, 4 
add $t0, $t0, $t1 
lw $t8, ($t0) 				# 2nd Middle Element
sub $t0, $t0, 4
lw $t9, ($t0) 				# 1st Middle Element

add $t6, $t6, $t8 			# Sum of first, last, and 2 middle values
add $t6, $t6, $t9

# Divide by 4 
div $t6, $t6, 4 
sw $t6, volEMid





# #########################################################
#  Display results.

	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, volMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, volEMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, volMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, volSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, volAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

