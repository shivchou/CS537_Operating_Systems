---
title: CS 537 Project 1
layout: default
---

# CS537 Fall 2025, Project 1 Part 1 -- UW Grade Sorter

## Updates
* TBD


## Learning Objectives


* Re-familiarize yourself with the C programming language
* Familiarize yourself with a shell / terminal / command-line of Linux
* Practice file I/O, string processing, dynamic memory allocation, and simple data structures in C

## Project Overview

In this assignment, you will write a command line program that sorts students' grades for a course and prints out their names and grades sorted by a specific score.

Summary of what is to be completed:

* One `.c` file: `gradesorter.c`
* It is mandatory to compile your code with the following flags `-O2 -Wall -Wextra -Werror -pedantic -o gradesorter`.
    * Check `man gcc` and search for these flags to understand what they do and why you will like them.
    * It is a good idea to create a `Makefile` so you just type `make` for the compilation.
    * We are trying to use a recent version of the C language. The compiler (`gcc` on lab machines and in the docker container) support the C17 specification (201710L).
    * `-std=c17` is not required. 
* It should (hopefully) pass the tests we supply. 
* Include a single `README.md` inside `solution` directory describing the implementation. This file should include your name, your cs login, you wisc ID and email, and the status of your implementation. If it all works then just say that. If there are things you know don't work let me know.

* Commit and push your solution to your repository before the due date.

__Before beginning__: Read this [lab tutorial](http://pages.cs.wisc.edu/~remzi/OSTEP/lab-tutorial.pdf); it has some useful tips for programming in the C environment.

## UW Grade Sorter
The program you will build is called `gradesorter`.  It takes two command line arguments -- the name of a CSV file with a list of students and an integer k.

k is in the range of 4 byte unsigned integer [0, 2^32-1].

Then, it prints the students' names and their kth score from the file, sorted by the k-th grade to STDOUT, formatted nicely (e.g. 2 decimal point precision).

Here is what it looks like to run the program:

```bash
$ ./gradesorter students.csv 2
```

`gradesorter` will sort the students by the k-th score (0 indicates average of all scores).  If a student does not have a k-th score, it should be placed at the end of the sorted list.

If there is a tie, student names are sorted lexicographically.  Among students with fewer than k scores, their relative order is determined lexicographically by their name.

Names may contain all ~alphanumeric~ ASCII except a comma.  Scores contain only digits and decimal point.

### Sample Results 1 file
students.csv:
```
Claudette Colvin,78,,83
Barbara Johns,81,78,91.25
Parth Gaggar,84,84,84
Vijay Jain,82,84,86.5
Eesha Khare,72,70.5,80
Viet Tran,91,85,96
Seth Robertson,88,89,86
Ciara Judge,78,82,83
Emer Hickey,65,72.5,75
Sophie Healy-Thow,69,,
Alan Turing,92,96,95
Chevalier dEon,78,0.0,88.5
Qin Shi Huang,81,0,
Jang Yeong-sil,,,
Sarathbabu Elumalai,73,88.25,85
```

command:
```bash
$ ./gradesorter students.csv 1
```

result to STDOUT:
```
Alan Turing score: 92.00
Viet Tran score: 91.00
Seth Robertson score: 88.00
Parth Gaggar score: 84.00
Vijay Jain score: 82.00
Barbara Johns score: 81.00
Qin Shi Huang score: 81.00
Chevalier dEon score: 78.00
Ciara Judge score: 78.00
Claudette Colvin score: 78.00
Sarathbabu Elumalai score: 73.00
Eesha Khare score: 72.00
Sophie Healy-Thow score: 69.00
Emer Hickey score: 65.00
Jang Yeong-sil score: nan
```

Note: Formatting must match exactly.  See the testcases in the `tests` directory for additional examples.

### File formats

The input file is a standard comma separated value (CSV) file.  Each line represents one student and their scores ending in a newline character '\n'.  The first field is a student's name.  The remaining fields are scores.  Scores may be missing.  Lines need not have the same number of scores.  Scores will fit in a typical 4 byte single-precision float.  You must not assume a maximum limit on the length of a name, the number of scores in a row, or the number of rows in the file.

### Possible outputs

* if k is not an integer, exit with return code 1.
* if k is less than zero, exit with return code 1.
* All other errors (wrong number of arguments, open file failed, improperly formatted input file, etc.) should exit with return code 1.

### Tips

* When working with any C library functions, check its manual page (`man`) for a description and proper usage, e.g. `man 3 fopen`. Note: the linux manual was not installed in the Docker container, so you will probably want to use an online version of the linux manual like [here](https://man.he.net/).
* To work with files, look at `man 3 fopen` and `man 3 fclose`.
* To read data from files, consider using `getline(3)`, `fgets(3)`, or maybe `scanf(3)`.
* Printing to the terminal can be done with `printf(3)`.
* You don't know the number of lines or the length of names or how many scores ahead of time, so you will need to dynamically allocate memory.
* To sort an array of data, you can use `qsort(3)`.  Also, you can implement your own way to sort.
