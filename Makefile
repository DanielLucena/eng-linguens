all:
	lex lexer.l
	gcc lex.yy.c
	./a.out < snipet.txt

snippet:
	lex lexer.l
	gcc lex.yy.c
	./a.out < snipet.txt