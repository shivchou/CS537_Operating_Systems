#include "wsh.h"
#include "dynamic_array.h"
#include "utils.h"
#include "hash_map.h"

#include <stdio.h>
#include <errno.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <sys/wait.h>

int rc;
HashMap *alias_hm = NULL;
DynamicArray *cdlHistory = NULL;
int exiting;
FILE *f;

/***************************************************
 * Helper Functions
 ***************************************************/
/**
 * @Brief Free any allocated global resources
 */
void wsh_free(void)
{
  // Free any allocated resources here
  if (alias_hm != NULL)
  {
    hm_free(alias_hm);
    alias_hm = NULL;
  }
  // free dynamic array
  if (cdlHistory != NULL)
  {
    da_free(cdlHistory);
    cdlHistory = NULL;
  }
  // free file
  if (f != NULL)
  {
    fclose(f);
  }
}

/**
 * @Brief Cleanly exit the shell after freeing resources
 *
 * @param return_code The exit code to return
 */
void clean_exit(int return_code)
{
  wsh_free();
  exit(return_code);
}

/**
 * @Brief Print a warning message to stderr and set the return code
 *
 * @param msg The warning message format string
 * @param ... Additional arguments for the format string
 */
void wsh_warn(const char *msg, ...)
{
  va_list args;
  va_start(args, msg);

  vfprintf(stderr, msg, args);
  va_end(args);
  rc = EXIT_FAILURE;
}

/**
 * @Brief Main entry point for the shell
 *
 * @param argc Number of arguments
 * @param argv Array of argument strings
 * @return
 */
int main(int argc, char **argv)
{
  alias_hm = hm_create();
  setenv("PATH", "/bin", 1);
  if (argc > 2)
  {
    wsh_warn(INVALID_WSH_USE);
    return EXIT_FAILURE;
  }
  switch (argc)
  {
  case 1:
    interactive_main();
    break;
  case 2:
    rc = batch_main(argv[1]);
    break;
  default:
    break;
  }
  wsh_free();
  return rc;
}

/**
 * helper method to find path for command execution
 * 
 * @param const char *command - a pointer to the constant char array 
 *  containing the command to be executed
 */
char *findExecPath(const char *command)
{
  // check relative or absolute path
  if (command[0] == '.' || command[0] == '/')
  {
    // check file permissions - is it executable?
    if (access(command, X_OK) == 0)
    {
      char *cmdCopy = strdup(command);
      if (cmdCopy == NULL)
      {
        perror("strdup");
        fflush(stderr);
        return NULL;
      }
      return cmdCopy;
    }
    else
    {
      return NULL;
    }
  }

  // otherwise, follow path to executable file
  char *path = getenv("PATH");
  if (path == NULL || strlen(path) == 0)
  {
    fprintf(stderr, EMPTY_PATH);
    fflush(stderr);
    rc = EXIT_FAILURE;
    return NULL;
  }

  // create a copy of the path for tokenizing (don't edit actual path!!)
  char *pathCopy = strdup(path);

  // check strdup output
  if (!pathCopy)
  {
    perror("strdup");
    fflush(stderr);
    return NULL;
  }

  // tokenize path string, with ':' as delimiter to follow path
  char *follow = strtok(pathCopy, ":");

  // iterate through tokenized path to go through directories to find file
  while (follow != NULL)
  {
    // allocate space for path + '/' + '\0'
    char *wholePath = malloc(strlen(follow) + strlen(command) + 2);
    if (!wholePath)
    {
      perror("malloc");
      free(pathCopy);
      pathCopy = NULL;
      return NULL;
    }
    // save path
    sprintf(wholePath, "%s/%s", follow, command);

    // check file
    if (access(wholePath, X_OK) == 0)
    {
      free(pathCopy);
      pathCopy = NULL;
      return wholePath;
    }
    free(wholePath);
    wholePath = NULL;
    follow = strtok(NULL, ":");
  }
  free(pathCopy);
  pathCopy = NULL;
  return NULL;
}

/***************************************************
 * BUILTINS
 ***************************************************/

/**
 * builtin exit function that should exit the shell when 'exit' is typed as a command
 * 
 * @param int argc - the number of arguments passed with the command
 */
