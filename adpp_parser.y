%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>

#include "../lib/entry.h"
#include "../lib/hash_table.h"
#include "../lib/stack.h"

int yylex(void);
int yyerror(char *s);
char *cat(int, ...);
void populateTypeTablePrimitives();
void insert_imports(const char*, const char*);
char * generateId();

void checkTypeBinaryExpression(entry*, entry*, char*);
void checkTypeUnaryExpression(entry*, char*);
int isTypeValidForOperator(char*, char*);
int strBelongsToStrArray( char*,  char ** , int );
entry* getEntryForExpression(entry*, entry*, char*);
entry* getEntryForUnaryExprPrefix(entry *, char * );
entry* getEntryForUnaryExprSufix(entry *, char * );
char* convertToStirng(entry*);
void checkAtrib(char*, entry*);
char* getLiteralType(char*);
void printVariables(const char*, const char*);
void push_on_stack_id(char*);
void remove_content_inside_brackets(char*);

extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;
HashTable * type_table;
Stack * scope_stack;
int Errors = 0;
int scopeId = 1;
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
%token HASH NEW PTRACCESS NULLTK
%token AND OR PIPE AMPERSAND DOLLAR
%token ARRAY RECORD IMPORT GLOBAL

%token IF ELSE FOR RETURN SWITCH CASE DEFAULT BREAK CONTINUE DO WHILE INPUT OUTPUT

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

%type <ent> main 
            stmts
            stmt
            import_stmt
            record_stmt
            global_stmt
            record_block
            record_fields
            record_field
            func_def
            param
            params
            param_list
            type
            block
            declaration
            atrib
            expression
            literal
            access
            args
            func_call
            pre_comp_direct
            pre_comp_directs
            func_defs
            expressions
            exp_lv_8
            exp_lv_7
            exp_lv_6
            exp_lv_5
            exp_lv_4
            exp_lv_3
            exp_lv_2
            exp_lv_1
            if_stmt
            else_stmt
            for_stmt
            for_part
            while_stmt
            do_while_stmt
            /* switch_stmt */
            return_stmt
            break_stmt
            continue_stmt
            input_stmt
            output_stmt
            dimention
            dimentions

%start file

%%

