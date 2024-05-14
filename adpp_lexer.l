%{
  #include <stdio.h>

  void removeSlashN(char*);
%}

%%

[ \t\n\r]              ;

"program"             return("PROGRAM\n");
"func"                {return("SUBPROGRAM\n");}

"if"                  {return("IF\n");}
"else"                {return("ELSE\n");}

"switch"              {return("SWITCH\n");}
"case"                {return("CASE\n");}
"break"               {return("BREAK\n");}
"continue"            {return("CONTINUE\n");}

"for"                 {return("FOR\n");}

"do"                  {return("DO\n");}
"while"               {return("WHILE\n");}

"try"                 {return("TRY\n");}
"catch"               {return("CATCH\n");}
"finally"             {return("FINALLY\n");}
"throw"               {return("THROW\n");}


";"                   return(yytext[0]); // retorna o caractere consumido, isso pode ser feito para tokens que sejam de apenas um char
":"                   return(yytext[0]);
"=="                  {return("COMPARISON\n");}
"!="                  {return("DIFFERENT\n");}
"="                   return(yytext[0]);
","                   return(yytext[0]);
"."                   return(yytext[0]);
"<"                   {return("LESS_THAN\n");}
">"                   {return("MORE_THAN\n");}
"!"                   {return("FACTORIAL\n");}
"?"                   {return("TERNARY\n");}
"#"                   {return("HASH\n");}
"&&"                  {return("AND\n");}
"||"                  {return("OR\n");}
"|"                   {return("PIPE\n");}
"&"                   {return("AMPERSAND\n");}
"+"                   {return("PLUS\n");}
"-"                   {return("MINUS\n");}
"**"                  {return("POWER\n");}
"*"                   {return("TIMES\n");}
"/"                   {return("SPLIT\n");}
"%"                   {return("MOD\n");}

"("                   return(yytext[0]); 
")"                   return(yytext[0]);
"["                   return(yytext[0]);
"]"                   return(yytext[0]);
"{"                   return(yytext[0]);
"}"                   return(yytext[0]);

"int"                 {return("TYPE(INT)\n");}
"decimal"             {return("TYPE(DECIMAL)\n");}
"string"              {return("TYPE(STRING)\n");}
"bool"                {return("TYPE(BOOLEAN)\n");}
"char"                {return("TYPE(CARACTER)\n");}
"array"               {return("ARRAY\n");}
"rec"                 {return("RECORD\n");}
"struct"              {return("STRUCT\n");}
"dict"                {return("MAP\n");}
"void"                {return("VOID\n");}

"import"              {return("IMPORT\n");}
"static"              {return("STATIC\n");}
"return"              {return("RETURN\n");}

\/\/.*\n?             {removeSlashN(yytext); return("COMMENT(%s)\n", yytext);}

[0-9]+\.[0-9]+        {return("DOUBLE(%s)\n",yytext);}

[0-9]+                {return("INTEGER(%s)\n",yytext);}

(\"\")|(\".*?[^\\]\") {return("STRING(%s)\n",yytext);}

'.'                   {return("CARACTERE(%s)\n", yytext);}

[a-zA-Z][a-zA-Z0-9]*  {return("ID(%s)\n",yytext);}

.                     {return("INVALID_CARACTERE(%s)\n", yytext);}

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