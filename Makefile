#custom compiler with flex and bison
ifndef DEBUG
# Default: compile for debug
DEBUG=1
endif

CC = gcc

BASICFLAGS= -std=c99

DEBUGFLAGS=  -g
OPTFLAGS= -g -finline -march=native -O3 -DNDEBUG

INCLUDE_PATH=-I.

CFLAGS= -Wall -D_GNU_SOURCE $(BASICFLAGS)

ifeq ($(DEBUG),1)
CFLAGS+=  $(DEBUGFLAGS) $(PROFFLAGS) $(INCLUDE_PATH)
else
CFLAGS+=  $(OPTFLAGS) $(PROFFLAGS) $(INCLUDE_PATH)
endif

all : customCompiler good1 good2
	@echo "------------------------------------------------------------------------------------------"
	@echo "I've created the correct examples in the programs directory"
	@echo "To easily check the wrong examples type [make bad1] or [make bad2]"
	@echo "To create the c executables from the correct files type [make good1exe] or [make good2exe]"
	@echo "------------------------------------------------------------------------------------------"

customCompiler : bison.l lex.yy.c compile

compile:
	$(CC) $(CFLAGS) -o executable lex.yy.c myParser.tab.c cgen.c -lfl

lex.yy.c :
	flex myLexer.l

bison.l :
	bison -d -v -r all myParser.y

clean :
	rm lex.yy.c executable *.tab.* *.output programs/*.c programs/*.exe

remake : clean all

good1:
	./executable < programs/good_1.ms > programs/good_1.c

good2:
	./executable < programs/good_2.ms > programs/good_2.c

bad1:
	./executable < programs/bad_1.ms > programs/bad_1.c

bad2:
	./executable < programs/bad_2.ms > programs/bad_2.c

good1exe:
	$(CC) -std=c99 -Wall -o programs/good_1.exe programs/good_1.c

good2exe:
	$(CC) -std=c99 -Wall -o programs/good_2.exe programs/good_2.c
