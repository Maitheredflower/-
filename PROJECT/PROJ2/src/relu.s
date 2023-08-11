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
    # 检查数组长度
    addi t0, x0, 1
    bgt a1,  t0, no_exception
    li a1, 78
    j exit2 #返回error code 78    

no_exception:
    addi t0, x0, 0

loop_start:
    lw t1, 0(a0)    # t1 = a[i] t0 = i
    bge t1, x0, loop_continue
    sw x0, 0(a0) #ReLU: 负数变为0

loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4 # a0地址+4得到下一个数据的地址a[i]
    beq t0, a1, loop_end
    j loop_start

loop_end:
    # Epilogue
	ret
