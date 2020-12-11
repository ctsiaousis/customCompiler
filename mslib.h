#ifndef MSLIB_H
#define MSLIB_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void writeString(const char* s) {printf("%s", s);}
void writeNumber(double n) { printf("%0.3lf",n); } 


char* strdup(const char*);

#define BUFSIZE 1024

char* readString() {
  char buffer[BUFSIZE];
  buffer[0] = '\0';
  fgets(buffer, BUFSIZE, stdin);
  
  /* strip newline from the end */
  int blen = strlen(buffer);
  if (blen > 0 && buffer[blen-1] == '\n')
    buffer[blen-1] = '\0';

  return strdup(buffer);
}
#undef BUFSIZE

double readNumber() { return atof(readString()); }

#endif 
