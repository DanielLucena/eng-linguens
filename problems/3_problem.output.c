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

void leMatriz(long** matriz, long linhas, long colunas){
{long i = 0;
ID5:
if(!(i<linhas)) goto ID6;
{
{long j = 0;
ID3:
if(!(j<colunas)) goto ID4;
{
printf("%s", concat(concat(concat(concat("Elemento [", i_to_s(i)), "]["), i_to_s(j)), "]: "));
long v;
scanf("%ld", &v);clearBuffer();
matriz[i][j]=v;
}
j=j+1;
goto ID3;
ID4:
}
}
(++i);
goto ID5;
ID6:
}
}
void imprimeMatriz(long** matriz, long linhas, long colunas){
{long i = 0;
ID11:
if(!(i<linhas)) goto ID12;
{
{long j = 0;
ID9:
if(!(j<colunas)) goto ID10;
{
long v = matriz[i][j];
printf("%s", concat(" ", i_to_s(v)));
}
(++i);
goto ID9;
ID10:
}
printf("%s", "\n");
}
(++i);
goto ID11;
ID12:
}
}
void somaMatrizes(long** a, long** b, long linhas, long colunas){
long** soma = (long* *)malloc(linhas * sizeof(long*));
{long i = 0;
ID14:
if(!(i<linhas)) goto ID15;
{
soma[i]=(long *)malloc(colunas * sizeof(long));
}
(++i);
goto ID14;
ID15:
}
{long i = 0;
ID20:
if(!(i<linhas)) goto ID21;
{
{long j = 0;
ID18:
if(!(j<colunas)) goto ID19;
{
soma[i][j]=a[i][j]+b[i][j];
}
j=j+1;
goto ID18;
ID19:
}
}
(++i);
goto ID20;
ID21:
}
printf("%s", "Soma das Matrizes:\n");
imprimeMatriz(soma, linhas, colunas);
}
void produtoMatrizes(long** a, long** b, long linhasA, long colunasA, long colunasB){
long** produto = (long* *)malloc(linhasA * sizeof(long*));
{long i = 0;
ID23:
if(!(i<linhasA)) goto ID24;
{
produto[i]=(long *)malloc(colunasB * sizeof(long));
}
(++i);
goto ID23;
ID24:
}
{long i = 0;
ID32:
if(!(i<linhasA)) goto ID33;
{
{long j = 0;
ID30:
if(!(j<colunasB)) goto ID31;
{
{long k = 0;
ID28:
if(!(k<colunasA)) goto ID29;
{
produto[i][j]=produto[i][j]+a[i][k]*b[k][j];
}
k=k+1;
goto ID28;
ID29:
}
}
j=j+1;
goto ID30;
ID31:
}
}
(++i);
goto ID32;
ID33:
}
printf("%s", "Produto das Matrizes:\n");
imprimeMatriz(produto, linhasA, colunasB);
}


int main() {
long linhasA;
long colunasA;
printf("%s", "Digite o número de linhas da matriz A: ");
scanf("%ld", &linhasA);clearBuffer();
printf("%s", "Digite o número de colunas da matriz A: ");
scanf("%ld", &colunasA);clearBuffer();
long** matrizA = (long* *)malloc(linhasA * sizeof(long*));
{long i = 0;
ID35:
if(!(i<linhasA)) goto ID36;
{
matrizA[i]=(long *)malloc(colunasA * sizeof(long));
}
(++i);
goto ID35;
ID36:
}
printf("%s", "Digite os elementos da matriz A:\n");
leMatriz(matrizA, linhasA, colunasA);
long linhasB;
long colunasB;
printf("%s", "Digite o número de linhas da matriz B: ");
scanf("%ld", &linhasB);clearBuffer();
printf("%s", "Digite o número de colunas da matriz B: ");
scanf("%ld", &colunasB);clearBuffer();
long** matrizB = (long* *)malloc(linhasB * sizeof(long*));
{long i = 0;
ID38:
if(!(i<linhasB)) goto ID39;
{
matrizB[i]=(long *)malloc(colunasB * sizeof(long));
}
(++i);
goto ID38;
ID39:
}
printf("%s", "Digite os elementos da matriz B:\n");
leMatriz(matrizB, linhasB, colunasB);
if(linhasA==linhasB&&colunasA==colunasB) {
somaMatrizes(matrizA, matrizB, linhasA, colunasA);
}
if(!(linhasA==linhasB&&colunasA==colunasB)){
printf("%s", "A soma das matrizes não pode ser realizada.\n");
}
if(colunasA==linhasB) {
produtoMatrizes(matrizA, matrizB, linhasA, colunasA, colunasB);
}
if(!(colunasA==linhasB)){
printf("%s", "O produto das matrizes não pode ser realizado.\n");
}

return 0;
}
