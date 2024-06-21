#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
typedef struct Node {long chave; struct Node * esquerda; struct Node * direita;} Node;

struct Node * novoNo(long chave){
struct Node * temp=(struct Node *)malloc(sizeof(struct Node));
temp->chave=chave;
temp->esquerda=NULL;
temp->direita=NULL;
return temp;
}
struct Node * inserir(struct Node * node, long chave){
if(node == NULL) {
return novoNo(chave);
}
long cv=node->chave;
if(chave < cv) {
node->esquerda=inserir(node->esquerda, chave);
} else if(chave > cv) {
node->direita=inserir(node->direita, chave);
}
return node;
}
void encontrarMinimo(struct Node * node, long nivel, long * minChave, long * minNivel){
if(node == NULL) {
return;
}
long cv=node->chave;
if(cv < (*minChave)) {
(*minChave)=node->chave;
(*minNivel)=nivel;
}
encontrarMinimo(node->esquerda, nivel + 1, minChave, minNivel);
}
void encontrarMaximo(struct Node * node, long nivel, long * maxChave, long * maxNivel){
if(node == NULL) {
return;
}
long cv=node->chave;
if(cv > (*maxChave)) {
(*maxChave)=node->chave;
(*maxNivel)=nivel;
}
encontrarMaximo(node->direita, nivel + 1, maxChave, maxNivel);
}
void imprimirNivel(struct Node * node, long nivel){
if(node == NULL) {
return;
}
if(nivel == 1) {
printf("%ld ", node->chave);
} else if(nivel > 1) {
imprimirNivel(node->esquerda, nivel - 1);
imprimirNivel(node->direita, nivel - 1);
}
}
long altura(struct Node * node){
if(node == NULL) {
return 0;
}
long esquerdaAltura=altura(node->esquerda);
long direitaAltura=altura(node->direita);
return ((esquerdaAltura > direitaAltura ? esquerdaAltura : direitaAltura)) + 1;
}
void imprimirArvore(struct Node * root){
long h=altura(root);
{long i=1;
FgfWmQklzHkZuDNLQcXB:
if(!(i <= h)) goto kIwfoJzKpXVwFaUSsedR;
{
imprimirNivel(root, 1);
printf("\n");
}
i++;
goto FgfWmQklzHkZuDNLQcXB;
kIwfoJzKpXVwFaUSsedR:
}
}


int main() {
struct Node * root=NULL;
long * valores=(long *)malloc(7 * sizeof(long));
valores[0]=50;
valores[1]=30;
valores[2]=20;
valores[3]=40;
valores[4]=70;
valores[5]=60;
valores[6]=80;
long n=sizeof(valores) / sizeof(valores[0]);
{long i=0;
onRIsguiKTlUdIZrrbDi:
if(!(i < n)) goto AzggbaYuHDNVsEfKnbuX;
{
root=inserir(root, valores[i]);
}
i++;
goto onRIsguiKTlUdIZrrbDi;
AzggbaYuHDNVsEfKnbuX:
}
long minChave=INT_MAX;
long minNivel=0;
encontrarMinimo(root, 1, (&minChave), (&minNivel));
printf("Chave mínima: %ld, Nível: %ld\n", minChave, minNivel);
long maxChave=INT_MIN;
long maxNivel=0;
encontrarMaximo(root, 1, (&maxChave), (&maxNivel));
printf("Chave máxima: %ld, Nível: %ld\n", maxChave, maxNivel);
printf("Árvore nível a nível:\n");
imprimirArvore(root);

return 0;
}
