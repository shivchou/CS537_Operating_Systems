#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
  printf(1, "XV6_TEST_OUTPUT Hello world!\n");
  char buf[16];
  int rv=getcwd(buf,16);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d.\n", buf, rv);
  exit();
}
