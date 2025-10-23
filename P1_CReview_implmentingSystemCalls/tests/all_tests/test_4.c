#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
  printf(1, "XV6_TEST_OUTPUT Before calling getcwd.\n");
  char *buf = (void*)0;
  int rv=getcwd(buf,16);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d.\n", buf, rv);
  exit();
}
