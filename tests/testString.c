#include <stdio.h>
#include <stdlib.h>

int main() {
    char *str = NULL;
    size_t len = 0;
    ssize_t nread;

    printf("Digite uma string: ");
    nread = getline(&str, &len, stdin);

    if (nread == -1) {
        printf("Erro ao ler a string.\n");
        free(str);  // Libera a memória alocada
        return 1;
    }

    // Remove o '\n' se estiver presente
    if (str[nread - 1] == '\n') {
        str[nread - 1] = '\0';
    }

    printf("Você digitou: %s\n", str);

    free(str);  // Libera a memória alocada
    return 0;
}

