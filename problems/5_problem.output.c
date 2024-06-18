#include <stdio.h>

void mdc(long n, long m, long * r){
if(m % n == 0) {
(*r)=n;
} else if(n % m == 0) {
(*r)=m;
} else if(m > n) {
mdc(n, m % n, r);
} else {
mdc(m, n % m, r);
}
}


int main() {
long n;
long m;
long resultado;
printf("Digite dois números naturais estritamente positivos:\n");
printf("n: ");
scanf("%d", (&n));
printf("m: ");
scanf("%d", (&m));
if(n <= 0 || m <= 0) {
printf("Erro: Os números devem ser naturais estritamente positivos.\n");
} else {
mdc(n, m, (&resultado));
printf("O maior divisor comum de %d e %d é: %d\n", n, m, resultado);
}
return 0;

return 0;
}
