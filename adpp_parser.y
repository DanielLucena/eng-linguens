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
%token <sValue> PRIMITIVE
%token <sValue> ARRAY
%token <iValue> INTEGER
%token <cValue> CARACTERE
%token <fValue> DOUBLE
%token <sValue> STRING
%token PROGRAM SUBPROGRAM

%token COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS PLUS MINUS POWER TIMES SPLIT MOD INCREMENT DECREMENT
%token FACTORIAL TERNARY HASH 
%token AND OR PIPE AMPERSAND
%token MAP VOID IMPORT STATIC COMMENT

%token IF ELSE FOR RETURN SWITCH CASE BREAK CONTINUE DO WHILE TRY CATCH FINALLY THROW 

%start program
%%

program         : PROGRAM ID '{' stmts '}'
                ;

stmts           : stmt
                | stmt stmts
                ;


type            : PRIMITIVE
                | ARRAY LESS_THAN PRIMITIVE MORE_THAN
                ;

func_def        : SUBPROGRAM ID '(' params ')' ':' type block
                ;

params          : param 
                | param ',' params
                |
                ;

param           : type ID
                ;

block           : '{' stmts '}'
                ;

expression      : ID
                | literal
                | func_call
                | binary_expr
                | access
                ;

access          : ID '[' expression ']'
                ;

/* inserir literal de outros tipos */
literal         : INTEGER
                | DOUBLE
                | CARACTERE
                | STRING
                | array_literal
                ;

literais        : literal
                | literal ',' literais
                ;

array_literal   : '{' literais '}'
                ;

func_call       : ID '(' args ')'
                ;

args            : expressions
                ;

expressions     : expression
                | expression ',' expressions
                ;

binary_expr     : expression binary_operator expression
                ;

binary_operator : PLUS 
                | MINUS 
                | POWER 
                | TIMES 
                | SPLIT 
                | MOD
                | COMPARISON 
                | DIFFERENT 
                | LESS_THAN 
                | MORE_THAN 
                | LESS_THAN_EQUALS 
                | MORE_THAN_EQUALS      
                | AND
                | OR
                ;

stmt            : ';'
                | func_def
                | expression ';'
                | if_stmt
                | for_stmt
                | return_stmt ';'
                | atrib ';'
                | declaration ';'
                ;

declaration     : type atrib
                | type ID
                ;

atrib           : ID  '=' expression
                | ID INCREMENT
                | ID DECREMENT
                ;

if_stmt         : IF '(' expression ')' block
                | IF '(' expression ')' block ELSE block
                ;

for_stmt        : FOR '(' for_part ';' expression ';' for_part ')' block
                ;

for_part        : atrib
                | declaration
                ;

return_stmt     : RETURN expression
                ;
%%

int main (void) {
    yylineno = 1;
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "linha %d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}