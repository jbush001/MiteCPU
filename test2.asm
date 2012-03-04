#
# Sum the digits 1-8
#

res result
res count
res buffer, 8
res ptr

start:		ldi 8
		st count
		ldi buffer
		st ptr

loop:		ldi 0
		add count
		index ptr
		st 0

		ldi 1
		add ptr
		st ptr		

		ldi -1
		add count
		st count
		bl done
		
		ldi -1			# Branch unconditionally
		bl loop

done:	ldi -1
		bl done			# Infinite loop
