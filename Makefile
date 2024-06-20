BIN_DIRECTORY := bin

all: compile_problems
	
build: create_bin_directory
	@echo "BUILDING COMPILER"

	lex -o bin/adpp.yy.c adpp_lexer.l

	yacc adpp_parser.y -d -v

	mv y.tab.c bin/y.tab.c
	mv y.tab.h bin/y.tab.h
	mv y.output bin/y.output

	gcc -o ADPP bin/adpp.yy.c bin/y.tab.c lib/entry.c lib/hash_table.c lib/stack.c

test: clean build
	@echo "COMPILING TESTS\n"

	@echo "TEST 1\n"
	./ADPP tests/simple.adpp

compile_problems: clean build
	@echo "COMPILING EXAMPLE PROBLEMS\n"

	@echo "PROBLEM 1\n"
	./ADPP problems/1_problem.adpp
	gcc problems/1_problem.output.c -o problems/1_problem -lm

	@echo "PROBLEM 2\n"
	./ADPP problems/2_problem.adpp
	gcc problems/2_problem.output.c -o problems/2_problem -lm
	
	@echo "PROBLEM 3\n"
	./ADPP problems/3_problem.adpp
	gcc problems/3_problem.output.c -o problems/3_problem -lm
	
	@echo "PROBLEM 4\n"
	./ADPP problems/4_problem.adpp
	gcc problems/4_problem.output.c -o problems/4_problem -lm
	
	@echo "PROBLEM 5\n"
	./ADPP problems/5_problem.adpp
	gcc problems/5_problem.output.c -o problems/5_problem -lm
	
	@echo "PROBLEM 6\n"
	./ADPP problems/6_problem.adpp
	gcc problems/6_problem.output.c -o problems/6_problem -lm
clean:
	clear
	
	@echo "CLEANING"

	rm -f ADPP
	rm -f bin/*.yy.c
	rm -f bin/*.dot
	rm -f bin/*.tab.c
	rm -f bin/*.tab.h
	rm -f bin/*.output

	rm -f examples/*.output.c

create_bin_directory:
	@if [ ! -d "$(BIN_DIRECTORY)" ]; then \
        mkdir -p "$(BIN_DIRECTORY)"; \
    fi

sint:
	lex adpp_lexer.l

	yacc adpp_parser.y -d -v -g  

	gcc lex.yy.c y.tab.c -o parser.exe 
	./parser.exe < examples/quicksort.adpp