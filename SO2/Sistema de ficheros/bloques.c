///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////BLOQUES.C/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "bloques.h"
static int descriptor=0;
static sem_t *mutex; //Variable global del semaforo
static unsigned int inside_sc = 0;


int bmount (const char *camino) {
  if (descriptor > 0) {
    close(descriptor);
  }
  if ((descriptor=open(camino, O_RDWR|O_CREAT, 0666)) ==-1) {
    fprintf(stderr, "Error %d: %s\n", errno, strerror(errno));}
    if (!mutex) {
      mutex = initSem();
    	 if (mutex == SEM_FAILED) {
        return -1;
    	 }
    }
    return descriptor;
}


int bumount(){
  descriptor = close(descriptor);
  if(descriptor == -1){
    fprintf(stderr, "Error %d: %s\n", errno, strerror(errno));
    return -1;
   }
   deleteSem(); // borramos semaforo
   return 0;
}


int bwrite(unsigned int nbloque,const void *buf){
	/*Escribe el contenido de un buffer de memoria. Tamaño de un bloque*/
	
	int despl= nbloque*BLOCKSIZE;//Variable de desplazamiento.
	
	lseek(descriptor,despl,SEEK_SET);
	int escritura = write(descriptor,buf,BLOCKSIZE);
	if(escritura<0){
		fprintf(stderr, "Error %d: %s\n", errno, strerror(errno));//Gestionar error 
	return -1; //Devolvemos que ha ocurrido un error.
	}
	return escritura;
}

int bread(unsigned int nbloque, void *buf){
	/*Lee del sistema de ficheros el bloque especificado por uno de los
	 * argumentos. Copia su contenido en un buffer de memoria.
	 */
	int despl= nbloque*BLOCKSIZE;//Variable de desplazamiento.
	lseek(descriptor,despl,SEEK_SET);
	int lectura =read(descriptor,buf,BLOCKSIZE);
	if(lectura==-1){
		fprintf(stderr, "Error %d: %s\n", errno, strerror(errno));//Gestionar error 
	return -1; //Devolvemos que ha ocurrido un error.
	}
	return lectura;
}




/*
	Definiremos unas funciones propias para llamar a waitSem y signalSem (de esta manera todas las llamadas a las funciones de semaforo_mutex_posix.c estarán concentradas en bloques.c, y si cambiásemos el semáforo no habría que tocar el código del resto de programas)
*/
void mi_waitSem(){
if (!inside_sc) {
waitSem(mutex);
}
inside_sc++;
}
void mi_signalSem() {
inside_sc--;
if (!inside_sc) {
    signalSem(mutex);
}
}
