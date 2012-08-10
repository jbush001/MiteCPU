#
# Sum the digits 1-8
#

res result
res count
res scratch

start:	ldi 8
		st count

loop:	ldi 0			# Clear accumulator
		add result
		add count	
		st result		# result = result + count

		ldi -1
		add count		
		st count		# count = count - 1
		bl done			# if count < 0 exit loop
		
		ldi -1			# Branch unconditionally
		bl loop

done:	ldi -1
		bl done			# Infinite loop
