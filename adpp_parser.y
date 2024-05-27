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
%token FACTORIAL HASH TRUE FALSE
%token AND OR PIPE AMPERSAND
%token MAP VOID IMPORT STATIC

%token IF ELSE FOR RETURN SWITCH CASE DEFAULT BREAK CONTINUE DO WHILE TRY CATCH FINALLY THROW 

%start program
%%

program         : PROGRAM ID '{' stmts '}' ;

stmts           : /* vazio */
                | stmt stmts ;

stmt            : ';'
                | func_def
                | expression ';'
                | if_stmt
                | for_stmt
                | while_stmt
                | do_while_stmt
                | try_catch_stmt
                | switch_stmt
                | return_stmt ';'
                | break_stmt ';'
                | continue_stmt ';'
                | throw_stmt ';'
                | atrib ';'
                | declaration ';'
                | import_stmt
                | static_declaration ;

type            : PRIMITIVE
                | ARRAY LESS_THAN PRIMITIVE MORE_THAN
                | MAP LESS_THAN PRIMITIVE ',' PRIMITIVE MORE_THAN
                | VOID
                | type TIMES ;

func_def        : SUBPROGRAM ID '(' params ')' ':' type block ;

params          : /* vazio */
                | param_list ;

param_list      : param 
                | param ',' param_list ;

param           : type ID ;

block           : '{' stmts '}' ;

expression      : ID
                | recursive_expr
                | literal
                | func_call
                | ID INCREMENT;
                | ID DECREMENT;
                | INCREMENT ID;
                | DECREMENT ID;
                | binary_expr
                | unary_expr
                | access
                | primitive_func
                | ternary_expr
                | pointer_expr;

recursive_expr  : term
           | recursive_expr PLUS term
           | recursive_expr MINUS term ;
           | recursive_expr MORE_THAN term ;
           | recursive_expr LESS_THAN term ;
           | recursive_expr MORE_THAN_EQUALS term ;
           | recursive_expr LESS_THAN_EQUALS term ;
           | recursive_expr COMPARISON term ;
           | recursive_expr DIFFERENT term ;

term : factor
     | term TIMES factor
     | term SPLIT factor
     | term MOD factor ;

factor : literal
       | ID
       | '(' recursive_expr ')' ;


access          : ID '[' expression ']' ;

literal         : INTEGER
                | DOUBLE
                | CARACTERE
                | STRING
                | TRUE
                | FALSE
                | array_literal ;

array_literal   : '{' literais '}' ;

literais        : literal
                | literal ',' literais ;

func_call       : ID '(' args ')' ;

args            : /* vazio */
                | expressions ;

expressions     : expression
                | expression ',' expressions ;

primitive_func  : ID '.' ID ;

binary_expr     : expression binary_operator expression ;

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
                | PIPE
                | AMPERSAND ;

unary_expr      : expression FACTORIAL
                | HASH expression ;

ternary_expr    : expression '?' expression ':' expression ;

pointer_expr    : TIMES expression
                | AMPERSAND expression ;

declaration     : type atrib
                | type ID ;

atrib           : ID '=' expression
                | ID INCREMENT
                | ID DECREMENT
                | TIMES ID '=' expression
                | access '=' expression;

if_stmt         : IF '(' expression ')' block
                | IF '(' expression ')' block ELSE block ;

for_stmt        : FOR '(' for_part ';' expression ';' for_part ')' block ;

for_part        : atrib
                | declaration ;

while_stmt      : WHILE '(' expression ')' block ;

do_while_stmt   : DO block WHILE '(' expression ')' ';' ;

try_catch_stmt  : TRY block CATCH '(' ID ')' block
                | TRY block CATCH '(' ID ')' block FINALLY block ;

switch_stmt     : SWITCH '(' expression ')' '{' case_stmts '}' ;

case_stmts      : /* vazio */
                | case_stmt case_stmts ;

case_stmt       : CASE literal ':' stmts
                | DEFAULT ':' stmts ;

return_stmt     : RETURN expression ;

break_stmt      : BREAK ;

continue_stmt   : CONTINUE ;

throw_stmt      : THROW expression ;

import_stmt     : IMPORT STRING ';' ;

static_declaration : STATIC func_def ;

%%

int main (void) {
    yylineno = 1;
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "linha %d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}