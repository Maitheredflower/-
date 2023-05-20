/* Include the system headers we need */
#include <stdlib.h>
#include <stdio.h>

/* Include our header */
#include "vector.h"

/* Define what our struct is */
struct vector_t
{
    size_t size;
    int *data;
};

/* Utility function to handle allocation failures. In this
   case we print a message and exit. */
static void allocation_failed()
{
    fprintf(stderr, "Out of memory.\n");
    exit(1);
}

/* Bad example of how to create a new vector */
vector_t *bad_vector_new()
{
    /* Create the vector and a pointer to it */
    vector_t *retval, v;
    retval = &v;
    // 没有给retval动态分配内存

    /* Initialize attributes */
    retval->size = 1;
    retval->data = malloc(sizeof(int));
    if (retval->data == NULL)
    {
        // 没有将retval资源释放
        allocation_failed();
    }

    retval->data[0] = 0;
    return retval;
}

/* Another suboptimal way of creating a vector */
vector_t also_bad_vector_new()
{
    /* Create the vector */
    vector_t v;

    /* Initialize attributes */
    v.size = 1;
    v.data = malloc(sizeof(int));
    if (v.data == NULL)
    {
        // 没有将retval资源释放
        allocation_failed();
    }
    v.data[0] = 0;
    return v;
}

/* Create a new vector with a size (length) of 1
   and set its single component to zero... the
   RIGHT WAY */
vector_t *vector_new()
{
    /* Declare what this function will return */
    vector_t *retval;

    /* First, we need to allocate memory on the heap for the struct */
    retval = malloc(sizeof(vector_t));

    /* Check our return value to make sure we got memory */
    if (retval == NULL)
    {
        allocation_failed();
    }

    /* Now we need to initialize our data.
       Since retval->data should be able to dynamically grow,
       what do you need to do? */
    retval->size = 1;
    retval->data = malloc(sizeof(int) * retval->size);

    /* Check the data attribute of our vector to make sure we got memory */
    if (retval->data == NULL)
    {
        free(retval); // Why is this line necessary?
        allocation_failed();
    }

    /* Complete the initialization by setting the single component to zero */
    retval->data[0] = 0;

    /* and return... */
    return retval;
}

/* Return the value at the specified location/component "loc" of the vector */
int vector_get(vector_t *v, size_t loc)
{

    /* If we are passed a NULL pointer for our vector, complain about it and exit. */
    if (v == NULL)
    {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        abort();
    }

    /* If the requested location is higher than we have allocated, return 0.
     * Otherwise, return what is in the passed location.
     */
    // printf("loc:%lx\n", loc);
    // printf("v->size:%lx\n", v->size);
    if (loc < v->size)
    {
        // printf("v->data:%ls\n", v->data);
        return v->data[loc];
    }
    else
    {
        return 0;
    }
}

/* Free up the memory allocated for the passed vector.
   Remember, you need to free up ALL the memory that was allocated. */
void vector_delete(vector_t *v)
{
    // 释放掉所有指针（包括vector_t和内部的int * data）
    free(v->data);
    free(v);
}

/* Set a value in the vector. If the extra memory allocation fails, call
   allocation_failed(). */
void vector_set(vector_t *v, size_t loc, int value)
{
    /* What do you need to do if the location is greater than the size we have
     * allocated?  Remember that unset locations should contain a value of 0.
     */

    /* YOUR SOLUTION HERE */
    if (v == NULL)
    {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        abort();
    }

    if (loc < v->size)
    {
        v->data[loc] = value;
    }
    else
    {
        // loc > v->size
        // 增加retval->size
        size_t befor_size = v->size;
        v->size = loc + 1;
        v->data = realloc(v->data, v->size * (sizeof(int))); // 需要再次动态分配否则可能会出现内存泄漏
        for (size_t i = befor_size; i < v->size - 1; i++)
        {
            v->data[i] = 0; // 将新增加的数据设置为0
        }
        v->data[loc] = value;
    }
}