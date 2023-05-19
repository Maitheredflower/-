# Lab 02

## exercise 01

1. 

```c++
unsigned get_bit(unsigned x, unsigned n)
```

获取x的第n位的数据：

- 让x右移n位，将要提取的数据保持在最低位

- 将右移后的数据和1(00000...0001)进行与(&)操作，即可获得第n位的数据

2. 

```c++
void set_bit(unsigned *x,unsigned n, unsigned v)
```

设置x的第n位的数据：

| 0    | 0    | 0    |
| ---- | ---- | ---- |
| 0    | 1    | 1    |
| 1    | 0    | 0    |
| 1    | 1    | 1    |



- 将x的第n位设为0
- 让v左移n位，将要设置的数据与n对齐

- 将左移后的数据n进行异或(^)操作

3. 

```c++
void flip_bit(unsigned *x,unsigned n)
```

翻转x的第n位的数据：

- 将1左移n位 value = 1 << n;

- x与value进行异或(^)操作;



# exercise 02

![LFSR 图](https://inst.eecs.berkeley.edu/~cs61c/fa20/labs/lab02/LFSR-F18.gif)

可以用到exercise 01中的函数

- On each call to `lfsr_calculate`, you will shift the contents of the register 1 bit to the right.

  ```c++
  reg >> 1
  ```

  

- This shift is neither a logical shift or an arithmetic shift. On the left side, you will shift in a single bit equal to the Exclusive Or (XOR) of the bits originally in position 0, 2, 3, and 5.

  ```c++
  value = (v0 ^ v2) ^ v3 ^ v5;
  set_bit(reg, 15, value)
  ```

  

- The curved head-light shaped object is an XOR, which takes two inputs (a, b) and outputs a^b.

- If you implemented `lfsr_calculate()` correctly, it should output all 65535 positive 16-bit integers before cycling back to the starting number.

- Note that the leftmost bit is the MSB and the rightmost bit is the LSB.
