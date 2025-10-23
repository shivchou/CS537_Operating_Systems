#define _GNU_SOURCE // Required for getline to be available in stdio.h
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>

struct student
{
    char *name;
    float score;
};

void free_student(struct student *s)
{
    free(s->name);
    free(s);
}

int cmpstudents(const void  *a, const void *b)
{
    struct student *s1 = *(struct student **)a;
    struct student *s2 = *(struct student **)b;
    // printf("COMP: %s score: %.2f -- %s score: %.2f\t",s1->name,s1->score, s2->name, s2->score);
    int rv;
    if (isnan(s1->score) && isnan(s2->score))
    {
        rv=strcmp(s1->name,s2->name);
        // printf("return %d\n",rv);
        return rv;
    }
    if (isnan(s1->score))
    {
        // printf("return 1\n");
        return 1;
    }
    if (isnan(s2->score))
    {
        // printf("return -1\n");
        return -1;
    }
    float val = s2->score - s1->score;
    if (val > 0) rv=1;
    else if (val < 0) rv=-1;
    else rv = strcmp(s1->name,s2->name);
    // printf("return %d\n",rv);
    return rv;
}

struct student *process_line(char *line, int index) {
    struct student *ret = (struct student *)malloc(sizeof(struct student));
    const char *delim = ",";
    char *token = strsep(&line,delim);
    //printf("first token '%s'\n",token);
    ret->name = malloc(strlen(token)+1);
    strcpy(ret->name,token);
    int current_number = 0;
    int numbers_stored = 0;
    float score_to_keep = 0.0f;
    char *endptr;
    while (token != NULL) {
        token = strsep(&line, delim);
        //printf("next token '%s'\n",token);
        current_number++;
        if (token == NULL) break;
        float num = NAN;
        if (strlen(token) > 0) {
	    errno = 0;
	    num = (float)strtod(token,&endptr);
	    if (endptr == token || *endptr !='\0' || errno != 0) exit(1);
            //num = atof(token);
	}
        if (current_number == index) {
            ret->score = num;
            return ret;
        }
        if (index == 0) {
            if (!isnan(num))
            {
                score_to_keep += num;
                numbers_stored ++;
            }
        }
    }
    if (index == 0 && numbers_stored > 0)
    {
        ret->score = score_to_keep / numbers_stored;
    } else {
        ret->score = NAN;
    }
    return ret;
}

void printStudents(struct student **students, int len) {
    for(int i=0;i<len;i++) {
        printf("%s score: %.2f\n",students[i]->name,students[i]->score);
    }
}

int main(int argc, char **argv)
{
    if (argc != 3)
        return 1;

    char *path = argv[1];
    char *endptr;
    int pos = (int) strtol(argv[2],&endptr,10);
    if (endptr==argv[2] || pos < 0) return 1;
    int student_len = 10;
    struct student **students = calloc(student_len, sizeof(struct student *));
    int num_students=0;
    FILE *fp;
    char *line = NULL; // Pointer to the buffer that will hold the line
    size_t len = 0;    // Size of the buffer
    ssize_t read;      // Number of characters read

    // Open the file in read mode
    fp = fopen(path, "r");
    if (fp == NULL) {
        return 1;
    }

    // Read lines from the file until end of file or error
    while ((read = getline(&line, &len, fp)) != -1) {
        int len = strlen(line);
        if (len > 0 && line[len-1] == '\n') line[len-1] = '\0'; //remove the newline character
        students[num_students++] = process_line(line,pos);
        if (num_students==student_len) {
            students = realloc(students, student_len * 2 * sizeof(struct student *) );
            if (students == NULL)
                return -1;
            student_len *= 2;
        }
    }

    // Free the dynamically allocated memory by getline()
    free(line);
    // Close the file
    fclose(fp);

    // printf("BEFORE SORTING:\n");
    // printStudents(students,num_students);
    qsort(students,num_students, sizeof(struct student *), cmpstudents);
    // printf("\nAFTER:\n");
    printStudents(students,num_students);

    for(int i=0;i<num_students;i++) {
        free_student(students[i]);
    }
    free(students);


    return 0;
}
