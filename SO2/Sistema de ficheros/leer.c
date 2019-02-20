#include <stdio.h>
#include <string.h>

#include "ficheros.h"



int main(int argc, char **argv) {
	if(argc==3){
		unsigned int size=1700;
		void *nombre_fichero = argv[1];
		int ninodo = atoi(argv[2]);
		unsigned char buffer [size];
		memset(buffer, 0, size);

		unsigned int offset = 0;
		unsigned int llegit = 0;
		unsigned int lectura_actual=0;

		if(bmount(nombre_fichero)==-1){
			printf("Error de fichero");
		}else{
			struct inodo ino; leer_inodo(ninodo, &ino);
			if(ino.permisos<4){
				printf("El inodo %d no tiene permiso de lectura\n",ninodo );
				
			}else{
			// printf("tamEnBytesLog:%d\n",ino.tamEnBytesLog);
			//Se ha de guardar el tamaño del buffer de lectura en una variable o constante simbólica para que sea fácilmente modificable.
				lectura_actual=mi_read_f(ninodo,buffer,offset,size);
			// printf("lectura:%d\n",lectura_actual);
				while(lectura_actual>0){
					llegit+=lectura_actual;
					write(1, buffer, lectura_actual);
					offset += size;
					memset(buffer, 0, size);
					lectura_actual=mi_read_f(ninodo,buffer,offset,size);
				}
			}
			//mostrar los resultados por pantalla
			struct STAT state;
			mi_stat_f(ninodo,&state);
			char string [128];
			sprintf(string, "\n\nBytes leídos: %d\nTamaño en bytes lógicos del inodo: %d\n", llegit, state.tamEnBytesLog);	
			write(2, string, strlen(string));
			
			int u;
			u=bumount();
			if(u==-1){
				printf("Error en el close del fitxer\n");
				return -1;
			} else {
				return 0;
			}

		}
	}else{
		printf("Sintaxis: ./leer <nombre_dispositivo> <numero_inodo>\n");
	}


}