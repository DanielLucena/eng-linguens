#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
char* concat(const char* s1, const char* s2){char* r=malloc(strlen(s1)+strlen(s2)+1);if(r){strcpy(r,s1);strcat(r,s2);}return r;}
double my_exp(double x){double sum=1.0;double term=1.0;for(int n=1;n<20;++n){term*=x/n;sum+=term;}return sum;}
double my_log(double x){if(x<=0.0)return -1e308;double y=(x-1)/(x+1);double y2=y*y;double sum=0.0;for(int n=1;n<20;n+=2){sum+=(1.0/n)*y;y*= y2;}return 2*sum;}
double power(double bs,double exp){double r=1.0;int int_exp=(int)exp;double frac_exp=exp-int_exp;while(int_exp){if(int_exp%2)r*=bs;bs*=bs;int_exp/=2;}if(frac_exp!=0.0)r*=my_exp(frac_exp*my_log(bs));return r;}



int main() {
char* d = concat("Hello", "world");
double b = 2.0;
double a = 4.0;
a+b;
a-b;
a*b;
a*-b;
a/b;
power(a+ 0.0, b + 0.0);
int x = 1;
int y = 0;
x&&y;
x||y;
x==y;
x!=y;
long i = 0;
ID3:
if(!(i>10)) goto ID4;
{
if(i>5) {
;
}
(++i);
}
goto ID3;
ID4:

printf("%f", (a+b/a*power(b+ 0.0, 2.0 + 0.0)+1.9));

return 0;
}
