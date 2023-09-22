#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src)
{
    for (int x = 0; x < n; x++)
    {
        for (int y = 0; y < n; y++)
        {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src)
{
    // YOUR CODE HERE
    for (int x = 0; x < n; x += blocksize)
    {
        for (int y = 0; y < n; y += blocksize)
        {
            for (int i = 0; i < blocksize; i++)
            {
                for (int j = 0; j < blocksize; j++)
                {
                    if ((y + j + (x + i) * n) > (n * n) && (x + i + (y + j) * n) > (n * n))
                    {
                        break;
                    }
                    else
                    {
                        dst[y + j + (x + i) * n] = src[x + i + (y + j) * n];
                    }
                }
            }
        }
    }
}
