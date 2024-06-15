%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "../lib/entry.h"
#include "../lib/hash_table.h"

int yylex(void);
int yyerror(char *s);
char *cat(int, ...);
void populateTypeTablePrimitives();

extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;
HashTable * type_table;
%}

%union {
	char * sValue;  /* string value */
    struct entry * ent;
};

%token <sValue> ID
%token <sValue> PRIMITIVE
%token <sValue> INTEGER
%token <sValue> CARACTERE
%token <sValue> DOUBLE
%token <sValue> BOOLEAN
%token <sValue> STRING

%token PROGRAM SUBPROGRAM

%token NOT COMPARISON DIFFERENT LESS_THAN MORE_THAN LESS_THAN_EQUALS MORE_THAN_EQUALS PLUS MINUS POWER TIMES SPLIT MOD INCREMENT DECREMENT
%token HASH
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

%type <ent> main, 
            stmts,
            stmt,
            func_def,
            params,
            type,
            block,
            declaration,
            atrib,
            expression,
            literal,
            access,
            args,
            func_call,
            pre_comp_direct,
            pre_comp_directs,
            func_defs,
            expressions,
            exp_lv_8,
            exp_lv_7,
            exp_lv_6,
            exp_lv_5,
            exp_lv_4,
            exp_lv_3,
            exp_lv_2,
            exp_lv_1,

%start file

%%


file            : pre_comp_directs func_defs main func_defs {
                    fprintf(yyout, "%s\n%s\n%s\n%s", $1->code, $2->code, $4->code, $3->code);
                    freeEntry($1);
                    freeEntry($2);
                    freeEntry($3);
                    freeEntry($4);
                }
                ;

pre_comp_directs: {$$ = createEntry("","");}
                | pre_comp_direct pre_comp_directs {
                    char * s = cat(3, $1->code, "\n", $2->code);
                    freeEntry($1);
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                }

pre_comp_direct : record_stmt
                | import_stmt
                | static_stmt
                ;

main            : PROGRAM ID '{' stmts '}' 
                {
                    char * s = cat(4, "int ", "main() {\n", $4->code, "\nreturn 0;\n}\n");
                    free($2);
                    freeEntry($4);
                    $$ = createEntry(s, "");
                    free(s);
                }
;

stmts           : {$$ = createEntry("","");}
                | stmt stmts {
                    char * s = cat(2, $1->code, $2->code);
                    freeEntry($1);
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                }
;

stmt            : ';' {$$ = createEntry(";","");}
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
                ;

type            : PRIMITIVE {
                    if (exists_entry(type_table, $1)) {
                        char * s = get_value(type_table, $1);
                        $$ = createEntry(s, $1);
                        free($1);
                        free(s);
                    } else {
                        perror("Unable to find declareted primitive");
                        exit(1);
                    }
                }
                | ARRAY LESS_THAN type MORE_THAN
                | DICT LESS_THAN type ',' type MORE_THAN
                | type TIMES ;

func_defs       : {$$ = createEntry("","");}
                | func_def func_defs

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

expression      : expression '?' expression ':' expression
                | exp_lv_8
                ;

exp_lv_8        : exp_lv_8 OR exp_lv_7
                | exp_lv_7
                ;

exp_lv_7        : exp_lv_7 AND exp_lv_6
                | exp_lv_6
                ;

exp_lv_6        : exp_lv_6 MORE_THAN exp_lv_5
                | exp_lv_6 LESS_THAN exp_lv_5
                | exp_lv_6 MORE_THAN_EQUALS exp_lv_5
                | exp_lv_6 LESS_THAN_EQUALS exp_lv_5
                | exp_lv_6 COMPARISON exp_lv_5
                | exp_lv_6 DIFFERENT exp_lv_5
                | exp_lv_5
                ;

exp_lv_5        : exp_lv_5 PLUS exp_lv_4
                | exp_lv_5 MINUS exp_lv_4
                | exp_lv_4
                ;

exp_lv_4        : exp_lv_4 TIMES exp_lv_3
                | exp_lv_4 SPLIT exp_lv_3
                | exp_lv_4 MOD exp_lv_3
                | exp_lv_3 {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                ;

exp_lv_3        : exp_lv_3 POWER exp_lv_2
                | exp_lv_2
                ;

exp_lv_2        : DOLLAR exp_lv_1
                | AMPERSAND exp_lv_1
                | INCREMENT exp_lv_1
                | DECREMENT exp_lv_1
                | exp_lv_1
                ;

exp_lv_1        : literal {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | ID {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | '(' expression ')' {
                    char * s = cat(3, "(", $2->code, ")");
                    freeEntry($2);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | func_call
                | access {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                ;

access          : ID '[' expression ']' {
                    char * s = cat(4, $1, "[", $3->code, "]");
                    free($1);
                    freeEntry($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | ID '.' ID {
                    char * s = cat(3, $1, ".", $3);
                    free($1);
                    free($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | access '.' ID {
                    char * s = cat(3, $1->code, ".", $3);
                    freeEntry($1);
                    free($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
                | access '[' expression ']' {
                    char * s = cat(4, $1->code, "[", $3->code, "]");
                    freeEntry($1);
                    freeEntry($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
                ;

literal         : INTEGER {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "INTEGER");
                    free(s);
                }
                | DOUBLE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "DECIMAL");
                    free(s);
                }
                | CARACTERE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "CARACTERE");
                    free(s);
                }
                | STRING {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "STRING");
                    free(s);
                }
                | BOOLEAN {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = createEntry(s, "BOOLEAN");
                    free(s);
                }
                | collection_lit;

collection_lit  : '{' '}'
                | '{' array_members '}'
                | '{' compound_members '}'

array_members   : expression
                | expression ',' array_members ;  

compound_members: compound_member
                | compound_member ',' compound_members

compound_member : expression ':' expression

func_call       : ID '(' args ')' {
                    char * s = cat(4, $1, "(", $3->code, ")");
                    free($1);
                    freeEntry($3);
                    $$ = createEntry(s, "");
                    free(s);
                }
                ;

args            : {$$ = createEntry("", "");};
                | expressions {
                    char * s = cat(1, $1->code);
                    freeEntry($1);
                    $$ = createEntry(s, "");
                    free(s);
                }
                ;

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
                | ID ID {
                    // TODO consultar a tabela de tipos e verificar se o primeiro id é um tipo
                };

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

    type_table = create_table();
    populateTypeTablePrimitives();

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

void populateTypeTablePrimitives() {
    add_entry(type_table, "int", "long");
    add_entry(type_table, "decimal", "double");
    add_entry(type_table, "string", "char*");
    add_entry(type_table, "bool", "int");
    add_entry(type_table, "char", "char");
    add_entry(type_table, "rec", "typedef struct");
    add_entry(type_table, "void", "void");
}