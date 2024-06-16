#ifndef ENTRY
#define ENTRY

struct entry {
	   char * code;
	   char * type;
};

typedef struct entry entry;
 
void free_entry(entry *);
entry * create_entry(char *, char *);

#endif