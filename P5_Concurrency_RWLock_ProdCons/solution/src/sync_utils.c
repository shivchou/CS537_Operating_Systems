#define _XOPEN_SOURCE 700
#include <unistd.h>
#include "sync_utils.h"
#include <sys/time.h>
#include <string.h>
#include <stdbool.h>


int usleep(unsigned int usec);
uint64_t now_ms(void) {
  struct timeval tv; gettimeofday(&tv, NULL);
  return (uint64_t)tv.tv_sec * 1000ULL + tv.tv_usec / 1000ULL;
}

pthread_t spawn(thread_fn fn, void *arg, const char *name) {
  (void)name; /* name useful for extended logging */
  pthread_t t;
  if (pthread_create(&t, NULL, fn, arg)) DIE("pthread_create");
  return t;
}
void join(pthread_t t) { if (pthread_join(t, NULL)) DIE("pthread_join"); }

void jitter_us(int min_us, int max_us) {
  int span = (max_us > min_us) ? (max_us - min_us) : 1;
  int d = min_us + (rand() % span);
  usleep(d);
}

/* ------- Reader-Writer Lock: initialization and cleanup ------- */
int rw_init(rwlock_t *rw) {
  /* TODO: Initialize all fields in rwlock_t structure
   * - Initialize mutex
   * - Initialize semaphores
   * - Set initial counter values
   */

  pthread_mutex_init(&rw->m, NULL); //initialize mutex lock

  rw->readers = 0; //no active readers

  sem_init(&rw->wlock, 0, 1); //initialize RW semaphore to 1 to use as lock

  rw->writer_active = false; //no active writers

  rw->writers_waiting = 0; //no waiting writers
 
  return 0;
}

void rw_destroy(rwlock_t *rw) {
  /* TODO: Clean up resources
   * - Destroy mutex
   * - Destroy semaphores
   */
  pthread_mutex_destroy(&rw->m);
  sem_destroy(&rw->wlock);
}
/* RW lock functions are implemented in readers_writers.c */

/* ------- Food Tray Helper Functions ------- */
food_tray_t* create_food_tray(int tray_id, const char *food_name, int cook_id) {
  food_tray_t *tray = malloc(sizeof(food_tray_t));
  if (!tray) DIE("malloc food_tray");
  
  tray->tray_id = tray_id;
  tray->food_name = strdup(food_name);
  if (!tray->food_name) DIE("strdup food_name");
  tray->prepared_by = cook_id;
  
  return tray;
}

void free_food_tray(food_tray_t *tray) {
  if (tray) {
    free(tray->food_name);
    free(tray);
  }
}

/* ------- Bounded Buffer: initialization and operations ------- */
int bb_init(bb_t *q, int capacity) {  
  // step 1: Allocate buffer array for food_tray_t pointers using calloc
  q->buf = (food_tray_t**)calloc(capacity, sizeof(food_tray_t));
  // error checking: calloc allocated space 
  if(q->buf == NULL) {
    return -1; 
  }

  // step 2: set buffer capacity
  q->cap = capacity;

  // step 3: initialize head and tail to 0
  q->head = 0;
  q->tail = 0;

  // step 4: initialize empty semaphore to capacity
  if(sem_init(&q->empty, 0, capacity) == -1) {
    // error initializing semaphore (returned -1)
    free(q->buf);
    return -1; 
  }

  // step 5: initialize full semaphore to 0
  if(sem_init(&q->full, 0, 0) == -1) {
    // error init semaphore
    free(q->buf);
    return -1;
  }

  // step 6: init mutex
  if(pthread_mutex_init(&q->m, NULL) == -1) {
    // error init lock 
    sem_destroy(&q->full);
    sem_destroy(&q->empty);
    free(q->buf);
    return -1;
  }

  // step 6: return success!
  return 0; 
}

void bb_destroy(bb_t *q) {
  // step 1: destroy mutex
  pthread_mutex_destroy(&q->m);

  // step 2: destroy semaphores
  sem_destroy(&q->empty);
  sem_destroy(&q->full);

  // step 3: free buffer 
  free(q->buf);
}

void bb_put(bb_t *q, food_tray_t *tray) {
  // step 1: wait on empty semaphore
  sem_wait(&q->empty);

  // step 2: lock mutex
  pthread_mutex_lock(&q->m);

  // step 3: add tray to buffer at tail position 
  q->buf[q->tail] = tray;

  // step 4: update tail (circular: (tail + 1) % capacity)
  q->tail = (q->tail + 1) % q->cap;

  // step 5: unlock mutex
  pthread_mutex_unlock(&q->m);

  // step 6: post to full sem
  sem_post(&q->full);
}

food_tray_t* bb_take(bb_t *q) {
  // step 1: wait on full semaphore
  sem_wait(&q->full); 

  // step 2: lock mutex
  pthread_mutex_lock(&q->m);

  // step 3: remove tray from buffer at head position
  food_tray_t *tray = q->buf[q->head];

  // step 4: update head (circular: (head + 1) % capacity)
  q->head = (q->head + 1) % q->cap;

  // step 5: unlock mutex
  pthread_mutex_unlock(&q->m);

  // step 6: post to empty sem
  sem_post(&q->empty);

  // step 7: return tray
  return tray;
}
