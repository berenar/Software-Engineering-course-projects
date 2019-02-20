///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////DIRECTORIOS.C/////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "directorios.h"


struct UltimaEntrada UltimaEntradaLectura;
struct UltimaEntrada UltimaEntradaEscritura;

int error_entrada(int error)
{
	switch(error)
	{	


		case -1: fprintf(stderr, "ERROR:No se ha podido extraer el camino.\n"); break;
		case -2: fprintf(stderr, "ERROR:No existe entrada consulta.\n"); break;
		case -3: fprintf(stderr, "ERROR:No existe directorio intermedio.\n"); break;
		case -4: fprintf(stderr, "ERROR:No hay permisos de escritura.\n"); break;
		case -5: fprintf(stderr, "ERROR:Entrada ya existente.\n"); break;
		case -6: fprintf(stderr, "ERROR:No directorio no se ha podido crear.\n"); break;
		case -7: fprintf(stderr, "ERROR:El fichero no se ha podido crear.\n"); break;
		case -8: fprintf(stderr, "ERROR:El inodo no tiene permisos de lectura.\n"); break;
	}
	return 0;
}

int extraer_camino(const char *camino, char *inicial, char *final, char *tipo){
	int i = 0;
	if (camino[0]!='/')
	{
	return ERROR_EXTRAER_CAMINO;
	}
	const char *sig_camino = strchr(camino + 1,'/');
	memset(inicial,0,strlen(inicial));
	if(sig_camino==NULL){
		//It's a file
		strcpy(inicial, camino+1);
		*final = '\0';		
		*tipo = 'f';
	}else{
		//It's a directory
		i = sig_camino - camino - 1;
		strncpy(inicial, camino + 1,i);
		strcpy(final, sig_camino);
		*tipo = 'd';
	}

	return 0;
}

