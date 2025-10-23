#include "types.h"
#include "stat.h"
#include "user.h"


int main(){
    printf(1, "XV6_TEST: workload 1 started\n");
    remain(100);
    spinwait(50);
    int pid = fork();

    //remain should be approx 50
    if (pid == 0){
        remain(90);
        printf(1, "XV6_TEST: Should be reached after the parent finishes\n");
        spinwait(90);
        printf(1, "XV6_TEST: Child fin\n");
        exit();
    }else{
        spinwait(50);
    }
    printf(1, "XV6_TEST: workload 1 fin\n");
    wait();
    exit();
}