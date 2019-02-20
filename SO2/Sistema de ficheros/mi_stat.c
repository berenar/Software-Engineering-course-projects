///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_STAT.C/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "directorios.h"
int main(int argc, char **argv) {
	if (argc != 3) {
		printf("Sintaxis: ./mi_stat <nombre_dispositivo> <ruta>\n");
		return -1;
	} else {
		void *nom_fitxer = argv[1];
		void *ruta = argv[2];
		int e = bmount(nom_fitxer);
		if (e == -1) {
			printf("ERROR: APERTURA FICHERO INCORRECTA.\n");
			return -1;
		} else {
			struct STAT p_stat;
    struct tm *ts;
    char atime [80];
    char ctime [80];
    char mtime [80];
			int error;
			error= mi_stat(ruta, &p_stat);
			if (error < 0) {
				switch (error) {
					case -1: 
						printf("ERROR: EXTRACCIÓN INCORECTA DEL CAMINO\n");
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
    printf("p_stat.tipo: %c\n", p_stat.tipo);
    printf("p_stat.permisos: %c\n",p_stat.permisos);
    ts = localtime(&p_stat.atime);
    strftime(atime, sizeof(atime), "%a %Y-%m-%d %H:%M:%S", ts);
    ts = localtime(&p_stat.mtime);
    strftime(mtime, sizeof(mtime), "%a %Y-%m-%d %H:%M:%S", ts);
    ts = localtime(&p_stat.ctime);
    strftime(ctime, sizeof(ctime), "%a %Y-%m-%d %H:%M:%S", ts);
    printf("\atime: %s \nmtime: %s \nctime: %s\n",atime,mtime,ctime);
    printf("p_stat.nlinks: %u\n", p_stat.nlinks);
    printf("p_stat.tamEnBytesLog: %u\n", p_stat.tamEnBytesLog);
    printf("p_stat.numBloquesOcupados: %u\n\n", p_stat.numBloquesOcupados);
			int u;
			u = bumount(); 
			if (u == -1) {
				printf("ERROR: CIERRE FICHERO INCORRECTO.\n");
				return -1;
			} else {
				return 0;
			}
		}
	}
}