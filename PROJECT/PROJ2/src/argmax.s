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
# s0: a[i]  s1: i s2: max
# =================================================================
argmax:
    # Prologue
    # determine the length of the array
    addi t0, x0, 1
    bge a1, t0, no_exception
    li a1, 77 #error_code: 77
    j exit2

no_exception:
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    mv s0, a0
    mv s1, a1
    addi s2, x0, 0
    lw t0, 0(s0)
    li t2, 0 

loop_start:
    addi t2, t2, 1
    beq t2, s1, loop_end
    addi s0, s0, 4
    lw t1, 0(s0)
    ble t1, t0, loop_continue   #比大小
    mv s2, t2
    mv t0, t1
    j loop_start


loop_continue:
    j loop_start

loop_end:
    # Epilogue
    mv a0, s2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret
