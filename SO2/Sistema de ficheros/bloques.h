///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////BLOQUES.H/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <unistd.h> 
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h> /* Modos de apertura y función open()*/
#include <stdlib.h>
#include <errno.h> //errno
#include <string.h> //strerror() i memset()
#include "semaforo_mutex_posix.h"

#define BLOCKSIZE 1024 //bytes


int bmount(const char *camino);
int bumount();
int bwrite(unsigned int nbloque, const void *buf);
int bread(unsigned int nbloque, void *buf);

//Semaforos
void mi_waitSem();
void mi_signalSem();
