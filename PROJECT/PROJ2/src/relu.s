.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    # 检查数组长度
    sltiu s0, a1, 1
    bnez s0, exception

    li s0, 0

loop_start:
    beq s0, a1, loop_end
    sll t0, s0, 2
    add t1, a0, t0
    lw t1, 0(t0)
    

exception:

    







loop_continue:



loop_end:


    # Epilogue

    
	ret
