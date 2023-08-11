.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# s0: a[i]  s1: i t2: max
# =================================================================
argmax:
    # Prologue
    # determine the length of the array
    addi t1, x0, 1
    bge a1, t1, no_exception
    li a1, 77 #error_code: 77
    j exit2

no_exception:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    addi s1, x0, 0
    lw s0, 0(a0)

loop_start:
    addi t1, t1, 1
    addi a0, a0, 4
    bgt t1, a1, loop_end
    lw t0, 0(a0)
    ble t0, s0, loop_continue   #比大小
    mv s0, t0
    mv s1, t1


loop_continue:
    j loop_start

loop_end:
    # Epilogue
    mv a0, s1
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret
