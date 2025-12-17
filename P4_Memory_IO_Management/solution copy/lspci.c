#include "types.h"
#include "user.h"
#include "fcntl.h"

void help()
{
  printf(1, "Basic Display Mode: \n");
  printf(1, "No option                      Display all devices. \n");
  printf(1, "Display Options: \n");
  printf(1, "-h                             Show help. \n");
  printf(1, "-s [bus]:[device].[function]   Show device details. \n");
}

int
main(int argc, char *argv[])
{
  if(argc < 2){
    printf(1, "08:00.0 Toy Device: WISC DPU (rev 537) \n");
    printf(1, "ab:00.0 Toy Device: WISC SSD (rev 537) \n");
    exit();
  }
  else if(strcmp(argv[1], "-h") == 0){
    help();
    exit();
  }
  else if(strcmp(argv[1], "-s") == 0){
    if (strcmp(argv[2], "08:00.0") == 0){
      printf(1, "08:00.0 Toy Device: WISC DPU (rev 537) \n");
      printf(1, "        Physical Slot: 0 \n");
      printf(1, "        Region 0: Memory at 0xFE000000      [size=4K] \n");
      printf(1, "        Region 1: Memory at 0xFE080000      [size=512K] \n");
      printf(1, "        Kernel driver in use: wDPUdriver \n");
      printf(1, "        Kernel modules: wDPUdriver \n");
    }
    else if (strcmp(argv[2], "ab:00.0") == 0){
      printf(1, "ab:00.0 Toy Device: WISC SSD (rev 537) \n");
      printf(1, "        Physical Slot: 1 \n");
      printf(1, "        Region 0: Memory at 0xFE100000      [size=4K] \n");
      printf(1, "        Kernel driver in use: wSSDdriver \n");
      printf(1, "        Kernel modules: wSSDdriver \n");
    }
    else
    {
      printf(1, "Invalid BDF address.\n");
    }
    exit();
  }
  else{
    printf(1, "invalid option \n");
    help();
    exit();
  }
}




