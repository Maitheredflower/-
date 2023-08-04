# LAB 04

## Exercise 1: 

### MAP

1. `add t1, s0, x0` 仅仅是将`s0`的值赋给了`t1`，是算术运算操作；`lw t1, 0(s0)` 是将`s0`内存中的数据地址副给`t1`，是内存运算操作

2. ```
   lw t1, 0(s0)
   lw t2, 4(s0)        # load the size of the node's array into t2
   addi t1, t1, -4
   ```

   map函数中需要将node的*arr载入内存0(s0)，size载入4(s0)

### MapLoop

1. 

```
#     save t0, t1, t2
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    jalr s1             # call the function on that value.
    
    # store t0, t1, t2
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
```

每次跳转函数前都需要保存数据，并且在函数算完后再加载变化后的数据。

2. ```
   #     lw a1, 0(s1)        # put the address of the function back into a1 to prepare for the recursion
       mv a1, s1
   ```

   与`add t1, s0, x0` 原因类似，mv就是add的伪代码



## Exercise 2: 

```
# f takes in two arguments:
# a0 is the value we want to evaluate f at
# a1 is the address of the "output" array (defined above).
# Think: why might having a1 be useful?
f:
    # YOUR CODE GOES HERE!
    addi a0, a0, 3  # x+3
    addi t0, x0, 4 
    mul a0, a0, t0 # (x+3) *4
    add a1, a0, a1 # a1为对应数的地址
    lw a0,  0(a1)
    jr ra               # Always remember to jr ra after your function!
```

1. Think: why might having a1 be useful?

​	**a1是output的地址，通过a1可以得到正确的output数据。**

2. Hint: How do you load a word from a dynamic address?

   **以a0为基础进行加减，a0:{-3, -2, -1, 0, 1, 2, 3}，因此`[(a0+3)*4+a1]`就可以得到正确的output地址，那么再`lw a0, 0(a1)`就将正确的output数据load到a0处。**