int builtinExit(int argc)
{
  // check for illegal args
  if (argc != 1)
  {
    fprintf(stderr, INVALID_EXIT_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }
  // exit
  clean_exit(rc);
  return EXIT_SUCCESS;
}

/**
 * builtin path function that should:
 *  1) print path if no other arguments are passed
 *  2) set the path to the provided argument
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinPath(char **argv, int argc)
{
  if (argc > 2)
  {
    fprintf(stderr, INVALID_PATH_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }
  if (argc == 1)
  {
    char *path = getenv("PATH");
    if (path == NULL)
    {
      fprintf(stdout, "\n");
      fflush(stdout);
      return EXIT_SUCCESS;
    }
    else
    {
      fprintf(stdout, "%s\n", path);
      fflush(stdout);
    }
    return EXIT_SUCCESS;
  }

  else
  {
    setenv("PATH", argv[1], 1);
    return EXIT_SUCCESS;
  }
}

/**
 * builtin alias function that should:
 *  1) print all aliases and aliased functions if no other arguments are passed
 *  2) set an alias if provided a command to alias
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinAlias(char **argv, int argc)
{
  if (argc == 1)
  {
    if (strcmp(argv[0], "alias") == 0)
    {
      if (alias_hm == NULL)
      {
        return EXIT_SUCCESS;
      }
      hm_print_sorted(alias_hm);
      fflush(stdout);
      return EXIT_SUCCESS;
    }
  }
  if (argc < 3 || strcmp(argv[2], "=") != 0)
  {
    fprintf(stderr, INVALID_ALIAS_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }

  if (alias_hm == NULL)
  {
    alias_hm = hm_create();
    if (!alias_hm)
    {
      fprintf(stderr, "Problem making hashmap");
      fflush(stderr);
      return EXIT_FAILURE;
    }
  }
  // empty command
  if (argc == 3)
  {
    hm_put(alias_hm, argv[1], "");
  }
  else if (argc == 4)
  {
    hm_put(alias_hm, argv[1], argv[3]);
  }
  else
  {
    fprintf(stderr, INVALID_ALIAS_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}


/**
 * helper function for execution of aliased commands. search for alias in hashmap (key-value search),
 *  then do alias expansion to get rid of alias and ready command for execution.
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
void searchAlias(char **argv, int *argc)
{
  if (argv == NULL || argc == NULL || alias_hm == NULL)
  {
    return;
  }

  // search hashmap using alias
  char *aliasCmd = hm_get(alias_hm, argv[0]);

  // if not found, simply return.
  if (!aliasCmd)
  {
    return;
  }

  // parse updated command line input
  char *parseArg[MAX_ARGS + 1];
  int parseArgC = 0;

  // tokenize and parse for commands >1 arg
  parseline_no_subst(aliasCmd, parseArg, &parseArgC);

  // no command ("") associated with key
  if (parseArgC == 0)
  {
    // get rid of 'alias'
    free(argv[0]);

    // shift line left to execute aliased command
    for (int i = 0; i < *argc - 1; i++)
    {
      argv[i] = argv[i + 1];
    }

    // decrease arg count to reflect shift
    (*argc)--;

    // set last element of argv to null
    if (*argc >= 0)
    {
      argv[*argc] = NULL;
    }

    // free temp array for parsed command
    for (int i = 0; i < parseArgC; i++)
    {
      free(parseArg[i]);
      parseArg[i] = NULL;
    }
    return;
  }

  //'alias' + actual args - overlap
  int updatedArgC = parseArgC + (*argc - 1);

  // oversized
  if (parseArgC >= MAX_ARGS)
  {
    for (int i = 0; i < parseArgC; i++)
    {
      free(parseArg[i]);
      parseArg[i] = NULL;
    }
    return;
  }

  // save original args (eg e hello) - alias name to temp array
  char *oldArgs[MAX_ARGS];
  for (int i = 1; i < *argc; i++)
  {
    oldArgs[i - 1] = argv[i];
  }

  // free 'alias'
  free(argv[0]);

  // move alias command args to beginning for execution
  for (int i = 0; i < parseArgC; i++)
  {
    argv[i] = parseArg[i];
    parseArg[i] = NULL;
  }

  // copy original args into parsed array after alias command arg expansion
  for (int i = 0; i < (*argc - 1); i++)
  {
    argv[parseArgC + i] = oldArgs[i];
    oldArgs[i] = NULL;
  }

  *argc = updatedArgC;

  argv[*argc] = NULL;

  // FREE!!
  for (int i = 0; i < parseArgC; i++)
  {
    free(parseArg[i]);
    parseArg[i] = NULL;
  }
}

/**
 * builtin unalias function that should get rid of the specified alias (delete from hashmap)
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinUnalias(char **argv, int argc)
{
  if (argc != 2)
  {
    fprintf(stderr, INVALID_UNALIAS_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }
  hm_delete(alias_hm, argv[1]);
  fflush(stdout);
  return EXIT_SUCCESS;
}

/**
 * builtin which that tells user which command is executed when the command passed as input is executed
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinWhich(char **argv, int argc)
{
  // check args to see if valid command
  if (argc != 2)
  {
    fprintf(stderr, INVALID_WHICH_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }

  // check if existing alias
  if (hm_get(alias_hm, argv[1]))
  {
    fprintf(stdout, WHICH_ALIAS, argv[1], hm_get(alias_hm, argv[1]));
    fflush(stdout);
    return EXIT_SUCCESS;
  }

  // check if builtin
  if (strcmp(argv[1], "exit") == 0 || strcmp(argv[1], "alias") == 0 ||
      strcmp(argv[1], "unalias") == 0 || strcmp(argv[1], "path") == 0 ||
      strcmp(argv[1], "cd") == 0 || strcmp(argv[1], "which") == 0 || strcmp(argv[1], "history") == 0)
  {
    fprintf(stdout, WHICH_BUILTIN, argv[1]);
    fflush(stdout);
    return EXIT_SUCCESS;
  }

  char *path = findExecPath(argv[1]);

  if (path == NULL)
  {

    fprintf(stdout, WHICH_NOT_FOUND, argv[1]);
    fflush(stdout);
    return EXIT_FAILURE;
  }
  fprintf(stdout, WHICH_EXTERNAL, argv[1], path);
  fflush(stdout);
  free(path);
  path = NULL;
  return EXIT_SUCCESS;
}

/**
 * builtin cd that changes directory to provided directory 
 *  or HOME directory if no directory provided
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinCd(char **argv, int argc)
{
  if (argc > 2)
  {
    fprintf(stderr, INVALID_CD_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }

  if (argc == 1)
  {
    char *home = getenv("HOME");
    if (!home)
    {
      fprintf(stderr, CD_NO_HOME);
      fflush(stderr);
      return EXIT_FAILURE;
    }
    if (chdir(home) != 0)
    {
      perror("cd");
      home = NULL;
      return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
  }
  if (chdir(argv[1]) != 0)
  {
    perror("cd");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

/**
 * builtin history that prints all commands executed in shell session
 *  or the nth command executed if n is provided as an argument
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
int builtinHistory(char **argv, int argc)
{
  if (argc > 2)
  {
    fprintf(stderr, INVALID_HISTORY_USE);
    fflush(stderr);
    return EXIT_FAILURE;
  }

  if (cdlHistory == NULL)
  {
    cdlHistory = da_create(MAX_ARGS);
  }

  if (argc == 1)
  {
    da_print(cdlHistory);
    return EXIT_SUCCESS;
  }

  char *endptr;
  int n = (int)strtol(argv[1], &endptr, 10);

  if (*endptr != '\0' || n < 1)
  {
    fprintf(stderr, HISTORY_INVALID_ARG);
    fflush(stderr);
    endptr = NULL;
    return EXIT_FAILURE;
  }

  int size = cdlHistory->size;

  if (n > size)
  {
    fprintf(stderr, HISTORY_INVALID_ARG);
    fflush(stderr);
    return EXIT_FAILURE;
  }

  char *cmd = da_get(cdlHistory, n - 1);
  if (!cmd)
  {
    fprintf(stderr, HISTORY_INVALID_ARG);
    fflush(stderr);
    return EXIT_FAILURE;
  }
  fprintf(stdout, "%s\n", cmd);
  fflush(stdout);
  return EXIT_SUCCESS;
}

/**
 * execute commands user types into shell. handle builtins and external commands.
 *    fork() - create child process for command execution
 *    execv() - external commands - provide file path so process image can be overwritten
 *    wait(NULL) - parent process waits for child to finish running and die before continuing
 * 
 * @param char **argv - the array of pointers to char arrays that have been passed as arguments
 * @param int argc - the number of arguments
 */
void execCommand(char **argv, int argc)
{
  // check args
  if (argc == 0 || argv[0] == NULL)
  {
    return;
  }

  // do alias lookup
  searchAlias(argv, &argc);

  // built-in commands
  if (strcmp(argv[0], "exit") == 0)
  {
    exiting = 1;
    for (int i = 0; i < MAX_ARGS; i++)
    {
      if (argv[i] != NULL)
      {
        free(argv[i]);
        argv[i] = NULL;
      }
    }
    rc = builtinExit(argc);
    return;
  }
  else if (strcmp(argv[0], "path") == 0)
  {
    rc = builtinPath(argv, argc);
    return;
  }
  else if (strcmp(argv[0], "alias") == 0)
  {
    rc = builtinAlias(argv, argc);
    return;
  }
  else if (strcmp(argv[0], "unalias") == 0)
  {
    rc = builtinUnalias(argv, argc);
    return;
  }
  else if (strcmp(argv[0], "which") == 0)
  {
    rc = builtinWhich(argv, argc);
    return;
  }
  else if (strcmp(argv[0], "cd") == 0)
  {
    rc = builtinCd(argv, argc);
    return;
  }
  else if (strcmp(argv[0], "history") == 0)
  {
    rc = builtinHistory(argv, argc);
    return;
  }

  // external commands
  char *execPath = findExecPath(argv[0]);
  if (execPath == NULL)
  {
    // handle the case where the path may not be null but is still not found.
    char *path_env = getenv("PATH");
    if (path_env != NULL && strlen(path_env) > 0)
    {
      fprintf(stderr, CMD_NOT_FOUND, argv[0]);
      fflush(stderr);
      path_env = NULL;
      rc = EXIT_FAILURE;
    }
    return;
  }

  // fork
  int pid = fork();
  if (pid < 0)
  {
    perror("fork");
    fflush(stderr);
    free(execPath);
    execPath = NULL;
    rc = EXIT_FAILURE;
    return;
  }

  if (pid == 0) // child
  {
    int exec = execv(execPath, argv);
    if (exec < 0)
    {
      fprintf(stderr, CMD_NOT_FOUND, argv[0]);
      fflush(stderr);
      free(execPath);
      execPath = NULL;
      rc = EXIT_FAILURE;
      return;
    }
  }
  else // parent
  {
    int parent = wait(NULL);
    if (parent < 0)
    {
      perror("wait");
      fprintf(stderr, CMD_NOT_FOUND, argv[0]);
      fflush(stderr);
      free(execPath);
      execPath = NULL;
      rc = EXIT_FAILURE;
      return;
    }
  }
  free(execPath);
  execPath = NULL;
}

/**
 * handle piped commands in shell by:
 *  1) parsing and separating commands
 *  2) checking builtin vs. external
 *  3) build pipes - 2D array
 *    a) number of pipes needed + 2 ends (read/write)
 *  4) fork() to execute pipes commands
 *    a) pid array to keep track of parent-child processes
 *    b) execute in child (very similar logic to execCommand)
 *  5) close pipes and free!
 * @param char *input - the inputted command (including pipes)
 */
void runPipe(char *input)
{
  // create a copy for parsing
  char *inputCopy = strdup(input);
  if (inputCopy == NULL)
  {
    perror("strdup");
    rc = EXIT_FAILURE;
    return;
  }

  // count how many command segments (num pipes plus 1)
  int count = 0;
  for (int i = 0; i < (int)strlen(input); i++)
  {
    if (input[i] == '|')
    {
      count++;
    }
  }

  count++; // for first segment

  // check if number of commands exceeds max
  if (count > MAX_ARGS)
  {
    fprintf(stderr, "Too many pipeline segments (max 128)\n");
    fflush(stderr);
    free(inputCopy);
    rc = EXIT_FAILURE;
    return;
  }

  // parse the segments
  char *segments[MAX_ARGS];
  char *curr = strtok(inputCopy, "|");

  int currIndex = 0;

  while (curr != NULL && currIndex < count)
  {
    segments[currIndex] = strdup(curr);
    if (segments[currIndex] == NULL)
    {
      perror("strdup");
      // free previous segments
      for (int j = 0; j < currIndex; j++)
      {
        free(segments[j]);
      }
      free(inputCopy);
      rc = EXIT_FAILURE;
      return;
    }

    currIndex++;
    curr = strtok(NULL, "|");
  }

  // array of args - 2D bc strings are char arrays!
  char *argv[MAX_ARGS][MAX_ARGS];

  // array for arg counts
  int argc[128];

  // validation
  for (int i = 0; i < count; i++)
  {
    parseline_no_subst(segments[i], argv[i], &argc[i]);

    // check for empty segment
    if (argc[i] == 0)
    {

      fprintf(stderr, "Empty command segment in pipeline\n");
      fflush(stderr);

      // FREE!!
      for (int j = 0; j < i; j++)
      {
        for (int k = 0; k < argc[j]; k++)
        {
          free(argv[j][k]);
        }
      }
      for (int j = 0; j < count; j++)
      {
        free(segments[j]);
      }
      free(inputCopy);
      rc = EXIT_FAILURE;
      return;
    }

    // alias expansion
    searchAlias(argv[i], &argc[i]);

    // check if it's an external command, then check if it exists
    if (argc[i] > 0 &&
        strcmp(argv[i][0], "path") != 0 &&
        strcmp(argv[i][0], "alias") != 0 &&
        strcmp(argv[i][0], "unalias") != 0 &&
        strcmp(argv[i][0], "which") != 0 &&
        strcmp(argv[i][0], "cd") != 0 &&
        strcmp(argv[i][0], "history") != 0 &&
        strcmp(argv[i][0], "exit") != 0)
    {
      char *execPath = findExecPath(argv[i][0]);
      if (execPath == NULL)
      {
        fprintf(stderr, EMPTY_PATH);
        fflush(stderr);

        // FREE!!
        for (int j = 0; j <= i; j++)
        {
          for (int k = 0; k < argc[j]; k++)
          {
            free(argv[j][k]);
          }
        }
        for (int j = 0; j < count; j++)
        {
          free(segments[j]);
        }
        free(inputCopy);
        rc = EXIT_FAILURE;
        return;
      }
      free(execPath);
    }
  }

  // create the pipes
  int pipes[MAX_ARGS][2];

  for (int i = 0; i < count - 1; i++)
  {
    // check if pipe is successfully made
    if (pipe(pipes[i]) == -1)
    {
      perror("pipe");

      // close previously created pipes
      for (int j = 0; j < i; j++)
      {
        close(pipes[j][0]);
        close(pipes[j][1]);
      }

      // FREE!!
      for (int j = 0; j < count; j++)
      {
        for (int k = 0; k < argc[j]; k++)
        {
          free(argv[j][k]);
        }
        free(segments[j]);
      }
      free(inputCopy);
      rc = EXIT_FAILURE;
      return;
    }
  }

  // fork process to execute piped command
  // very similar to execCommand (+ piping and redirection logic) but honestly a bit scared to use that here!
  // don't want issues with double forking bc that was a REAL pain
  pid_t pids[MAX_ARGS];
  for (int i = 0; i < count; i++)
  {
    pids[i] = fork();

    if (pids[i] < 0)
    {
      perror("fork");

      // close pipes
      for (int j = 0; j < count - 1; j++)
      {
        close(pipes[j][0]);
        close(pipes[j][1]);
      }

      // FREE!!
      for (int j = 0; j < count; j++)
      {
        for (int k = 0; k < argc[j]; k++)
        {
          free(argv[j][k]);
        }
        free(segments[j]);
      }
      free(inputCopy);
      rc = EXIT_FAILURE;
      return;
    }
    // child process!
    else if (pids[i] == 0)
    {
      // input redirection
      if (i > 0)
      {
        if (dup2(pipes[i - 1][0], STDIN_FILENO) == -1)
        {
          perror("child: dup2 stdin failed");
          exit(EXIT_FAILURE);
        }
      }

      // output redirection
      if (i < count - 1)
      {
        if (dup2(pipes[i][1], STDOUT_FILENO) == -1)
        {
          perror("child: dup2 stdout failed");
          exit(EXIT_FAILURE);
        }
      }

      // close pipes
      for (int j = 0; j < count - 1; j++)
      {
        close(pipes[j][0]);
        close(pipes[j][1]);
      }

      // execute the command using the same logic as execCommand
      // handle built-ins directly (to avoid double-forking)

      if (strcmp(argv[i][0], "exit") == 0)
      {
        int result = builtinExit(argc[i]);
        exit(result);
      }
      if (strcmp(argv[i][0], "path") == 0)
      {
        int result = builtinPath(argv[i], argc[i]);
        exit(result);
      }
      else if (strcmp(argv[i][0], "alias") == 0)
      {
        int result = builtinAlias(argv[i], argc[i]);
        exit(result);
      }
      else if (strcmp(argv[i][0], "unalias") == 0)
      {
        int result = builtinUnalias(argv[i], argc[i]);
        exit(result);
      }
      else if (strcmp(argv[i][0], "which") == 0)
      {
        int result = builtinWhich(argv[i], argc[i]);
        exit(result);
      }
      else if (strcmp(argv[i][0], "cd") == 0)
      {
        int result = builtinCd(argv[i], argc[i]);
        exit(result);
      }
      else if (strcmp(argv[i][0], "history") == 0)
      {
        int result = builtinHistory(argv[i], argc[i]);
        exit(result);
      }
      // external command - treat it the same as in execCommand
      else
      {
        char *execPath = findExecPath(argv[i][0]);
        if (execPath == NULL)
        {
          // path is not null but not found either
          char *path_env = getenv("PATH");
          if (path_env != NULL && strlen(path_env) > 0)
          {
            fprintf(stderr, CMD_NOT_FOUND, argv[i][0]);
            fflush(stderr);
          }
          return;
        }

        // execute!
        if (execv(execPath, argv[i]) == -1)
        {
          fprintf(stderr, CMD_NOT_FOUND, argv[i][0]);
          fflush(stderr);
          free(execPath);
          exit(EXIT_FAILURE);
        }
        // FREE!!
        free(execPath);
      }
    }
  }

  // parent process

  // close all pipe file descriptors
  for (int i = 0; i < count - 1; i++)
  {
    close(pipes[i][0]);
    close(pipes[i][1]);
  }

  // wait for child processes to finish
  int status = EXIT_SUCCESS;
  for (int i = 0; i < count; i++)
  {
    int curr;
    if (waitpid(pids[i], &curr, 0) == -1)
    {
      perror("parent: waitpid failed");
      status = EXIT_FAILURE;
    }
    //check if child terminated correctly
    else if (!WIFEXITED(curr) || WEXITSTATUS(curr) != EXIT_SUCCESS)
    {
      status = EXIT_FAILURE;
    }
  }

  // FREE!!
  for (int i = 0; i < count; i++)
  {
    for (int j = 0; j < argc[i]; j++)
    {
      free(argv[i][j]);
    }
    free(segments[i]);
  }

  // add pipe command to history
  da_put(cdlHistory, input);
  
  free(inputCopy);

  rc = status;
  return;
}


/**
 * helper function to process and execute command typed into shell.
 * 
 * @param const char *cLine - the command line input
 */
void processCmd(const char *cLine)
{
  char *argv[MAX_ARGS + 1] = {0}; // args + \0

  int argc;

  if (strchr(cLine, '|') != NULL)
  {
    // Handle pipeline
    char *lineCopy = strdup(cLine);
    if (lineCopy == NULL)
    {
      perror("strdup");
      rc = EXIT_FAILURE;
      return;
    }

    // Remove trailing newline if present
    size_t len = strlen(lineCopy);
    if (len > 0 && lineCopy[len - 1] == '\n')
    {
      lineCopy[len - 1] = '\0';
    }

    runPipe(lineCopy);
    free(lineCopy);
    return;
  }

  //parse args
  parseline_no_subst(cLine, argv, &argc);

  //execute
  if (argc > 0)
  {
    execCommand(argv, argc);
  }

  //free if command passed is not 'exit'
  if (!exiting)
  {
    for (int i = 0; i < MAX_ARGS; i++)
    {
      if (argv[i] != NULL)
      {
        free(argv[i]);
        argv[i] = NULL;
      }
    }
  }

  //create history array
  if (!cdlHistory)
  {
    cdlHistory = da_create(MAX_ARGS);
  }

  //add command to history
  char *cmdCopy = strdup(cLine);
  size_t len = strlen(cmdCopy);
  if (len > 0 && cmdCopy[len - 1] == '\n')
  {
    cmdCopy[len - 1] = '\0';
  }

  da_put(cdlHistory, cmdCopy);
  free(cmdCopy);
}

/***************************************************
 * Modes of Execution
 ***************************************************/

/**
 * @Brief Interactive mode: print prompt and wait for user input
 * execute the given input and repeat
 */
void interactive_main(void)
{

  char inp[MAX_LINE];

  while (1)
  {
    fprintf(stdout, "wsh> ");
    fflush(stdout);

    if (fgets(inp, sizeof(inp), stdin) == NULL)
    {
      fprintf(stderr, "fgets error \n");
      fflush(stdout);
      rc = EXIT_FAILURE;
      break;
    }
    processCmd(inp);
  }
}

/**
 * @Brief Batch mode: read commands from script file line by line
 * execute each command and repeat until EOF
 *
 * @param script_file Path to the script file
 * @return EXIT_SUCCESS(0) on success, EXIT_FAILURE(1) on error
 */

int batch_main(const char *script_file)
{
  f = fopen(script_file, "r");
  if (f == NULL)
  {
    perror("fopen");
    fflush(stderr);
    return EXIT_FAILURE;
  }

  char cmdLine[MAX_LINE];

  while (fgets(cmdLine, sizeof(cmdLine), f) != NULL)
  {
    processCmd(cmdLine);
  }

  // fclose(f);
  return rc;
}

/***************************************************
 * Parsing
 ***************************************************/

/**
 * @Brief Parse a command line into arguments without doing
 * any alias substitutions.
 * Handles single quotes to allow spaces within arguments.
 *
 * @param cmdline The command line to parse
 * @param argv Array to store the parsed arguments (must be preallocated)
 * @param argc Pointer to store the number of parsed arguments
 */
void parseline_no_subst(const char *cmdline, char **argv, int *argc)
{
  if (!cmdline)
  {
    *argc = 0;
    argv[0] = NULL;
    return;
  }
  char *buf = strdup(cmdline);
  if (!buf)
  {
    perror("strdup");
    clean_exit(EXIT_FAILURE);
  }
  /* Replace trailing newline with space */
  const size_t len = strlen(buf);
  if (len > 0 && buf[len - 1] == '\n')
    buf[len - 1] = ' ';
  else
  {
    char *new_buf = realloc(buf, len + 2);
    if (!new_buf)
    {
      perror("realloc");
      free(buf);
      clean_exit(EXIT_FAILURE);
    }
    buf = new_buf;
    strcat(buf, " ");
  }

  int count = 0;
  char *p = buf;
  while (*p && *p == ' ')
    p++; /* skip leading spaces */

  while (*p)
  {
    char *token_start = p;
    char *token = NULL;
    if (*p == '\'')
    {
      token_start = ++p;
      token = strchr(p, '\'');
      if (!token)
      {
        /* Handle missing closing quote - Print `Missing closing quote` to stderr */
        wsh_warn(MISSING_CLOSING_QUOTE);
        free(buf);
        for (int i = 0; i < count; i++)
          free(argv[i]);
        *argc = 0;
        argv[0] = NULL;
        return;
      }
      *token = '\0';
      p = token + 1;
    }
    else
    {
      token = strchr(p, ' ');
      if (!token)
        break;
      *token = '\0';
      p = token + 1;
    }
    argv[count] = strdup(token_start);
    if (!argv[count])
    {
      perror("strdup");
      for (int i = 0; i < count; i++)
        free(argv[i]);
      free(buf);
      clean_exit(EXIT_FAILURE);
    }
    count++;
    while (*p && (*p == ' '))
      p++;
  }
  argv[count] = NULL;
  *argc = count;
  free(buf);
}
