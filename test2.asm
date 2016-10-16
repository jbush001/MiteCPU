#
# Store values into a memory array
#

res result
res count
res buffer, 8
res ptr

start:  ldi 8
        st count
        ldi buffer
        st ptr

loop:   ldi 0       # Clear accumulator
        add count   # Copy count into accumulator
        index ptr   # Load destination pointer
        st 0        # Store count into destination pointer

        ldi 1
        add ptr
        st ptr      # Increment pointer

        ldi -1
        add count   # Decrement count
        st count    # Update count
        bl done     # Finished?  if so, branch out

        ldi -1      # Branch unconditionally
        bl loop     # loop again

done:   ldi -1
        bl done     # Infinite loop
