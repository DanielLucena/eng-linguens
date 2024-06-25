#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
void clearBuffer() {int c;start:c = getchar();if (c != '\n' && c != EOF) {goto start;}}
#include <string.h>
char* concat(const char* s1, const char* s2){char* r=malloc(strlen(s1)+strlen(s2)+1);if(r){strcpy(r,s1);strcat(r,s2);}return r;}
double my_exp(double x){double sum=1.0;double term=1.0;for(int n=1;n<20;++n){term*=x/n;sum+=term;}return sum;}
double my_log(double x){if(x<=0.0)return -1e308;double y=(x-1)/(x+1);double y2=y*y;double sum=0.0;for(int n=1;n<20;n+=2){sum+=(1.0/n)*y;y*= y2;}return 2*sum;}
double power(double bs,double exp){double r=1.0;int int_exp=(int)exp;double frac_exp=exp-int_exp;while(int_exp){if(int_exp%2)r*=bs;bs*=bs;int_exp/=2;}if(frac_exp!=0.0)r*=my_exp(frac_exp*my_log(bs));return r;}
#define BUF_SZ 50
static char buf[BUF_SZ];
const char *d_to_s(double v){snprintf(buf, BUF_SZ, "%f", v);return buf;}
const char *b_to_s(int v){return v ? "true" : "false";}
const char *i_to_s(long v){snprintf(buf, BUF_SZ, "%ld", v);return buf;}
const char *c_to_s(char v){snprintf(buf, BUF_SZ, "%c", v);return buf;}



int main() {
double x = 2.5;
double y = 3.7;
long c = 5;
double result = power(x+ 0.0, 2 + 0.0)-y+( (double)c) ;
printf("%s", concat("Result: ", d_to_s(result)));

return 0;
}
