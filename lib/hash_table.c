#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash_table.h"

unsigned int hash(const char *key, int size)
{
    unsigned long int value = 0;
    unsigned int i = 0;
    unsigned int key_len = strlen(key);

    for (; i < key_len; ++i)
    {
        value = value * 37 + key[i];
    }

    return value % size;
}

HashTable *create_table()
{
    HashTable *table = (HashTable *)malloc(sizeof(HashTable));
    table->size = INITIAL_SIZE;
    table->count = 0;
    table->nodes = (HashNode **)malloc(sizeof(HashNode *) * table->size);

    for (int i = 0; i < table->size; i++)
    {
        table->nodes[i] = NULL;
    }

    return table;
}

void free_table(HashTable *table)
{
    for (int i = 0; i < table->size; i++)
    {
        if (table->nodes[i] != NULL)
        {
            free(table->nodes[i]->key);
            free(table->nodes[i]->value);
            free(table->nodes[i]);
        }
    }

    free(table->nodes);
    free(table);
}

void resize_table(HashTable *table)
{
    int old_size = table->size;
    table->size *= 2;
    HashNode **old_nodes = table->nodes;
    table->nodes = (HashNode **)malloc(sizeof(HashNode *) * table->size);

    for (int i = 0; i < table->size; i++)
    {
        table->nodes[i] = NULL;
    }

    table->count = 0;

    for (int i = 0; i < old_size; i++)
    {
        if (old_nodes[i] != NULL)
        {
            add_entry(table, old_nodes[i]->key, old_nodes[i]->value);
            free(old_nodes[i]->key);
            free(old_nodes[i]->value);
            free(old_nodes[i]);
        }
    }

    free(old_nodes);
}

bool add_entry(HashTable *table, const char *key, const char *value)
{
    if (table->count >= table->size * 0.7)
    {
        resize_table(table);
    }

    unsigned int index = hash(key, table->size);

    while (table->nodes[index] != NULL && strcmp(table->nodes[index]->key, key) != 0)
    {
        index = (index + 1) % table->size;
    }

    if (table->nodes[index] != NULL)
    {
        free(table->nodes[index]->key);
        free(table->nodes[index]->value);
    }
    else
    {
        table->nodes[index] = (HashNode *)malloc(sizeof(HashNode));
        table->count++;
    }

    table->nodes[index]->key = strdup(key);
    table->nodes[index]->value = strdup(value);

    return true;
}

bool remove_entry(HashTable *table, const char *key)
{
    unsigned int index = hash(key, table->size);

    while (table->nodes[index] != NULL)
    {
        if (strcmp(table->nodes[index]->key, key) == 0)
        {
            free(table->nodes[index]->key);
            free(table->nodes[index]->value);
            free(table->nodes[index]);
            table->nodes[index] = NULL;
            table->count--;

            index = (index + 1) % table->size;
            while (table->nodes[index] != NULL)
            {
                HashNode *temp = table->nodes[index];
                table->nodes[index] = NULL;
                table->count--;
                add_entry(table, temp->key, temp->value);
                free(temp->key);
                free(temp->value);
                free(temp);
                index = (index + 1) % table->size;
            }
            return true;
        }
        index = (index + 1) % table->size;
    }

    return false;
}

bool exists_entry(HashTable *table, const char *key)
{
    unsigned int index = hash(key, table->size);

    while (table->nodes[index] != NULL)
    {
        if (strcmp(table->nodes[index]->key, key) == 0)
        {
            return true;
        }
        index = (index + 1) % table->size;
    }

    return false;
}

char* get_value(HashTable* table, const char* key) {
    unsigned int index = hash(key, table->size);

    while (table->nodes[index] != NULL) {
        if (strcmp(table->nodes[index]->key, key) == 0) {
            return strdup(table->nodes[index]->value);
        }
        index = (index + 1) % table->size;
    }

    return NULL;
}
