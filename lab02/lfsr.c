#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

// 1.On each call to lfsr_calculate, you will shift the contents of the register 1 bit to the right.
// 2.This shift is neither a logical shift or an arithmetic shift. On the left side, you will shift in a single bit equal to the Exclusive Or (XOR) of the bits originally in position 0, 2, 3, and 5.
// 3.The curved head-light shaped object is an XOR, which takes two inputs (a, b) and outputs a^b.
// 4.If you implemented lfsr_calculate() correctly, it should output all 65535 positive 16-bit integers before cycling back to the starting number.
// 5.Note that the leftmost bit is the MSB and the rightmost bit is the LSB.
void lfsr_calculate(uint16_t *reg)
{
    /* YOUR CODE HERE */
    uint16_t v0, v2, v3, v5;
    v0 = get_bit(*reg, 0);
    v2 = get_bit(*reg, 2);
    v3 = get_bit(*reg, 3);
    v5 = get_bit(*reg, 5);
    uint16_t value = v0 ^ v2 ^ v3 ^ v5;
    // printf("v0 = %x,v2 = %x,v3 = %x,v5 = %x,value = %x\n", v0, v2, v3, v5, value);
    *reg = *reg >> 1;        // 先右移一位
    set_bit(reg, 15, value); // 再将最高位设置为value
}

uint16_t get_bit(uint16_t reg, int n)
{
    return (reg >> n) & 1;
}

void set_bit(uint16_t *reg, int n, uint16_t value)
{
    uint16_t mask = 1 << n;
    *reg = (*reg & ~mask) | (value << n);
}
