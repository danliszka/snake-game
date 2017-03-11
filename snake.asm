.data
board: 
.ascii "*************************    *****************    **************"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                     ***                                      *"
.ascii "*                     ***                                      *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "                                                                "
.ascii "                                                                "
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                        ***                   *"
.ascii "*                                        ***                   *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                *                                             *"
.ascii "*                ****                                          *"
.ascii "*                *                                             *"
.ascii "*                *                                             *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.asciiz "*************************    *****************    **************"

snake: 








.text

#write the board to the display
li $t4, 0 #xcoor
li $t5, 0 #ycoor
li $t6, 0 #counter
la $s0, board
boardloop:

	beq $t5, 0x40, placeFrogs
	
	innerloop:
	
		beq $t4, 0x40, endinnerloop
		lb $s1, 0($s0)
		addi $s0, $s0, 1
		bne $s1, 0x2a, continue
			addi $a0, $t4, 0
			addi $a1, $t5, 0
			li $a2, 1
			jal _setLED
		continue:
		addi $t6, $t6, 1
		addi $t4, $t4, 1
		j innerloop
		
	endinnerloop:
	li $t4, 0
	addi $t5, $t5, 1
	j boardloop
	

#randomly places frogs on the board
#t4: counter
#t5: color
li $t4, 0
placeFrogs:
	addi $t4, $t4, 1
	beq $t4, 0x15, updateSnake
	li $a1, 0x40
	li $v0, 42
	syscall
	add $t6,$zero,$a0 
	li $a1, 0x40
	li $v0, 42
	syscall
	add $a1, $zero,$t6
	
	jal _getLED
	addi $t5, $v0, 0
	bne $t5, 0, placeFrogs
	
	li $a2, 3
	jal _setLED
	j placeFrogs
	
	
	
	
updateSnake:
	
	
	
	
	
	

MAIN:











j EXIT





# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=yellow, 3=green
	#
	# arguments: $a0 is x, $a1 is y, $a2 is color
	# trashes:   $t0-$t3
	# returns:   none
	#
_setLED:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll	$t0,$a1,4      # y * 16 bytes
	srl	$t1,$a0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008 # base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$a0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
	
	# int _getLED(int x, int y)
	#   returns the value of the LED at position (x,y)
	#
	#  arguments: $a0 holds x, $a1 holds y
	#  trashes:   $t0-$t2
	#  returns:   $v0 holds the value of the LED (0, 1, 2 or 3)
	#
_getLED:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll  $t0,$a1,4      # y * 16 bytes
	srl  $t1,$a0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$a0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	jr   $ra
	
	
EXIT: