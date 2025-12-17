Task 5: Processing Tasks on DPU

In this task, you should write codes to correctly perform computing tasks with the DPU.

File ```task.c``` and ```task.h``` defines the computing task functions you call from user space. 

### Computing Task 1: Hash function

A hash processor on DPU will return hashed value given input and key. All values are uint.

| Register | Definition                              |
|----------|-----------------------------------------|
| 11       | Set to 1 to start Hash Computing. |
| 12       | Input integer |
| 13       | Hash Key |
| 14       | Host polling address for the hash completion |
| 15       | Hash value return |


### Computing Task 2: Vector computing

A vector computing engine on DPU takes in two vector with the same length and computers their inner product.

| Register | Definition                              |
|----------|-----------------------------------------|
| 21       | Set to 1 to start Vector Computing. |
| 22       | Vector length |
| 23       | Vector 1 address in DPU memory. |
| 24       | Vector 2 address in DPU memory. |
| 25       | Host polling address for the vector completion |
| 26       | Inner product return |

Notice: Device writes 1 to polling address to indicate an event completion.

Test 10-11 will test your hash and vector computing and print the returned values.

