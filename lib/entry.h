#ifndef ENTRY
#define ENTRY

struct entry {
	   char * code; /* field for storing the output code */
	   char * opt1; /* field for another purpose */
};

typedef struct entry entry;
 
void freeEntry(entry *);
entry * createEntry(char *, char *);

#endif