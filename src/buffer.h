#ifndef BUFFER_H
#define BUFFER_H

#include <stdlib.h>
#include <strings.h>
#include <stdarg.h>

struct Buffer_t {
    char *contents;
    int bytes_used;
    int total_size;
};

typedef struct Buffer_t Buffer_t;

extern Buffer_t * buffer_alloc(int initial_size);
extern void buffer_reset(Buffer_t *buf);
extern int buffer_strlen(Buffer_t *buf);
extern void buffer_free(Buffer_t *buf);
extern int buffer_append(Buffer_t *buf, char *append, int length);
extern int buffer_appendf(Buffer_t *buf, const char *format, ...);
extern int buffer_nappendf(Buffer_t *buf, size_t length, const char *format, ...);
extern char *buffer_to_s(Buffer_t *buf);

#endif
