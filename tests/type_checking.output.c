#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#define BUF_SZ 50
static char buf[BUF_SZ];
const char *d_to_s(double v){snprintf(buf, BUF_SZ, "%f", v);return buf;}
const char *b_to_s(int v){return v ? "true" : "false";}
const char *i_to_s(long v){snprintf(buf, BUF_SZ, "%ld", v);return buf;}
const char *c_to_s(char v){snprintf(buf, BUF_SZ, "%c", v);return buf;}



int main() {
1+2;
1.2+3.4;
1%2;
1==1;
0==0;
1==0;
0==1;
strcat("Hello", d_to_s(1.2));
strcat("Hello", "true");
strcat("Hello", "false");
strcat("Hello", "W");
strcat(strcat("Hello", "world"), "world");
long B = 2;
B;

return 0;
}
