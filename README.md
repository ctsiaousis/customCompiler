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
Any characters after the '//' symbol until \n is read.   
### Whitespace
Any whitespace is accepted.   

## Grammar


