#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
void clearBuffer() {int c;start:c = getchar();if (c != '\n' && c != EOF) {goto start;}}
typedef struct teststr {long v1; long v2;} teststr;

void test(struct teststr x){
}


int main() {
long z = 5;
struct teststr x;
test(x);

return 0;
}
