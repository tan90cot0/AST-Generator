# COL266 Assignment 3
# Aryan Dua
# While Programming language

### File Contents
> * 'while.cm' - Compilation Manager which converts lex and yacc files to sml files and loads them.
* 'while.lex' - Lex file containing the lexical rules
* 'while.yacc' - Yacc file containing grammar rules
* 'while_ast.sml' - SML file which acts as glue code for the Lexer and Parser
* 'AST.sml' - Contains the structure 'Tree' and the datatypes used
* 't1.txt' - test case 1
* 't2.txt' - test case 2
* 't3.txt' - test case 3
* 't4.txt' - test case 4

### How to Run
1. Traverse to the required directory.
2. Open the SML interactive environment
3. Type the command -- CM.make "while.cm"; to manage all the files.
4. If the input is in 't.txt', then to parse it, type -- While.compile "t.txt";
5. The output AST will be displayed on the terminal.

### Context-Free Grammar

> The terminal symbols that I have used are: 
DOUBLECOLON | COLON | SEMICOLON
	| COMMA | RCURL | LCURL | ASSIGN
	| LPAR | RPAR | TILDE | DOUBLEBAR
	| DOUBLEAND | LT | LEQ | EQ | GT
	| GEQ | NEQ | PLUS | MINUS | TIMES
	| DIV | MOD | EXCLAIM | PROGRAM | VAR | INT
	| BOOL| READ | WRITE | IF 
	| THEN | ELSE | ENDIF | WHILE | DO 
	| ENDWH | TT | FF | NUMBER of int | ID of string | EOF | ILLCH

> The non-terminals that I have used are: 
start of AST|
progr of PROG| 
block of BLK| 
declarationseq of DEC list|
declaration of DEC| 
type2 of Typ|
variablelist of string list|
commandseq of CMD list |
command of CMD| 
expression of EXP |
s of string list |
t of CMD list

*  The grammar rules that I have defined for the terminals and non-terminals are:
1. start: progr

2. progr: PROGRAM ID DOUBLECOLON block

3. block: declarationseq commandseq

4. declarationseq: epsilon|declaration declarationseq

5. declaration: VAR variablelist COLON type SEMICOLON

6. type: INT|BOOL

7. variablelist: ID s

8. s:  epsilon|COMMA ID s

9. commandseq: LCURL t RCURL

10. t:  epsilon|command SEMICOLON t

11. command:    ID ASSIGN expression|
READ ID |
WRITE expression |
IF expression THEN commandseq	ELSE commandseq	ENDIF |
WHILE expression DO commandseq	ENDWH

12. expression: expression PLUS expression|
expression MINUS expression|
expression TIMES expression|
expression DIV expression|
expression MOD expression|
expression DOUBLEAND expression|
expression DOUBLEBAR expression|
expression LT expression|
expression LEQ expression|
expression EQ expression|
expression GT expression|
expression GEQ expression|
expression NEQ expression|
TILDE expression|
EXCLAIM expression|
LPAR expression RPAR|
NUMBER|
ID|
TT|
FF

### AST Datatype Definition
> I have made a structure called Tree which contains my AST datatype. My AST datatype is made up of a few more auxiliary datatypes. AST and Tree are defined in AST.sml as:

> structure Tree =
struct
datatype     AST = AST of PROG
and          PROG = PROG of string * BLK
and          BLK = BLK of DEC list * CMD list
and          DEC = DEC of string * string list * Typ
and          Var = Var of string
and          CMD = SET of string * EXP| INPUT of string | OUTPUT of EXP | ITE of EXP * CMD list * CMD list | WH of EXP * CMD list
and          EXP =  UN of unop_EXP | BIN of binop_EXP*EXP  |INT of int | Variable of string |Boolean of string
and          binop = PLUS|MINUS|TIMES|DIV|MOD|AND|OR|LT|LEQ|EQ|GT|GEQ|NEQ
and          unop = TILDE|NOT
and 	     Typ = Int | Bool
end;

> I can refer to any of these user defined datatypes in my .yacc file by mentioning open Tree, or by referring each data type like Tree.datatype. These auxiliary datatypes were created to define the AST datatype.

### Syntax-Directed Translation

1. progr: (PROG(ID, block))

2. block: (BLK(declarationseq, commandseq))

3. declarationseq:	(declaration::declarationseq)

4. declaration: 	(DEC("Var", variablelist,type2))

5. type2: (Int)|(Bool)

6. variablelist: (ID::s)

7. s:  ([])|(ID::s)

8. commandseq:  (t)

9. t:  ([])|  (command::t)

10. command:    (SET(ID, expression))|
(INPUT(ID))|
(OUTPUT(expression))|
(ITE(expression, commandseq1, commandseq2))|
(WH(expression, commandseq))

11. expression:     (BIN(PLUS,expression1, expression2)) |
(BIN(MINUS,expression1, expression2)) |
(BIN(TIMES,expression1, expression2)) |
(BIN(DIV,expression1, expression2))  |
(BIN(MOD,expression1, expression2))   |
(BIN(AND,expression1, expression2)) |
(BIN(OR,expression1, expression2)) |
(BIN(LT,expression1, expression2))   |
(BIN(LEQ,expression1, expression2))   |
(BIN(EQ,expression1, expression2)) |
(BIN(GT,expression1, expression2))   |
(BIN(GEQ,expression1, expression2))   |
(BIN(NEQ,expression1, expression2)) |
(UN(TILDE,expression)) |
(UN(NOT,expression))|
(expression) |
(INT(NUMBER)) |
(Variable(ID)) |
(Boolean("tt")) |
(Boolean("ff"))

### Auxiliary Functions and Data

> Some auxiliary functions and structures are defined in while_ast.sml.
The most important function with regards to the user interface is the compile function. If we enter While.compile filename in the sml interactive environment, the AST for the give file is generated. Here, I have tested filename to be a .txt file.

> The auxiliary datatypes that I have created to define my AST are: 
PROG, DEC, BLK, CMD, Var, EXP, binop, unop, Typ

### Other Design Decisions
1. When I encounter a whitespace, I ignore it and call the lexer again with the same paramters ( continue()).
2. I have defined the precedence of all operators to be either left-associative/right-associative or non-associative

### Other Implementation Decisions
1. In the grammar given in the hypernotes under the heading WHILE programming language, there were a few extra terminals like addOp, relOp, etc. I have removed these. I have also combined the bool and int expression non terminals into one. Since I have defined the operator precedence above, I have merged all the expression commands into 1 single non-terminal named "expression".
2. As type checking was not to be done in this stage, I have combined bool and int expressions into a single entity called expression. This was done to remove the ambiguity between the two, as "variable" was being reduced to both these expressions thus leading to a reduce/reduce conflict. The way to resolve this keeping both bool and int is by doing type checking, which will happen in the next stage. Type checking usually is done after implementing the AST in normal pipelines.

### Acknowledgements

1. Used some ideas from pi.lex(from the user guide.pdf(83 pages)(rogerprice.org)) for val badCh and Tokens.ILLCH.
2. Since the glue code was similar for pi.lex and the parser that I required (because it is a general code), some of the code is similar to that example.