int buscar_entrada(const char *camino_parcial, unsigned int *p_inodo_dir, unsigned int *p_inodo, unsigned int *p_entrada, char reservar, unsigned char permisos){
	if (strcmp(camino_parcial, "/") == 0) {
		*p_inodo = 0;
		*p_entrada =0;
		// printf("----------------C\n");
		return 0;
	}	
	char inicial[LONG_CAM_MAX];
	char final[strlen(camino_parcial)];
	memset(inicial,0,LONG_CAM_MAX);
	memset(final,0,strlen(camino_parcial));
	char tipo;
	if (extraer_camino(camino_parcial, inicial, final,&tipo) == -1) {
		return ERROR_EXTRAER_CAMINO;
	}
	// printf("final:%s\n", final);
	// printf("inicial:%s\n", inicial);

	struct inodo in;
	leer_inodo(*p_inodo_dir,&in);
	char buffer[in.tamEnBytesLog];
	struct entrada *entrada;
	entrada = malloc(sizeof(struct entrada));
	entrada->nombre[0] = '\0';

	int numentrades = in.tamEnBytesLog / sizeof(struct entrada);
	// printf("Numentrades:%d\n",numentrades );
	int nentrada = 0;
	

	if (numentrades > 0){

	// 	// printf("numentradesMAJORqueCERO\n");
	// 	if ((in.permisos & 4 )!= 4) return ERROR_PERMISO_LECTURA;
	// 	mi_read_f(*p_inodo_dir, entrada, nentrada * sizeof(struct entrada), sizeof(struct entrada));
	// 	while ((nentrada < numentrades) && (strcmp(entrada.nombre, inicial) != 0)){ 
	// 		nentrada++;
	// 		mi_read_f(*p_inodo_dir, entrada, nentrada * sizeof(struct entrada), sizeof(struct entrada));
	// 	}

	        if ((in.permisos & 4) != 4) return ERROR_PERMISO_LECTURA;

			int offset = 0; int encontrado = 1;
	      	while(nentrada < numentrades && encontrado != 0)
	      	{
	      		mi_read_f(*p_inodo_dir, buffer, nentrada * sizeof(struct entrada), sizeof(buffer)); //leer siguiente entrada
				memcpy(entrada, buffer, sizeof(struct entrada));
				encontrado = strcmp(inicial, entrada->nombre);
				while(offset < numentrades && nentrada < numentrades && encontrado != 0)
				{
					nentrada++;
					offset++;
					memcpy(entrada, offset * sizeof(struct entrada) + buffer, sizeof(struct entrada));
					encontrado = strcmp(inicial, entrada->nombre);
				}
				offset = 0;
	      	}


	}	
    if (nentrada == numentrades){ //la entrada no existe

    	switch(reservar){
            case 0:  //modo consulta. Como no existe retornamos error
            return ERROR_NO_EXISTE_ENTRADA_CONSULTA;
            case 1:  
            		//modo escritura. 
                 if (in.tipo=='f')
                 {
                 	return -1;
                 }
                 //Creamos la entrada en el directorio referenciado por *p_inodo_dir
            strcpy(entrada->nombre, inicial);
            if (tipo == 'd'){
            	if (strcmp(final,"/")==0) {
            		// printf("reservamosDIRECTORIO\n");
            		entrada->inodo = reservar_inodo('d', permisos);
			        }else{//cuelgan más diretorios o ficheros
			        	return ERROR_NO_EXISTE_DIRECTORIO_INTERMEDIO;
			        }
			    }else{ //es un fichero

			    	entrada->inodo = reservar_inodo('f', permisos);	

			    }
			    if (mi_write_f(*p_inodo_dir, entrada, nentrada * sizeof(struct entrada), sizeof(struct entrada)) < 0) {
			    	if (entrada->inodo != -1) {

			    		liberar_inodo(entrada->inodo);
			    	}
			    	printf("4\n");
			    	return ERROR_PERMISO_ESCRITURA;
			    }
			}

		}

		if ((strcmp(final,"/")==0) || strcmp(final, "\0") == 0){

			if ((nentrada < numentrades) && (reservar == 1)) {return ERROR_ENTRADA_YA_EXISTENTE;}

			*p_inodo = entrada->inodo;
			*p_entrada =nentrada;
			return 0;
		} else {

			*p_inodo_dir = entrada->inodo;	

			return buscar_entrada(final, p_inodo_dir, p_inodo, p_entrada, reservar, permisos);
		}
	}


