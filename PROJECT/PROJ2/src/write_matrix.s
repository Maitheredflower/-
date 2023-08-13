.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
# s0: filename    s1: matrix_pointer      s2: rows    s3: columns     s4: file_descriptor
# fopen(filename)
#  s4 = a0
# fwrite(s4, s1, 4 * s2 * s3)
# fclose(s4)
write_matrix:

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
    mv s3, a3

    #fopen
    mv a1, s0 # a1 = filename
    li a2, 1    # a2 = write_mode
    jal fopen
    li t0, -1
    beq a0, t0, exception_fopen
    mv s4, a0   # s4 = file_descriptor

    # fwrite -> rows and columns
    li a0, 8
    jal malloc
    sw s2, 0(a0)
    sw s3, 4(a0)
    mv a1, s4   # a1 = file_descriptor
    mv a2, a0   # a2 = malloc_pointer
    li a3, 2    # a3 = 2
    li a4, 4    # a4 = =sizeof(int)
    jal fwrite
    li t0, 2
    blt a0, t0, exception_fwrite


    # fwrite -> matrix
    li t0, 0
    mv t1, s2   #t1 = rows
    mv t2, s3   #t2 = columns
    mul t0, t1, t2  # t0 = rows * columns
    li t1, 4

    mv a1, s4  # a1 = file_descriptor
    mv a2, s1   # a2 = matrix_pointer
    mv a3, t0   # a3 = number of items
    mv a4, t1   # a4 = sizeof(int) = 4

    jal fwrite
    mul t0, s2, s3  # t0 = rows * columns
    blt a0, t0, exception_fwrite

    # fclose
    mv a1, s4   # a1 = file_descriptor
    jal fclose
    bne a0, x0, exception_fclose

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp) 
    addi sp, sp, 24

    ret

exception_fopen:
    li a1, 93
    jal exit2

exception_fwrite:
    # fflush
    # mv a1, s4
    # jal fflush
    # bne a0, x0, exception_fflush 
    li a1, 94
    jal exit2

exception_fclose:
    li a1, 95
    jal exit2
