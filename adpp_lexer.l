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
"!"                   {return(NOT);}
"?"                   return(yytext[0]);
"#"                   {return(HASH);}
"&&"                  {return(AND);}
"||"                  {return(OR);}
"|"                   {return(PIPE);}
"&"                   {return(AMPERSAND);}
"+"                   {return(PLUS);}
"-"                   {return(MINUS);}
"^"                   {return(POWER);}
"*"                   {return(TIMES);}
"/"                   {return(SPLIT);}
"%"                   {return(MOD);}
"++"                  {return(INCREMENT);}
"--"                  {return(DECREMENT);}
"$"                   {return(DOLLAR);}

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
"array"               {return ARRAY;}
"rec"                 {return RECORD;}
"dict"                {return DICT;}
"void"                {yylval.sValue = strdup("void"); 
                       return PRIMITIVE;}

"true"                {yylval.sValue = strdup("1"); 
                       return BOOLEAN;}

"false"               {yylval.sValue = strdup("0"); 
                       return BOOLEAN;}

"import"              {return(IMPORT);}
"static"              {return(STATIC);}
"return"              {return(RETURN);}

\/\/.*\n?             {yylineno++;}

[0-9]+\.[0-9]+        {yylval.sValue = strdup(yytext); 
                       return DOUBLE;}

[0-9]+                {yylval.sValue = strdup(yytext); 
                       return INTEGER;}

(\"\")|(\".*?[^\\]\") {yylval.sValue = yytext; 
                       return STRING;}

\'.{1}\'               {yylval.sValue = strdup(yytext); 
                       return CARACTERE;}

[a-zA-Z][a-zA-Z0-9]*  {yylval.sValue = strdup(yytext); 
                       return ID;}

.                     {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif