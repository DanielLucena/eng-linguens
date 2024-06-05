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
%token <iValue> INTEGER
%token <cValue> CARACTERE
%token <fValue> DOUBLE
%token <sValue> STRING
%token PROGRAM SUBPROGRAM

%token COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS PLUS MINUS POWER TIMES SPLIT MOD INCREMENT DECREMENT
%token FACTORIAL HASH TRUE FALSE
%token AND OR PIPE AMPERSAND DOLLAR
%token ARRAY DICT RECORD IMPORT STATIC

%token IF ELSE FOR RETURN SWITCH CASE DEFAULT BREAK CONTINUE DO WHILE TRY CATCH FINALLY THROW 

%start program

%right INCREMENT DECREMENT
%right DOLLAR AMPERSAND
%right POWER
%left TIMES SPLIT MOD
%left PLUS MINUS
%left COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS
%left AND 
%left OR
%right '?'
%right ':'


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
                | record_stmt ';'
                | import_stmt
                | static_stmt ;

type            : PRIMITIVE
                | ARRAY LESS_THAN type MORE_THAN
                | DICT LESS_THAN type ',' type MORE_THAN
                | type TIMES ;

func_def        : SUBPROGRAM ID '(' params ')' ':' type block ;

params          : /* vazio */
                | param_list ;

param_list      : param 
                | param ',' param_list ;

param           : type ID ;

block           : '{' stmts '}' ;

expression      : DOLLAR expression
                | AMPERSAND expression
                /* | primitive_func */
                | INCREMENT ID;
                | DECREMENT ID;
                | term
                | expression PLUS term
                | expression MINUS term ;
                | expression MORE_THAN term ;
                | expression LESS_THAN term ;
                | expression MORE_THAN_EQUALS term ;
                | expression LESS_THAN_EQUALS term ;
                | expression COMPARISON term ;
                | expression DIFFERENT term  ;
                | expression AND term;
                | expression OR term;
                | expression '?' expression ':' expression ;


term            : factor
                | term TIMES factor
                | term SPLIT factor
                | term MOD factor ;
                | term POWER factor;
                | term FACTORIAL;

factor          : literal
                | ID
                | '(' expression ')' ;
                | func_call
                | access
                


access          : ID '[' expression ']' ;
                | ID '.' ID;
                | access '.' ID;
                | access '[' expression ']'

/* atribute_access : ID '.' ID;
                | atribute_access '.' ID; */

literal         : INTEGER
                | DOUBLE
                | CARACTERE
                | STRING
                | TRUE
                | FALSE
                | collection_lit;

collection_lit  : '{' '}'
                | '{' array_members '}'
                | '{' dict_members  '}'
                | '{' rec_members'}'


array_members   : expression
                | expression ',' array_members ;

dict_members    : dict_member
                | dict_member ',' dict_members

dict_member     : expression ':' expression

rec_members     : rec_member
                | rec_member ',' rec_members

rec_member      : ID ':' expression

func_call       : ID '(' args ')' ;

args            : /* vazio */
                | expressions ;

expressions     : expression
                | expression ',' expressions ;

/* primitive_func  : ID '.' ID ; */

declaration     : type atrib
                | type ID ;
                | ID atrib;
                | ID ID;

atrib           : ID '=' expression
                | ID INCREMENT
                | ID DECREMENT
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

static_stmt     : STATIC func_def ;

record_stmt     : RECORD ID  ':' record_block

record_block    : '{' record_fields '}'

record_fields  : record_field
                | record_field ',' record_fields

record_field   : type ID
                | ID ID

%%

int main (void) {
    yylineno = 1;
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "linha %d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}