int mi_creat(const char *camino, unsigned char permisos){
	mi_waitSem();
	unsigned int p_inodo_dir, p_inodo, p_entrada;
	p_inodo_dir = 0; //inodo raiz
	// struct superbloque sb;
	// bread(POS_SB, &sb);
	// int p_inodo, p_entrada;
	// int p_inodo_dir = sb.posInodoRaiz;

	//Crea fichero/directorio con reservar a 1
	int comprobar = buscar_entrada(camino, &p_inodo_dir, &p_inodo, &p_entrada, 1, permisos);
	if(comprobar<0){
		switch(comprobar){
		case -1:
			printf("Tipo no adecuado");
			break;
		case -2:
			printf("No se puede leer el inodo");
			break;
		case -3:
			printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
			break;
		case -5:
			printf("Ya existe");
			break;

		}
		mi_signalSem();
		return -1; //Algo ha fallado;
	}
	mi_signalSem();
	return 0; //Todo correcto
}

	int mi_dir (const char *camino, char *buf) {
	unsigned int zero = 0;
	unsigned int p_inodo=0;
	unsigned int p_entrada=0;
	char permisos = '4';
	struct inodo in;
	struct entrada entr;
	int error;
	error = buscar_entrada(camino, &zero, &p_inodo, &p_entrada, 0, permisos);
	//Buscamos la entrada correspondiente a camino para comprobar que existe.
	//Comprobación errores.
	if(error<0){
		switch(error){
		case -1:
			printf("Tipo no adecuado");
			break;
		case -2:
			printf("No se puede leer el inodo");
			break;
		case -3:
			printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
			break;
		case -5:
			printf("Ya existe");
			break;

		}
		mi_signalSem();
		return -1;
	}

	
	if(leer_inodo(p_inodo, &in) == -1) return -1; //lee el inodo

	//comprobar que se trata de un directorio y que tiene permisos de lectura.
	if(in.tipo != 'd' && in.permisos & 4) return -1;

	int numEntradas = in.tamEnBytesLog/sizeof(struct entrada);



	for(int i=0;i < numEntradas;i++){ //Mientras haya entradas

		if(mi_read_f(p_inodo,&entr,i*sizeof(struct entrada),sizeof(struct entrada)) < 0){
			printf("Error in mi_link while reading struct entrada, file directorios.c \n");
			return -1;			
		}

		if(leer_inodo(entr.inodo, &in) == -1) return -1;

			if(in.tipo == 'd') strcat(buf,"d"); //Tipo de inodo
			else strcat(buf,"f");
			strcat(buf,"\t");
			//Para incorporar informacion acerca de los permisos
			if(in.permisos & 4) strcat(buf,"r");
			else strcat(buf,"-");

			if(in.permisos & 2) strcat(buf,"w");
			else strcat(buf,"-");

			if(in.permisos & 1) strcat(buf,"x");
			else strcat(buf,"-");

			strcat(buf, "\t");
		
			//Para incorporar informacion acerca del tiempo
			struct tm *tm;
			char tmp[100];
			tm = localtime(&in.mtime);
			sprintf(tmp,"%d-%02d-%02d %02d:%02d:%02d\t",tm->tm_year+1900,tm->tm_mon+1,tm->tm_mday,tm->tm_hour,tm->tm_min,tm->tm_sec);
			strcat(buf,tmp);
			char size [15];
			sprintf(size, "%d", in.tamEnBytesLog);
			strcat(buf,size);
			strcat(buf, "\t");

			strcat(buf,entr.nombre);
			strcat(buf,"\n");

		}
		return numEntradas;
	}

int mi_link(const char *camino1, const char *camino2){
	unsigned int p_inodo_dir = 0;
	unsigned int p_inodo = 0;
	unsigned int p_entrada = 0;
	char permisosCERO= '0';
	char permisosSEIS='6';

	struct entrada entrada;
	struct inodo inodo;
	mi_waitSem();
	int error = buscar_entrada(camino1,&p_inodo_dir,&p_inodo,&p_entrada,0,permisosCERO); //Obtiene entrada origen

	if(error<0){
		switch(error){
		case -1:
			printf("Tipo no adecuado");
			break;
		case -2:
			printf("No se puede leer el inodo");
			break;
		case -3:
			printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
			break;
		case -5:
			printf("Ya existe");
			break;

		}
		mi_signalSem();
		return -1;
	}
	int ninodo = p_inodo;


	if(leer_inodo(ninodo, &inodo) == -1){
		mi_signalSem();
		return -1;
	}

	if(inodo.tipo != 'f' && (inodo.permisos & 4) != 4) {
		error_entrada(ERROR_PERMISO_LECTURA);
		mi_signalSem();
		return -1;
	}


	p_inodo_dir = 0;
	error = buscar_entrada(camino2,&p_inodo_dir,&p_inodo,&p_entrada,1,permisosSEIS);	//Crea entrada destino
	if(error<0){
		switch(error){
		case -1:
			printf("Tipo no adecuado");
			break;
		case -2:
			printf("No se puede leer el inodo");
			break;
		case -3:
			printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
			break;
		case -5:
			printf("Ya existe");
			break;
		}
		mi_signalSem();
		return -1;
	}
	if(mi_read_f(p_inodo_dir,&entrada,p_entrada*sizeof(struct entrada),sizeof(struct entrada))==-1){	
			mi_signalSem();
			return -2;
	}	
	liberar_inodo(entrada.inodo);
	entrada.inodo = ninodo;
	if(mi_write_f(p_inodo_dir,&entrada,p_entrada*sizeof(struct entrada),sizeof(struct entrada))==-1){	
		mi_signalSem();
		return -3; 
	}
	if(leer_inodo(ninodo, &inodo) == -1)
	{
		mi_signalSem();
		return -1;
	}
	inodo.nlinks++;
	inodo.ctime = time(NULL);
	escribir_inodo(inodo,ninodo);
	
	mi_signalSem();
	return 0;
}


