#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
typedef struct rational_t {long numerador; long denominador;} rational_t;


long mdc(long a, long b){
kwnOVjnrPOVVduXYZUrm:
if(!(b != 0)) goto ScgeGcTZTxldvytSHiMY;
{
long temp=b;
b=a % b;
a=temp;
}
goto kwnOVjnrPOVVduXYZUrm;
ScgeGcTZTxldvytSHiMY:

}
struct rational_t simplificar(struct rational_t r){
long divisor=mdc(r.numerador, r.denominador);
r.numerador=r.numerador / divisor;
r.denominador=r.denominador / divisor;
if(r.denominador < 0) {
r.numerador=r.numerador * -1;
r.denominador=r.denominador * -1;
}
}
struct rational_t criarRacional(long a, long b){
struct rational_t r;
if(b == 0) {
printf("Erro: Denominador não pode ser zero.\n");
r.numerador=0;
r.denominador=1;
} else {
r.numerador=a;
r.denominador=b;
r=simplificar(r);
}
return r;
}
int iguais(struct rational_t r1, struct rational_t r2){
r1=simplificar(r1);
r2=simplificar(r2);
return (r1.numerador == r2.numerador) && (r1.denominador == r2.denominador);
}
struct rational_t soma(struct rational_t r1, struct rational_t r2){
struct rational_t resultado;
resultado.numerador=r1.numerador * r2.denominador + r2.numerador * r1.denominador;
resultado.denominador=r1.denominador * r2.denominador;
return simplificar(resultado);
}
struct rational_t negacao(struct rational_t r){
r.numerador=r.numerador * -1;
return r;
}
struct rational_t subtracao(struct rational_t r1, struct rational_t r2){
return soma(r1, negacao(r2));
}
struct rational_t multiplicacao(struct rational_t r1, struct rational_t r2){
struct rational_t resultado;
resultado.numerador=r1.numerador * r2.numerador;
resultado.denominador=r1.denominador * r2.denominador;
return simplificar(resultado);
}
struct rational_t inverso(struct rational_t r){
struct rational_t resultado;
if(r.numerador == 0) {
printf("Erro: Não é possível inverter um número racional com numerador zero.\n");
resultado.numerador=0;
resultado.denominador=1;
} else {
resultado.numerador=r.denominador;
resultado.denominador=r.numerador;
if(resultado.denominador < 0) {
resultado.numerador=resultado.numerador * -1;
resultado.denominador=resultado.denominador * -1;
}
}
return resultado;
}
struct rational_t divisao(struct rational_t r1, struct rational_t r2){
return multiplicacao(r1, inverso(r2));
}

int main() {
struct rational_t r1=criarRacional(2, 3);
struct rational_t r2=criarRacional(4, 6);
struct rational_t r3=criarRacional(1, 2);
struct rational_t r4=criarRacional(3, 4);
printf("r1: %ld/%ld\n", r1.numerador, r1.denominador);
printf("r2: %ld/%ld\n", r2.numerador, r2.denominador);
if(iguais(r1, r2)) {
printf("r1 e r2 são iguais.\n");
} else {
printf("r1 e r2 não são iguais.\n");
}
struct rational_t somaR=soma(r1, r3);
printf("Soma de r1 e r3: %ld/%ld\n", somaR.numerador, somaR.denominador);
struct rational_t subtracaoR=subtracao(r1, r3);
printf("Subtração de r1 e r3: %ld/%ld\n", subtracaoR.numerador, subtracaoR.denominador);
struct rational_t multiplicacaoR=multiplicacao(r1, r4);
printf("Multiplicação de r1 e r4: %ld/%ld\n", multiplicacaoR.numerador, multiplicacaoR.denominador);
struct rational_t divisaoR=divisao(r1, r4);
printf("Divisão de r1 por r4: %ld/%ld\n", divisaoR.numerador, divisaoR.denominador);
struct rational_t inversoR=inverso(r1);
printf("Inverso de r1: %ld/%ld\n", inversoR.numerador, inversoR.denominador);
return 0;

return 0;
}
