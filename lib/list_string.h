#ifndef LIST_STRING_H
#define LIST_STRING_H

#include <stdbool.h>

#define INITIAL_CAPACITY 10

typedef struct {
    char **items;
    int size;
    int capacity;
} StringList;

StringList* create_string_list();
void free_string_list(StringList* list);
bool add_string(StringList* list, const char* str);
bool remove_string(StringList* list, const char* str);
bool exists_string(StringList* list, const char* str);
char* get_string(StringList* list, int index);

#endif // LIST_STRINGS_H