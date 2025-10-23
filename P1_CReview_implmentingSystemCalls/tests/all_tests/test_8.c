#include "types.h"
#include "user.h"

// testing after calling chdir with an invalid directory name.
int main(int argc, char* argv[]) {
  printf(1, "XV6_TEST_OUTPUT before changing directory.\n");
  int rv;

  if ((rv=chdir("doesnotexist")) >= 0) {
    printf(1, "XV6_TEST_ERROR chdir unexpectedly succeeded.\n");
    exit();
  } else {
    printf(1, "XV6_TEST_OUTPUT chdir(\"doesnotexist\") failed as expected.\n", rv);
  }

  char buf[16];
  rv=getcwd(buf,16);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d.\n", buf, rv);
  exit();
}