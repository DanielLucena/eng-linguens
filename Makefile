BIN_DIRECTORY := bin

all: clean run
	@echo "RUNNING quicksort.adpp"
	
	./ADPP < examples/snippet.adpp

build: create_bin_directory
	@echo "BUILDING LEXICAL ANALYZER"

	lex -o bin/adpp.yy.c adpp_lexer.l
	gcc -o ADPP bin/adpp.yy.c -ll

run: clean build
	@echo "RUNNING quicksort.adpp"
	
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