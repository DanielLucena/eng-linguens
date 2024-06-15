#include <stdio.h>
#include "hash_table.h"

int main() {
    HashTable* table = create_table();

    add_entry(table, "nome", "André");
    add_entry(table, "idade", "25");

    if (exists_entry(table, "nome")) {
        printf("nome: %s\n", get_value(table, "nome"));
    }

    if (exists_entry(table, "idade")) {
        printf("idade: %s\n", get_value(table, "idade"));
    }

 if (exists_entry(table, "nome")) {
        printf("nome: %s\n", get_value(table, "nome"));
    }

    if (exists_entry(table, "idade")) {
        printf("idade: %s\n", get_value(table, "idade"));
    }

     if (exists_entry(table, "nome")) {
        printf("nome: %s\n", get_value(table, "nome"));
    }

    if (exists_entry(table, "idade")) {
        printf("idade: %s\n", get_value(table, "idade"));
    }

    remove_entry(table, "idade");
    remove_entry(table, "nome");

    if (!exists_entry(table, "idade")) {
        printf("Entrada da idade removida\n");
    }

    if (!exists_entry(table, "nome")) {
        printf("Entrada do nome removido\n");
    }

    free_table(table);
    return 0;
}
