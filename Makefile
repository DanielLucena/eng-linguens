BIN_DIRECTORY := bin

all: run
	
build: create_bin_directory
	@echo "BUILDING LEXICAL ANALYZER"

	lex -o bin/adpp.yy.c adpp_lexer.l

	yacc adpp_parser.y -d
	mv y.tab.c bin/y.tab.c
	mv y.tab.h bin/y.tab.h
	mv y.output bin/y.output

	gcc -o ADPP bin/adpp.yy.c bin/y.tab.c

run: clean build
	@echo "RUNNING quicksort.adpp\n"
	./ADPP < examples/quicksort.adpp
	./ADPP < examples/exemplo_completo.adpp

clean:
	clear
	
	@echo "CLEANING"

	rm -f ADPP
	rm -f bin/*.yy.c
	rm -f bin/*.dot
	rm -f bin/*.tab.c
	rm -f bin/*.tab.h
	rm -f bin/*.output

create_bin_directory:
	@if [ ! -d "$(BIN_DIRECTORY)" ]; then \
        mkdir -p "$(BIN_DIRECTORY)"; \
    fi

sint:
	lex adpp_lexer.l

	yacc adpp_parser.y -d -v -g  

	gcc lex.yy.c y.tab.c -o parser.exe 
	./parser.exe < examples/quicksort.adpp