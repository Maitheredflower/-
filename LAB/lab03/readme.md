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