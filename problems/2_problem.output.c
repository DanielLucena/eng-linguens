#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
long _0to25=0;
long _26to50=0;
long _51to75=0;
long _76to100=0;



int main() {
long num=0;
printf("Digite um numero (negativo para terminar): ");
scanf("%ld", (&num));
printf("%ld", num);
GkBIErJTEHKbNJdKtgID:
if(!(num >= 0)) goto fsecdHNAxzqdltMsLvlR;
{
if(num >= 0 && num <= 25) {
_0to25++;
} else if(num >= 26 && num <= 50) {
_26to50++;
} else if(num >= 51 && num <= 75) {
_51to75++;
} else if(num >= 76 && num <= 100) {
_76to100++;
}
printf("Digite um numero (negativo para terminar): ");
scanf("%ld", (&num));
printf("%ld", num);
}
goto GkBIErJTEHKbNJdKtgID;
fsecdHNAxzqdltMsLvlR:

printf("\nQuantidades nos intervalos:\n");
printf("[0, 25]: %ld\n", _0to25);
printf("[26, 50]: %ld\n", _26to50);
printf("[51, 75]: %ld\n", _51to75);
printf("[76, 100]: %ld\n", _76to100);

return 0;
}
