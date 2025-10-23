#include "types.h"
#include "stat.h"
#include "user.h"

// Test give_cpu behavior with only one process.
// The process should yield the CPU, but since there is no other runnable
// process, it should continue running safely.

int
main(void)
{
    printf(1, "XV6_TEST: give_cpu() test started\n");

    remain(100); // remaining time for this single process

    printf(1, "XV6_TEST: before give_cpu\n");
    give_cpu(); // voluntarily yield CPU
    printf(1, "XV6_TEST: after give_cpu\n");

    printf(1, "XV6_TEST: give_cpu() test finished\n");
    exit();
}
