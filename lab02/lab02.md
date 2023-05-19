# Lab 02

## exercise 01 位运算

1. 

```c
unsigned get_bit(unsigned x, unsigned n)
```

获取x的第n位的数据：

- 让x右移n位，将要提取的数据保持在最低位

- 将右移后的数据和1(00000...0001)进行与(&)操作，即可获得第n位的数据

2. 

```c
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

```c
void flip_bit(unsigned *x,unsigned n)
```

翻转x的第n位的数据：

- 将1左移n位 value = 1 << n;

- x与value进行异或(^)操作;



# exercise 02 线性反馈移位寄存器

![LFSR 图](https://inst.eecs.berkeley.edu/~cs61c/fa20/labs/lab02/LFSR-F18.gif)

可以用到exercise 01中的函数

- On each call to `lfsr_calculate`, you will shift the contents of the register 1 bit to the right.

  ```c
  reg >> 1
  ```

  

- This shift is neither a logical shift or an arithmetic shift. On the left side, you will shift in a single bit equal to the Exclusive Or (XOR) of the bits originally in position 0, 2, 3, and 5.

  ```c
  value = v0 ^ v2 ^ v3 ^ v5;
  set_bit(reg, 15, value)
  ```

  

- The curved head-light shaped object is an XOR, which takes two inputs (a, b) and outputs a^b.

- If you implemented `lfsr_calculate()` correctly, it should output all 65535 positive 16-bit integers before cycling back to the starting number.

- Note that the leftmost bit is the MSB and the rightmost bit is the LSB.



## excerise 03 内存管理

### `vector.h`、`vector-test.c`和`vector.c`，

```c
vector_t *vector_new()
```

与`bad_vector_new()`和`also_bad_vector_new()`相比，正确的`vector_new()`使用了指针作为返回类型，并对结构体vector_t使用了动态分配的内存；判断当retval->data == NULL时将retval结构体指针进行释放。

1. `bad_vector_new()` 函数返回指向**栈上局部变量**的指针 `retval`，这是不安全的。在函数结束后，`retval` 指向的内存会被释放，因此返回指向栈上的指针将导致未定义行为。调用该函数后，返回的指针将指向无效的内存区域，访问该指针将导致错误。
2. `also_bad_vector_new()` 函数直接返回**结构体** `vector_t`，而不是返回指向堆上分配的结构体的指针。这意味着在函数结束后，返回的**结构体将不再存在**，因此返回的结构体将是无效的。类似于 `bad_vector_new()`，这样的实现会导致错误和未定义行为。
3. 两个函数在动态分配内存时没有进行**错误检查**。如果内存分配失败，它们没有正确处理错误情况，也没有释放先前分配的内存，导致内存泄漏。

相比之下，`vector_new()` 函数是一个更好的实现方式。它正确地在**堆**上分配了结构体和数据数组，并进行了错误检查。如果内存分配失败，它会适当处理错误并释放先前分配的内存，避免了内存泄漏和未定义行为。



```c
void vector_delete(vector_t *v)
```

释放资源函数需要注意，资源指的是指针，所有类型的指针都应该被释放，包括结构体指针(`vector_t *`)以及结构体内部的指针(`int * data`)。



```c
void vector_set(vector_t *v, size_t loc, int value)
```

需要注意当`loc > v->size`时需要动态分配内存，用relloc函数，且注意分配的内存空间大小是`(loc + 1) * sizeof(int)`，并且将新分配的内存data**初始化为0**；



### MakeFile部分

make时提前设置好makefile将更方便，例如想要make vector-test，先将需要用到的文件设置好

```makefile
VECTOR_OBJS=vector.o vector-test.o
VECTOR_PROG= vector-test 
```

`VECTOR_OBJS`是要编译链接的.o文件

`VECTOR_PROG`是生成的程序名称

```makefile
$(VECTOR_PROG): $(VECTOR_OBJS)
	$(CC) $(CFLAGS) -g -o $(VECTOR_PROG) $(VECTOR_OBJS) $(LDFLAGS)
```

☝上面是完整的make语句
