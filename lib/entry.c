#include "entry.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void free_entry(entry * e){
  if (e) {
    if (e->code != NULL) free(e->code);
	  if (e->type != NULL) free(e->type);
    free(e);
  }
}

entry * create_entry(char * c1, char * c2){
  entry * r = (entry *) malloc(sizeof(entry));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->code = strdup(c1);
  r->type = strdup(c2);

  return r;
}

