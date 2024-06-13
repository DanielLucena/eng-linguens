#include "entry.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void freeEntry(entry * e){
  if (e) {
    if (e->code != NULL) free(e->code);
	  if (e->opt1 != NULL) free(e->opt1);
    free(e);
  }
}

entry * createEntry(char * c1, char * c2){
  entry * r = (entry *) malloc(sizeof(entry));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->code = strdup(c1);
  r->opt1 = strdup(c2);

  return r;
}

