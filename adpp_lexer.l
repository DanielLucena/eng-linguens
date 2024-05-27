%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg); 
%}

%%

[ \t\r]                 ;

\n                    {yylineno++;}

"program"             {return(PROGRAM);}
"func"                {return(SUBPROGRAM);}

"if"                  {return(IF);}
"else"                {return(ELSE);}

"switch"              {return(SWITCH);}
"case"                {return(CASE);}
"default"             {return(DEFAULT);}
"break"               {return(BREAK);}
"continue"            {return(CONTINUE);}

"for"                 {return(FOR);}

"do"                  {return(DO);}
"while"               {return(WHILE);}

"try"                 {return(TRY);}
"catch"               {return(CATCH);}
"finally"             {return(FINALLY);}
"throw"               {return(THROW);}


";"                   return(yytext[0]);
":"                   return(yytext[0]);
"=="                  {return(COMPARISON);}
"!="                  {return(DIFFERENT);}
"="                   return(yytext[0]);
","                   return(yytext[0]);
"."                   return(yytext[0]);
"<"                   {return(LESS_THAN);}
">"                   {return(MORE_THAN);}
"<="                  {return(LESS_THAN_EQUALS);}
">="                  {return(MORE_THAN_EQUALS);}
"!"                   {return(FACTORIAL);}
"?"                   return(yytext[0]);
"#"                   {return(HASH);}
"&&"                  {return(AND);}
"||"                  {return(OR);}
"|"                   {return(PIPE);}
"&"                   {return(AMPERSAND);}
"+"                   {return(PLUS);}
"-"                   {return(MINUS);}
"**"                  {return(POWER);}
"*"                   {return(TIMES);}
"/"                   {return(SPLIT);}
"%"                   {return(MOD);}
"++"                  {return(INCREMENT);}
"--"                  {return(DECREMENT);}

"("                   return(yytext[0]); 
")"                   return(yytext[0]);
"["                   return(yytext[0]);
"]"                   return(yytext[0]);
"{"                   return(yytext[0]);
"}"                   return(yytext[0]);

"int"                 {yylval.sValue = strdup("int"); 
                       return PRIMITIVE;}
"decimal"             {yylval.sValue = strdup("decimal"); 
                       return PRIMITIVE;}
"string"              {yylval.sValue = strdup("string"); 
                       return PRIMITIVE;}
"bool"                {yylval.sValue = strdup("bool"); 
                       return PRIMITIVE;}
"char"                {yylval.sValue = strdup("char"); 
                       return PRIMITIVE;}
"array"               {yylval.sValue = strdup("array"); 
                       return ARRAY;}
"rec"                 {yylval.sValue = strdup("rec"); 
                       return PRIMITIVE;}
"struct"              {yylval.sValue = strdup("struct"); 
                       return PRIMITIVE;}
"dict"                {yylval.sValue = strdup("dict"); 
                       return PRIMITIVE;}
"void"                {yylval.sValue = strdup("void"); 
                       return PRIMITIVE;}

"import"              {return(IMPORT);}
"static"              {return(STATIC);}
"return"              {return(RETURN);}

\/\/.*\n?             {yylineno++;}

[0-9]+\.[0-9]+        {yylval.fValue = atof(yytext); 
                       return DOUBLE;}

[0-9]+                {yylval.iValue = atoi(yytext); 
                       return INTEGER;}

(\"\")|(\".*?[^\\]\") {yylval.sValue = yytext; 
                       return STRING;}

\'.{1}\'               {yylval.cValue = yytext[1]; 
                       return CARACTERE;}

[a-zA-Z][a-zA-Z0-9]*  {yylval.sValue = strdup(yytext); 
                       return ID;}

.                     {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif