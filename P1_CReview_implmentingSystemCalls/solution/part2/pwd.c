#include "types.h"
#include "user.h"

int main(int argc, char*argv[])
{
    char buf[16]; 
    int result;
    
    //call getcwd
    result = getcwd(buf, sizeof(buf));
    
    if (result < 0) {
        printf(1, "pwd: error getting current directory\n");
        exit();
    }
    
    printf(1, "%s\n", buf);
    
    exit();
}