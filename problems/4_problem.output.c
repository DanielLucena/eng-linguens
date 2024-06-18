#include <stdio.h>
typedef struct {long numerador; long denominador} rational_t;


long mdc(long a, long b){
CDNIeHNYCyilkUdYLwUU:
if(!(b != 0)) goto iODvnXdVFraiUNsAWfay;
{
long temp=b;
b=a % b;
a=temp;
}
goto CDNIeHNYCyilkUdYLwUU;
iODvnXdVFraiUNsAWfay:

}
rational_t simplificar(rational_t r){
long divisor=mdc(r.numerador, r.denominador);
r.numerador=r.numerador / divisor;
r.denominador=r.denominador / divisor;
if(r.denominador < 0) {
r.numerador=r.numerador * -1;
r.denominador=r.denominador * -1;
}
}
rational_t criarRacional(long a, long b){
rational_t r;
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
int iguais(rational_t r1, rational_t r2){
r1=simplificar(r1);
r2=simplificar(r2);
return (r1.numerador == r2.numerador) && (r1.denominador == r2.denominador);
}
rational_t soma(rational_t r1, rational_t r2){
rational_t resultado;
resultado.numerador=r1.numerador * r2.denominador + r2.numerador * r1.denominador;
resultado.denominador=r1.denominador * r2.denominador;
return simplificar(resultado);
}
rational_t negacao(rational_t r){
r.numerador=r.numerador * -1;
return r;
}
rational_t subtracao(rational_t r1, rational_t r2){
return soma(r1, negacao(r2));
}
rational_t multiplicacao(rational_t r1, rational_t r2){
rational_t resultado;
resultado.numerador=r1.numerador * r2.numerador;
resultado.denominador=r1.denominador * r2.denominador;
return simplificar(resultado);
}
rational_t inverso(rational_t r){
rational_t resultado;
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
rational_t divisao(rational_t r1, rational_t r2){
return multiplicacao(r1, inverso(r2));
}

int main() {
rational_t r1=criarRacional(2, 3);
rational_t r2=criarRacional(4, 6);
rational_t r3=criarRacional(1, 2);
rational_t r4=criarRacional(3, 4);
printf("r1: %d/%d\n", r1.numerador, r1.denominador);
printf("r2: %d/%d\n", r2.numerador, r2.denominador);
if(iguais(r1, r2)) {
printf("r1 e r2 são iguais.\n");
} else {
printf("r1 e r2 não são iguais.\n");
}
rational_t somaR=soma(r1, r3);
printf("Soma de r1 e r3: %d/%d\n", somaR.numerador, somaR.denominador);
rational_t subtracaoR=subtracao(r1, r3);
printf("Subtração de r1 e r3: %d/%d\n", subtracaoR.numerador, subtracaoR.denominador);
rational_t multiplicacaoR=multiplicacao(r1, r4);
printf("Multiplicação de r1 e r4: %d/%d\n", multiplicacaoR.numerador, multiplicacaoR.denominador);
rational_t divisaoR=divisao(r1, r4);
printf("Divisão de r1 por r4: %d/%d\n", divisaoR.numerador, divisaoR.denominador);
rational_t inversoR=inverso(r1);
printf("Inverso de r1: %d/%d\n", inversoR.numerador, inversoR.denominador);
return 0;

return 0;
}
