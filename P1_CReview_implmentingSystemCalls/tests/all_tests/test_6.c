#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
    printf(1, "XV6_TEST_OUTPUT Before forking.\n");
    int rv;
    char buf[16];
    if ((rv=mkdir("foobar")) < 0){
      printf(1, "XV6_TEST_ERROR mkdir failed with rv %d.\n",rv);
    }
    if ((rv=chdir("foobar")) < 0) {
      printf(1, "XV6_TEST_ERROR chdir failed with rv %d.\n",rv);
    }
    int pid = fork();
    if (pid > 0) {
      wait(); //Parent waits
      printf(1, "XV6_TEST_OUTPUT Parent waited for child.\n");
      rv=getcwd(buf,16);
      printf(1, "XV6_TEST_OUTPUT getcwd in parent returned %s with return value of %d.\n", buf, rv);
      if ((rv=chdir("..")) < 0) {
        printf(1, "XV6_TEST_ERROR chdir failed with rv %d.\n",rv);
      }
      rv=getcwd(buf,16);
      printf(1, "XV6_TEST_OUTPUT getcwd in parent returned %s with return value of %d.\n", buf, rv);
    } else {
      rv=getcwd(buf,16);
      printf(1, "XV6_TEST_OUTPUT getcwd in child returned %s with return value of %d.\n", buf, rv);
      if ((rv=mkdir("blah")) < 0){
        printf(1, "XV6_TEST_ERROR mkdir failed with rv %d.\n",rv);
      }
      if ((rv=chdir("blah")) < 0) {
        printf(1, "XV6_TEST_ERROR chdir failed with rv %d.\n",rv);
      }
      rv=getcwd(buf,16);
      printf(1, "XV6_TEST_OUTPUT getcwd in child returned %s with return value of %d.\n", buf, rv);
    }
    exit();
}
