#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

void leMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
XHwCDtcCPWOIYwMgaigT:
if(!(i < linhas)) goto hryfrRXBCJzzSxDvtiXi;
{
{long j=0;
kwnOVjnrPOVVduXYZUrm:
if(!(j < colunas)) goto ScgeGcTZTxldvytSHiMY;
{
printf("Elemento [%ld][%ld]: ", i, j);
scanf("%ld", (&matriz[i][j]));
}
j++;
goto kwnOVjnrPOVVduXYZUrm;
ScgeGcTZTxldvytSHiMY:
}
}
i++;
goto XHwCDtcCPWOIYwMgaigT;
hryfrRXBCJzzSxDvtiXi:
}
}
void imprimeMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
btsPxVsxYxxLfaqIhqhv:
if(!(i < linhas)) goto sOOINLjuVxPyQhnQFhnD;
{
{long j=0;
enQElfLlPteWmebDyBea:
if(!(j < colunas)) goto MgbFDEaWoAHspxXBeIMT;
{
printf("%ld ", matriz[i][j]);
}
j++;
goto enQElfLlPteWmebDyBea;
MgbFDEaWoAHspxXBeIMT:
}
printf("\n");
}
i++;
goto btsPxVsxYxxLfaqIhqhv;
sOOINLjuVxPyQhnQFhnD:
}
}
void somaMatrizes(long * * a, long * * b, long linhas, long colunas){
long * * soma=(long * *)malloc(linhas * sizeof(long *));
{long i=0;
gnQlnIwuBDQTTgBitmCo:
if(!(i < linhas)) goto KsocbdSikIorVeeKNAfo;
{
soma[i]=(long *)malloc(colunas * sizeof(long));
}
i++;
goto gnQlnIwuBDQTTgBitmCo;
KsocbdSikIorVeeKNAfo:
}
{long i=0;
ORwtRmawVQlJvUxfHVew:
if(!(i < linhas)) goto yrRaQLHbpkOdDNZuZZsU;
{
{long j=0;
FxJyDNHWZLMldaoHdgPP:
if(!(j < colunas)) goto OdglKNWxnDnTCWTfJcDl;
{
soma[i][j]=a[i][j] + b[i][j];
}
j++;
goto FxJyDNHWZLMldaoHdgPP;
OdglKNWxnDnTCWTfJcDl:
}
}
i++;
goto ORwtRmawVQlJvUxfHVew;
yrRaQLHbpkOdDNZuZZsU:
}
printf("Soma das Matrizes:\n");
imprimeMatriz(soma, linhas, colunas);
}
void produtoMatrizes(long * * a, long * * b, long linhasA, long colunasA, long colunasB){
long * * produto=(long * *)malloc(linhasA * sizeof(long *));
{long i=0;
rfgpBDuKyzhysAaKlHod:
if(!(i < linhasA)) goto tcIWPHSrjMlARTPVwMFw;
{
produto[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto rfgpBDuKyzhysAaKlHod;
tcIWPHSrjMlARTPVwMFw:
}
{long i=0;
aKeLRauwgZOJAevswHAo:
if(!(i < linhasA)) goto WzgqRMjvITAIfgtWgpUP;
{
{long j=0;
DgQlWmNRZeyZjhtJFgFQ:
if(!(j < colunasB)) goto bANMSsKGpMZSuPGqEtKf;
{
{long k=0;
lowfPwsCdGFwIoUaVMre:
if(!(k < colunasA)) goto yehSYyNWkUtXjrdYOvAR;
{
produto[i][j]=produto[i][j] + a[i][k] * b[k][j];
}
k++;
goto lowfPwsCdGFwIoUaVMre;
yehSYyNWkUtXjrdYOvAR:
}
}
j++;
goto DgQlWmNRZeyZjhtJFgFQ;
bANMSsKGpMZSuPGqEtKf:
}
}
i++;
goto aKeLRauwgZOJAevswHAo;
WzgqRMjvITAIfgtWgpUP:
}
printf("Produto das Matrizes:\n");
imprimeMatriz(produto, linhasA, colunasB);
}


int main() {
long linhasA;
long colunasA;
printf("Digite o número de linhas da matriz A: ");
scanf("%ld", (&linhasA));
printf("Digite o número de colunas da matriz A: ");
scanf("%ld", (&colunasA));
long * * matrizA=(long * *)malloc(linhasA * sizeof(long *));
{long i=0;
oJaqpYkLhKZdkIuDWDYE:
if(!(i < linhasA)) goto YamdIhBPwvgLGIDVGOjO;
{
matrizA[i]=(long *)malloc(colunasA * sizeof(long));
}
i++;
goto oJaqpYkLhKZdkIuDWDYE;
YamdIhBPwvgLGIDVGOjO:
}
printf("Digite os elementos da matriz A:\n");
leMatriz(matrizA, linhasA, colunasA);
long linhasB;
long colunasB;
printf("Digite o número de linhas da matriz B: ");
scanf("%ld", (&linhasB));
printf("Digite o número de colunas da matriz B: ");
scanf("%ld", (&colunasB));
long * * matrizB=(long * *)malloc(linhasB * sizeof(long *));
{long i=0;
aKRMUNpRSPvQrkvarWrO:
if(!(i < linhasB)) goto UxbcfgAoUlcxVvLsLbjD;
{
matrizB[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto aKRMUNpRSPvQrkvarWrO;
UxbcfgAoUlcxVvLsLbjD:
}
printf("Digite os elementos da matriz B:\n");
leMatriz(matrizB, linhasB, colunasB);
if(linhasA == linhasB && colunasA == colunasB) {
somaMatrizes(matrizA, matrizB, linhasA, colunasA);
} else {
printf("A soma das matrizes não pode ser realizada.\n");
}
if(colunasA == linhasB) {
produtoMatrizes(matrizA, matrizB, linhasA, colunasA, colunasB);
} else {
printf("O produto das matrizes não pode ser realizado.\n");
}

return 0;
}
