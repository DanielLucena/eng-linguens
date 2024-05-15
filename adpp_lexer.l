%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg); 
  
  void removeSlashN(char*);
%}

%%

[ \t\n\r]              ;

"program"             return(PROGRAM);
"func"                {return(SUBPROGRAM);}

"if"                  {return(IF);}
"else"                {return(ELSE);}

"switch"              {return(SWITCH);}
"case"                {return(CASE);}
"break"               {return(BREAK);}
"continue"            {return(CONTINUE);}

"for"                 {return(FOR);}

"do"                  {return(DO);}
"while"               {return(WHILE);}

"try"                 {return(TRY);}
"catch"               {return(CATCH);}
"finally"             {return(FINALLY);}
"throw"               {return(THROW);}


";"                   return(yytext[0]); // retorna o caractere consumido, isso pode ser feito para tokens que sejam de apenas um char
":"                   return(yytext[0]);
"=="                  {return(COMPARISON);}
"!="                  {return(DIFFERENT);}
"="                   return(yytext[0]);
","                   return(yytext[0]);
"."                   return(yytext[0]);
"<"                   {return(LESS_THAN);}
">"                   {return(MORE_THAN);}
"!"                   {return(FACTORIAL);}
"?"                   {return(TERNARY);}
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

"("                   return(yytext[0]); 
")"                   return(yytext[0]);
"["                   return(yytext[0]);
"]"                   return(yytext[0]);
"{"                   return(yytext[0]);
"}"                   return(yytext[0]);

"int"                 {yylval.sValue = strdup("int"); 
                       return TYPE;}
"decimal"             {yylval.sValue = strdup("decimal"); 
                       return TYPE;}
"string"              {yylval.sValue = strdup("string"); 
                       return TYPE;}
"bool"                {yylval.sValue = strdup("bool"); 
                       return TYPE;}
"char"                {yylval.sValue = strdup("char"); 
                       return TYPE;}
"array"               {yylval.sValue = strdup("array"); 
                       return TYPE;}
"rec"                 {yylval.sValue = strdup("rec"); 
                       return TYPE;}
"struct"              {yylval.sValue = strdup("struct"); 
                       return TYPE;}
"dict"                {yylval.sValue = strdup("dict"); 
                       return TYPE;}
"void"                {yylval.sValue = strdup("void"); 
                       return TYPE;}

"import"              {return(IMPORT);}
"static"              {return(STATIC);}
"return"              {return(RETURN);}

\/\/.*\n?              { removeSlashN(yytext); 
                        printf("COMMENT(%s)\n", yytext);}

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

#ifndef removeSlashN
  void removeSlashN(char *str) {
      int i, j;
      for (i = 0, j = 0; str[i] != '\0'; i++) {
          if (str[i] != '\n') {
              str[j++] = str[i];
          }
      }
      str[j] = '\0';
  }
#endif