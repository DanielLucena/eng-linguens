#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>



int main() {
1+2;
1.2+3.4;
1.2+2;
1+3.4;
1%2;
1.2%2.2;
1%2.2;
1==1;
0==0;
1==0;
0==1;
1==1;
0==3.4;
strcat("Hello", "world");
strcat("Hello", "1");
strcat("Hello", "1.2");
strcat("Hello", "true");
strcat("Hello", "false");
strcat("Hello", "W");
strcat(strcat("Hello", "world"), "world");

return 0;
}
