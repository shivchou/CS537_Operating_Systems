#include "types.h"
#include "stat.h"
#include "user.h"

#define MAXSIZE 16

char p[MAXSIZE];

int main(void) 
{
  getcwd(p,MAXSIZE);
  printf(1, "%s\n", p);
  exit();
}

