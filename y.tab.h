#ifndef _yy_defines_h_
#define _yy_defines_h_

#define ID 257
#define PRIMITIVE 258
#define ARRAY 259
#define INTEGER 260
#define CARACTERE 261
#define DOUBLE 262
#define STRING 263
#define PROGRAM 264
#define SUBPROGRAM 265
#define COMPARISON 266
#define DIFFERENT 267
#define LESS_THAN 268
#define MORE_THAN 269
#define LESS_THAN_EQUALS 270
#define MORE_THAN_EQUALS 271
#define PLUS 272
#define MINUS 273
#define POWER 274
#define TIMES 275
#define SPLIT 276
#define MOD 277
#define INCREMENT 278
#define DECREMENT 279
#define FACTORIAL 280
#define TERNARY 281
#define HASH 282
#define AND 283
#define OR 284
#define PIPE 285
#define AMPERSAND 286
#define MAP 287
#define VOID 288
#define IMPORT 289
#define STATIC 290
#define COMMENT 291
#define IF 292
#define ELSE 293
#define FOR 294
#define RETURN 295
#define SWITCH 296
#define CASE 297
#define BREAK 298
#define CONTINUE 299
#define DO 300
#define WHILE 301
#define TRY 302
#define CATCH 303
#define FINALLY 304
#define THROW 305
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
    double fValue; /* double value */
	} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
