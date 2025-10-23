#include "types.h"
#include "stat.h"
#include "user.h"


int
main(void)
{
    printf(1, "XV6_TEST: exec2() test started\n");

    int ret;
    char *argv[3] = {"work", "10", 0};

    // Test exec2 with 0
    ret = exec2(0, "/work", argv);
    if (ret < 0)
        printf(1, "XV6_TEST: exec2(0) returned -1\n");
    if (ret >= 0)
        printf(1, "XV6_TEST: exec2(0) FAILED (expected -1, got %d)\n", ret);

    // Test exec2 with negative value
    ret = exec2(-50, "/work", argv);
    if (ret < 0)
        printf(1, "XV6_TEST: exec2(-50) returned -1\n");
    if (ret >= 0)
        printf(1, "XV6_TEST: exec2(-50) FAILED (expected -1, got %d)\n", ret);

    // Fork a child to run a valid /work process to ensure scheduler still works
    int pid = fork();
    if (pid == 0) {
        exec2(50, "/work", argv);  // valid completion_time
        exit(); 
    }
    if (pid > 0)
        wait();

    printf(1, "XV6_TEST: exec2() test finished\n");
    exit();
}
