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
void print_entry(const char* key, const char* value);

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
%token <sValue> STRINGLIB

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
            import_stmt,
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
                    fprintf(yyout, "#include <stdio.h>\n");
                    
                    fprintf(yyout, "%s\n%s\n%s\n%s", $1->code, $2->code, $4->code, $3->code);
                    free_entry($1);
                    free_entry($2);
                    free_entry($3);
                    free_entry($4);
                }
                ;

pre_comp_directs: {$$ = create_entry("","");}
                | pre_comp_direct pre_comp_directs {
                    char * s = cat(3, $1->code, "\n", $2->code);
                    free_entry($1);
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }

pre_comp_direct : record_stmt
                | import_stmt
                | static_stmt
                ;

main            : {$$ = create_entry("","");}
                | PROGRAM ID '{' stmts '}' 
                {
                    add_to_table(type_table, "int main()", "#FUNCTION");
                    char * s = cat(4, "int ", "main() {\n", $4->code, "\nreturn 0;\n}\n");
                    free($2);
                    free_entry($4);
                    $$ = create_entry(s, "");
                    free(s);
                }
;

stmts           : {$$ = create_entry("","");}
                | stmt stmts {
                    char * s = cat(2, $1->code, $2->code);
                    free_entry($1);
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
;

stmt            : ';' {$$ = create_entry(";","");}
                | expression ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
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
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

type            : PRIMITIVE {
                    if (exists_on_table(type_table, $1)) {
                        char * s = get_value_from_table(type_table, $1);
                        $$ = create_entry(s, $1);
                        free($1);
                        free(s);
                    } else {
                        yyerror("Unable to find declareted primitive");
                    }
                }
                | ARRAY LESS_THAN type MORE_THAN
                | DICT LESS_THAN type ',' type MORE_THAN
                | type TIMES ;

func_defs       : {$$ = create_entry("","");}
                | func_def func_defs

func_def        : SUBPROGRAM ID '(' params ')' ':' type block {
                    char * funcProt = cat(6, $7->code, " ", $2, "(", $4->code, ")");

                    if (strcmp("long main()", funcProt) == 0) {
                        free(funcProt);
                        free($2);
                        free_entry($7);
                        free_entry($8);
                        yyerror("Function main is reservated by the compiller");
                    }
                    
                    if(exists_on_table(type_table, funcProt)) {
                        free(funcProt);
                        free($2);
                        free_entry($7);
                        free_entry($8);
                        yyerror("Function has arready bean declareted");
                    }

                    add_to_table(type_table, funcProt, "#FUNCTION");
                    char * s = cat(2, funcProt, $8->code);
                    free(funcProt);
                    free($2);
                    free_entry($7);
                    free_entry($8);
                    $$ = create_entry(s, "");
                    free(s);
                }

;

params          : {$$ = create_entry("","");}
                | param_list ;

param_list      : param 
                | param ',' param_list ;

param           : type ID ;

block           : '{' stmts '}' {
                    char * s = cat(3, "{\n", $2->code, "}");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
;

expression      : expression '?' expression ':' expression {
                    // TODO verificar se tem ternário em C
                }
                | exp_lv_8 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_8        : exp_lv_8 OR exp_lv_7 {
                    char * s = cat(3, $1->code, " || ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_7 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_7        : exp_lv_7 AND exp_lv_6 {
                    char * s = cat(3, $1->code, " && ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_6        : exp_lv_6 MORE_THAN exp_lv_5 {
                    char * s = cat(3, $1->code, " > ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 LESS_THAN exp_lv_5 {
                    char * s = cat(3, $1->code, " < ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 MORE_THAN_EQUALS exp_lv_5 {
                    char * s = cat(3, $1->code, " >= ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 LESS_THAN_EQUALS exp_lv_5 {
                    char * s = cat(3, $1->code, " <= ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 COMPARISON exp_lv_5 {
                    char * s = cat(3, $1->code, " == ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_6 DIFFERENT exp_lv_5 {
                    char * s = cat(3, $1->code, " != ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "BOOLEAN");
                    free(s);
                }
                | exp_lv_5 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_5        : exp_lv_5 PLUS exp_lv_4 {
                    char * s = cat(3, $1->code, " + ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_5 MINUS exp_lv_4 {
                    char * s = cat(3, $1->code, " - ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_4 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_4        : exp_lv_4 TIMES exp_lv_3 {
                    char * s = cat(3, $1->code, " * ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_4 SPLIT exp_lv_3 {
                    char * s = cat(3, $1->code, " / ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_4 MOD exp_lv_3 {
                    char * s = cat(3, $1->code, " % ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_3 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_3        : exp_lv_3 POWER exp_lv_2 {
                    char * s = cat(5, "pow(", $1->code, ", ", $3->code, " + 0.0)");
                    if(!exists_on_table(type_table, "#include \"math.h\"")){
                        add_to_table(type_table, "#include \"math.h\"", "#IMPORT");
                    }

                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_2 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_2        : DOLLAR exp_lv_1 {
                    char * s = cat(3, "(*", $2->code, ")");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | AMPERSAND exp_lv_1 {
                    char * s = cat(3, "(&", $2->code, ")");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | INCREMENT exp_lv_1 {
                    char * s = cat(3, "(++", $2->code, ")");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | DECREMENT exp_lv_1 {
                    char * s = cat(3, "(--", $2->code, ")");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_1 {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

exp_lv_1        : literal {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | ID {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | '(' expression ')' {
                    char * s = cat(3, "(", $2->code, ")");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | func_call {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | access {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

access          : ID '[' expression ']' {
                    char * s = cat(4, $1, "[", $3->code, "]");
                    free($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | ID '.' ID {
                    char * s = cat(3, $1, ".", $3);
                    free($1);
                    free($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | access '.' ID {
                    char * s = cat(3, $1->code, ".", $3);
                    free_entry($1);
                    free($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | access '[' expression ']' {
                    char * s = cat(4, $1->code, "[", $3->code, "]");
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

literal         : INTEGER {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "INTEGER");
                    free(s);
                }
                | DOUBLE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "DECIMAL");
                    free(s);
                }
                | CARACTERE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "CARACTERE");
                    free(s);
                }
                | STRING {
                    char * s = cat(1, $1);
                    //free($1); Por algum motivo tá dando errado
                    $$ = create_entry(s, "STRING");
                    free(s);
                }
                | BOOLEAN {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "BOOLEAN");
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
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

args            : {$$ = create_entry("", "");};
                | expressions {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

expressions     : expression {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | expression ',' expressions {
                    char * s = cat(3, $1->code, ", ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

declaration     : type atrib {
                    char * s = cat(3, $1->code, " ", $2->code);
                    free_entry($2);
                    $$ = create_entry(s, "");
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
                    free_entry($3);
                    $$ = create_entry(s, "");
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

import_stmt     : IMPORT STRING ';' {
                    char * importText = cat(2, "#include ", $2);
                    if(!exists_on_table(type_table, importText)){
                        add_to_table(type_table, importText, "#IMPORT");
                    }
                    
                    $$ = create_entry(importText, "#IMPORT");
                }
                | IMPORT STRINGLIB ';' {
                    char * importText = cat(2, "#include ", $2);
                    if(!exists_on_table(type_table, importText)){
                        add_to_table(type_table, importText, "#IMPORT");
                    }
                    
                    $$ = create_entry(importText, "#IMPORT");
                }
                ;

static_stmt     : STATIC func_def ;

record_stmt     : RECORD ID  ':' record_block

record_block    : '{' record_fields '}'

record_fields   : record_field
                | record_field ',' record_fields

record_field    : type ID
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
        yyerror("Unable to allocate memory for output filename");
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
        free(outputFilename);
        yyerror("Unable to open input file");
    }

    yyout = fopen(outputFilename, "w");
    if (yyout == NULL) {
        fclose(yyin);
        free(outputFilename);
        yyerror("Unable to open output file");
    }

    type_table = create_table();

    populateTypeTablePrimitives();

    status = yyparse();

    iterate_table(type_table, print_entry);

    fclose(yyin);
    fclose(yyout);
    free(outputFilename);
    free_table(type_table);

    return status;
}

void print_entry(const char* key, const char* value) {
    printf("Key: %s, Value: %s\n", key, value);
}

int yyerror (char *msg) {
	fprintf (stderr, "line %d: %s at '%s'\n", yylineno, msg, yytext);
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
    add_to_table(type_table, "int", "long");
    add_to_table(type_table, "decimal", "double");
    add_to_table(type_table, "string", "char*");
    add_to_table(type_table, "bool", "int");
    add_to_table(type_table, "char", "char");
    add_to_table(type_table, "rec", "typedef struct");
    add_to_table(type_table, "void", "void");
}