file            : {push_on_stack(scope_stack, "ADPP");} pre_comp_directs func_defs main func_defs {
                    if(Errors > 0){
                        Errors > 1  
                            ? printf("Unable to compile the program, %d errors found\n", Errors)
                            : printf("Unable to compile the program, 1 error found\n");
                        exit(1);
                    }
                    fprintf(yyout, "#include <stdio.h>\n");
                    fprintf(yyout, "#include <stdlib.h>\n");
                    fprintf(yyout, "#include <limits.h>\n");
                    fprintf(yyout, "void clearBuffer() {int c;start:c = getchar();if (c != '\\n' && c != EOF) {goto start;}}\n");

                    iterate_table(type_table, insert_imports);
                    
                    fprintf(yyout, "%s\n%s\n%s\n%s", $2->code, $3->code, $5->code, $4->code);
                    free_entry($2);
                    free_entry($3);
                    free_entry($4);
                    free_entry($5);
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

pre_comp_direct : record_stmt {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | import_stmt {
                    $$ = create_entry("", "");
                }
                | global_stmt {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

main            : {$$ = create_entry("","");}
                | PROGRAM ID {push_on_stack(scope_stack, "main");} '{' stmts '}' {pop_from_stack(scope_stack);}
                {
                    add_to_table(type_table, "int main()", "#FUNCTION");
                    char * s = cat(4, "int ", "main() {\n", $5->code, "\nreturn 0;\n}\n");
                    free($2);
                    free_entry($5);
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
                | if_stmt {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | for_stmt {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | while_stmt {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | do_while_stmt {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                /* | switch_stmt {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                } */
                | return_stmt ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | break_stmt ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | continue_stmt ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | atrib ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | declaration ';' {
                    char * s = cat(2, $1->code, ";\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | input_stmt ';' {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | output_stmt ';' {
                    char * s = cat(2, $1->code, "\n");
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

type            : PRIMITIVE {
                    if (exists_on_table(type_table, $1)) {
                        char * s = get_value_from_table(type_table, $1);
                        $$ = create_entry(s, getLiteralType($1));
                        free($1);
                        free(s);
                    } else {
                        yyerror("Unable to find declareted primitive");
                        free($1);
                        exit(1);
                    }
                }
                | type TIMES {
                    char * s = cat(2, $1->code, "*");
                    free($1);
                    $$ = create_entry(s, s);
                    free(s);
                }
                | HASH ID {
                    char * s = cat(2, "struct ", $2);
                    free($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

func_defs       : {$$ = create_entry("","");}
                | func_def func_defs {
                    char * s = cat(3, $1->code, "\n", $2->code);
                    free_entry($1);
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

func_def        : SUBPROGRAM ID {push_on_stack(scope_stack, $2);} '(' params ')' ':' type block {pop_from_stack(scope_stack);} {
                    char * funcDef = cat(6, $8->code, " ", $2, "(", $5->code, ")");

                    char * funcProt = cat(4, $2, "(", $5->type, ")");
                    printf("%s\n", funcProt);
                    if (strcmp("main()", funcProt) == 0) {
                        yyerror("Function main is reservated by the compiller");
                        free(funcProt);
                        free($2);
                        free_entry($5);
                        free_entry($8);
                        free_entry($9);
                        exit(1);
                    }
                    
                    if(exists_on_table(type_table, funcProt)) {
                        printf("func %s type %s\n",funcProt, get_value_from_table(type_table, funcProt));
                        yyerror(cat(3, "Function ", $2, " has already bean declareted."));
                        free(funcProt);
                        free($2);
                        free_entry($5);
                        free_entry($8);
                        free_entry($9);
                        exit(1);
                    }
                    add_to_table(type_table, funcProt, $8->code);
                    char * s = cat(2, funcDef, $9->code);
                    free(funcDef);
                    free(funcProt);
                    free($2);
                    free_entry($5);
                    free_entry($8);
                    free_entry($9);
                    $$ = create_entry(s, "");
                    free(s);
                    
                }
                ;

params          : {$$ = create_entry("","");}
                | param_list {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    printf("AAAAAAAAA%s\n", t);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

param_list      : param {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                | param ',' param_list {
                    char * s = cat(3, $1->code, ", ", $3->code);
                    char * t = cat(3, $1->type, ",", $3->type);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, t);
                    free(s);
                }
                ;

param           : type ID {
                    char * variable = cat(3, $2, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    
                    add_to_table(type_table, variable, $1->code);

                    char * s = cat(3, $1->code, " ", $2);
                    $$ = create_entry(s, $1->code);
                    free_entry($1);
                    free($2);
                    free(s);
                    free(variable);
                }
                | type ID dimentions {
                    char * variable = cat(3, $2, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    
                    char * typeClean = strdup($3->code);

                    remove_content_inside_brackets(typeClean);

                    char * t = cat(2, $1->code, typeClean);
                    add_to_table(type_table, variable, t);
                    char * s = cat(5, $1->code, " ", $2, " ", $3->code);
                    
                    $$ = create_entry(s, t);

                    free_entry($1);
                    free($2);
                    free_entry($3);
                    free(s);
                    free(variable);
                    free(t);
                }
                ;

block           : '{' stmts '}' {
                    char * s = cat(3, "{\n", $2->code, "}");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
;

expression      : expression '?' expression ':' expression {
                    char * s = cat(7, "(", $1->code, " ? ", $3->code, " : ", $5->code, ")");
                    free_entry($1);
                    free_entry($3);
                    free_entry($5);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | NEW type {
                    char * s = cat(5, "(", $2->code, " *)malloc(sizeof(", $2->code, "))");
                    char * t = cat(2, $2->code, "*");
                    $$ = create_entry(s, t);
                    free_entry($2);
                    free(s);
                    free(t);
                }
                | NEW type '[' expression ']'{
                    char * s = cat(7, "(", $2->code, " *)malloc(", $4->code, " * sizeof(", $2->code, "))");
                    char * t = cat(2, $2->code, "*");
                    $$ = create_entry(s, t);
                    free_entry($2);
                    free(s);
                    free(t);
                }
                | exp_lv_8 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_8        : exp_lv_8 OR exp_lv_7 {
                    entry * e = getEntryForExpression($1, $3, "||");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_7 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_7        : exp_lv_7 AND exp_lv_6 {
                    entry * e = getEntryForExpression($1, $3, "&&");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_6 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_6        : exp_lv_6 MORE_THAN exp_lv_5 {
                    entry * e = getEntryForExpression($1, $3, ">");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_6 LESS_THAN exp_lv_5 {
                    entry * e = getEntryForExpression($1, $3, "<");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_6 MORE_THAN_EQUALS exp_lv_5 {
                    entry * e = getEntryForExpression($1, $3, ">=");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_6 LESS_THAN_EQUALS exp_lv_5 {
                    entry * e = getEntryForExpression($1, $3, "<=");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_6 COMPARISON exp_lv_5 {
                    entry * e = getEntryForExpression($1,$3, "==");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;     
                }
                | exp_lv_6 DIFFERENT exp_lv_5 {
                    entry * e = getEntryForExpression($1, $3, "!=");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_5 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_5        : NULLTK {
                    char * s = cat(1, "NULL");
                    $$ = create_entry(s, "");
                    free(s);
                }
                | exp_lv_5 PLUS exp_lv_4 {
                    entry * e = getEntryForExpression($1,$3, "+");
                    if((strcmp($1->type, "string") == 0) 
                    && !exists_on_table(type_table, "#include <string.h>")){
                        add_to_table(type_table, "#include <string.h>", "#IMPORT");
                    }
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_5 MINUS exp_lv_4 {
                    entry * e = getEntryForExpression($1, $3, "-");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_4 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_4        : exp_lv_4 TIMES exp_lv_3 {
                    entry * e = getEntryForExpression($1, $3, "*");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_4 TIMES MINUS exp_lv_3 {
                    entry * e = getEntryForExpression($1, $4, "*-");
                    free_entry($1);
                    free_entry($4);
                    $$ = e;
                }
                | exp_lv_4 SPLIT exp_lv_3 {
                    entry * e = getEntryForExpression($1, $3, "/");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_4 MOD exp_lv_3 {
                    entry * e = getEntryForExpression($1, $3, "%");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_3 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_3        : exp_lv_3 POWER exp_lv_2 {
                    entry * e = getEntryForExpression($1, $3, "^");
                    free_entry($1);
                    free_entry($3);
                    $$ = e;
                }
                | exp_lv_2 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
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
                    $$ = create_entry(s, cat(2, $2->type, "*"));
                    free(s);
                }
                | INCREMENT exp_lv_1 {
                    entry * e = getEntryForUnaryExprPrefix($2, "++");
                    free_entry($2);
                    $$ = e;
                }
                | DECREMENT exp_lv_1 {
                    entry * e = getEntryForUnaryExprPrefix($2, "--");
                    free_entry($2);
                    $$ = e;
                }
                | exp_lv_1 INCREMENT {
                    entry * e = getEntryForUnaryExprPrefix($1, "++");
                    free_entry($1);
                    $$ = e;
                }
                | exp_lv_1 DECREMENT {
                    entry * e = getEntryForUnaryExprPrefix($1, "--");
                    free_entry($1);
                    $$ = e;
                }
                | NOT exp_lv_1 {
                    entry * e = getEntryForUnaryExprPrefix($2, "!");
                    free_entry($2);
                    $$ = e;
                }
                | MINUS exp_lv_1 {
                    entry * e = getEntryForUnaryExprPrefix($2, "-");
                    free_entry($2);
                    $$ = e;
                }
                | exp_lv_1 {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

exp_lv_1        : literal {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                | ID {
                    char * s = cat(1, $1);
                    char * variable = cat(3, $1, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    char * t;
                    char* found_key = NULL;
                    
                    bool exists = check_scope(type_table, variable, &found_key);

                    if(!exists){
                        yyerror(cat(3, "Variable ", $1, " is not declared on scope."));
                        t = cat(1, "null");
                    }
                    else{
                        t = cat(1, get_value_from_table(type_table, found_key));
                    }
                    free(variable);
                    free($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                | '(' expression ')' {
                    char * s = cat(3, "(", $2->code, ")");
                    char * t = cat(1, $2->type);
                    free_entry($2);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                | func_call {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | access {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

access          : ID '[' expression ']' {
                    char * s = cat(4, $1, "[", $3->code, "]");

                    char * variable = cat(3, $1, "#", concat_stack_with_delimiter(scope_stack, "#"));

                    char* found_key = NULL;
                    bool exists = check_scope(type_table, variable, &found_key);
                    char * type;

                    if(!exists){
                        yyerror(cat(3, "Variable ", $1, " is not declared on scope."));
                        type = cat(1, "null");
                    }
                    else{
                        char * f = get_value_from_table(type_table, found_key);
                        size_t len = strlen(f);
                        if (len > 0) {
                            f[len - 1] = '\0';
                        }
                        type = cat(1, f);
                    }

                    free($1);
                    free_entry($3);
                    $$ = create_entry(s, type);
                    free(s);
                }
                |  ID '[' expression ']' '[' expression ']' {
                    char * s = cat(7, $1, "[", $3->code, "]", "[", $6->code, "]");

                    char * variable = cat(3, $1, "#", concat_stack_with_delimiter(scope_stack, "#"));

                    char* found_key = NULL;
                    bool exists = check_scope(type_table, variable, &found_key);
                    char * type;

                    if(!exists){
                        yyerror(cat(3, "Variable ", $1, " is not declared on scope."));
                        type = cat(1, "null");
                    }
                    else{
                        char * f = get_value_from_table(type_table, found_key);
                        size_t len = strlen(f);
                        if (len > 0) {
                            f[len - 2] = '\0';
                        }
                        type = cat(1, f);
                    }

                    free($1);
                    free_entry($3);
                    $$ = create_entry(s, type);
                    free(s);
                }
                | ID '.' ID {
                    char * s = cat(3, $1, ".", $3);
                    free($1);
                    free($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | ID PTRACCESS ID {
                    char * s = cat(3, $1, "->", $3);
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
                    $$ = create_entry(s, "long");
                    free(s);
                }
                | DOUBLE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "double");
                    free(s);
                }
                | CARACTERE {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "char");
                    free(s);
                }
                | STRING {
                    char * s = cat(1, $1);
                    free($1); //expressão regular de string modificada, por enquanto sem erro
                    $$ = create_entry(s, "string");
                    free(s);
                }
                | BOOLEAN {
                    char * s = cat(1, $1);
                    free($1);
                    $$ = create_entry(s, "bool");
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

output_stmt     : OUTPUT '(' expression ')' {
                    if(strcmp($3->type, "string") == 0) {
                        char * s = cat(3, "printf(\"%s\", ", $3->code, ");");
                        $$ = create_entry(s, "");
                        free(s);
                        free_entry($3);
                    } else {
                        yyerror(cat(1, "You just can print strings."));
                        free_entry($3);
                        $$ = create_entry("", "");
                    }
                }

input_stmt      : INPUT '(' PRIMITIVE ',' ID ')' {
                    
                    char * variable = cat(3, $5, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    char* found_key = NULL;
                    bool exists = check_scope(type_table, variable, &found_key);
                    char * type;

                    if(!exists){
                        yyerror(cat(3, "Variable ", $5, " is not declared on scope."));
                        type = cat(1, "null");
                    }
                    else{
                        type = cat(1, get_value_from_table(type_table, found_key));
                    }

                    char * s;
                    if (strcmp(getLiteralType($3), type) == 0) {
                        if (strcmp(type, "string") == 0) {
                            // eu sei que $5 é do tipo char *
                            char *len = cat(2, "len", generateId());
                            char *nread = cat(2, "nread", generateId());

                            s = cat(19, "size_t ", len, "=0;ssize_t ", nread, ";", nread, "= getline(&", $5, ",&", len,",stdin);if (", $5, "[", nread, " - 1] == '\\n') {", $5, "[", nread, " - 1] = '\\0';}");

                        } else if (strcmp(type, "long") == 0) {
                            s = cat(3, "scanf(\"%ld\", &", $5, ");clearBuffer();");
                        } else if (strcmp(type, "double") == 0) {
                            s = cat(3, "scanf(\"%lf\", &", $5, ");clearBuffer();");
                        } else {
                            yyerror(cat(3, "Unsupported type ", type, "."));
                        }
                    } else {
                        yyerror(cat(5, "Incompatible types between ", getLiteralType($3), " and ", type, "."));
                    }


                    free(found_key);
                    free(variable);
                    free($3);
                    free($5);
                    
                    $$ = create_entry(s, type);
                    
                    free(s);
                    free(type);
                }
                ;

func_call       : ID '(' args ')' {
                    char * call = cat(4, $1, "(", $3->type, ")");

                    if(!exists_on_table(type_table, call)) {                    
                        yyerror(cat(3, "Function  ", call, " dont exists."));
                    }

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
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

expressions     : expression {
                    char * s = cat(1, $1->code);
                    char * t = cat(1, $1->type);
                    free_entry($1);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                | expression ',' expressions {
                    char * s = cat(3, $1->code, ", ", $3->code);
                    char * t = cat(3, $1->type, ",", $3->type);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                ;

declaration     : type ID '=' expression {
                    char * s = cat(5, $1->code," ", $2, " = ", $4->code);
                    char * variable = cat(3, $2, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    if(exists_on_table(type_table, variable)) {                    
                        yyerror(cat(3, "Variable ", $2, " already declared on scope."));
                    }
                    else if(strcmp($1->type, $4->type) != 0){
                        yyerror(cat(4,"invalid attribution, variable of type ", $1->type, " can't recieve a value of type ", $4->type));
                    }
                    else{
                        add_to_table(type_table, variable, $1->code);
                    }
                    
                    free(variable);
                    free_entry($1);
                    free($2);
                    free_entry($4);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | type ID dimentions {
                    char * variable = cat(3, $2, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    
                    if(exists_on_table(type_table, variable)) {
                        free(variable);
                        yyerror(cat(3, "Variable ", $2, " already declared on scope."));
                        exit(0);
                    }

                    char * typeClean = strdup($3->code);

                    remove_content_inside_brackets(typeClean);

                    char * t = cat(2, $1->code, typeClean);

                    add_to_table(type_table, variable, t);

                    char * s = cat(5, $1->code, " ", $2, " ", $3->code);
                    free_entry($1);
                    free($2);
                    free(typeClean);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | type ID {
                    
                    char * variable = cat(3, $2, "#", concat_stack_with_delimiter(scope_stack, "#"));
                    
                    if(exists_on_table(type_table, variable)) {
                        free(variable);
                        yyerror(cat(3, "Variable ", $2, " already declared on scope."));
                        exit(0);
                    }
                    
                    add_to_table(type_table, variable, $1->code);

                    char * s = cat(3, $1->code, " ", $2);
                    free_entry($1);
                    free($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

dimentions      : dimention {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | dimention dimentions {
                    char * s = cat(2, $1->code, $2->code);
                    free_entry($1);
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

dimention       : '[' INTEGER ']' {
                    char * s = cat(3, "[", $2, "]");
                    $$ = create_entry(s, "");
                    free($2);
                    free(s);
                }
                | '[' ID ']' {
                    char * s = cat(3, "[", $2, "]");
                    $$ = create_entry(s, "");
                    free($2);
                    free(s);
                } 

atrib           : ID '=' expression {
                    char * s = cat(3, $1, "=", $3->code);
                    char * t = cat(1,$3->type);
                    //printf("exprType: %s\n",t);
                    checkAtrib($1,$3);
                    free($1);
                    free_entry($3);
                    $$ = create_entry(s, t);
                    free(s);
                    free(t);
                }
                /* | ID INCREMENT {
                    char * s = cat(2, $1, "++");
                    free($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | ID DECREMENT {
                    char * s = cat(2, $1, "--");
                    free($1);
                    $$ = create_entry(s, "");
                    free(s);
                } */
                | access '=' expression {
                    char * s = cat(3, $1->code, "=", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | expression '=' expression {
                    char * s = cat(3, $1->code, "=", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

if_stmt         : IF {push_on_stack_id("@if@");} '(' expression ')' block {pop_from_stack(scope_stack);} else_stmt {
                    char * s;
                    if(strcmp($8->type,"ELSEIF") == 0){
                        s = cat(9, "if(", $4->code, ") ", $6->code, "\nif(!(", $4->code, ")){", $8->code, "}");
                    }
                    else if(strcmp($8->type,"ELSE") == 0){
                        s = cat(8, "if(", $4->code, ") ", $6->code, "\nif(!(", $4->code, "))", $8->code);
                    }
                    else{
                        s = cat(4, "if(", $4->code, ") ", $6->code);
                        
                    }
                     
                    free_entry($4);
                    free_entry($6);
                    free_entry($8);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

else_stmt       : {$$ = create_entry("","");}
                | ELSE {push_on_stack_id("@else@");} block {pop_from_stack(scope_stack);} {
                    char * s = cat(1, $3->code );
                    free_entry($3);
                    $$ = create_entry(s, "ELSE");
                    free(s);
                }
                | ELSE IF {push_on_stack_id("@if@");} '(' expression ')' block {pop_from_stack(scope_stack);} else_stmt {


                    char * s;

                    if(strcmp($9->type,"ELSEIF") == 0){
                        s = cat(9, "if(", $5->code, ") ", $7->code, "\nif(!(", $5->code, ")){", $9->code, "}");
                    }
                    else if(strcmp($9->type,"ELSE") == 0){
                        s = cat(8, "if(", $5->code, ") ", $7->code, "\nif(!(", $5->code, "))", $9->code);
                    }
                    else{
                        s = cat(4, "if(", $5->code, ") ", $7->code);
                        
                    }
                     
                    free_entry($5);
                    free_entry($7);
                    free_entry($9);
                    $$ = create_entry(s, "ELSEIF");
                    free(s);
                }
                ;

for_stmt        : FOR {push_on_stack_id("@for@");}  '(' for_part ';' expression ';' for_part ')' block {pop_from_stack(scope_stack);} {
                    char * startGoto = generateId();

                    char * endGoto = generateId();

                    char * s = cat(18, "{", $4->code, ";\n", startGoto, ":\n", "if(!(", $6->code, ")) goto ", endGoto, ";\n", $10->code, "\n", $8->code, ";\ngoto ", startGoto, ";\n", endGoto, ":\n}"); 
                    free_entry($4);
                    free_entry($6);
                    free_entry($8);
                    free_entry($10);

                    free(startGoto);
                    free(endGoto);

                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

for_part        : atrib {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | declaration {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | expression {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

while_stmt      : WHILE '(' expression ')' {push_on_stack_id("@while@");} block {pop_from_stack(scope_stack);} {
                    char * startGoto = generateId();

                    char * endGoto = generateId();

                    char * s = cat(13, startGoto, ":\n", "if(!(", $3->code, ")) goto ", endGoto, ";\n", $6->code, "\ngoto ", startGoto, ";\n", endGoto, ":\n");

                    free_entry($3);
                    free_entry($6);

                    free(startGoto);
                    free(endGoto);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

do_while_stmt   : DO {push_on_stack_id("@dowhile@");} block {pop_from_stack(scope_stack);} WHILE '(' expression ')' ';' {
                    char * startGoto = generateId();

                    char * s = cat(8, startGoto, ":\n", $3->code, "\nif(", $7->code, ") goto ", startGoto, ";\n");

                    free_entry($3);
                    free_entry($7);

                    free(startGoto);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;
                
/* switch_stmt     : SWITCH '(' expression ')' '{' case_stmts '}' ; */

/* case_stmts      : 
                | case_stmt case_stmts ; */

/* case_stmt       : CASE literal ':' stmts
                | DEFAULT ':' stmts ; */

return_stmt     : RETURN {
                    char * s = cat(1, "return");
                    $$ = create_entry(s, "");
                    free(s);
                }
                |RETURN expression {
                    char * s = cat(2, "return ", $2->code, ";");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

break_stmt      : BREAK {$$ = create_entry("","");};

continue_stmt   : CONTINUE {$$ = create_entry("","");};

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


global_stmt     : GLOBAL declaration ';' {
                    char * s = cat(2, $2->code, ";");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

record_stmt     : RECORD ID record_block {
                    char * structText = cat(2, "struct ", $2);
                    if(!exists_on_table(type_table, structText)){
                        add_to_table(type_table, structText, "#STRUCT");
                    } else {
                        yyerror(cat(3, "Struct ", $2, " has arready bean declareted."));
                        free($2);
                        free_entry($3);
                        exit(1);
                    }
                    char * s = cat(7, "typedef struct ", $2 ," {", $3->code, "} ", $2, ";");
                    free($2);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

record_block    : '{' record_fields '}' {
                    char * s = cat(2, $2->code, ";");
                    free_entry($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

record_fields   : record_field {
                    char * s = cat(1, $1->code);
                    free_entry($1);
                    $$ = create_entry(s, "");
                    free(s);
                }
                | record_field ',' record_fields {
                    char * s = cat(3, $1->code, "; ", $3->code);
                    free_entry($1);
                    free_entry($3);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;

record_field    : type ID {
                    char * s = cat(3, $1->code, " ", $2);
                    free_entry($1);
                    free($2);
                    $$ = create_entry(s, "");
                    free(s);
                }   
                | ID ID {
                    char * s = cat(3, $1, " ", $2);
                    free($1);
                    free($2);
                    $$ = create_entry(s, "");
                    free(s);
                }
                ;
%%

int main (int argc, char ** argv) {
    srand(time(NULL));
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
    scope_stack = create_stack();

    populateTypeTablePrimitives();

    status = yyparse();

    iterate_table(type_table, printVariables);

    fclose(yyin);
    fclose(yyout);
    free(outputFilename);
    free_table(type_table);

    return status;
}

void printVariables(const char* key, const char* value) {
    printf("-> %s : %s \n", key, value);
}

void insert_imports(const char* key, const char* value) {
    if(strcmp(value, "#IMPORT") == 0) {
        fprintf(yyout, "%s\n", key);
    }
}

int yyerror (char *msg) {
    Errors++;
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

void push_on_stack_id(char * prefix) {
    char * str = generateId();
    push_on_stack(scope_stack, cat(2, prefix, str));
    free(str);
}

char * generateId() {
    char * string = malloc(sizeof(char) * 14);
    sprintf(string, "ID%d", scopeId);
    scopeId++;
    string[13] = '\0';
    return string;
}

entry* getEntryForExpression(entry *firstOperand, entry *secondOperand, char * operator){
    /* printf("Generating expression for:[%s, %s, %s]\n",
    firstOperand->code,secondOperand->code,operator); */
    /* printf("entry\n"); */
    char* s;
    char* t = firstOperand->type;
    if((strcmp(firstOperand->type, "string") == 0)){
        const char* string_concat_func = "char* concat(const char* s1, const char* s2){char* r=malloc(strlen(s1)+strlen(s2)+1);if(r){strcpy(r,s1);strcat(r,s2);}return r;}";
        if(!exists_on_table(type_table, string_concat_func)){
        add_to_table(type_table, string_concat_func, "#IMPORT");
    }
        if((strcmp(operator, "+") == 0) && (strcmp(secondOperand->type, "string") != 0)){ //segundo operando não é string
            s = cat(5, "concat(",firstOperand->code,", ", convertToStirng(secondOperand),")");
        }
        else{
            s = cat(5, "concat(",firstOperand->code, ", ",secondOperand->code,")");
        }
        //printf("\tExpression: %s\n\tExprType: %s\n",s,"STRING");
        return create_entry(s, "string");
    }
    else{
        char *boolReturnOperands[] = {  "==","!=",">","<",">=","<=","&&","||"};
        int isBoolReturnOperand = strBelongsToStrArray(operator,boolReturnOperands , sizeof(boolReturnOperands)/sizeof(boolReturnOperands[0]));

        if(strcmp(operator,"^")== 0){
            const char * my_math_lib= "double my_exp(double x){double sum=1.0;double term=1.0;for(int n=1;n<20;++n){term*=x/n;sum+=term;}return sum;}\ndouble my_log(double x){if(x<=0.0)return -1e308;double y=(x-1)/(x+1);double y2=y*y;double sum=0.0;for(int n=1;n<20;n+=2){sum+=(1.0/n)*y;y*= y2;}return 2*sum;}\ndouble power(double bs,double exp){double r=1.0;int int_exp=(int)exp;double frac_exp=exp-int_exp;while(int_exp){if(int_exp%2)r*=bs;bs*=bs;int_exp/=2;}if(frac_exp!=0.0)r*=my_exp(frac_exp*my_log(bs));return r;}";
            if((strcmp(firstOperand->type, "long") == 0) || (strcmp(secondOperand->type, "long") == 0) && (strcmp(firstOperand->type, "double") == 0) || (strcmp(secondOperand->type, "double") == 0));
            s = cat(6, "power(", firstOperand->code, "+ 0.0", ", ", secondOperand->code, " + 0.0)");
                if(!exists_on_table(type_table, my_math_lib)){
                    add_to_table(type_table, my_math_lib, "#IMPORT");
                }
                /* return create_entry(s, "double"); */
                t = "double";
        }
        else if((strcmp(firstOperand->type,"long")== 0) && (strcmp(secondOperand->type,"double")== 0)){
            s = cat(5, "( (double)", firstOperand->code, ") ", operator, secondOperand->code);
            /* return create_entry(s, secondOperand->type); */
            t=secondOperand->type;
        }
        else if((strcmp(firstOperand->type,"double")== 0) && (strcmp(secondOperand->type,"long")== 0)){
            s = cat(5, firstOperand->code, operator, "( (double)", secondOperand->code, ") ");
            /* return create_entry(s, firstOperand->type); */
            t = firstOperand->type;
        }
        else{
            checkTypeBinaryExpression(firstOperand, secondOperand, operator);
            s = cat(3, firstOperand->code, operator, secondOperand->code);
        }

        if(isBoolReturnOperand){
            t = "bool";
        }
        
        //printf("\tExpression: %s\n\tExprType: %s\n",s,firstOperand->type);
        return create_entry(s, t);
    }

} 

entry* getEntryForUnaryExprPrefix(entry *operand, char * operator){
    checkTypeUnaryExpression(operand, operator);
    char* s;
    if(strcmp(operator,"-")== 0){
        s = cat(4, "(", operator , operand->code, ")");
    }
    else{
        s = cat(4, "(", operator, operand->code, ")");
    }
    return create_entry(s, operand->type);
}

entry* getEntryForUnaryExprSufix(entry *operand, char * operator){
    checkTypeUnaryExpression(operand, operator);
    char* s = cat(4, "(", operand->code, operator, ")");
    return create_entry(s, operand->type);
}

char* convertToStirng(entry *operand){
    const char* string_conversion_lib = "#define BUF_SZ 50\nstatic char buf[BUF_SZ];\nconst char *d_to_s(double v){snprintf(buf, BUF_SZ, \"%f\", v);return buf;}\nconst char *b_to_s(int v){return v ? \"true\" : \"false\";}\nconst char *i_to_s(long v){snprintf(buf, BUF_SZ, \"%ld\", v);return buf;}\nconst char *c_to_s(char v){snprintf(buf, BUF_SZ, \"%c\", v);return buf;}";
    if(!exists_on_table(type_table, string_conversion_lib)){
        add_to_table(type_table, string_conversion_lib, "#IMPORT");
    }
    char* s;
    if(strcmp(operand->type, "long") == 0){

        s = cat(3, "i_to_s(", operand->code, ")");
    }
    else if(strcmp(operand->type, "double") == 0){
        s = cat(3, "d_to_s(", operand->code, ")");
    }
    else if(strcmp(operand->type, "char") == 0){
        s = operand->code;
        s[0] = s[2] = '\"';
    }
    else if(strcmp(operand->type, "bool") == 0){
        if(strcmp(operand->code, "1") == 0){ 
            s = "\"true\"";
        }
        else{
            s = "\"false\"";
        }
    }
    return s;
}
void checkTypeBinaryExpression(entry *firstOperand, entry *secondOperand, char * operator){
    //printf("first operand: code[%s] type[%s]\n", firstOperand->code, firstOperand->type);
    //printf("second operand: code[%s] type[%s]\n", secondOperand->code, secondOperand->type);
    if(strcmp(firstOperand->type,secondOperand->type)){
        yyerror(cat(5,"invalid operands, ", firstOperand->type, " and ", secondOperand->type, " are not compatible"));
    }
    if(!isTypeValidForOperator(firstOperand->type, operator)){
        yyerror(cat(4,"operator \"", operator,"\" does not suport support operand of type: ", firstOperand->type ));
    }
}

void checkTypeUnaryExpression(entry *firstOperand, char* operator){
    //printf("unique operand: code[%s] type[%s]\n", firstOperand->code, firstOperand->type);
    if(!isTypeValidForOperator(firstOperand->type, operator)){
        yyerror(cat(4,"operator \"", operator,"\" does not suport support operand of type: ", firstOperand->type ));
    }
}

int isTypeValidForOperator(char* type, char* operator){
    char *intValidOperands[] = { "+", "-", "/", "/-", "*", "*-", "%", "^", "==","!=",">","<",">=","<=","++","--" };
    int isValidForInt = (strcmp(type, "long") == 0) && strBelongsToStrArray(operator,intValidOperands , sizeof(intValidOperands)/sizeof(intValidOperands[0]));

    char *decimalValidOperands[] = { "+", "-", "/", "/-", "*", "*-", "^", "==","!=",">","<",">=","<=" };
    int isValidForDecimal = (strcmp(type, "double") == 0) && strBelongsToStrArray(operator,decimalValidOperands , sizeof(decimalValidOperands)/sizeof(decimalValidOperands[0]));

    char *boolValidOperands[] = {"==","!=", "&&", "||", "!"};
    int isValidForBool = (strcmp(type, "bool") == 0) && strBelongsToStrArray(operator,boolValidOperands, sizeof(boolValidOperands)/sizeof(boolValidOperands[0]));

    char *charValidOperands[] = {"+", "-", "/", "*","%", "==","!=",">","<",">=","<="};
    int isValidForChar = (strcmp(type, "char") == 0) && strBelongsToStrArray(operator,charValidOperands, sizeof(charValidOperands)/sizeof(charValidOperands[0]));

    char *stringValidOperands[] = {"+", "==", "!="};
    int isValidForString = (strcmp(type, "string") == 0) && strBelongsToStrArray(operator,stringValidOperands, sizeof(stringValidOperands)/sizeof(stringValidOperands[0]));

    if(isValidForInt){
        return 1;
    }
    else if(isValidForDecimal){
        return 1;
    }
    else if(isValidForBool){
        return 1;
    }
    else if(isValidForChar){
        return 1;
    }
    else if(isValidForString){
        return 1;
    }
    else{
        return 0;
    }
}

int strBelongsToStrArray( char* str, char *array[], int strArrayLength){
    //printf("tamanho do array: %d\n", strArrayLength);
    for(int i=0; i<strArrayLength; i++){
        if(strcmp(str, array[i]) == 0){
            //printf("achou %s é igual a %s\n", str, array[i]);
            return 1;
        }
    }
    return 0;
}

void checkAtrib(char* id, entry* expr){
    char * variable = cat(3, id, "#", concat_stack_with_delimiter(scope_stack, "#"));
    //printf("variable %s atrib with %s\n", variable, expr->code);
    if(exists_on_table(type_table, variable)) {
        if(strcmp(expr->type, get_value_from_table(type_table,variable)) != 0){
            yyerror(cat(4,"invalid attribution, variable of type ", expr->type, " can't recieve a value of type ",get_value_from_table(type_table,variable)));
        }
        //printf("variable type is %s atrib with an expression of %s type\n", get_value_from_table(type_table,variable), expr->type);
    }
    free(variable);
}

char* getLiteralType(char* variableType){
    if(strcmp(variableType, "int") == 0){
        return "long";
    }
    else if(strcmp(variableType, "decimal") == 0){
        return "double";
    }
    else if(strcmp(variableType, "string") == 0){
        return "string";
    }
    else if(strcmp(variableType, "bool") == 0){
        return "bool";
    }
    else if(strcmp(variableType, "char") == 0){
        return "char";
    }
    else{
        return "NOTVALID";
    }
}

void remove_content_inside_brackets(char* str) {
    int length = strlen(str);
    int write_pos = 0;
    int inside_brackets = 0;

    for (int i = 0; i < length; i++) {
        if (str[i] == '[') {
            inside_brackets = 1;
            str[write_pos++] = '[';
        } else if (str[i] == ']') {
            inside_brackets = 0;
            str[write_pos++] = ']';
        } else if (!inside_brackets) {
            str[write_pos++] = str[i];
        }
    }
    str[write_pos] = '\0';
}