#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#ifndef HASH_TABLE_H
#define HASH_TABLE_H

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
bool check_scope(HashTable* table, const char* key);

#endif // HASH_TABLE_H

// Function to create a new hash table
HashTable* create_table() {
    HashTable* table = (HashTable*)malloc(sizeof(HashTable));
    table->capacity = INITIAL_CAPACITY;
    table->size = 0;
    table->buckets = (Node**)malloc(sizeof(Node*) * table->capacity);
    for (int i = 0; i < table->capacity; i++) {
        table->buckets[i] = NULL;
    }
    return table;
}

// Function to free a hash table
void free_table(HashTable* table) {
    for (int i = 0; i < table->capacity; i++) {
        Node* node = table->buckets[i];
        while (node) {
            Node* temp = node;
            node = node->next;
            free(temp->key);
            free(temp->value);
            free(temp);
        }
    }
    free(table->buckets);
    free(table);
}

// Hash function to calculate the index for a given key
unsigned int hash_function(const char* key, int capacity) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    }
    return hash % capacity;
}

// Function to add a key-value pair to the hash table
bool add_to_table(HashTable* table, const char* key, const char* value) {
    unsigned int index = hash_function(key, table->capacity);
    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->value = strdup(value);
    new_node->next = table->buckets[index];
    table->buckets[index] = new_node;
    table->size++;
    return true;
}

// Function to check if a key exists in the hash table
bool exists_on_table(HashTable* table, const char* key) {
    unsigned int index = hash_function(key, table->capacity);
    Node* node = table->buckets[index];
    while (node) {
        if (strcmp(node->key, key) == 0) {
            return true;
        }
        node = node->next;
    }
    return false;
}

// Function to remove a key-value pair from the hash table
bool remove_from_table(HashTable* table, const char* key) {
    unsigned int index = hash_function(key, table->capacity);
    Node* node = table->buckets[index];
    Node* prev = NULL;
    while (node) {
        if (strcmp(node->key, key) == 0) {
            if (prev) {
                prev->next = node->next;
            } else {
                table->buckets[index] = node->next;
            }
            free(node->key);
            free(node->value);
            free(node);
            table->size--;
            return true;
        }
        prev = node;
        node = node->next;
    }
    return false;
}

// Function to get the value associated with a key in the hash table
char* get_value_from_table(HashTable* table, const char* key) {
    unsigned int index = hash_function(key, table->capacity);
    Node* node = table->buckets[index];
    while (node) {
        if (strcmp(node->key, key) == 0) {
            return node->value;
        }
        node = node->next;
    }
    return NULL;
}

// Function to iterate over the hash table and apply a callback function to each key-value pair
void iterate_table(HashTable* table, void (*callback)(const char* key, const char* value)) {
    for (int i = 0; i < table->capacity; i++) {
        Node* node = table->buckets[i];
        while (node) {
            callback(node->key, node->value);
            node = node->next;
        }
    }
}

// Helper function to copy the key up to the last level
char* copy_up_to_last_level(const char* key) {
    char* copy = strdup(key);
    char* last_separator = strrchr(copy, '#');
    if (last_separator) {
        *last_separator = '\0';
    }
    return copy;
}

// Function to check if a key is in the exact scope or one level up
bool check_scope(HashTable* table, const char* key) {
    // Check exact scope
    if (exists_on_table(table, key)) {
        return true;
    }

    // Check one level up
    char* key_copy = strdup(key);
    char* last_separator = strrchr(key_copy, '#');
    if (last_separator) {
        *last_separator = '\0';
        bool exists = exists_on_table(table, key_copy);
        free(key_copy);
        return exists;
    }

    free(key_copy);
    return false;
}

// Test callback function to print key-value pairs
void print_key_value(const char* key, const char* value) {
    printf("Key: %s, Value: %s\n", key, value);
}

int main() {
    HashTable* table = create_table();

    add_to_table(table, "Z##main", "value1");
    add_to_table(table, "X##IF##main", "value2");
    add_to_table(table, "X##main", "value3");

    printf("Check Z##IF##main: %d\n", check_scope(table, "Z##IF##main")); // Expected: 1 (true)
    printf("Check Z##main: %d\n", check_scope(table, "Z##main"));         // Expected: 1 (true)
    printf("Check Z: %d\n", check_scope(table, "Z"));                     // Expected: 0 (false)
    printf("Check X##IF##main: %d\n", check_scope(table, "X##IF##main")); // Expected: 1 (true)
    printf("Check X##main: %d\n", check_scope(table, "X##main"));         // Expected: 1 (true)
    printf("Check X: %d\n", check_scope(table, "X"));                     // Expected: 0 (false)

    iterate_table(table, print_key_value);

    free_table(table);
    return 0;
}
