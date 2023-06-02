# exe1
1. What do the .data, .word, .text directives mean (i.e. what do you use them for)? Hint: think about the 4 sections of memory.
2. Run the program to completion. What number did the program output? What does this number represent?
3. At what address is n stored in memory? Hint: Look at the contents of the registers.
4. Without actually editing the code (i.e. without going into the “Editor” tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the “Display Settings” option at the bottom.


Answer:
1. .data指令用于定义数据段，.word指令用于定义数据，而.text指令用于定义代码段。
2.  34，共进行了9次斐波那其运算，取第九次运算的t0并输出。
3.  0x00000008的高两位。
4.   更改t3(x28):0x00000009为0x0000000D。

# exe2
1. The register representing the variable k.
2. The register representing the variable sum.
3. The registers acting as pointers to the source and dest arrays.
4. The assembly code for the loop found in the C code.
5. How the pointers are manipulated in the assembly code.

Answer:
1. t0
2. s0
3. source: t1   dest: t3
4.  loop:
```C
for (k = 0; source[k] != 0; k++) {
        dest[k] = fun(source[k]);
        sum += dest[k];
    }
```
5.  汇编代码通过addi：增加立即数的方式完成指针的变换

## exe4
1. What caused the errors in simple_fn, naive_pow, and inc_arr that were reported by the Venus CC checker?
2. In RISC-V, we call functions by jumping to them and storing the return address in the ra register. Does calling convention apply to the jumps to the naive_pow_loop or naive_pow_end labels?
3. Why do we need to store ra in the prologue for inc_arr, but not in any other function?
4. Why wasn’t the calling convention error in helper_fn reported by the CC checker? (Hint: it’s mentioned above in the exercise instructions.)

Answer:
1. - t0未被初始化
    -  s0是已保存的寄存器，对他进行修改前必须先将其保存到另一个寄存器中
    -  需要保存s0和s1
2. 否，对于同一函数内部的标签跳转（如naive_pow_loop或naive_pow_end），不会应用调用约定。这些标签仅用于函数内部的控制流，不是函数调用。在这种情况下，不需要在ra寄存器中保存或恢复返回地址，因为没有必要返回到特定的调用者。
3. 对于inc_arr函数，它可能在函数体内修改了ra寄存器或者执行了函数调用操作。为了保证返回地址的正确性，需要在前导部分将ra保存到栈中，在后导部分（epilogue）从栈中恢复ra的值。其他函数可能不需要保存ra寄存器，因为它们要么不修改ra寄存器，要么不执行任何会改变返回地址的函数调用。具体是否需要保存ra寄存器取决于每个函数的具体实现和需求。在前导部分保存ra寄存器是一种良好的编程实践，可以确保正确的控制流，并避免返回函数时出现意外问题。
4. 它只会查找使用 .globl 指令导出的函数中的错误