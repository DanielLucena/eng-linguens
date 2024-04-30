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
"="                  {printf("ASSIGNMENT\n");}
[a-zA-Z][a-zA-Z0-9]*	{printf("ID(%s)\n",yytext);}
.                     {printf("Invalid character.\n");}
