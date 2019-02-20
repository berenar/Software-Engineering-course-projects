///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_RM.C///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "directorios.h"


int main(int argc, char **argv){

	if(argc!=3){
		printf("Sintaxis: mi_rm <nombre_dispositivo> </ruta>\n");
		return -1;
	}

	bmount(argv[1]);	//Monta disco

	if(mi_unlink(argv[2])<0){
		//printf("Error al borrar el fichero/directorio \n");
	}else{
		printf("Borrado correctamente \n");
	}

	bumount();	//Desmonta disco

	return 0;
}