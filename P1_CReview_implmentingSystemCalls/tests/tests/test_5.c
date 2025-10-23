#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
  printf(1, "XV6_TEST_OUTPUT Before calling getcwd.\n");
  char buf[16];
  int rv=getcwd(buf,0);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d for size of 0.\n", buf, rv);
  rv=getcwd(buf,-1);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d for size of -1.\n", buf, rv);
  exit();
}
