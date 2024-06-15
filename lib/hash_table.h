#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stdbool.h>

#define INITIAL_SIZE 100

typedef struct {
    char* key;
    char* value;
} HashNode;

typedef struct {
    HashNode** nodes;
    int size;
    int count;
} HashTable;

HashTable* create_table();
void free_table(HashTable* table);
bool add_entry(HashTable* table, const char* key, const char* value);
bool remove_entry(HashTable* table, const char* key);
bool exists_entry(HashTable* table, const char* key);
char* get_value(HashTable* table, const char* key);

#endif
