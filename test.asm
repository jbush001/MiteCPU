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
		add count		# result = result + count
		st result

		ldi -1
		add count		
		st count		# count = count - 1
		ble done
		ldi 0			# Branch unconditionally
		ble loop

done:	ldi 0
		ble done		# Infinite loop
