///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////FICHEROS.C////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include <string.h>
#include <stdio.h>
#include "bloques.h"
#include "ficheros.h"


int mi_write_f(unsigned int ninodo, const void *buf_original,unsigned int offset, unsigned int nbytes){	
	int primerBL, ultimoBL, ultimoByteL;
	int desp1, desp2;
	int bloqueFisico;
	unsigned char buff_bloque[BLOCKSIZE];
	struct inodo inodo;
	if(leer_inodo(ninodo, &inodo) == -1) return -1;
	if((inodo.permisos & 2) != 2){
		fprintf(stderr, "Error: no tiene permisos de escritura\n");
		return -1;
	} 
	primerBL = offset/BLOCKSIZE;
	ultimoByteL = (offset + nbytes - 1);
	ultimoBL = ultimoByteL/BLOCKSIZE;
	desp1 = offset % BLOCKSIZE;
	if(primerBL == ultimoBL) 
	{
		mi_waitSem();
		bloqueFisico = traducir_bloque_inodo(ninodo, primerBL, 1);
		mi_signalSem();
		if(bloqueFisico == -1) return -1;
		if(bread(bloqueFisico, buff_bloque) == -1) return -1;
		memcpy(buff_bloque + desp1, buf_original, nbytes);
		if(bwrite(bloqueFisico,buff_bloque) == -1) return -1;
	} else{	
		//primer bloque
		mi_waitSem();
		bloqueFisico = traducir_bloque_inodo(ninodo, primerBL, 1);
		mi_signalSem();
		if(bloqueFisico == -1) return -1;
		if(bread(bloqueFisico, buff_bloque) == -1) return -1;
		memcpy(buff_bloque+desp1, buf_original, BLOCKSIZE - desp1);
		if(bwrite(bloqueFisico,buff_bloque) == -1) return -1;
		//bloques intermedios
		for (int i = primerBL + 1; i < ultimoBL; i++){
			mi_waitSem();
			bloqueFisico = traducir_bloque_inodo(ninodo, i, 1);
			mi_signalSem();
			if(bwrite(bloqueFisico, buf_original + (BLOCKSIZE - desp1) + (i - primerBL - 1) * BLOCKSIZE) == -1) return -1;
		}

		//último bloque
		mi_waitSem();
		bloqueFisico = traducir_bloque_inodo(ninodo, ultimoBL, 1);
		mi_signalSem();
		if(bloqueFisico == -1) return -1;
		if(bread(bloqueFisico, buff_bloque) == -1) return -1;
		desp2 = ultimoByteL % BLOCKSIZE;	
		memcpy (buff_bloque, buf_original + nbytes - desp2 - 1, desp2 + 1);
		if(bwrite(bloqueFisico,buff_bloque) == -1) return -1;
	}
	mi_waitSem();
	if(leer_inodo(ninodo, &inodo) == -1){
		mi_signalSem();
		return -1;
	}
	if((offset + nbytes) > inodo.tamEnBytesLog) {
		inodo.tamEnBytesLog = (offset + nbytes);
		inodo.ctime = time(NULL);
	}
	inodo.mtime = time(NULL);
	if(escribir_inodo(inodo,ninodo) == -1){
		mi_signalSem();
		return -1;
	}
	mi_signalSem();
	return nbytes;
}


int mi_read_f(unsigned int ninodo, void *buf_original, unsigned int offset, unsigned int nbytes) {	
	struct inodo inodo;
	int leidos = 0;

	mi_waitSem();
	if(leer_inodo(ninodo, &inodo) == -1){
		mi_signalSem();
		return -1;
	}
	inodo.atime = time(NULL);
	if(escribir_inodo(inodo,ninodo) == -1){
		mi_signalSem();
		return -1;
	}
	mi_signalSem();

	if((inodo.permisos & 4) != 4){
		fprintf(stderr, "El inodo %u no tiene permisos de lectura\n", ninodo);
		return -1;
	}
	
	if((offset + nbytes) >= inodo.tamEnBytesLog) {
		nbytes = inodo.tamEnBytesLog - offset; 
	}
	if(offset >= inodo.tamEnBytesLog){
		return leidos; 
	}

	int primerBL, ultimoBL, ultimoByteL; 
	int desp1, desp2;				
	int bloqueFisico;
	unsigned char buff_bloque[BLOCKSIZE];

	primerBL = offset/BLOCKSIZE;
	ultimoByteL = (offset + nbytes - 1);
	ultimoBL = ultimoByteL/BLOCKSIZE;
	desp1 = offset % BLOCKSIZE;

	if(primerBL == ultimoBL) {
		bloqueFisico = traducir_bloque_inodo(ninodo, primerBL, 0);
		if(bloqueFisico != -1) {
			if(bread(bloqueFisico, buff_bloque) == -1) return -1;
			memcpy(buf_original, buff_bloque + desp1, nbytes);
		}
		leidos = leidos + nbytes;
	} else{	
		//primer bloque
		bloqueFisico = traducir_bloque_inodo(ninodo, primerBL, 0);
		if(bloqueFisico != -1){
			if(bread(bloqueFisico, buff_bloque) == -1) return -1;
			memcpy(buf_original, buff_bloque + desp1, BLOCKSIZE - desp1);
			
		}
		leidos = leidos + BLOCKSIZE - desp1;
		//bloques intermedios
		for (int i = primerBL + 1; i < ultimoBL; i++){
			bloqueFisico = traducir_bloque_inodo(ninodo, i, 0);
			if(bloqueFisico != -1){
				if(bread(bloqueFisico, buff_bloque) == -1) return -1;
				memcpy(buf_original + (BLOCKSIZE - desp1) + (i - primerBL - 1) * BLOCKSIZE, buff_bloque , BLOCKSIZE);
			}
			leidos = leidos + BLOCKSIZE;
		}

		//último bloque
		bloqueFisico = traducir_bloque_inodo(ninodo, ultimoBL, 0);
		if(bloqueFisico != -1){
			if(bread(bloqueFisico, buff_bloque) == -1) return -1;
			desp2 = ultimoByteL % BLOCKSIZE;	
			memcpy (buf_original + nbytes - desp2 - 1, buff_bloque, desp2 + 1);
		}
		leidos = leidos + desp2 + 1;
	}
	return leidos;
}