/*
Borra la entrada de directorio especificada y, en caso de que sea el último enlace existente,
 borrar el propio fichero/directorio.
*/

int mi_unlink(const char *camino){
	unsigned int p_inodo_dir=0;
	unsigned int p_inodo= 0;
	unsigned int p_entrada = 0;
	struct entrada entrada;
	int nentradas;
	struct inodo inodo;
	char permisos = '6';
	mi_waitSem();
	int error = buscar_entrada(camino,&p_inodo_dir,&p_inodo,&p_entrada,0,permisos);
	if(error<0){
		switch(error){
		case -1:
			printf("Tipo no adecuado");
			break;
		case -2:
			printf("No se puede leer el inodo");
			break;
		case -3:
			printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
			break;
		case -4:
			printf("No existe");
			break;
		}
		mi_signalSem();
		return -1;
	}
	if(leer_inodo(p_inodo, &inodo) == -1){mi_signalSem();return -1;}

	if(inodo.tipo == 'd' && (inodo.tamEnBytesLog != 0)) {mi_signalSem();return -2;}

	if(leer_inodo(p_inodo_dir, &inodo) == -1){mi_signalSem();return -1;}
	nentradas = inodo.tamEnBytesLog/sizeof(struct entrada);

	if(p_entrada != nentradas - 1){
		mi_read_f(p_inodo_dir, &entrada, (nentradas - 1) * sizeof(struct entrada), sizeof(struct entrada));
		mi_write_f(p_inodo_dir, &entrada, p_entrada * sizeof(struct entrada), sizeof(struct entrada));	
	}
	mi_truncar_f(p_inodo_dir, (nentradas - 1) * sizeof(struct entrada));

	if(leer_inodo(p_inodo, &inodo) == -1){	mi_signalSem();	return -1;}
	inodo.nlinks--;
	if(inodo.nlinks == 0) {	
		liberar_inodo(p_inodo);
	} else{
		inodo.ctime = time(NULL);
		escribir_inodo(inodo, p_inodo);
	}
	mi_signalSem();
	return 0;
}

/*
Buscar la entrada camino para obtener el p_inodo. 
Si la entrada existe llamamos a la función correspondiente de ficheros.c 
pasándole el p_inodo: mi_chmod_f(p_inodo, permisos)
*/
	int mi_chmod(const char *camino, unsigned char permisos){
		unsigned int zero = 0;
		unsigned int p_inodo;
		unsigned int p_entrada;
		int error = buscar_entrada(camino, &zero, &p_inodo, &p_entrada, 0,permisos);
		if(error<0){
			switch(error){
			case -1:
				printf("Tipo no adecuado");
				break;
			case -2:
				printf("No se puede leer el inodo");
				break;
			case -3:
				printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
				break;
			case -4:
				printf("No existe");
				break;
			}
			return -1;
		}
		mi_chmod_f(p_inodo, permisos);
		return 0;
	}

/*
Buscar la entrada camino para obtener el p_inodo. 
Si la entrada existe llamamos a la función correspondiente de ficheros.c 
pasándole el p_inodo: mi_stat_f(p_inodo, p_stat)
*/

