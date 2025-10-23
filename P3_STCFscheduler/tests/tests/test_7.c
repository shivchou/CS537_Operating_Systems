#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
    printf(1, "XV6_TEST: remain() test started\n");

    int ret;

    // Test remain(0)
    ret = remain(0);
    if (ret < 0)
        printf(1, "XV6_TEST: remain(0) returned -1\n");
    else
        printf(1, "XV6_TEST: remain(0) FAILED (expected -1, got %d)\n", ret);

    // Test remain(-50)
    ret = remain(-50);
    if (ret < 0)
        printf(1, "XV6_TEST: remain(-50) returned -1\n");
    else
        printf(1, "XV6_TEST: remain(-50) FAILED (expected -1, got %d)\n", ret);

    // Fork a child to run a short work process to verify scheduler still works
    int pid = fork();
    if (pid == 0) {
        char *argv[3] = {"work", "10", 0}; // work spins for 100ms - 10 ticks
        exec("/work", argv);
    } else {
        wait();
    }

    printf(1, "XV6_TEST: remain() test finished\n");
    exit();
}
