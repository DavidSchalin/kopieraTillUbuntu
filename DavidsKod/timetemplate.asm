  # timetemplate.asm
  # Written 2015 by F Lundevall & 2020 by David Schalin and Sebastian Holmen
  # Copyright abandonded - this file is in the public domain.

.macro STRLOOP (%reg)
	move $a0,%reg
	srl %reg,%reg,4
	PUSH(%reg)
	jal hexasc
	nop
	POP(%reg)
	PUSH($v0)
.end_macro

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
hexasc:
	move $t1,$a0
	
	and $t1,$t1,0xf		# Get only the 4 lsb of t1
	
	
	slti $t0,$t1,10		# Check if t1 < 10
	
	beq $t0,1,number		#If t1 < 10 go to number
	
	add $t1,$t1,0x37	#Add 0x37 to t1 if t1 > 9
	
	move $v0,$t1
	
	jr $ra		#Jump out of the if
	
	number:	add $t1,$t1,0x30	#Add 0x30 to t1 if t1 < 10
	
	move $v0,$t1
	
	jr $ra		#Return to return_point in caller
	
## Delay function to simulate time passing
#void delay( int ms ) /* Wait a number of milliseconds, specified by the parameter value. */
#{
# int i;
# while( ms > 0 )
# {
# ms = ms - 1;
# /* Executing the following for loop should take 1 ms */
# for( i = 0; i < 4711; i = i + 1 ) /* The constant 4711 must be easy to change! */
# {
# /* Do nothing. */
# }
# }
#}
		
delay:			#testing this on PC results in the programs clock taking 965ms per tick

	#argument $a0 = ms sent in as 1000
	move $t0,$a0 #Set t0 as the sent in argument aka ms
	slti $t2,$t0,1
	bne $t2,1,delay_loop_1
	
	jr $ra	#if ms <= 0 return
	nop
	
	delay_loop_1: #start of while loop
		li $t1,0 #int i = 0
		
		sub $t0,$t0,1 #ms = ms -1
		
		delay_loop_2: #start of for loop
			add, $t1,$t1,1 #for loop i++
			
			bne $t1,1050, delay_loop_2 #if i != 1050 jump back to start of for loop
			
		bne $t0,0,delay_loop_1 #if ms != 0 jump back to delay_loop_1
		
 jr $ra
 nop
 
 ## Takes the current time as a hex value and returns it as a readable time (eg. 0x5859 becomes 58:59)

 time2string:
 	#a0 memory adress
 	#a1 time
 	PUSH($ra) #Send return adress to stack
 	move $t0,$a0 #t0 = a0
 	move $t1,$a1 #t1 = a1
 	PUSH($t0) #Send memory adress to the stack
 	
 	#### 00:0x
	STRLOOP($t1)
	####
	#### 00:x0
	STRLOOP($t1)
	####
 	#### 00x00
  	add $t0,$0,0x3a			#Kolon
 	PUSH($t0) 
   	####
   	#### 0x:00
   	STRLOOP($t1)
   	####	
	#### x0:00
   	STRLOOP($t1)
   	####
	####		NULL Value
    	add $t1,$0,0x00
 	PUSH($t1)
 	####
	POP($t0) # NULL
 	POP($t1) #This is the x0:00
 	POP($t2) #This is the 0x:00
 	POP($t3) #This is the 00x00
 	POP($t4) #This is the 00:x0
 	POP($t5) #This is the 00:0x
 	POP($t6) #This is the memory adress
 	sb $t0,5($t6)
 	sb $t1,0($t6)
 	sb $t2,1($t6)
 	sb $t3,2($t6)
 	sb $t4,3($t6)
 	sb $t5,4($t6)
   
   	POP($ra)
   
 	jr $ra
	
