#include <stddef.h>
#include <stdio.h>
#include "ll_cycle.h"

// Start with two pointers at the head of the list. We’ll call the first one tortoise and the second one hare.
// Advance hare by two nodes. If this is not possible because of a null pointer, we have found the end of the list, and therefore the list is acyclic.
// Advance tortoise by one node. (A null pointer check is unnecessary. Why?)
// If tortoise and hare point to the same node, the list is cyclic. Otherwise, go back to step 2.
int ll_has_cycle(node *head)
{
    /* your code here */
    node *tortoise;
    node *hare;
    tortoise = head;
    hare = head;
    if (head == NULL)
    {
        return 0;
    }
    while (1)
    {
        hare = hare->next;
        if (hare == NULL)
        {
            return 0;
        }
        hare = hare->next;
        if (hare == NULL)
        {
            return 0;
        }
        tortoise = tortoise->next;
        if (hare == tortoise)
        {
            return 1;
        }
    }
}