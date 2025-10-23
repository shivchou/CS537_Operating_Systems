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
  printf(1, "XV6_TEST_OUTPUT calling pwd from subdirectory:");
  char *args[2];
  args[0] = "../pwd";
  args[1] = 0;
  if(exec("../pwd", args) < 0){
    printf(1, "XV6_TEST_ERROR exec call failed\n");
    exit();
  }
  exit();
}
