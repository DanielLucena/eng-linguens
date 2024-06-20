#ifndef STACK_H
#define STACK_H

typedef struct StackNode {
    char* data;
    struct StackNode* next;
} StackNode;

typedef struct Stack {
    StackNode* top;
} Stack;

Stack * create_stack();
int is_stack_empty(Stack* stack);
void push_on_stack(Stack* stack, const char* value);
char* pop_from_stack(Stack* stack);
char* peek_from_stack(Stack* stack);
void clear_stack(Stack* stack);
char* concat_stack_with_delimiter(Stack* stack, const char* delimiter);

#endif // STACK_H
