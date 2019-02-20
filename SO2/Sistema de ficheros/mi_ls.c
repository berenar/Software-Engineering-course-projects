///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_LS.C///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "directorios.h"
int main (int argc, char **argv) {
	if (argc != 3) {
		printf("Sintaxis: mi_ls <nombre_dispositivo> <ruta_directorio>\n");
		return -1;
	}
	//Montamos el disco
	if(bmount(argv[1]) < 0){
		printf("No se ha podido abrir el fichero: %s", argv[1]);
		return 0;
	}

	char buffer[64*200];
	memset(buffer,0,BLOCKSIZE);
	printf("Directorio %s:\n", argv[2]);

	if(mi_dir (argv[2],(char *)buffer) > 0) {
		printf("%c[%d;%dmTipo\tPerm.\tmTime\t\t\tTamaño\tNombre%c[%dm\n",27,0,32,27,0);
		puts("----------------------------------------------------------------------");
		printf("%s\n", buffer);
	}
	bumount();
	return 0;
}