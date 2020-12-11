# customCompiler
Accepts a "MiniScript" Context-Free Language based on the `flex` lexical analyzer and `bison`, the GNU tools for creating c files that then gcc uses to compile.

___
___
# MiniScript Language
## Dictionary
This language accepts:
### Keywords
Reserved types of MiniScript
|  |  |    |    |      |
|--------|---------|----------|--------|----------|
| number | boolean | string   | void   | true     |
| false  | var     | const    | if     | else     |
| for    | while   | function | break  | continue |
| not    | and     | or       | return | null     |

### Identifiers
Anything that consists of lowercase characters, uppercase characters or underdash.   
eg. `x   y1   angle   myValue   Distance_02`

### String
Any one-line definition inside `""` or `''`. The escape characters available are `\n, \t, \r, \\, \"`

### Operators
|  |  |    |    |      |
|--------|---------|----------|--------|----------|
| + | - | *   | /   | %     |
| ==  | <=     | <    | !=     |      |
| and    | or   | not |   |  |

### Delimiters
`;   (   )   ,   [   ]   {   }   :`

### Comments
Characters between `/* */`.   
### Line Comments
Any characters after the `//` symbol until `\n` is read.   
### Whitespace
Any whitespace is accepted.   

## Grammar

### Programs
```
const pi = 3.14 : number; //optional
function bla(bli : number, blo : number) : number { return bli+blo; } //also optional
var listOfNums[10] : int; //also optional

function start() : void { //obligatory (main equivilant)
    var x: number;
    x = 1 + 2 + 3 + 4;
    writeNumber(x);
    return 0;
}
```

### Data Types
**number:** integers and reals.   
**string:** characters.   
**boolean:** logicals.   
**void:** null value.   

Any of the above can be:
* var   
* const   
### Functions
```
function funcName ( variable(s) ) : returnType{
    var localVariables : number; // optional
    function_body
    return expression; //optional
}
```
With this compiler there is also a library that includes these self-explainatory functions:
* function readString(): string  
* function readNumber(): number  
* function writeString(s: string)  
* function writeNumber(n: number)   
for basic input and output.

