///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_ESCRIBIR.C/////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include <stdio.h>
#include <string.h>
#include "directorios.h"


int main(int argc, char **argv){

	int tam2,tam3,tam4;

	if(argc!=5){
		printf("Sintaxis: mi_escribir <nombre_dispositivo> </ruta_fichero> <texto> <offset> \n");
		return -1;
	}

	tam2 = strlen(argv[2]);
	tam3 = strlen(argv[3]);
	tam4 = atoi(argv[4]);
	if(argv[2][tam2-1]=='/'){
		printf("No es un fichero \n");
		return -2;
	}

	bmount(argv[1]);	//Monta disco
	printf("longitud texto:%d\n",tam3);
	if(mi_write(argv[2], argv[3], tam4, tam3)<0){
		printf("Error al escribir en el fichero \n");
	}else{
		// printf("Fichero escrito correctamente \n");

	}

	bumount();	//Desmonta disco

	return 0;
}