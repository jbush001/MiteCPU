#
# Sum the digits 1-8
#

res result
res count
res scratch

start:	ldi 8
		st count

loop:	ldi 0
		add result
		add count	
		st result

		ldi -1
		add count
		st count
		bl done
		
		ldi -1			# Branch unconditionally
		bl loop

done:	ldi -1
		bl done			# Infinite loop
