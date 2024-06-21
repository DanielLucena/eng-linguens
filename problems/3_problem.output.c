#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

void leMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
MMRVsjcudjCFyEZpTxVX:
if(!(i < linhas)) goto iEztDvsXCayQNpMHaqbd;
{
{long j=0;
xzqSmSNhhdeOHesgzshi:
if(!(j < colunas)) goto CoASpoWFCLhCkZuZRhgB;
{
printf("Elemento [%ld][%ld]: ", i, j);
scanf("%ld", (&matriz[i][j]));
}
j++;
goto xzqSmSNhhdeOHesgzshi;
CoASpoWFCLhCkZuZRhgB:
}
}
i++;
goto MMRVsjcudjCFyEZpTxVX;
iEztDvsXCayQNpMHaqbd:
}
}
void imprimeMatriz(long * * matriz, long linhas, long colunas){
{long i=0;
deMXHZShgnLofEKPnOyK:
if(!(i < linhas)) goto wljHmJfxAhtflgcuHwdO;
{
{long j=0;
zEkzKMrDjmdssCLVYFSc:
if(!(j < colunas)) goto hSTwhhehxfMylzAWlRbu;
{
printf("%ld ", matriz[i][j]);
}
j++;
goto zEkzKMrDjmdssCLVYFSc;
hSTwhhehxfMylzAWlRbu:
}
printf("\n");
}
i++;
goto deMXHZShgnLofEKPnOyK;
wljHmJfxAhtflgcuHwdO:
}
}
void somaMatrizes(long * * a, long * * b, long linhas, long colunas){
long * * soma=(long * *)malloc(linhas * sizeof(long *));
{long i=0;
JPcrVMgjdETbrEIfnqCp:
if(!(i < linhas)) goto xWWkEYFlXIZGZbzVqFeV;
{
soma[i]=(long *)malloc(colunas * sizeof(long));
}
i++;
goto JPcrVMgjdETbrEIfnqCp;
xWWkEYFlXIZGZbzVqFeV:
}
{long i=0;
oCTCHztnKYQIDCdnNVnf:
if(!(i < linhas)) goto RKMmdYoexHCLjYPsxjiK;
{
{long j=0;
MzWFegLrwPjTnfGReldD:
if(!(j < colunas)) goto vEjvilqaQWVevtmzzXty;
{
soma[i][j]=a[i][j] + b[i][j];
}
j++;
goto MzWFegLrwPjTnfGReldD;
vEjvilqaQWVevtmzzXty:
}
}
i++;
goto oCTCHztnKYQIDCdnNVnf;
RKMmdYoexHCLjYPsxjiK:
}
printf("Soma das Matrizes:\n");
imprimeMatriz(soma, linhas, colunas);
}
void produtoMatrizes(long * * a, long * * b, long linhasA, long colunasA, long colunasB){
long * * produto=(long * *)malloc(linhasA * sizeof(long *));
{long i=0;
JYsOcXbPSQxlAjZDJnIg:
if(!(i < linhasA)) goto wMRhKHAKsIuDiosllVCF;
{
produto[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto JYsOcXbPSQxlAjZDJnIg;
wMRhKHAKsIuDiosllVCF:
}
{long i=0;
TecSEZOaLqnqhhSBVyUw:
if(!(i < linhasA)) goto fMmOjHUWIDgCHiuOhLOv;
{
{long j=0;
NcdEVmfzxSXSZYvuUMCn:
if(!(j < colunasB)) goto FpsZuNeQZHSoJxuglzhk;
{
{long k=0;
MZQmKPstFCzboTjBcllW:
if(!(k < colunasA)) goto TFbDvVOGRTNfuDTfUlab;
{
produto[i][j]=produto[i][j] + a[i][k] * b[k][j];
}
k++;
goto MZQmKPstFCzboTjBcllW;
TFbDvVOGRTNfuDTfUlab:
}
}
j++;
goto NcdEVmfzxSXSZYvuUMCn;
FpsZuNeQZHSoJxuglzhk:
}
}
i++;
goto TecSEZOaLqnqhhSBVyUw;
fMmOjHUWIDgCHiuOhLOv:
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
bEnjLfmigIglWtCHaYDI:
if(!(i < linhasA)) goto CJMLRJzBuQyvuLgHtVsz;
{
matrizA[i]=(long *)malloc(colunasA * sizeof(long));
}
i++;
goto bEnjLfmigIglWtCHaYDI;
CJMLRJzBuQyvuLgHtVsz:
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
DymAtOhtpLERuqeOZERt:
if(!(i < linhasB)) goto uprqCZXVURWaqLcJzjFq;
{
matrizB[i]=(long *)malloc(colunasB * sizeof(long));
}
i++;
goto DymAtOhtpLERuqeOZERt;
uprqCZXVURWaqLcJzjFq:
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
