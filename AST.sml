structure Tree =
struct 
datatype     AST = AST of PROG
and          PROG = PROG of string * BLK
and          BLK = BLK of DEC list * CMD list
and          DEC = DEC of string * string list * Typ
and          Var = Var of string
and          CMD = SET of string * EXP| INPUT of string | OUTPUT of EXP | ITE of EXP * CMD list * CMD list | WH of EXP * CMD list
and          EXP =  UN of unop*EXP | BIN of binop*EXP*EXP  |INT of int | Variable of string |Boolean of string
and          binop = PLUS|MINUS|TIMES|DIV|MOD|AND|OR|LT|LEQ|EQ|GT|GEQ|NEQ
and          unop = TILDE|NOT
and 	     Typ = Int | Bool

end;
