///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////LEER_SF.C/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "ficheros_basico.h"
#include <time.h>

int main(int argc, char **argv){ //$ ./leer_sf <nombre_dispositivo>
if(argc ==2){
	struct superbloque SB; //creamos superbloque

	bmount(argv[1]);//Montar el fichero que se usará como disp.//nombre de fichero
	
	if (bread(posSB,&SB)==-1) return -1;


	printf("DATOS DEL SUPERBLOQUE\n");
	printf("posPrimerBloqueMB = %d\n", SB.posPrimerBloqueMB);
	printf("posUltimoBloqueMB = %d\n", SB.posUltimoBloqueMB);
	printf("posPrimerBloqueAI = %d\n", SB.posPrimerBloqueAI);
	printf("posUltimoBloqueAI = %d\n", SB.posUltimoBloqueAI);
	printf("posPrimerBloqueDatos = %d\n", SB.posPrimerBloqueDatos);
	printf("posUltimoBloqueDatos = %d\n", SB.posUltimoBloqueDatos);
	printf("posInodoRaiz = %d\n", SB.posInodoRaiz);
	printf("posPrimerInodoLibre = %d\n", SB.posPrimerInodoLibre);
	printf("cantBloquesLibres = %d\n", SB.cantBloquesLibres);
	printf("cantInodosLibres = %d\n", SB.cantInodosLibres);
	printf("totBloques = %d\n", SB.totBloques);
	printf("totInodos = %d\n", SB.totInodos);
	printf(" \n");
	int x=0;
	int ninodo=0;
//ninodo=reservar_inodo('f', 6);
	
    // traducir_bloque_inodo(ninodo, 8, 1);
    // traducir_bloque_inodo(ninodo, 204, 1);
    // traducir_bloque_inodo(ninodo, 30004, 1);
    // traducir_bloque_inodo(ninodo, 400004, 1);
    // traducir_bloque_inodo(ninodo, 16843019, 1); //bloque lógico máximo del SF

	struct tm *ts;
	char atime[80];
	char mtime[80];
	char ctime[80];
	struct inodo ino;
for (int i = 0; i<SB.totInodos; ++i)
{
if((ninodo=leer_inodo(i,&ino))==-1) {
	printf("ERROR\n");
}
if (ino.tipo !='l'){
	printf ("ninodo: %d\n", i);
	
	x++;
printf("tipo: %c\n", ino.tipo);
printf("permisos: %c\n", ino.permisos);

	ts = localtime(&ino.atime);
	strftime(atime, sizeof(atime), "%a %Y-%m-%d %H:%M:%S", ts);
	ts = localtime(&ino.mtime);
	strftime(mtime, sizeof(mtime), "%a %Y-%m-%d %H:%M:%S", ts);
	ts = localtime(&ino.ctime);
	strftime(ctime, sizeof(ctime), "%a %Y-%m-%d %H:%M:%S", ts);
	printf("\atime: %s \nmtime: %s \nctime: %s\n",atime,mtime,ctime);
	printf("nlinks: %d\n", ino.nlinks);
	printf("tamEnBytesLog: %d\n", ino.tamEnBytesLog);
	printf("numBloquesOcupados: %d\n\n", ino.numBloquesOcupados);

	// printf("MAPA DE BITS CON BLOQUES DE METADATOS OCUPADOS\n");
	// printf("bloque %d (posSB) = %u\n", posSB,leer_bit(posSB));
	// printf("bloque %d (posPrimerBloqueMB) = %u\n", SB.posPrimerBloqueMB,leer_bit(SB.posPrimerBloqueMB));
	// printf("bloque %d (posUltimoBloqueMB) = %u\n", SB.posUltimoBloqueMB,leer_bit(SB.posUltimoBloqueMB));
	// printf("bloque %d (posPrimerBloqueAI) = %u\n", SB.posPrimerBloqueAI,leer_bit(SB.posPrimerBloqueAI));
	// printf("bloque %d (posUltimoBloqueAI) = %u\n", SB.posUltimoBloqueAI,leer_bit(SB.posUltimoBloqueAI));
	// printf("bloque %d (posPrimerBloqueDatos) = %u\n", SB.posPrimerBloqueDatos,leer_bit(SB.posPrimerBloqueDatos));
	// printf("bloque %d (posUltimoBloqueDatos) = %u\n", SB.posUltimoBloqueDatos,leer_bit(SB.posUltimoBloqueDatos));
}	}
	bumount();//Desmontar el fichero usado como dispositivo.
}

else{
	printf("Sintax error\n");
}

return 0;
}