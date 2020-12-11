%{
/*Prologue
 contains macro definitions
 declaration of funcs and vars
 also #includes.
 Everything here is transmitted in the tab.c file.
*/
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "cgen.h"
#define YYDEBUG 1
extern int yylex(void);
extern int line_num;
%}

/*Bison Declarations
 declaration of tokens to communicate with flex.
 terminal symbols and non-terminal (groupings).
*/

%union {
char* string;
double val;
}

%token <string> KW_IDENTIFIER
%token <string> KW_NUMBER
%token <string> KW_STRING

%left ASSIGN

%start program

%left KW_DELIM
%token KW_BOOLEAN
%token KW_VOID
%token KW_TRUE
%token KW_FALSE
%token KW_VAR
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_FUNCTION
%token KW_BREAK
%token KW_CONTINUE
%right KW_NOT
%left KW_AND
%left KW_OR
%token KW_RETURN
%token KW_NULL
%token KW_POWER
%left CMP_EQ
%left CMP_LESS
%left CMP_LESSEQ
%left CMP_NOTEQ
%expect 1

%right '+'
%right '-'
%left '*'
%left '/'
%left '%'
%left '(' '{' '[' '<'
%left ')' '}' ']' '>'
%left '='

%token <val> NUM

%token KW_START
%type <string> decl_list body decl decl_list_item_id
%type <string> const_decl_list const_decl_list_item
%type <string> type_spec op_list operations
%type <string> expr iden arrdec
%type <string> func_call func_call_parameters
%type <string> func_decl func_decl_parameters
%type <string> if_st ret_st for_st

%debug
%define parse.error verbose

%%
/*Grammar Rules
 Most important part of my bison file.
 Speaks for itself, at least one rule.
*/

program:
decl_list KW_FUNCTION KW_START '(' ')' KW_DELIM KW_VOID '{' body '}' {
/* We have a successful parse!
  Check for any errors and generate output.
*/
    if (yyerror_count == 0) {
    // include the mslib.h file
      puts(c_prologue);
      printf("/* program */ \n\n");
      printf("%s\n\n", $1);
      printf("int main() {\n%s\n} \n", $9);
    }
}
;

decl_list:
decl_list decl { $$ = template("%s\n%s", $1, $2); }
| decl { $$ = $1; }
;

decl:
KW_CONST const_decl_list KW_DELIM type_spec KW_DELIM { $$ = template("const %s %s;", $4, $2); }
|func_decl {$$ = $1;}
;

const_decl_list:
const_decl_list KW_DELIM const_decl_list_item{ $$ = template("%s, %s", $1, $3); }
| const_decl_list_item { $$ = template("%s", $1); }
;

const_decl_list_item:
decl_list_item_id ASSIGN expr { $$ = template("%s = %s", $1, $3);}
;

decl_list_item_id:
KW_IDENTIFIER { $$ = $1; }
| KW_IDENTIFIER '['']' { $$ = template("*%s", $1); }
;

type_spec: //antistoixia sthn c99
KW_NUMBER { $$ = "double"; }
| KW_STRING { $$ = "char*"; }
| KW_VOID { $$ = "void"; }
| KW_BOOLEAN { $$ = "int"; }
;

iden: //otidipote mporei na ginei me identifiers. to KW_DELIM to orizo sta operations
KW_IDENTIFIER  {$$ =template ("%s",$1);}
|KW_IDENTIFIER arrdec {$$=template ("%s %s",$1,$2);}
|KW_IDENTIFIER ASSIGN expr {$$ =template ("%s = %s",$1,$3);}
|KW_IDENTIFIER arrdec ASSIGN expr {$$=template ("%s %s = %s",$1,$2,$4);}
|KW_IDENTIFIER ASSIGN func_call {$$ =template ("%s = %s",$1,$3);}
|KW_IDENTIFIER arrdec ASSIGN func_call {$$=template ("%s %s = %s",$1,$2,$4);}
|KW_VAR iden KW_DELIM type_spec {$$ = template("%s %s",$4,$2);}
//|KW_IDENTIFIER KW_DELIM iden {$$ = template("%s , %s", $1, $3);}
;


body: //useless but ok
op_list {$$ = $1;}
;

arrdec: //antistoixeia pinakwn sthn c99
'[' expr ']' {$$ = template("[%s]",$2);}
| '[' ']' {$$ = template("");}
|'[' expr ']' arrdec {$$ = template("[%s]%s",$2,$4);}
;

func_decl: //function declaration
KW_FUNCTION KW_IDENTIFIER '(' func_decl_parameters ')' KW_DELIM type_spec '{' op_list '}' KW_DELIM {$$= template ("%s %s(%s){\n%s\n}\n",$7,$2,$4,$9);}
|KW_FUNCTION KW_IDENTIFIER '(' func_decl_parameters ')' KW_DELIM type_spec '{' op_list '}' {$$= template ("%s %s(%s){\n%s\n}\n",$7,$2,$4,$9);}
;
func_decl_parameters: //parametroi declaration
{$$= template("");}
|KW_IDENTIFIER KW_DELIM type_spec {$$= template ("%s %s",$3,$1);}
|KW_IDENTIFIER KW_DELIM type_spec KW_DELIM func_decl_parameters {$$= template ("%s %s,%s",$3,$1,$5);}
;

