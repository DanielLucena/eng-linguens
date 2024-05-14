%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    double fValue; /* double value */
	};

%token <sValue> ID
%token <sValue> TYPE
%token <iValue> INTEGER
%token <cValue> CARACTERE
%token <fValue> DOUBLE
%token PROGRAM SUBPROGRAM

%token COMPARISON DEFERENT LESS_THAN MORE_THAN PLUS MINUS POWER TIMES SPLIT MOD

%token IF ELSE FOR RETURN

%start program
%%

program : PROGRAM ID '{' stmts '}';

stmts : stmt 
      | stmt stmts;


func_def : SUBPROGRAM ID '(' params ')' ':' TYPE block;

params : param 
       | param ',' params;

param : TYPE ID;

block : '{' stmt '}'

expression : ID
           | literal
           | func_call
           | binary_expr

/* inserir literal de outros tipos */
literal : INTEGER
        | DOUBLE
        | CARACTERE

func_call: ID '(' args ')';

args: expressions;

expressions : expression
    | expression ',' expressions;

binary_expr : expression binary_operator expression;

binary_operator : COMPARISON 
                |DEFERENT 
                |LESS_THAN 
                |MORE_THAN 
                |PLUS 
                |MINUS 
                |POWER 
                |TIMES 
                |SPLIT 
                |MOD
                ;

stmt : func_def
     | expression ;
     | if_stmt
     | for_stmt
     | return_stmt
     | atrib
     ;

atrib : ID  '=' expression;

if_stmt : IF '(' expression ')' block
        | IF '(' expression ')' block ELSE block
        ;

for_stmt : FOR '(' expression ';' expression ';' expression ')';

return_stmt : RETURN expression;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}