#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list_string.h"

StringList* create_string_list() {
    StringList* list = (StringList*)malloc(sizeof(StringList));
    list->size = 0;
    list->capacity = INITIAL_CAPACITY;
    list->items = (char**)malloc(sizeof(char*) * list->capacity);
    return list;
}

void free_string_list(StringList* list) {
    for (int i = 0; i < list->size; i++) {
        free(list->items[i]);
    }
    free(list->items);
    free(list);
}

void resize_string_list(StringList* list) {
    list->capacity *= 2;
    list->items = (char**)realloc(list->items, sizeof(char*) * list->capacity);
}

bool add_string(StringList* list, const char* str) {
    if (list->size >= list->capacity) {
        resize_string_list(list);
    }
    list->items[list->size] = strdup(str);
    list->size++;
    return true;
}

bool remove_string(StringList* list, const char* str) {
    for (int i = 0; i < list->size; i++) {
        if (strcmp(list->items[i], str) == 0) {
            free(list->items[i]);
            for (int j = i; j < list->size - 1; j++) {
                list->items[j] = list->items[j + 1];
            }
            list->size--;
            return true;
        }
    }
    return false;
}

bool exists_string(StringList* list, const char* str) {
    for (int i = 0; i < list->size; i++) {
        if (strcmp(list->items[i], str) == 0) {
            return true;
        }
    }
    return false;
}

char* get_string(StringList* list, int index) {
    if (index < 0 || index >= list->size) {
        return NULL;
    }
    return strdup(list->items[index]);
}
