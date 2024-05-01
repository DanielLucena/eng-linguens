## Lexical Analyzer for ADPP Language

### Overview

A lexical analyzer, or lexer, is a crucial component of a compiler responsible for transforming source code into meaningful tokens. This readme explains the operation of a lexical analyzer developed using Lex for the ADPP language.

### Execution

To run the ADPP lexical analyzer and execute the provided example (quicksort.adpp), follow these steps:

1. **Makefile Setup**: Ensure you have the necessary tools installed, including Lex and GCC.

2. **Compile and Run**:
   - Open a terminal.
   - Navigate to the directory containing the Makefile and ADPP files.
   - Simply type `make` and press Enter.

### Makefile Commands

The provided Makefile automates the build and execution process:

- **`make`**: This command triggers the default target defined in the Makefile, which is `all`.
  - It first creates the `bin` directory if it doesn't exist.
  - Then, it generates the C source code (`bin/adpp.yy.c`) from the Lex specification (`adpp_lexer.l`).
  - Finally, it compiles the generated C code to produce the `ADPP` executable.

### Running the Lexical Analyzer

After running `make`, the following steps occur:

1. **Build Process**:
   - Lex reads `adpp_lexer.l` and generates `bin/adpp.yy.c`.
   - GCC compiles `bin/adpp.yy.c` to create the `ADPP` executable in the current directory.

2. **Execution**:
   - Once compilation is complete, the Makefile automatically runs the `ADPP` executable with `quicksort.adpp` as input.
   - The `ADPP` program processes `quicksort.adpp`, identifies tokens based on lexical rules defined in `adpp_lexer.l`, and performs associated actions.

### Clean Up

- **`make clean`**: This command removes the `ADPP` executable and any intermediate files created during the build process.

### Language Details

The ADPP language is defined by lexical rules specified in `adpp_lexer.l`. These rules identify various token types such as keywords, identifiers, operators, and literals.

### Example Execution

By simply running `make` in the terminal, you initiate the complete process of building and executing the ADPP lexical analyzer on the `quicksort.adpp` example. The output will display the identified tokens and any relevant messages or errors generated during analysis.

### Conclusion

This setup allows for streamlined testing and development of the ADPP lexical analyzer, facilitating efficient processing of ADPP source code into meaningful tokens.
