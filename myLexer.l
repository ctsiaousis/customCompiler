%{
#include <stdio.h>
#include <string.h>
#include "cgen.h"
#include "myParser.tab.h"

int line_num = 1;

%}
/* Allowed IDENTIFIER for variables */
IDENTIFIER		[A-Za-z_][0-9a-zA-Z_]*

/* NUMBERology */
digit			[0-9]
INTEG		    [+-]?{digit}{digit}*
decimal			([+-]?"."{INTEG})|([+-]?{INTEG}("."{INTEG}?)?)
NUMBER			{decimal}([Ee][+-]?{INTEG})?

/* boolean constants */
boolean			("true"|"false")

/* constant strings (a backslash to escape backslash or ") */
escapechars		("\\n"|"\\t"|"\\r"|"\\\\"|"\\\"")
specialchars	("~"|"!"|"@"|"#"|"$"|"%"|"^"|"&"|"*"|"?"|"."|"/"|"=")
text			([A-Za-z0-9]*)|" "|{escapechars}|{specialchars}
STRING          \"{text}*\"

/* delimiters */
delimiters		(";"|","|":")

%x note

%%
"+"             return '+';
"*"             return '*';
"-"             return '-';
"/"             return '/';
"%"             return '%';
")"             return ')';
"("             return '(';
"}"             return '}';
"{"             return '{';
"]"             return ']';
"["             return '[';
"**"            return KW_POWER;
"=="            return CMP_EQ;
"<"             return CMP_LESS;
"<="            return CMP_LESSEQ;
"!="            return CMP_NOTEQ;
"="             { return ASSIGN; }

boolean			return KW_BOOLEAN;
void			return KW_VOID;
true			return KW_TRUE;
false			return KW_FALSE;
var			    return KW_VAR;
const			return KW_CONST;
if			    return KW_IF;
else			return KW_ELSE;
for			    return KW_FOR;
while			return KW_WHILE;
function		return KW_FUNCTION;
break			return KW_BREAK;
continue		return KW_CONTINUE;
not			    return KW_NOT;
and			    return KW_AND;
or			    return KW_OR;
return			return KW_RETURN;
null			return KW_NULL;
start           return KW_START;
number          return KW_NUMBER;
string          return KW_STRING;


{delimiters}    return KW_DELIM;

{IDENTIFIER}    { yylval.string = strdup(yytext); return KW_IDENTIFIER; }

{NUMBER}        { yylval.string = strdup(yytext); return KW_NUMBER; }

{STRING}        { yylval.string = strdup(yytext); return KW_STRING; }

"//"[^\n]*      /* eat line comments */
"/*"                    BEGIN(note);
<note>[^*\n]*       /* eat anything that's not a '*' */
<note>"*"+[^*/\n]*  /* eat up '*'s not followed by '/'s */
<note>\n        ++line_num;
<note>"*"+"/"       { BEGIN(INITIAL);}

<<EOF>>         return EOF;

[ \r\t]             /* skip demn white */

\n          ++line_num;
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", line_num, yytext); };


%%

