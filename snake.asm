#Daniel Liszka
#Jenn Gingerich

#TO DO:
#-what happens when a red dot is next

.data
board: 
.ascii "*************************    *****************    **************"
.ascii "*                       *    *                                 *"
.ascii "*                       *    *                                 *"
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
.ascii "*                 *********                                    *"
.ascii "*                 *       *                                    *"
.ascii "*                 *       *                                    *"
.ascii "*                 *       ***                                  *"
.ascii "*                 *                                            *"
.ascii "*                 *                                            *"
.ascii "*                 ***********                                  *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                                                              *"
.ascii "*                       *    *                                 *"
.ascii "*                       *    *                                 *"
.asciiz "*************************    *****************    **************"

snake: .space 64

#s0 will store increment for x
#s1 will store increment for y
#s2 will store game time
#s3 will store number of frogs snake has eaten
#s4 will store head address of snake
#s5 will store tail address of snake
#s6 will store beginning of space for snake addresses
#s7 will store end of space for snake addresses




##hello


.text

#write the board to the display
li $t4, 0 #xcoor
li $t5, 0 #ycoor
li $t6, 0 #counter
la $s0, board
boardloop:

	beq $t5, 0x40, initializeSnake
	
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



initializeSnake:
#s4 will store head address
#s5 will store tail address
#s6 will store beginning of space for snake addresses
#s7 will store end of space for snake addresses
li $s1, 0
li $s0, 0
	la $s6, snake
	addi $s7, $s6, 0x40
	addi $s5, $s6, 0
	addi $s4, $s5, 14 #creats a space of 16 bytes because it starts out with 8 segments and each coordinate needs two bytes
	li $t1, 4
	li $t2, 31
	li $t3, 0 #counter
	addi $t4, $s5, 0
	initializeloop:
		beq $t3, 8, endinitializeloop
		sb $t1, 0($t4)
		sb $t2, 1($t4)
		addi $t1, $t1, 1
		addi $t4, $t4, 2
		addi $t3, $t3, 1
		j initializeloop
	endinitializeloop:
	addi $t4, $s5, 0
	addi $t5, $s4, 0
	li $a2, 2 #sets color to yellow
	updateloop:
		lb $a0, 0($t4)
		lb $a1, 1($t4)
		jal _setLED
		beq $t4, $t5, endupdateloop
		addi $t4, $t4, 2
		j updateloop
	endupdateloop:
	li $t4, 0
	
#This is randomly put in but its purpose is to start the snake going left
li $s0, 1
li $s1, 0





#randomly places frogs on the board
#t4: counter
#t5: color
placeFrogs:
	
	beq $t4, 0x15, MAIN
	li $a1, 0x3f
	li $v0, 42
	syscall
	addi $t6,$a0,1
	li $a1, 0x3f
	li $v0, 42
	syscall
	add $a1, $zero,$t6
	addi $a0, $a0, 1
	
	jal _getLED
	addi $t5, $v0, 0
	bne $t5, 0, placeFrogs
	
	li $a2, 3
	jal _setLED
	addi $t4, $t4, 1
	j placeFrogs
	
	
	
	


MAIN:
	
	jal _delay
	addi $s2, $s2, 1 #increments how many times there was a delay then will convert to total time at end
	jal _moveSnake
	bne $s2, 1000, MAIN #allow for a maximum of 1000 movements



j EXIT


#void _delay()
	#delays based on how many iterations of a loop has to be completed
	#arguments: none
	#trashes: $t0
	#returns: none
	
_delay:
	li $t0, 200
	delayloop:
	subi $t0, $t0, 1
	bnez $t0, delayloop
	jr $ra



# void _moveSnake (address head, address tail)
	#checks if key is pressed, then checks what new coordinate will be next, 
	#then based on color of next coordinate:
		#it will turn
		#keep going in same direction
		#keep going and decrement tail address to make snake longer
	#arguments: $s4 is head, $s5 is tail
	#trashes: $t6,$t7,$t8
	#returns: none
	
	
