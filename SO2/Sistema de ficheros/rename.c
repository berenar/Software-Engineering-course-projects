///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_RENAME.C///////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "directorios.h"

int main(int argc, char **argv) {
	if (argc != 4) {
	
		printf("Sintaxis: mi_remove <nombre_dispositivo> </ruta_inicial> </ruta_final>\n");
		return -1;
	} else {
		if(bmount(argv[1])==-1){
			printf("Error de fichero");
		}
		int error;
		if(argv[3][0] == '/'){
			printf("Error camino destino\n");
			return -1;
		}
		error=mi_rename(argv[2], argv[3]);
		if(error<0){
					switch (error) {
						case -1: 
						printf("Error: camino incorrecto.\n");
						return ERROR_EXTRAER_CAMINO;
						break;
						case -2:
						printf("ERROR: NO EXISTE ENTRADA CONSULTA\n");
						return ERROR_NO_EXISTE_ENTRADA_CONSULTA;
						break;
						case -3:
						printf("ERROR: NO EXISTE DIRECTORIO INTERMEDIO\n");
						return ERROR_NO_EXISTE_DIRECTORIO_INTERMEDIO;
						break;
						case -4:
						printf("ERROR DE PERMISOS:NO PERMISOS DE ESCRITURA\n");
						return ERROR_PERMISO_ESCRITURA;	
						break;
						case -5:
						printf("ERROR: LA ENTRADA YA EXISTE\n");
						return ERROR_ENTRADA_YA_EXISTENTE;
						break;
						case -8:
						printf("ERROR DE PERMISOS:NO PERMISOS DE LECTURA\n");
						return ERROR_PERMISO_LECTURA;
						break;
					}
}

int u;
		u=bumount();
		if(u==-1){
			printf("Error en el close del fitxer\n");
			return -1;
		} else {
			return 0;
		}

}

}
