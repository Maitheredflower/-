.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    
    #   s0: argc    s1: argv    s2: print_classification    s3: m0_pointer.rows and columns      s4: m0_pointer   
    #   s5: m1_pointer.rows and columns        s6: m1_pointer    s7: input_pointer.rows and columns      s8: input_pointer
    #   s9: (m0*input)_pointer      s10: result_pointer      s11: result_int
    #Prologue
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    li t0, 5
    bne s0, t0, argc_exception

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Load pretrained m0
    li a0, 8

    jal malloc  # allocate 8 bytes for m0.rows and m0.columns

    beq a0, x0, malloc_exception
    mv s3, a0   # s3 -> m0.rows and columns

    lw a0, 4(s1)    # a0 = m0_filename
    addi a1, s3, 0  # rows's address = address of s3 + 0
    addi a2, s3, 4  # rows's address = address of s3 + 4

    jal read_matrix

    mv s4, a0   # s4 = m0_pointer

    # Load pretrained m1
    li a0, 8

    jal malloc  # allocate 8 bytes for m1.rows and m1.columns

    beq a0, x0, malloc_exception
    mv s5, a0   # s5 -> m1.rows and columns

    lw a0, 8(s1)    # a0 = m1_filename
    addi a1, s5, 0  # rows's address = address of s5 + 0
    addi a2, s5, 4  # rows's address = address of s5 + 4

    jal read_matrix

    mv s6, a0   # s6 = m1_pointer

    # Load input matrix
    li a0, 8

    jal malloc  # allocate 8 bytes for input.rows and input.columns

    beq a0, x0, malloc_exception
    mv s7, a0   # s7 -> input.rows and columns

    lw a0, 12(s1)    # a0 = input_filename
    addi a1, s7, 0  # rows's address = address of s7 + 0
    addi a2, s7, 4  # rows's address = address of s7 + 4

    jal read_matrix

    mv s8, a0   # s8 = input_pointer


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    lw t0, 0(s3)    # (m0*input)_array.rows = m0.rows
    lw t1, 4(s7)    # (m0*input)_array.columns = input.columns
    mul t2, t0, t1
    li t0, 4
    mul t2, t2, t0
    mv a0, t2

    jal malloc

    beq a0, x0, malloc_exception
    mv s9, a0   # s6 = malloc_pointer

    mv a0, s4   # a0 = m0_pointer
    lw a1, 0(s3)    # a1 = m0.rowsm1
    lw a2, 4(s3)    # a2 = m0.columns
    mv a3, s8   # a3 = input_pointer
    lw a4, 0(s7)    # a4 = input.rows
    lw a5, 4(s7)    # a5 = input.columns
    mv a6, s9   # a6 = malloc_pointer

    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)

    mv a0, s9
    lw t0, 0(s3)    # (m0*input)_array.rows = m0.rows
    lw t1, 4(s7)    # (m0*input)_array.columns = input.columns
    mul t2, t0, t1
    mv a1, t2       # a1 = elements of matrix

    jal relu


    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 0(s5)    # result.rows = m1.rows
    lw t1, 4(s7)    # result.columns = ReLU(m0 * input).columns = input.columns
    mul t2, t0, t1
    li t0, 4
    mul t2, t2, t0
   mv a0, t2
 #   li a0, 80
    jal malloc

    beq a0, x0, malloc_exception
    mv s10, a0   # s7 = malloc_pointer

    mv a0, s6   # a0 = m1_pointer
    lw a1, 0(s5)    # a1 = m1.rows
    lw a2, 4(s5)    # a2 = m1.columns
    mv a3, s9   # a3 = ReLU(m0 * input)_pointer
    lw a4, 0(s3)    # a4 = ReLU(m0 * input).rows
    lw a5, 4(s7)    # a5 = ReLU(m0 * input).columns
    mv a6, s10  # a6 = malloc_pointer

    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)   # a0 = output_filename
    mv a1, s10   # a1 = result_pointer
    lw a2, 0(s5)    # result.rows = m1.rows
    lw a3, 4(s7)    # result.columns = ReLU(m0 * input).columns = input.columns

    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s10      # a0 = result_pointer
    li a1, 10

    jal argmax

    mv s11, a0  # s11 = result_int

    # Print classification
    bne s2, x0, finish
    mv a1, s11   # a1 =result_int
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52

    ret

finish: 
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    ret


malloc_exception:
    li a1, 88
    jal exit2

argc_exception:
    li a1, 89
    jal exit2
