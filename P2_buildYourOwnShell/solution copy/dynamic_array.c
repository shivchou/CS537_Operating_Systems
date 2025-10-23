#include "dynamic_array.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/** 
* TODO: Implement all the methods with declarations in dynamic_array.h here, before proceeding with your project
*/

/**
 * create a dynamic array of the given capacity by allocating space for data
 * initialize d->size and d->capacity
 * 
 * @param size_t initCapacity - the initial capacity of the data array
 * @return a dynamic array with initCapacity space allocated on the heap for data array
 */
DynamicArray* da_create(size_t init_capacity)
{
    DynamicArray *d = malloc(sizeof(DynamicArray));

    if(!d)
    {
        fprintf(stderr, "dynamic memory allocation failed!");
        return NULL;
    }

    if(init_capacity == 0)
    {
        d->capacity = 0;
        d->data = NULL;
        d->size = 0;
        return d;
    }
    d->capacity = init_capacity;
    d->data = malloc(sizeof(char*) * d->capacity);
    if(!(d->data))
    {
        fprintf(stderr, "memory allocation for data failed!");
        fflush(stderr);
        free(d);
        return NULL;
    }
    d->size = 0;
    return d;
}


/**
 * append the given element to the end of the array of the given dynamic array
 * 
 * @param DynamicArray *da - a pointer to the dynamic array to be edited
 * @param const char* val - a pointer to the constant char array to be added to the dynamic array
*/
void da_put(DynamicArray *da, const char* val)
{
    if(!da || !val)
    {
        return;
    }

    //check size
    if(da->size >= da->capacity)
    {
        if(da->capacity == 0)
        {
            da->capacity = 1;
        }
        size_t newCap = da->capacity * 2;

        char **newData = realloc(da->data, sizeof(char*)*newCap);
        if(!newData)
        {
            fprintf(stderr, "memory allocation for resized array failed!");
            fflush(stderr);
            return;
        }
        da->data = newData;
        da->capacity = newCap;
    }
    size_t valLen = strlen(val);
    da->data[da->size] = malloc(sizeof(char) * (valLen+1));
    if(!da->data[da->size])
    {
        fprintf(stderr, "memory allocation fail!");
        fflush(stderr);
        return;
    }
    strcpy(da->data[da->size], val);
    da->size++;
}

/**
 * get the element at the given index in the given dynamic array
 * 
 * @param DynamicArray *da - a pointer to the dynamic array 
 * @param size_t ind - the index of the element being fetched
 * 
 * @return the pointer to the constant char array at the given index
 */
char *da_get(DynamicArray *da, const size_t ind)
{
    if(!da)
    {
        fprintf(stderr, "no dynamic array");
        fflush(stderr);
        return NULL;
    }
    if(ind >= da->size)
    {
        fprintf(stderr, "index out of bounds!");
        fflush(stderr);
        return NULL;
    }
    if(!(da->data[ind]))
    {
        fprintf(stderr, "dynamic array at this index is NULL!");
        fflush(stderr);
        return NULL;
    }

    return da->data[ind];
}

/**
 * delete the element at a given index in a given dynamic array, 
 * then pack the array so there are no empty spots
 * 
 * @param DynamicArray *da - a pointer to the dynamic array
 * @param size_t ind - the index of the element to be deleted
 */
void da_delete(DynamicArray *da, const size_t ind)
{
    if(!da)
    {
        fprintf(stderr, "no dynamic array");
        fflush(stderr);
        return;
    }
    if(ind >= da->size)
    {
        fprintf(stderr, "index out of bounds!");
        fflush(stderr);
        return;
    }

    free(da->data[ind]);
    
    //packing - there should be no empty spots in the middle of the array
    for(size_t i = ind; i < da->size - 1; i++)
    {
        da->data[i] = da->data[i + 1];
    }

    da->size--;
}

/**
 * print elements line after line
 * 
 * @param DynamicArray *da - a pointer to the dynamic array
 */
void da_print(DynamicArray *da)
{
    if(!da || !da->data)
    {
        fprintf(stderr, "Dynamic array or char pointer array does not exist!");
        fflush(stderr);
        return;
    }

    if(da->size == 0)
    {
        fprintf(stderr, "empty array");
        fflush(stderr);
        return;
    }
    for(size_t i = 0; i < da->size; i++)
    {
        fprintf(stdout, "%s\n", da->data[i]);
        fflush(stdout);
       // return;
    }
}

/**
 * free whole dynamic array
 * 
 * @param DynamicArray *da - a pointer to the dynamic array to be freed
 */
void da_free(DynamicArray *da)
{
    if(!da)
    {
        return;
    }

    for(size_t i = 0; i < da->size; i++)
    {
        free(da->data[i]);
    }
    free(da->data);
    free(da);

}
