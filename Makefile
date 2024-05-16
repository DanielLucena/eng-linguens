BIN_DIRECTORY := bin

all: run_main
	
build: create_bin_directory
	@echo "BUILDING LEXICAL ANALYZER"

	lex -o bin/adpp.yy.c adpp_lexer.l
	gcc -o ADPP bin/adpp.yy.c 

run_all: clean build run_main
	@echo "RUNNING snippet.adpp\n"
	./ADPP < examples/snippet.adpp

run_main: clean build
	@echo "RUNNING quicksort.adpp\n"
	./ADPP < examples/quicksort.adpp

clean:
	clear
	
	@echo "CLEANING"

	rm -f ADPP
	rm -f bin/*.yy.c

create_bin_directory:
	@if [ ! -d "$(BIN_DIRECTORY)" ]; then \
        mkdir -p "$(BIN_DIRECTORY)"; \
    fi

sint:
	lex adpp_lexer.l
	yacc adpp_parser.y -d -v -g  
	gcc lex.yy.c y.tab.c -o parser.exe 
	./parser.exe < examples/quicksort.adpp