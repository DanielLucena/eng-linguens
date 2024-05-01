%{
  #include <stdio.h>

  void removeSlashN(char*); 
%}

%%

[ \t\n\r]              ;

"program"             {printf("PROGRAM\n");}
"func"                {printf("SUBPROGRAM\n");}

"if"                  {printf("IF\n");}
"else"                {printf("ELSE\n");}

"switch"              {printf("SWITCH\n");}
"case"                {printf("CASE\n");}
"break"               {printf("BREAK\n");}
"continue"            {printf("CONTINUE\n");}

"for"                 {printf("FOR\n");}

"do"                  {printf("DO\n");}
"while"               {printf("WHILE\n");}

"try"                 {printf("TRY\n");}
"catch"               {printf("CATCH\n");}
"finally"             {printf("FINALLY\n");}
"throw"               {printf("THROW\n");}


";"                   {printf("SEMICOLON\n");}
":"                   {printf("COLON\n");}
"=="                  {printf("COMPARISON\n");}
"!="                  {printf("DIFFERENT\n");}
"="                   {printf("ASSIGNMENT\n");}
","                   {printf("COMMA\n");}
"."                   {printf("DOT\n");}
"<"                   {printf("LESS_THAN\n");}
">"                   {printf("MORE_THAN\n");}
"!"                   {printf("FACTORIAL\n");}
"?"                   {printf("TERNARY\n");}
"#"                   {printf("HASH\n");}
"&&"                  {printf("AND\n");}
"||"                  {printf("OR\n");}
"|"                   {printf("PIPE\n");}
"&"                   {printf("AMPERSAND\n");}
"+"                   {printf("PLUS\n");}
"-"                   {printf("MINUS\n");}
"**"                  {printf("POWER\n");}
"*"                   {printf("TIMES\n");}
"/"                   {printf("SPLIT\n");}
"%"                   {printf("MOD\n");}

"("                   {printf("LEFT_PARENTHESES\n");}
")"                   {printf("RIGHT_PARENTHESES\n");}
"["                   {printf("LEFT_BRACKETS\n");}
"]"                   {printf("RIGHT_BRACKETS\n");}
"{"                   {printf("LEFT_BRACE\n");}
"}"                   {printf("RIGHT_BRACE\n");}

"int"                 {printf("TYPE(INT)\n");}
"decimal"             {printf("TYPE(DECIMAL)\n");}
"string"              {printf("TYPE(STRING)\n");}
"bool"                {printf("TYPE(BOOLEAN)\n");}
"char"                {printf("TYPE(CARACTER)\n");}
"array"               {printf("ARRAY\n");}
"rec"                 {printf("RECORD\n");}
"struct"              {printf("STRUCT\n");}
"dict"                {printf("MAP\n");}
"void"                {printf("VOID\n");}

"import"              {printf("IMPORT\n");}
"static"              {printf("STATIC\n");}
"return"              {printf("RETURN\n");}

\/\/.*\n?             {removeSlashN(yytext); printf("COMMENT(%s)\n", yytext);}

[0-9]+\.[0-9]+        {printf("DOUBLE(%s)\n",yytext);}

[0-9]+                {printf("INTEGER(%s)\n",yytext);}

(\"\")|(\".*?[^\\]\") {printf("STRING(%s)\n",yytext);}

'.'                   {printf("CARACTERE(%s)\n", yytext);}

[a-zA-Z][a-zA-Z0-9]*  {printf("ID(%s)\n",yytext);}

.                     {printf("INVALID_CARACTERE(%s)\n", yytext);}

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

int main(void)
{
  yylex();
  return 0;
}