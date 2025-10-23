#include "types.h"
#include "user.h"

//testing after changing directories
int main(int argc, char* argv[]) {
  printf(1, "XV6_TEST_OUTPUT before making directory and changing to it.\n");
  int rv;
  if ((rv=mkdir("foobar")) < 0){
    printf(1, "XV6_TEST_ERROR mkdir failed with rv %d.\n",rv);
  }
  if ((rv=chdir("foobar")) < 0) {
    printf(1, "XV6_TEST_ERROR chdir failed with rv %d.\n",rv);
  }
  char buf[16];
  rv=getcwd(buf,16);
  printf(1, "XV6_TEST_OUTPUT getcwd returned %s with return value of %d.\n", buf, rv);
  exit();
}
