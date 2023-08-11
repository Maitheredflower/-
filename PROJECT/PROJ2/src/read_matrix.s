.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
# s0: file_path    s1: rows    s2: columns     s3: file_descriptor    s4: malloc_pointer 
read_matrix:
    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen
    li a2, 0    # a2 = read_mode
    mv a1, s0 # a1 = filepath
    jal fopen
    mv s3, a0 #store file descriptor into s3
    li t0, -1
    beq a0, t0, exception_fopen

    # fread -> rows
    mv a1, s3   # a1 = file_descriptor
    mv a2, s1   # a2 = rows_pointer
    li a3, 4    # read 4 bytes(rows)
    jal fread
    li t0, 4
    bne a0, t0, exception_fread

    # fread -> columns
    mv a1, s3   # a1 = file_descriptor
    mv a2, s2   # a2 = rows_pointer
    li a3, 4    # read 4 bytes(columns)
    jal fread
    li t0, 4
    bne a0, t0, exception_fread

    # malloc
    lw t1, 0(s1) # t1 = rows
    lw t2, 0(s2) # t2 = columns
    mul t0, t1, t2  # t0 = rows * columns
    li t3, 4
    mul t0, t0, t3 # t0 = sizeof(int) * (rows * columns)
    mv a0, t0
    addi sp, sp, -4
    sw t0, 0(sp)
    jal malloc
    beq a0, x0, exception_malloc
    mv s4, a0
    lw t0, 0(sp)
    addi sp, sp, 4 

    # fread ->matrix
    mv a1, s3   # a1 = file_descriptor
    mv a2, s4   # a2 = malloc_pointer
    mv a3, t0    # read m * n bytes
    addi sp, sp, -4
    sw t0, 0(sp)
    jal fread
    lw t0, 0(sp)
    addi sp, sp, 4 
    bne a0, t0, exception_fread

    #fclose
    mv a1, s3   # a1 = file_descriptor
    jal fclose
    bne a0, x0, exception_fclose

    # Epilogue
    jal free
    mv a0, s4 # a0 = malloc_pointer
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp) 
    addi sp, sp, 24
    ret

exception_malloc:
    li a1, 88
    jal exit2

exception_fopen:
    li a1, 90
    jal exit2

exception_fread:
    li a1, 91
    jal exit2

exception_fclose:
    li a1, 92
    jal exit2