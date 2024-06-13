%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "../lib/entry.h"

int yylex(void);
int yyerror(char *s);
char *cat(int, ...);

extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    double fValue; /* double value */
    struct entry * ent;
};

%token <sValue> ID
%token <sValue> PRIMITIVE
%token <iValue> INTEGER
%token <cValue> CARACTERE
%token <sValue> DOUBLE
%token <sValue> STRING
%token PROGRAM SUBPROGRAM

%token COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS PLUS MINUS POWER TIMES SPLIT MOD INCREMENT DECREMENT
%token FACTORIAL HASH TRUE FALSE
%token AND OR PIPE AMPERSAND DOLLAR
%token ARRAY DICT RECORD IMPORT STATIC

%token IF ELSE FOR RETURN SWITCH CASE DEFAULT BREAK CONTINUE DO WHILE TRY CATCH FINALLY THROW 

%right INCREMENT DECREMENT
%right DOLLAR AMPERSAND
%right POWER
%right '?'
%right ':'

%left TIMES SPLIT MOD
%left PLUS MINUS
%left COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS
%left AND 
%left OR

%type <ent> stmts, stmt, func_def, params, type, block, declaration, atrib, expression, term, factor, literal

%start program

%%

program         : PROGRAM ID '{' stmts '}' 
                {
                    fprintf(yyout, "//PROGRAM %s\n", $2);
                    free($2);
                    fprintf(yyout, "%s", $4->code);
                    freeEntry($4);
                }
;

stmts           : {$$ = createEntry("","");}
                | stmt stmts {
                    char * s = cat(3, $1->code, "\n", $2->code);
                    freeEntry($1);
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                }
;

stmt            : ';' {$$ = createEntry(";","");}
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
                | declaration ';' {
                    char * s = cat(2, $1->code, ";\n");
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | record_stmt ';'
                | import_stmt
                | static_stmt ;

type            : PRIMITIVE {
                    printf("AQUI-----------------------------------------------------------------------------------%s\n", $1);
                    $$ = createEntry($1,"");
                    free($1);
                }
                | ARRAY LESS_THAN type MORE_THAN
                | DICT LESS_THAN type ',' type MORE_THAN
                | type TIMES ;

func_def        : SUBPROGRAM ID '(' params ')' ':' type block {
                    char * s = cat(7, $7->code, " ", $2, "(", $4->code, ")", $8->code);
                    free($2);
                    freeEntry($7);
                    freeEntry($8);
                    $$ = createEntry(s, "");
                    free(s);
                }

;

params          : {$$ = createEntry("","");}
                | param_list ;

param_list      : param 
                | param ',' param_list ;

param           : type ID ;

block           : '{' stmts '}' {
                    char * s = cat(3, "{\n", $2->code, "}");
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                }
;

expression      : DOLLAR expression
                | AMPERSAND expression
                | INCREMENT ID;
                | DECREMENT ID;
                | term {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
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


term            : factor {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
}
                | term TIMES factor
                | term SPLIT factor
                | term MOD factor ;
                | term POWER factor;
                | term FACTORIAL;

factor          : literal {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
}
                | ID
                | '(' expression ')' ;
                | func_call
                | access
                

access          : ID '[' expression ']' ;
                | ID '.' ID;
                | access '.' ID;
                | access '[' expression ']'

literal         : INTEGER
                | DOUBLE {
                    //printf("AQUI-----------------------------------------------------------------------------------%.2f\n", $1);
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "DECIMAL");
                    free(s);
                }
                | CARACTERE
                | STRING
                | TRUE
                | FALSE
                | collection_lit;

collection_lit  : '{' '}'
                | '{' array_members '}'
                | '{' compound_members '}'

array_members   : expression
                | expression ',' array_members ;  

compound_members: compound_member
                | compound_member ',' compound_members

compound_member : expression ':' expression

func_call       : ID '(' args ')' ;

args            : /* vazio */
                | expressions ;

expressions     : expression
                | expression ',' expressions ;

declaration     : type atrib {
                    char * s = cat(3, $1->code, " ", $2->code);
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                    
                }
                | type ID ;
                | ID atrib;
                | ID ID;

atrib           : ID '=' expression {
                    char * s = cat(3, $1, "=", $3->code);
                    free($1);
                    freeEntry($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
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

int main (int argc, char ** argv) {
    int status;
    yylineno = 1;

    if (argc != 2) {
       printf("Usage: $./ADPP input.adpp\nClosing application...\n");
       exit(0);
    }
    
    char *outputFilename = malloc(strlen(argv[1]) + 10); // Extra space for ".output.c"

    if (outputFilename == NULL) {
        perror("Unable to allocate memory for output filename");
        exit(1);
    }

    strcpy(outputFilename, argv[1]);
    char *dot = strrchr(outputFilename, '.');
    if (dot != NULL) {
        strcpy(dot, ".output.c");
    } else {
        strcat(outputFilename, ".output.c");
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Unable to open input file");
        free(outputFilename);
        exit(1);
    }

    yyout = fopen(outputFilename, "w");
    if (yyout == NULL) {
        perror("Unable to open output file");
        fclose(yyin);
        free(outputFilename);
        exit(1);
    }

    status = yyparse();

    fclose(yyin);
    fclose(yyout);
    free(outputFilename);

    return status;
}

int yyerror (char *msg) {
	fprintf (stderr, "linha %d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}

char *cat(int num, ...) {
    va_list args;
    int total_length = 0;
    
    // Calculate the total length of the resulting string
    va_start(args, num);
    for (int i = 0; i < num; i++) {
        char *s = va_arg(args, char *);
        total_length += strlen(s);
    }
    va_end(args);

    // Allocate memory for the concatenated string
    char *output = (char *)malloc((total_length + 1) * sizeof(char));
    if (!output) {
        printf("Allocation problem. Closing application...\n");
        exit(0);
    }

    // Concatenate the strings
    output[0] = '\0'; // Initialize the output string
    va_start(args, num);
    for (int i = 0; i < num; i++) {
        char *s = va_arg(args, char *);
        strcat(output, s);
    }
    va_end(args);

    return output;
}