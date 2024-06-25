#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"

Stack* create_stack() {
    Stack* stack = (Stack*)malloc(sizeof(Stack));
    stack->top = NULL;
    return stack;
}

int is_stack_empty(Stack* stack) {
    return stack->top == NULL;
}

void push_on_stack(Stack* stack, const char* value) {
    StackNode* new_node = (StackNode*)malloc(sizeof(StackNode));
    if (new_node == NULL) {
        printf("ERROR\n");
        return;
    }
    new_node->data = strdup(value);
    if (new_node->data == NULL) {
        printf("ERROR\n");
        free(new_node);
        return;
    }
    new_node->next = stack->top;
    stack->top = new_node;
}

char* pop_from_stack(Stack* stack) {
    if (is_stack_empty(stack)) {
        return NULL;
    }
    StackNode* temp = stack->top;
    char* popped_value = temp->data;
    stack->top = stack->top->next;
    free(temp);
    return popped_value;
}

char* peek_from_stack(Stack* stack) {
    if (is_stack_empty(stack)) {
        return NULL;
    }
    return stack->top->data;
}

void clear_stack(Stack* stack) {
    while (!is_stack_empty(stack)) {
        free(pop_from_stack(stack));
    }
}

void reverse_stack(Stack* original, Stack* reversed) {
    while (!is_stack_empty(original)) {
        push_on_stack(reversed, pop_from_stack(original));
    }
}

char* concat_stack_with_delimiter(Stack* stack, const char* delimiter) {
    if (is_stack_empty(stack)) {
        return strdup(""); 
    }

    size_t delimiter_len = strlen(delimiter);
    size_t total_len = 0;
    StackNode* current = stack->top;
    size_t num_elements = 0;

    // Calcular o comprimento total da string resultante
    while (current != NULL) {
        total_len += strlen(current->data) + delimiter_len;
        current = current->next;
        num_elements++;
    }
    total_len -= delimiter_len;

    char* result = (char*)malloc(total_len + 1);
    if (result == NULL) {
        printf("ERROR\n");
        return NULL;
    }

    result[0] = '\0';

    // Criar uma pilha temporária para inverter a ordem
    Stack* temp_stack = create_stack();
    reverse_stack(stack, temp_stack);

    // Concatenar os valores na ordem correta
    current = temp_stack->top;
    while (current != NULL) {
        strcat(result, current->data);
        current = current->next;
        if (current != NULL) {
            strcat(result, delimiter);
        }
    }

    // Restaurar a ordem original da pilha
    reverse_stack(temp_stack, stack);
    free(temp_stack);

    return result;
}
