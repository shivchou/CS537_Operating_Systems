#include "types.h"
#include "stat.h"
#include "user.h"


int main(){
    printf(1, "XV6_TEST: workload 1 started\n");
    remain(100);
    int pid = fork();

    if (pid == 0){
        char *argv[3]={"work", "15",0};
        exec2(150, "/work", argv);
    }else{
        spinwait(100);
    }
    printf(1, "XV6_TEST: workload 1 fin\n");
    wait();
    exit();
}