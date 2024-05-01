%{
  #include <stdio.h>  
%}

%%

[ \t\n]               ;
[0-9]+                {printf("NUMBER(%s)\n",yytext);}
"while"               {printf("WHILE\n");}
"begin"               {printf("BEGIN\n");}
"end"                 {printf("END\n");}
"do"                  {printf("DO\n");}
"if"                  {printf("IF\n");}
"then"                {printf("THEN\n");}
"else"                {printf("ELSE\n");}
";"                   {printf("SEMICOLON\n");}
"="                   {printf("ASSIGNMENT\n");}
"=="                  {printf("COMPARAÇÃO\n");}
"program"             {printf("PROGRAM\n");}
"int"                 {printf("TYPE(INT)\n");}
"decimal"             {printf("TYPE(DECIMAL)\n");}
"string"              {printf("TYPE(STRING)\n");}
[a-zA-Z][a-zA-Z0-9]*  {printf("ID(%s)\n",yytext);}
\/\/.*$?              {printf("COMENTARIO(%s)\n", yytext);}
.                     {printf("Invalid character.\n");}




%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif

int main(void)
{
  yylex();  
  return 0;
}