int mi_stat_f(unsigned int ninodo, struct STAT *p_stat){
// Devuelve la metainformación de un fichero/directorio (correspondiente al nº de
// inodo pasado como argumento): tipo, permisos, cantidad de enlaces de entradas en directorio, 
// tamaño en bytes lógicos, timestamps y cantidad de bloques ocupados en la zona de datos, es decir 
// todos los campos menos los punteros. (No es preciso utilizar campos para la alineación ni paddings)

// Se recomienda definir un tipo estructurado denominado STAT (podemos considerar que la estructura 
// 	STAT es la misma que la estructura INODO pero sin los punteros).
	struct inodo ino; leer_inodo(ninodo, &ino);
	p_stat -> tipo 				 = ino.tipo;
	p_stat -> permisos 			 = ino.permisos;
	p_stat -> atime 			 = ino.atime;
	p_stat -> mtime 			 = ino.mtime;
	p_stat -> ctime 			 = ino.ctime;
	p_stat -> nlinks 	 		 = ino.nlinks;
	p_stat -> tamEnBytesLog 	 = ino.tamEnBytesLog;
	p_stat -> numBloquesOcupados = ino.numBloquesOcupados;
	return 0;
}

int mi_chmod_f(unsigned int ninodo, unsigned char permisos){
// Cambia los permisos de un fichero/directorio (correspondiente al nº de inodo 
// pasado como argumento) según indique el argumento.
	mi_waitSem();
	struct inodo ino; leer_inodo(ninodo, &ino);
	ino.permisos = permisos;
// Actualizar ctime
	ino.ctime = time(NULL);
	escribir_inodo(ino, ninodo);
	mi_signalSem();
	return 0;
}

int mi_truncar_f(unsigned int ninodo, unsigned int nbytes){
// Trunca un fichero/directorio (correspondiente al nº de inodo pasado como argumento) 
// a los bytes indicados, liberando los bloques que no hagan falta.
	struct inodo ino; leer_inodo(ninodo, &ino);
	// Hay que comprobar que el inodo tenga permisos de escritura. 
	// No se puede truncar más allá del tamaño en bytes lógicos del fichero/directorio.
	if ((ino.permisos & 2) != 2) {
		return -1;
		// print permisos
	}else{
		if (ino.tamEnBytesLog<=nbytes)
		{
			fprintf(stderr, "No se puede truncar más allá del EOF: %d\n",ino.tamEnBytesLog );
			return -1;
		}
	// Nos basaremos en la función liberar_bloques_inodo() . 
	//Para saber que nº de bloque lógico le hemos de pasar:
	// si nbytes % BLOCKSIZE = 0  entonces nblogico := nbytes/BLOCKSIZE 
	// si_no nblogico := nbytes/BLOCKSIZE + 1
		int nblogico;
		if((nbytes % BLOCKSIZE) == 0){
			nblogico = nbytes/BLOCKSIZE;
		}else{
			nblogico = (nbytes / BLOCKSIZE) + 1;
		}

		ino.numBloquesOcupados=ino.numBloquesOcupados-liberar_bloques_inodo(ninodo, nblogico);
		//printf("inodo.numBloquesOcupados: %d\n\n",ino.numBloquesOcupados );
		// Actualizar mtime, ctime y el tamaño en bytes lógicos del inodo 
		// (pasará a ser igual a nbytes)!
		ino.ctime = time(NULL);
		ino.mtime = time(NULL);
		ino.tamEnBytesLog = nbytes;

		escribir_inodo(ino, ninodo);
		return 0;
	}
}