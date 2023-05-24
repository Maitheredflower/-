/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

int count_neighbor_live(Image *image, int row, int col, int count)
{
	if (image->image[row][col].R == 255 && image->image[row][col].G == 255 && image->image[row][col].B == 255)
	{
		count++;
	}
	return count;
}

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	// YOUR CODE HERE
	// 错误检测
	if (image == NULL)
	{
		printf("passed a NULL pointer");
		return NULL;
	}
	// else if (rule != 0x1808)
	// {
	// 	printf("The rule should be 0x1808");
	// }

	// 初始化Color，下一代死，故初始化为黑色(0,0,0)
	Color *next_color = malloc(sizeof(Color));
	next_color->R = 0;
	next_color->G = 0;
	next_color->B = 0;

	int neighbor_count = 0; // 活着的邻居数量
	int left_col = col - 1;
	int right_col = col + 1;
	int up_row = row - 1;
	int down_row = row + 1;

	// 确定邻居cell的位置
	if (up_row < 0)
	{
		up_row = image->rows - 1;
	}
	else if (down_row > image->rows - 1)
	{
		down_row = 0;
	}
	if (left_col < 0)
	{
		left_col = image->cols - 1;
	}
	else if (right_col > image->cols - 1)
	{
		right_col = 0;
	}
	neighbor_count = count_neighbor_live(image, up_row, left_col, neighbor_count);
	neighbor_count = count_neighbor_live(image, up_row, col, neighbor_count);
	neighbor_count = count_neighbor_live(image, up_row, right_col, neighbor_count);
	neighbor_count = count_neighbor_live(image, row, left_col, neighbor_count);
	neighbor_count = count_neighbor_live(image, row, right_col, neighbor_count);
	neighbor_count = count_neighbor_live(image, down_row, left_col, neighbor_count);
	neighbor_count = count_neighbor_live(image, down_row, col, neighbor_count);
	neighbor_count = count_neighbor_live(image, down_row, right_col, neighbor_count);

	if (image->image[row][col].R == 255 && image->image[row][col].G == 255 && image->image[row][col].B == 255)
	{
		if (neighbor_count == 2 || neighbor_count == 3)
		{
			next_color->R = 255;
			next_color->G = 255;
			next_color->B = 255;
		}
	}
	else if (image->image[row][col].R == 0 && image->image[row][col].G == 0 && image->image[row][col].B == 0)
	{
		if (neighbor_count == 3)
		{
			next_color->R = 255;
			next_color->G = 255;
			next_color->B = 255;
		}
	}

	return next_color;
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	if (image == NULL)
	{
		printf("Passed a NULL pointer");
		return NULL;
	}

	Image *next_image = malloc(sizeof(Image));
	if (next_image == NULL)
	{
		printf("Failed to allocate memory for next_image");
		return NULL;
	}

	next_image->rows = image->rows;
	next_image->cols = image->cols;

	next_image->image = malloc(sizeof(Color *) * next_image->rows);
	for (int i = 0; i < next_image->rows; i++)
	{
		next_image->image[i] = malloc(sizeof(Color) * next_image->cols);
		for (int j = 0; j < next_image->cols; j++)
		{
			Color *next_color = evaluateOneCell(image, i, j, rule);
			if (next_color == NULL)
			{
				printf("evaluateOneCell failed");
				freeImage(next_image);
				return NULL;
			}
			next_image->image[i][j].R = next_color->R;
			next_image->image[i][j].G = next_color->G;
			next_image->image[i][j].B = next_color->B;
			free(next_color);
		}
	}

	freeImage(image);
	return next_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	// YOUR CODE HERE
	char *filename;
	if (argc != 3)
	{
		printf("usage: ./gameOfLife filename rule\n");
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		// exit(-1);
	}

	filename = argv[1];
	Image *image = readData(filename);
	if (image == NULL)
	{
		freeImage(image);
		return -1;
	}
	char *end;
	uint32_t rule = strtol(argv[2], &end, 16);
	// if (0x00000 < rule || 0x3FFFF > rule)
	// {
	// 	printf("rule should between 0x00000 and 0x3FFFF\n");
	// 	freeImage(image);
	// 	return -1;
	// }
	image = life(image, rule);
	if (image == NULL)
	{
		freeImage(image);
		return -1;
	}

	writeData(image);
	freeImage(image);

	return 0;
}
