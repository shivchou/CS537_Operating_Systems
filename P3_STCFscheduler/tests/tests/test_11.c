#include "types.h"
#include "stat.h"
#include "user.h"

#define WORKNUM 10


void itoa(int i, char *buf) {
    // Get the actual buffer pointer from the pointer-to-pointer
    char *p = buf;
    
    // Use a copy of the integer for calculations
    int temp = i;
    int k = 0; // Index for writing into the buffer

    // 1. Handle the special case where the input integer is 0
    if (temp == 0) {
        p[k++] = '0';
        p[k] = '\0'; // Null-terminate
        return;
    }

    // 2. Convert digits (least significant digit first, so it's reversed)
    while (temp > 0) {
        // Calculate the remainder (last digit) and convert it to ASCII ('0' + digit)
        p[k++] = (temp % 10) + '0';
        
        // Remove the last digit
        temp /= 10;
    }

    // 3. Null-terminate the string at the current position
    p[k] = '\0';

    // 4. Reverse the string back to the correct order
    int start = 0;
    int end = k - 1; // k is the length of the string before null terminator
    
    while (start < end) {
        // Swap characters at start and end indices
        char t = p[start];
        p[start] = p[end];
        p[end] = t;
        
        start++;
        end--;
    }
}


int
main(void)
{
  printf(1, "XV6_TEST: parent start\n");
  int pid[WORKNUM];
  int remainarray[WORKNUM] = {100,180,200,50,30,70,150,120,90,130};
  remain(10);
  for (int i = 0; i< WORKNUM;i++){
    if ((pid[i] = fork()) == 0) {
      remain(remainarray[i]);
      printf(1, "XV6_TEST: proc %d start\n", i);
      give_cpu();
      spinwait(remainarray[i]);
      printf(1, "XV6_TEST: proc %d end\n", i);
      exit();
      
    }
  }
  for (int i=0; i<WORKNUM; i++){
    wait();
  }
  exit();
}