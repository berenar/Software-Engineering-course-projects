///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////MI_MKFS.C/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
#include "ficheros_basico.h"

 //Determinado de manera heurística

int main(int argc, char **argv)
{
if(argc ==3){
	int nbloques = atoi(argv[2]);
	unsigned int ninodos=nbloques/4;
	bmount(argv[1]);//Montar el fichero que se usará como disp.
	unsigned char T[BLOCKSIZE];//Del tamaño de un bloque.
	memset(T,0,BLOCKSIZE);//inicializaremos a 0.
	//No sé si la creacion del bloque va dentro del for o fuera:
	//Supongo que creamos un bloque en blanco y luego lo escribimos.
	//por lo que usamos tantos buffers vacíos como nbloques.
	int i;//Tengo que declarlo fuera del for, 
	for (i =0;i<nbloques;i++){
		bwrite(i,T);
	}
	initSB(nbloques,ninodos);
	initMB(nbloques); 
	initAI(ninodos);
	reservar_inodo('d', '7'); //reservar primer inodo 
	bumount();//Desmontar el fichero usado como dispositivo.
}
else{
	printf("Sintax error\n");
}
return 0;

}

