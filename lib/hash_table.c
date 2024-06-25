#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "hash_table.h"

unsigned int hash(const char* key, int capacity) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash % capacity;
}

HashTable* create_table() {
    HashTable* table = (HashTable*)malloc(sizeof(HashTable));
    table->size = 0;
    table->capacity = INITIAL_CAPACITY;
    table->buckets = (Node**)calloc(table->capacity, sizeof(Node*));
    return table;
}

void free_node(Node* node) {
    free(node->key);
    free(node->value);
    free(node);
}

void free_table(HashTable* table) {
    for (int i = 0; i < table->capacity; i++) {
        Node* node = table->buckets[i];
        while (node) {
            Node* temp = node;
            node = node->next;
            free_node(temp);
        }
    }
    free(table->buckets);
    free(table);
}

void resize_table(HashTable* table) {
    int old_capacity = table->capacity;
    table->capacity *= 2;
    Node** new_buckets = (Node**)calloc(table->capacity, sizeof(Node*));

    for (int i = 0; i < old_capacity; i++) {
        Node* node = table->buckets[i];
        while (node) {
            Node* next = node->next;
            unsigned int index = hash(node->key, table->capacity);
            node->next = new_buckets[index];
            new_buckets[index] = node;
            node = next;
        }
    }

    free(table->buckets);
    table->buckets = new_buckets;
}

// Adição de uma nova entrada na tabela de hash
bool add_to_table(HashTable* table, const char* key, const char* value) {
    if ((double)table->size / table->capacity >= 0.75) {
        resize_table(table);
    }

    unsigned int index = hash(key, table->capacity);
    Node* node = table->buckets[index];

    while (node) {
        if (strcmp(node->key, key) == 0) {
            free(node->value);
            node->value = strdup(value);
            return true;
        }
        node = node->next;
    }

    node = (Node*)malloc(sizeof(Node));
    node->key = strdup(key);
    node->value = strdup(value);
    node->next = table->buckets[index];
    table->buckets[index] = node;
    table->size++;
    return true;
}

bool remove_from_table(HashTable* table, const char* key) {
    unsigned int index = hash(key, table->capacity);
    Node* node = table->buckets[index];
    Node* prev = NULL;

    while (node) {
        if (strcmp(node->key, key) == 0) {
            if (prev) {
                prev->next = node->next;
            } else {
                table->buckets[index] = node->next;
            }
            free_node(node);
            table->size--;
            return true;
        }
        prev = node;
        node = node->next;
    }
    return false;
}

bool exists_on_table(HashTable* table, const char* key) {
    unsigned int index = hash(key, table->capacity);
    Node* node = table->buckets[index];

    while (node) {
        if (strcmp(node->key, key) == 0) {
            return true;
        }
        node = node->next;
    }
    return false;
}

char* get_value_from_table(HashTable* table, const char* key) {
    unsigned int index = hash(key, table->capacity);
    Node* node = table->buckets[index];
    while (node) {
        if (strcmp(node->key, key) == 0) {
            return strdup(node->value);
        }
        node = node->next;
    }
    return NULL;
}

void iterate_table(HashTable* table, void (*callback)(const char* key, const char* value)) {
    for (int i = 0; i < table->capacity; i++) {
        Node* node = table->buckets[i];
        while (node) {
            callback(node->key, node->value);
            node = node->next;
        }
    }
}

// Função auxiliar para buscar a chave
bool check_scope_recursive(HashTable* table, const char* key, char** found_key) {
    if (exists_on_table(table, key)) {
        *found_key = strdup(key);
        return true;
    }

    char* last_separator = strrchr(key, '#');
    if (last_separator) {
        size_t length = last_separator - key;
        char* higher_level_key = (char*)malloc(length + 1);
        strncpy(higher_level_key, key, length);
        higher_level_key[length] = '\0';

        bool result = check_scope_recursive(table, higher_level_key, found_key);
        free(higher_level_key);
        return result;
    }

    return false;
}

// Função principal para buscar a chave e retornar a chave encontrada
bool check_scope(HashTable* table, const char* key, char** found_key) {
    return check_scope_recursive(table, key, found_key);
}