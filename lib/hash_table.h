#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stdbool.h>

#define INITIAL_CAPACITY 10

typedef struct Node {
    char* key;
    char* value;
    struct Node* next;
} Node;

typedef struct {
    Node** buckets;
    int size;
    int capacity;
} HashTable;

HashTable* create_table();
void free_table(HashTable* table);
bool add_to_table(HashTable* table, const char* key, const char* value);
bool remove_from_table(HashTable* table, const char* key);
bool exists_on_table(HashTable* table, const char* key);
char* get_value_from_table(HashTable* table, const char* key);
void iterate_table(HashTable* table, void (*callback)(const char* key, const char* value));
bool check_scope(HashTable* table, const char* key, char** found_key);

#endif // HASH_TABLE_H
