/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	// YOUR CODE HERE
	Color *color = malloc(sizeof(Color));
	if (color == NULL)
	{
		printf("内存分配失败");
		return NULL;
	}
	color->R = image->image[row][col].R;
	color->G = image->image[row][col].G;
	color->B = image->image[row][col].B;
	return color;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	// YOUR CODE HERE
	if (image == NULL)
	{
		printf("passed a NULL pointer");
		return NULL;
	}
	for (int i = 0; i < image->rows; i++)
	{
		for (int j = 0; j < image->cols; j++)
		{
			Color *color = evaluateOnePixel(image, i, j);
			if (color == NULL)
			{
				free(color);
				printf("evaluateOnePixel failed");
				return NULL;
			}
			uint8_t blue = color->B;
			uint8_t pixel = blue & 1;
			if (pixel == 1)
			{
				image->image[i][j].R = 255;
				image->image[i][j].G = 255;
				image->image[i][j].B = 255;
			}
			else
			{
				image->image[i][j].R = 0;
				image->image[i][j].G = 0;
				image->image[i][j].B = 0;
			}
			free(color);
		}
	}
	return image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	// YOUR CODE HERE
	char *filename;
	if (argc != 2)
	{
		printf("usage: %s filename\n", argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		exit(-1);
	}
	filename = argv[1];
	Image *image = readData(filename);
	if (image == NULL)
	{
		freeImage(image);
		return -1;
	}
	image = steganography(image);
	if (image == NULL)
	{
		freeImage(image);
		return -1;
	}
	writeData(image);

	freeImage(image);
}
