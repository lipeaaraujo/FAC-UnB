.data	# Data definitions.
	invalidMessage: .string "Entrada invalida\n"
	primeMessage: .string "sim\n"
	notPrimeMessage: .string "nao\n"
	
.text	# Instructions definitions.
main:	# Main label
	# Get the number.
	li a7, 5					# Read integer syscall.
	ecall
	
	add s0, a0, zero			# s0 = num.
	li t0, 1					# Used to verify if the number is natural or equal to 1.
	li t1, 2 					# Used to verify if the number is equal to 2.
	
	blt s0, t0, invalidNum		# Branch if num is less than 1.
	beq s0, t0, numIsNotPrime	# Branch if num is equal to 1.
	beq s0, t1, numIsPrime		# Branch if num is equal to 2.
	
	checkPrime:
	fcvt.s.w ft0, s0			# Convert num to a float and store it.
	fsqrt.s ft1, ft0			# Get the square root of num.
	li t0, 2					# Start iterator.
	li t1, 0					# Remainder comparator.
	
	loop:
		rem t2, s0, t0			# t2 = num % i.
		beqz t2, numIsNotPrime	# Branch if t2 == 0.
		addi t0, t0, 1			# i++
		fcvt.s.w ft2, t0		# Convert t0 to a float.
		fle.s t3, ft2, ft1		# Check if iteration is smaller than sqrt(num).
		bnez t3, loop			# Branch back to loop.
		
	j numIsPrime				# If the loop ends, then the number is prime.
			
	invalidNum:
	li a7, 4					# PrintString syscall.
	la a0, invalidMessage		# Load string address.
	ecall						# Print: Entrada invalida.
	j exit						# Exit program.
	
	numIsPrime:
	li a7, 4					# PrintString syscall.
	la a0, primeMessage			# Load string address.
	ecall						# Print: sim.
	j exit						# Exit program.
	
	numIsNotPrime:
	li a7, 4					# PrintString syscall.
	la a0, notPrimeMessage		# Load string address.
	ecall						# Print: nao.
	j exit						# Exit program.
	
	exit:
	li a7, 10					# Exit syscall.
	ecall						# Exit program with code 0.	
	