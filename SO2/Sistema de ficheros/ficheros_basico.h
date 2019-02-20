///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////FICHEROS_BASICO.H/////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <time.h>
#include <limits.h>
#include "bloques.h"


#define TAM_INODO 128
#define posSB 0
#define NPUNTEROS (int) (BLOCKSIZE/sizeof(unsigned int)) 				//256,  hay que convertir a int !!!
#define DIRECTOS 12   
#define INDIRECTOS0 (NPUNTEROS + DIRECTOS)								//268   
#define INDIRECTOS1 (NPUNTEROS * NPUNTEROS + INDIRECTOS0)   			//65.804   
#define INDIRECTOS2 (NPUNTEROS * NPUNTEROS * NPUNTEROS + INDIRECTOS1) 	//16.843.020

struct superbloque
{
	unsigned int posPrimerBloqueMB; 	//Posición del primer bloque del mapa de bits
	unsigned int posUltimoBloqueMB; 	//Posición del último bloque del mapa de bits
	unsigned int posPrimerBloqueAI; 	//Posición del primer bloque del array de inodos
	unsigned int posUltimoBloqueAI; 	//Posición del último bloque del array de inodos
	unsigned int posPrimerBloqueDatos; 	//Posición del primer bloque de datos
	unsigned int posUltimoBloqueDatos; 	//Posición del último bloque de datos
	unsigned int posInodoRaiz; 			//Posición del inodo del directorio raíz
	unsigned int posPrimerInodoLibre; 	//Posición del primer inodo libre
	unsigned int cantBloquesLibres; 	//Cantidad de bloques libres
	unsigned int cantInodosLibres; 		//Cantidad de inodos libres
	unsigned int totBloques; 			//Cantidad total de bloques
	unsigned int totInodos; 			//Cantidad total de inodos
	char padding[BLOCKSIZE - 12 * sizeof(unsigned int)]; //Relleno
};

	struct inodo
	{	
		unsigned char reserva_alineacion1[6];
		unsigned char tipo; 			//Libre, directorio o fichero
		unsigned char permisos;			//Lectura y/o escritura y/o ejecucion
		time_t atime; 					//Fecha y hora del último acceso a datos
		time_t mtime; 					//Fecha y hora de la última modificación de datos
		time_t ctime; 					//Fecha y hora de la última modificación del inodo
		unsigned int nlinks; 			//Cantidad de enlaces de entradas en directorio
		unsigned int tamEnBytesLog; 	//En bytes lógicos
		unsigned int numBloquesOcupados; //Cantidad de bloques ocupados en la zona de datos
		unsigned int punterosDirectos [12]; //12 punteros a bloques directos
		unsigned int punterosIndirectos [3]; //Uno simple, uno doble y uno triple
		char padding[TAM_INODO-2*sizeof(unsigned char)-3*sizeof(time_t)-18*sizeof(unsigned int)-6*sizeof(unsigned char)]; //Relleno
	};

int tamMB (unsigned int nbloques);
int tamAI (unsigned int ninodos);
int initSB (unsigned int nbloques, unsigned int ninodos);
int initMB ();
int initAI();
int escribir_bit(unsigned int nbloque, unsigned int bit);
unsigned char leer_bit(unsigned int nbloque);
int reservar_bloque();
int liberar_bloque(unsigned int nbloque);
int escribir_inodo(struct inodo inodo, unsigned int ninodo);
int leer_inodo(unsigned int ninodo, struct inodo *inodo);
int reservar_inodo(unsigned char tipo, unsigned char permisos);
int obtener_nrangoBL (struct inodo inodo, int nblogico, int *ptr);
int obtener_indice (int nblogico, int nivel_punteros);
int traducir_bloque_inodo(unsigned int ninodo, unsigned int nblogico, char reservar);
int liberar_inodo(unsigned int ninodo);
int liberar_bloques_inodo(unsigned int ninodo, unsigned int nblogico);