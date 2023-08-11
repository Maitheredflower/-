.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================

# s0: a[i]      s1: b[i]        s2: result      s3: a_i     s4: b_i
# t0: result_temp     t1: i of a      t2: i of b        t3: a[i]_temp       t4: b[i]_temp 
dot:
    # determine the length of array
    addi t3, x0, 1
    blt a2, t3, exception_array

    # determine the stride of vector
    blt a3, t3, exception_stride
    blt a4, t3, exception_stride
    
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp) # address of a
    sw s2, 8(sp) # address of b
    sw s3, 12(sp) # i of a
    sw s4, 16(sp) # i of b

    addi s0, x0, 0
    addi s1, x0, 0
    addi s2, x0, 0
    addi s3, x0, 0
    addi s4, x0, 0

loop_start:
    lw t3, 0(a0)
    lw t4, 0(a1)
    mul t0, t3, t4
    add s0, s0, t0
    addi t5, x0, 4
    mul t1, a3, t5
    mul t2, a4, t5
    add s1, x0, t1     #i_a += stride_a
    add s2, x0, t2     #i_b += stride_b
    add s3, s3, a3
    add s4, s4, a4
    beq s3, a2, loop_end
    # beq s4, a2, loop_end
    add a0, a0, s1     #get the address of a[i]
    add a1, a1, s2     #get the address of b[i]

    j loop_start

loop_end:
    mv a0, s0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

    # Epilogue
    ret

exception_array:
    li a1, 75
    j exit2

exception_stride:
    li a1, 76
    j exit2