#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>


//struct to store student info [use NaN for missing scores]
typedef struct{
    char *name;
    float *scores;
    int numScores;
    float val;
    int hasVal;
} Student;

//parse line from csv file into student object with name and scores
static Student parse(char* line)
{
    Student s; //new student to be read from line
    s.name = NULL;
    s.scores = NULL;
    s.numScores = 0;
    s.val = NAN;
    s.hasVal = 0;

    char* stripped = strdup(line);
    if(!stripped) {
        exit(1);
    }
    
    //strip whitespace
    char* start = stripped;
    while(*start == ' ' || *start == '\t' || *start == '\n' || *start == '\r') {
        start++;
    }
    
    char* end = start + strlen(start) - 1;
    while(end > start && (*end == ' ' || *end == '\t' || *end == '\n' || *end == '\r')) {
        *end = '\0';
        end--;
    }

    //copy to be used with strsep (changes str)
    char* lineCopy = strdup(start);
    if(!lineCopy) {
        free(stripped);
        exit(1);
    }
    
    char* ptr = lineCopy;
    
    //name
    char* token = strsep(&ptr, ",");
    if(!token) {
        free(stripped);
        free(lineCopy);
        return s;
    }
    
    s.name = strdup(token);
    if(!s.name) {
        free(stripped);
        free(lineCopy);
        exit(1);
    }
    
    //add scores
    while((token = strsep(&ptr, ",")) != NULL) 
    {
        s.scores = realloc(s.scores, (s.numScores + 1) * sizeof(float));
        if(!s.scores) {
            free(stripped);
            free(lineCopy);
            exit(1);
        }
        
        if(token[0] == '\0') 
        {
            s.scores[s.numScores++] = NAN;
        }
        else 
        {
            char* parseEnd;
            float score = strtof(token, &parseEnd);
            s.scores[s.numScores++] = score;
            if (parseEnd == token) 
            {
                free(s.scores);
                free(stripped);
                free(lineCopy);
                exit(1);
            }
        }
    }
    
    free(stripped);
    free(lineCopy);

    return s;
}

int compar(const void *a, const void *b)
{
    const Student *first = a;
    const Student *second = b;

    if(first->hasVal && second->hasVal)
    {
        if(first->val > second->val)
        {
            return -1;
        }
        else if (second->val > first->val)
        {
            return 1;
        }
        else
        {
            return strcmp(first->name, second->name);
        }
    }
    else if (first->hasVal && !second->hasVal) 
    {
        return -1; //valid > invalid
    } 
    else if (!first->hasVal && second->hasVal) 
    {
        return 1; //invalid < valid
    } 
    else 
    {
        return strcmp(first->name, second->name);
    }

}

void sort(Student *students, size_t numStudents, unsigned int k)
{
    for(size_t i = 0; i < numStudents; i++)
    {
        Student *s = &students[i];

        //if 0, find avg
        if(k==0)
        {
            float sum = 0;
            int count = 0;
            for(int j = 0; j < s->numScores; j++)
            {
                //inc count IFF not NAN; if count = 0, all are NANs, return NAN
                if (!isnan(s->scores[j])) {
                    sum += s->scores[j];
                    count++;
                }
            }
            if (count > 0) 
            {
                s->val = sum / count;
                s->hasVal = 1;
            } 
            else 
            {
                s->hasVal = 0;
            }

        }
        //find k-th score
        else
        {
            if (k <= (unsigned int)(s->numScores) && !isnan(s->scores[k-1])) 
            {
                s->val = s->scores[k-1];
                s->hasVal = 1;
            }
            else 
            {
                s->hasVal = 0;
            }
        }
    }

     //sort based on s.hasVal
     qsort(students, numStudents, sizeof(Student), compar);
}

int main (int argc, char *argv[])
{
    if(argc != 3)
    {
        exit(1);
    }

    FILE *fp = fopen(*(argv + 1), "r");
	if (fp == NULL) {
		exit(1);
	}

    Student *students = NULL;
    size_t numStudents = 0;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;

    while ((read = getline(&line, &len, fp)) != -1)
    {
        Student s = parse(line);
        students = realloc(students, (numStudents + 1)*sizeof(Student));
        if(!students)
        {
            exit(1);
        }
        students[numStudents] = s;
        numStudents++;
    }
    free(line);
    line = NULL;
    fclose(fp);
    fp = NULL;
    int k = atoi(argv[2]);
    if (k < 0)
    {
        exit(1);
    }
    sort(students, numStudents, (unsigned int) k);

    for (size_t i = 0; i < numStudents; i++) 
    {

        if (students[i].hasVal == 1) 
        {
            printf("%s score: %.2f\n", students[i].name, students[i].val);
        } 
        else
        {
            printf("%s score: nan\n", students[i].name);
        }
        free(students[i].name);
        students[i].name = NULL;
        free(students[i].scores);
    }
    free(students);

}

