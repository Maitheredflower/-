.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    mv t1, a1
    mv t2, a2
    mv t4, a4
    mv t5, a5
    addi t6, x0, 1
    # Error checks
    blt t1, t6, m0_exception # row_m0 < 1
    blt t2, t6, m0_exception # col_m0 < 1

    blt t4, t6, m1_exception # row_m1 < 1
    blt t5, t6, m1_exception # col_m1 < 1

    # don't match
    bne t2, t4, Nmatch_exception

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp) 
    sw s6, 24(sp)
    sw ra, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    addi t0, x0, 0 # i =0


outer_loop_start:
    # make k = 0
    addi t1, x0, 0

inner_loop_start:
    # prepare for dot.s
    mv a0, s0
    li t2, 4
    mul t2, t2, t1
    add a1, s3, t2
    mv a2, s2
    li a3, 1
    mv a4, s5

    addi sp, sp, -8
    sw t0, 0(sp) #store i
    sw t1, 4(sp) #store k

    jal dot

    sw a0, 0(s6) #store result into vector d
    addi s6, s6, 4

    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    addi t1, t1, 1 # k++
    blt t1, s5, inner_loop_start

inner_loop_end:
    li t2, 4
    mul t2, t2, s2
    add s0, s0, t2
    addi t0, t0, 1  # i++
    blt t0, s1, outer_loop_start

outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp) 
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret

m0_exception:
    li a1, 72
    j exit2

m1_exception:
    li a1, 73
    j exit2

Nmatch_exception:
    li a1, 74
    j exit2