func_call: //klisi sunarthshs
KW_IDENTIFIER '(' func_call_parameters ')' {$$= template ("%s(%s)",$1,$3);}
;
func_call_parameters: //parametroi klisis
{$$= template("");}
|expr {$$= template ("%s",$1);}
|expr KW_DELIM func_call_parameters {$$= template ("%s , %s",$1,$3);}
;

op_list: //suntheta statements. Ylopoihsa ta brackets sta if/while/for kai den prolabainw na kanw allages
operations {$$ = $1;}
|operations op_list {$$= template("%s %s ",$1,$2);}
;

operations: //apla statements sta opoia epitrepw:
func_call KW_DELIM {$$= template ("%s;\n",$1);} //klhseis sunarthsewn
//|func_decl {$$ = $1;}
|iden KW_DELIM{$$= template ("%s;\n",$1);} //anatheseis kai dhlwseis stous identifiers
//|expr KW_DELIM {$$ = template("%s;\n",$1);}
|if_st {$$ = $1;} //if statements
|KW_WHILE '(' expr ')' '{' op_list '}' KW_DELIM {$$ = template("while (%s) {\n %s \n}\n",$3,$6);} //while statement
|for_st {$$ = $1;} //for statements
|KW_BREAK KW_DELIM {$$ = template("break;\n");} //break & continue ta opoia isws na eprepe na dexomai mono
|KW_CONTINUE KW_DELIM {$$ = template("continue;\n");} //inside loops. den prolavainw omws na to thewrhsw shmantiko lathos grammatikis
|ret_st KW_DELIM {$$ = template("%s;\n",$1);} //kai return statements
;

if_st: //from bison manual
  KW_IF '(' expr ')' operations KW_ELSE operations {$$ = template("if (%s) {\n %s \n} else {\n %s \n}\n",$3,$5,$7);}
| KW_IF '(' expr ')' operations {$$ = template("if (%s) {\n %s \n}\n",$3,$5);}
| KW_IF '(' expr ')' '{' op_list '}' KW_ELSE '{' op_list '}' KW_DELIM {$$ = template("if (%s) {\n %s \n} else {\n %s \n}\n",$3,$6,$10);}
| KW_IF '(' expr ')' operations KW_ELSE '{' op_list '}' KW_DELIM {$$ = template("if (%s) {\n %s \n} else {\n %s \n}\n",$3,$5,$8);}
| KW_IF '(' expr ')' '{' op_list '}' KW_DELIM {$$= template("if (%s) {\n %s \n}\n",$3,$6);}
;

for_st: //for statement
KW_FOR '(' iden KW_DELIM expr KW_DELIM iden ')' '{' op_list '}' KW_DELIM {$$ = template("for (%s; %s; %s) {\n %s \n}",$3,$5,$7,$10);}
|KW_FOR '(' iden KW_DELIM iden ')' '{' op_list '}' KW_DELIM {$$ = template("for (%s; 1; %s) {\n %s \n}",$3,$5,$8);}
;

ret_st: //return statement
KW_RETURN expr  {$$= template("return %s",$2);}
| KW_RETURN {$$ = template("return");}
;

expr: //exprations
KW_FALSE {$$ = template ("0");}
| KW_TRUE {$$ = template ("1");}
| KW_IDENTIFIER {$$= template ("%s",$1);}
| KW_NUMBER {$$= template ("%s",$1);}
| KW_STRING {$$= template ("%s",$1);}
| '-' expr {$$= template ("-%s",$2);}
| '+' expr {$$= template ("+%s",$2);}
| expr KW_AND expr  {$$ = template ("%s && %s",$1,$3);}
| expr KW_OR expr {$$ = template ("%s || %s",$1,$3);}
| KW_NOT expr {$$=template("!%s", $2);}
| expr CMP_LESS expr {$$ = template ("%s < %s",$1,$3);}
| expr CMP_EQ expr {$$ = template ("%s == %s",$1,$3);}
| expr CMP_NOTEQ expr {$$ = template ("%s != %s",$1,$3);}
| expr CMP_LESSEQ expr {$$ = template ("%s <= %s",$1,$3);}
| expr '+' expr {$$=template("%s + %s", $1, $3);}
| expr '-' expr {$$=template("%s - %s",$1, $3);}
| expr '*' expr {$$=template("%s * %s",$1, $3);}
| expr '/' expr {$$=template("%s / %s", $1, $3);}
| expr '%' expr {$$=template("%s %% %s", $1, $3);}
| '(' expr ')' {$$=template("(%s)", $2);}
;

%%

/*Epilogue
 Also trasmitted to the c file. If declared a
 func, implement it here!
*/
int main () {
  if ( yyparse() == 0 )
    printf("/* oooowee it's ACCEPTED!*/\n");
  else
    printf("Rejected!\n");
}
