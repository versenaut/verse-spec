/* A minimalist Verse example. Ask server for nodes, print information.
 * Written in 2004 by Emil Brink, but in the public domain.
*/

#include <stdio.h>
#include <stdlib.h>

#include "verse.h"      /* Bring in the Verse API. */

/* A callback for connection acception: will be called when server accepts this client. */
static void callback_accept_connect(void *user, uint32 avatar, void *address, void *connection)
{
    uint32 i, mask = 0;

    printf("Connected to a Verse host!\n\nListing nodes:\n");

    /* Build node subscription mask. */
    for(i = 0; i < V_NT_NUM_TYPES; i++)
        mask |= 1 << i;
    verse_send_node_list(mask);     /* Request listing of all nodes. */
}


/* A callback for node creation: is called to report information about existing nodes, too. */
static void callback_node_create(void *user, VNodeID node_id, uint8 type, VNodeID owner_id)
{
    printf(" Node #%u has type %u\n", node_id, type);
}

int main(void)
{
    /* Register callbacks for interesting commands. */
    verse_callback_set(verse_send_connect_accept, callback_accept_connect, NULL);
    verse_callback_set(verse_send_node_create,	  callback_node_create, NULL);

    /* Kick off program by connecting to Verse host on local machine. */
    verse_send_connect("My_name", "My_password", "localhost");
    while(TRUE)
        verse_callback_update(100);   /* Listen to network, get callbacks. */

    return EXIT_SUCCESS;    /* This is never reached. */
}
