#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

void leMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
zRihLDuyyBjWDrtwGhos:
if(!(i < linhas)) goto vdnNjjFxKcCMvmThQPFQ;
{
{long j=0;
idOAAiEBRYudfUvnlsEK:
if(!(j < colunas)) goto ycGUroORkMnUQDuSoBVf;
{
printf("Elemento [%ld][%ld]: ", i, j);
scanf("%ld", (&matriz[i][j]));
}
j++;
goto idOAAiEBRYudfUvnlsEK;
ycGUroORkMnUQDuSoBVf:
}
}
i++;
goto zRihLDuyyBjWDrtwGhos;
vdnNjjFxKcCMvmThQPFQ:
}
}
void imprimeMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
fCrtcQQLVKGhIQmvqCXi:
if(!(i < linhas)) goto xqrlzxLpUbUaENVGEMTb;
{
{long j=0;
qqMwkHSsOIKkMzXVJfUV:
if(!(j < colunas)) goto JYHfkAOCqVsiOHEYoxqF;
{
printf("%ld ", matriz[i][j]);
}
j++;
goto qqMwkHSsOIKkMzXVJfUV;
JYHfkAOCqVsiOHEYoxqF:
}
printf("\n");
}
i++;
goto fCrtcQQLVKGhIQmvqCXi;
xqrlzxLpUbUaENVGEMTb:
}
}
void somaMatrizes(long * * a, long * * b, long linhas, long colunas){
long * * soma=(long * *)malloc(linhas * sizeof(long *));
{long i=0;
wbiHRWcKyZSyRLlSjXiF:
if(!(i < linhas)) goto AEFesBmWnHXlJIScgwMh;
{
soma[i]=(long *)malloc(colunas * sizeof(long));
}
i++;
goto wbiHRWcKyZSyRLlSjXiF;
AEFesBmWnHXlJIScgwMh:
}
{long i=0;
ggsFxPXQamxuCtyAhEEU:
if(!(i < linhas)) goto wQFYKksvwpYDYqKvHHlj;
{
{long j=0;
YhFrSskDpsjQyOwQRloG:
if(!(j < colunas)) goto SOuBYOgelSlLZscuLmXa;
{
soma[i][j]=a[i][j] + b[i][j];
}
j++;
goto YhFrSskDpsjQyOwQRloG;
SOuBYOgelSlLZscuLmXa:
}
}
i++;
goto ggsFxPXQamxuCtyAhEEU;
wQFYKksvwpYDYqKvHHlj:
}
printf("Soma das Matrizes:\n");
imprimeMatriz(soma, linhas, colunas);
}
void produtoMatrizes(long * * a, long * * b, long linhasA, long colunasA, long colunasB){
long * * produto=(long * *)malloc(linhasA * sizeof(long *));
{long i=0;
vkEXfcxPGEJEWRCGDwcZ:
if(!(i < linhasA)) goto oCemSqHcYulVhPTmRSbx;
{
produto[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto vkEXfcxPGEJEWRCGDwcZ;
oCemSqHcYulVhPTmRSbx:
}
{long i=0;
AcoqdXpaKMofHoWfWnLp:
if(!(i < linhasA)) goto sktRpvDlugMwKCoOAEOM;
{
{long j=0;
nuiULpWsdZYpQzhxXNVL:
if(!(j < colunasB)) goto uUapWIrGQDXezfAkuYCZ;
{
{long k=0;
wnEsGgBjffitHPFbfOdF:
if(!(k < colunasA)) goto KpBReWeyOHxNUbHAKiJP;
{
produto[i][j]=produto[i][j] + a[i][k] * b[k][j];
}
k++;
goto wnEsGgBjffitHPFbfOdF;
KpBReWeyOHxNUbHAKiJP:
}
}
j++;
goto nuiULpWsdZYpQzhxXNVL;
uUapWIrGQDXezfAkuYCZ:
}
}
i++;
goto AcoqdXpaKMofHoWfWnLp;
sktRpvDlugMwKCoOAEOM:
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
qctXTRcPHpeZbZRqXWdT:
if(!(i < linhasA)) goto ErppUDdWJtkaYEzRXeGE;
{
matrizA[i]=(long *)malloc(colunasA * sizeof(long));
}
i++;
goto qctXTRcPHpeZbZRqXWdT;
ErppUDdWJtkaYEzRXeGE:
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
VnEXmXPLTTEykTpGZsCI:
if(!(i < linhasB)) goto npklTKcsqlXladKOCAAX;
{
matrizB[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto VnEXmXPLTTEykTpGZsCI;
npklTKcsqlXladKOCAAX:
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
