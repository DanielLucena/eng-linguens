#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
void clearBuffer() {int c;start:c = getchar();if (c != '\n' && c != EOF) {goto start;}}
#include <string.h>
char* concat(const char* s1, const char* s2){char* r=malloc(strlen(s1)+strlen(s2)+1);if(r){strcpy(r,s1);strcat(r,s2);}return r;}
#define BUF_SZ 50
static char buf[BUF_SZ];
const char *d_to_s(double v){snprintf(buf, BUF_SZ, "%f", v);return buf;}
const char *b_to_s(int v){return v ? "true" : "false";}
const char *i_to_s(long v){snprintf(buf, BUF_SZ, "%ld", v);return buf;}
const char *c_to_s(char v){snprintf(buf, BUF_SZ, "%c", v);return buf;}
long _0to25 = 0;
long _26to50 = 0;
long _51to75 = 0;
long _76to100 = 0;



int main() {
long num = 0;
printf("%s", "Digite um numero (negativo para terminar): ");
scanf("%ld", &num);clearBuffer();
ID6:
if(!(num>=0)) goto ID7;
{
if(num>=0&&num<=25) {
(++_0to25);
}
if(!(num>=0&&num<=25)){if(num>=26&&num<=50) {
(++_26to50);
}
if(!(num>=26&&num<=50)){if(num>=51&&num<=75) {
(++_51to75);
}
if(!(num>=51&&num<=75)){if(num>=76&&num<=100) {
(++_76to100);
}}}}
printf("%s", "Digite um numero (negativo para terminar): ");
scanf("%ld", &num);clearBuffer();
}
goto ID6;
ID7:

printf("%s", "\nQuantidades nos intervalos:\n");
printf("%s", concat(concat("[0, 25]: ", i_to_s(_0to25)), "\n"));
printf("%s", concat(concat("[26, 50]: ", i_to_s(_26to50)), "\n"));
printf("%s", concat(concat("[51, 75]: ", i_to_s(_51to75)), "\n"));
printf("%s", concat(concat("[76, 100]: ", i_to_s(_76to100)), "\n"));

return 0;
}
