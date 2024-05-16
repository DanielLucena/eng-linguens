/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    PRIMITIVE = 259,               /* PRIMITIVE  */
    ARRAY = 260,                   /* ARRAY  */
    INTEGER = 261,                 /* INTEGER  */
    CARACTERE = 262,               /* CARACTERE  */
    DOUBLE = 263,                  /* DOUBLE  */
    STRING = 264,                  /* STRING  */
    PROGRAM = 265,                 /* PROGRAM  */
    SUBPROGRAM = 266,              /* SUBPROGRAM  */
    COMPARISON = 267,              /* COMPARISON  */
    DIFFERENT = 268,               /* DIFFERENT  */
    LESS_THAN = 269,               /* LESS_THAN  */
    MORE_THAN = 270,               /* MORE_THAN  */
    LESS_THAN_EQUALS = 271,        /* LESS_THAN_EQUALS  */
    MORE_THAN_EQUALS = 272,        /* MORE_THAN_EQUALS  */
    PLUS = 273,                    /* PLUS  */
    MINUS = 274,                   /* MINUS  */
    POWER = 275,                   /* POWER  */
    TIMES = 276,                   /* TIMES  */
    SPLIT = 277,                   /* SPLIT  */
    MOD = 278,                     /* MOD  */
    INCREMENT = 279,               /* INCREMENT  */
    DECREMENT = 280,               /* DECREMENT  */
    FACTORIAL = 281,               /* FACTORIAL  */
    TERNARY = 282,                 /* TERNARY  */
    HASH = 283,                    /* HASH  */
    AND = 284,                     /* AND  */
    OR = 285,                      /* OR  */
    PIPE = 286,                    /* PIPE  */
    AMPERSAND = 287,               /* AMPERSAND  */
    MAP = 288,                     /* MAP  */
    VOID = 289,                    /* VOID  */
    IMPORT = 290,                  /* IMPORT  */
    STATIC = 291,                  /* STATIC  */
    COMMENT = 292,                 /* COMMENT  */
    IF = 293,                      /* IF  */
    ELSE = 294,                    /* ELSE  */
    FOR = 295,                     /* FOR  */
    RETURN = 296,                  /* RETURN  */
    SWITCH = 297,                  /* SWITCH  */
    CASE = 298,                    /* CASE  */
    BREAK = 299,                   /* BREAK  */
    CONTINUE = 300,                /* CONTINUE  */
    DO = 301,                      /* DO  */
    WHILE = 302,                   /* WHILE  */
    TRY = 303,                     /* TRY  */
    CATCH = 304,                   /* CATCH  */
    FINALLY = 305,                 /* FINALLY  */
    THROW = 306                    /* THROW  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define ID 258
#define PRIMITIVE 259
#define ARRAY 260
#define INTEGER 261
#define CARACTERE 262
#define DOUBLE 263
#define STRING 264
#define PROGRAM 265
#define SUBPROGRAM 266
#define COMPARISON 267
#define DIFFERENT 268
#define LESS_THAN 269
#define MORE_THAN 270
#define LESS_THAN_EQUALS 271
#define MORE_THAN_EQUALS 272
#define PLUS 273
#define MINUS 274
#define POWER 275
#define TIMES 276
#define SPLIT 277
#define MOD 278
#define INCREMENT 279
#define DECREMENT 280
#define FACTORIAL 281
#define TERNARY 282
#define HASH 283
#define AND 284
#define OR 285
#define PIPE 286
#define AMPERSAND 287
#define MAP 288
#define VOID 289
#define IMPORT 290
#define STATIC 291
#define COMMENT 292
#define IF 293
#define ELSE 294
#define FOR 295
#define RETURN 296
#define SWITCH 297
#define CASE 298
#define BREAK 299
#define CONTINUE 300
#define DO 301
#define WHILE 302
#define TRY 303
#define CATCH 304
#define FINALLY 305
#define THROW 306

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 11 "adpp_parser.y"

	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    double fValue; /* double value */
	

#line 177 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
