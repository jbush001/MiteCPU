#
# Sum the digits 1-8
#

res result
res count
res scratch

start:	ldi 8
		st count

loop:	ldi 0
		sub result
		sub count	
		st scratch
		ldi 0			# Negate
		sub scratch		
		st result

		ldi 1
		sub count		
		st scratch
		ldi 0
		sub scratch
		st count		# count = count - 1
		bl done
		
		ldi -1			# Branch unconditionally
		bl loop

done:	ldi -1
		bl done			# Infinite loop