int mi_stat (const char *camino, struct STAT *p_stat) {
		unsigned int zero = 0;
		unsigned int p_inodo;
		unsigned int p_entrada;
		char permisos = '4';
		int error = buscar_entrada(camino, &zero, &p_inodo, &p_entrada, 0,permisos);
	if(error<0){
			switch(error){
			case -1:
				printf("Tipo no adecuado");
				break;
			case -2:
				printf("No se puede leer el inodo");
				break;
			case -3:
				printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
				break;
			case -4:
				printf("No existe");
				break;
			}
			return -1;
		}
	// if(BE < 0) { //Tratamiento de errores
	// 	switch(BE){
	// 	case -1: printf("\"%s\" Camino no valido\n", camino); break;
	// 	case -2: printf("No tienes permisos de lectura\n"); break;
	// 	case -3: printf("Error en la lectura de la entrada \"%s\"\n", camino); break;
	// 	case -4: printf("No existe la entrada \"%s\"\n", camino); break;
	// 	case -5: printf("Error a la hora de reservar un inodo"); break;
	// 	case -6: printf("No existe directorio intermedio a \"%s\"", camino); break;
	// 	case -7: printf("Error a la hora de liberar un inodo"); break;
	// 	case -8: printf("Error en la escritura de la entrada \"%s\"\n", camino); break;
	// 	case -9: printf("Ya existe la entrada \"%s\"\n", camino); break;
	// 	}
	// 	return -1; //Error BE
	// }
		if(mi_stat_f(p_inodo,p_stat) < 0) return -2; //Error STAT
	return 0;
}

int mi_read(const char *camino, void *buf, unsigned int offset, unsigned int nbytes){
	unsigned int p_inodo_dir, p_inodo, p_entrada;
	p_inodo_dir = 0;
	char permisos = '4';
	//Comprobamos si el camino que nos pasan por parámetro es igual al último camino utilizado
	if(strcmp (camino, UltimaEntradaLectura.camino) == 0) {
		p_inodo = UltimaEntradaLectura.p_inodo;
	}else{ //Sino buscamos la entrada
		int error=buscar_entrada(camino, &p_inodo_dir, &p_inodo, &p_entrada, 0, permisos);
			if(error<0){
			switch(error){
			case -1:
				printf("Tipo no adecuado");
				break;
			case -2:
				printf("No se puede leer el inodo");
				break;
			case -3:
				printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
				break;
			case -4:
				printf("No existe");
				break;
			}
			return -1;
		}
		//copiamos el inodo en la variable global
		strcpy(UltimaEntradaLectura.camino, camino);
		UltimaEntradaLectura.p_inodo = p_inodo;
	}
	//Leemos en el sitio que nos pasan por parametro
	return mi_read_f(p_inodo, buf, offset, nbytes);
}

int mi_write(const char *camino, const void *buf, unsigned int offset, unsigned int nbytes){
	unsigned int p_inodo_dir, p_inodo, p_entrada;
	p_inodo_dir = 0;
	char permisos = '6';
	// mi_waitSem();
	//Comprobamos si el camino que nos pasan por parámetro es igual al último camino utilizado
	if(strcmp (camino, UltimaEntradaEscritura.camino) == 0) {
		p_inodo = UltimaEntradaEscritura.p_inodo;
	}else{ //Sino buscamos la entrada
		int error=buscar_entrada(camino, &p_inodo_dir, &p_inodo, &p_entrada, 0, permisos);
			if(error<0){
			switch(error){
			case -1:
				printf("Tipo no adecuado");
				break;
			case -2:
				printf("No se puede leer el inodo");
				break;
			case -3:
				printf("El directorio donde apunta p_inodo_dir no tiene permisos de escritura");
				break;
			case -4:
				printf("No existe");
				break;
			}
			return -1;
		}
		//copiamos el inodo en la variable global
		strcpy(UltimaEntradaEscritura.camino, camino);
		UltimaEntradaEscritura.p_inodo = p_inodo;
	}
	int bytesLeidos;
	if((bytesLeidos = mi_write_f(p_inodo, buf, offset, nbytes)) < 0){
		return -1;
	}
	return bytesLeidos;
}

int mi_rename(const void *camino_i, const void *camino_f){
	unsigned int pid = 0, pi = 0, pe = 0;
	struct entrada entrada;
	if(buscar_entrada(camino_i, &pid, &pi, &pe, 0, 0)<0){
		return -3;
	};
	if(mi_read_f(pid,&entrada,pe*sizeof(struct entrada),sizeof(struct entrada)) < 0) return -2;
	strcpy(entrada.nombre, camino_f);
	if(mi_write_f(pid,&entrada,pe*sizeof(struct entrada),sizeof(struct entrada)) < 0) return -2;
	return 0;
}