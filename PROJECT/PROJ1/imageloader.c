/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
	// YOUR CODE HERE

	// Initialize
	Image *_Image = malloc(sizeof(Image));
	if (_Image == NULL) // 错误处理
	{
		printf("内存分配失败");
		return NULL;
	}

	// open file
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) // 错误处理
	{
		printf("无法打开文件");
		return NULL;
	}

	// read file
	char formate[2];
	int formate_max;
	fscanf(fp, "%c%c", &formate[0], &formate[1]);
	fscanf(fp, "%u", &_Image->cols);
	fscanf(fp, "%u", &_Image->rows);
	fscanf(fp, "%d", &formate_max);
	// 按照行列数进行读取，每次读取一个像素(Color)
	_Image->image = malloc(sizeof(Color *) * _Image->rows); // 重新动态分配内存
	for (int i = 0; i < _Image->rows; i++)
	{
		_Image->image[i] = malloc(sizeof(Color) * _Image->cols); // 重新动态分配内存
		for (int j = 0; j < _Image->cols; j++)
		{
			fscanf(fp, "%hhd %hhd %hhd", &_Image->image[i][j].R, &_Image->image[i][j].G, &_Image->image[i][j].B);
		}
	}

	// close file
	fclose(fp);

	return _Image;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	// YOUR CODE HERE
	if (image == NULL)
	{
		printf("传入一个空指针");
		freeImage(image);
	}
	else
	{
		printf("P3\n");
		printf("%d %d\n", image->cols, image->rows);
		printf("255\n");
		// 按照行列数进行输出，每次输出一个像素(Color)
		for (int i = 0; i < image->cols; i++)
		{
			for (int j = 0; j < image->rows; j++)
			{
				if (j == 0)
				{
					printf("%3u %3u %3u", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
				}
				else
				{
					printf("   %3u %3u %3u", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
				}
			}
			printf("\n");
		}
	}
}

// Frees an image
void freeImage(Image *image)
{
	// YOUR CODE HERE
	if (image != NULL)
	{
		// 需要将所有指针资源都释放掉
		for (int i = 0; i < image->cols; i++)
		{
			free(image->image[i]);
		}
		free(image->image);
		free(image);
	}
}