_moveSnake:
	addi $sp, $sp, -4 #put return address on the stack
	sw $ra, 0($sp)

	li $t6, 0xFFFF0000
	lb $t7, 0($t6)
	addi $t8, $t7, 0 #used to show if a button was pressed later
	#stores original increment values for use to keep from moving in opposite direction
	addi $t0, $s0, 0
	addi $t1, $s1, 0
	bne $t7, 1, continueMoving
		setdirection:
		#resets the incrementers to zero for re-initialization with new direction
		
		li $t6, 0xFFFF0004
		lbu $t7, 0($t6)
		bne $t7, 0xE0, next1 #up
			beq $t1, 1, continueMoving #prevents from moving in the exact oposite direction
			li $s0, 0
			li $s1, -1
			j continueMoving
		next1:
		bne $t7, 0xE1, next2 #down
			beq $t1, -1, continueMoving #prevents from moving in the exact oposite direction
			li $s0, 0	
			li $s1, 1
			j continueMoving
		next2:
		bne $t7, 0xE2, next3 #left
			beq $t0, 1, continueMoving #prevents from moving in the exact oposite direction
			li $s1, 0
			li $s0, -1
			j continueMoving
		next3:
		bne $t7, 0xE3, next4 #right
			beq $t0, -1, continueMoving #prevents from moving in the exact oposite direction
			li $s1, 0
			li $s0, 1
			j continueMoving
		next4:
		bne $t7, 0x42, continueMoving #DONT KNOW WHAT TO DO WITH THIS BUTTON
		j EXIT
			
	continueMoving:
	#loads current head
	lb $t6, 0($s4)#x coor
	lb $t7, 1($s4)#y coor
	#adds incrementers for new coordinate
	add $a0, $t6, $s0
	add $a1, $t7, $s1
	#checks if on edge
		leftEdge:
			bne $a0, -1, rightEdge
			li $a0, 63
			j checkLED
		rightEdge:
			bne $a0, 64, topEdge
			li $a0, 0
			j checkLED
		topEdge:
			bne $a1, -1, bottomEdge
			li $a1, 63
			j checkLED
		bottomEdge:
			bne $a1, 64, checkLED #if not on an edge and only black in the way
			li $a1, 0
	checkLED:
	#get color at new location
	jal _getLED
	#increment head address by 2
	addi $s4, $s4, 2
	bne $s4, $s7, black
		#rolls over to beginning of memory for data structure if at end
		addi $s4, $s6, 0
	
	black:
		bne $v0, 0, red
		#if black:
		
		
			
		j finishmovesnake
		
	red:#NOT FINISHED-------
		bne $v0, 1, yellow
		#if red:
		
		beqz $t8, leftOrRight
		
		
		leftOrRight: j EXIT #DO NOT KEEP THIS IN
		
		
		
		j finishmovesnake
	yellow:
		bne $v0, 2, green
		#if yellow:
		j EXIT
	green:
		#if green:
		
		#increment counter for frogs
		addi $s3, $s3, 1
		bne $s3, 0x15, skipEatAllFrogs
			#if all frogs eaten, set final yellow and end game
			li $a2, 2
			jal _setLED
			j EXIT
		skipEatAllFrogs:
		#This purposefully skips updateSnake because the tail should stay in the same place
		sb $a0, 0($s4)
		sb $a1, 1($s4)
		li $a2, 2
		jal _setLED
		j exitmovesnake
		
	finishmovesnake:
		#store new coordinates in new memory location for head
		sb $a0, 0($s4)
		sb $a1, 1($s4)
	jal _updateSnake
	
	exitmovesnake:
	lw $ra, 0($sp)#grab old return address from stack
	addi $sp, $sp, 4
	jr $ra


# void _updateSnake(address head, address tail)
	#goes through the addresses of the snake and updates the board accordingly
	#arguments: $s4 is head, $s5 is tail
	#trashes: $t4-$t5
	#returns: none
	
_updateSnake:
	addi $sp, $sp, -4 #put return address on the stack
	sw $ra, 0($sp)
	
		#this portion sets the new head light to yellow
		lb $a0, 0($s4)
		lb $a1, 1($s4)
		li $a2, 2
		jal _setLED
		#this portion below sets the tail light to zero, then erases the coordinates from memory
		lb $a0, 0($s5) 
		lb $a1, 1($s5)
		li $a2, 0
		sb $zero, 0($s5)
		sb $zero, 1($s5)
		addi $s5, $s5, 2
		addi $t5, $s7, 0
		bne $s5, $t5, notAtEnd
			#if at end of memory for snake data structure, places at beginning
			addi $s5, $s6, 0
		notAtEnd:
		jal _setLED
	
	lw $ra, 0($sp)#grab old return address from stack
	addi $sp, $sp, 4
	jr $ra




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
