  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,17		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	


	move	$a0,$v0		# copy return value to argument register NOTE: Flippade v0 och a0 då funkade programmet, vet inte om det var en bug eller ej

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #

hexasc:
	move $t1,$a0
	
	and $t1,$t1,0xf		# Get only the 4 lsb of t1
	
	
	slti $t0,$t1,10		# Check if t1 < 10
	
	beq $t0,1,foo		#If t1 < 10 go to foo
	
	add $t1,$t1,0x37	#Add 0x37 to t1 if t1 > 9
	
	move $v0,$t1
	
	jr $ra		#Jump out of the if
	
	foo:	add $t1,$t1,0x30	#Add 0x30 to t1 if t1 < 10
	
	move $v0,$t1
	
	jr $ra			#Return to return_point in main
	
	