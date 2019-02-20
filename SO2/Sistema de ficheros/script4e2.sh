echo "Comprobación de permisos y sellos de tiempo"
echo "################################################################################"
echo "$ ./mi_mkfs disco 100000"
./mi_mkfs disco 100000
echo "################################################################################"
echo "$ ./mi_mkdir disco 4 /dir1/ #le damos permiso de lectura a dir1"
./mi_mkdir disco 4 /dir1/
echo "################################################################################"
echo "$ ./mi_ls disco /"
./mi_ls disco /
echo "################################################################################"
echo "$ ./mi_mkdir disco 6 /dir1/dir21/"
./mi_mkdir disco 6 /dir1/dir21/
echo "################################################################################"
echo "./mi_chmod disco 6 /dir1/ #le damos permiso de lectura/escritura a dir1"
./mi_chmod disco 6 /dir1/
echo "################################################################################"
echo "$ ./mi_ls disco /"
./mi_ls disco /
echo "################################################################################"
echo "$ ./mi_mkdir disco 6 /dir1/dir21/"
./mi_mkdir disco 6 /dir1/dir21/
echo "################################################################################"
echo "./mi_ls disco /dir1/"
./mi_ls disco /dir1/
echo "################################################################################"
echo "./mi_mkdir disco 6 /dir1/fic1"
./mi_mkdir disco 6 /dir1/fic1
echo "################################################################################"
echo "./mi_mkdir disco 6 /dir1/fic1/dir2/"
./mi_mkdir disco 6 /dir1/fic1/dir2/
echo "################################################################################"
echo "Vamos a escribir utilizando un offset correspondiente a un BL direccionado por I0"
echo "./mi_escribir disco /dir1/fic1 hola1  256000"
./mi_escribir disco /dir1/fic1 hola1  256000
echo "################################################################################"
echo "./mi_stat disco /dir1/fic1"
./mi_stat disco /dir1/fic1
echo "################################################################################"
echo "sleep 2 #esperamos un poco para observar los sellos de tiempo"
sleep 2
echo "################################################################################"
echo "Escribimos un poco más pero sin agrandar el tamaño del fichero, "
echo "en un offset corresondiente a un BL direccionado por un puntero directo"
echo "./mi_escribir disco /dir1/fic1 hola2  5120"
./mi_escribir disco /dir1/fic1 hola2  5120
echo "################################################################################"
echo "Debería haber cambiado el mtime porque he modificado el contenido del fichero, "
echo "y también el ctime porque ocupamos un bloque adicional de datos"
echo "./mi_stat disco /dir1/fic1"
./mi_stat disco /dir1/fic1
echo "################################################################################"
echo "sleep 2 #esperamos un poco para observar los sellos de tiempo"
sleep 2
echo "################################################################################"
echo "Escribimos de nuevo pero en el mismo bloque de datos que anteriormente"
echo "./mi_escribir disco /dir1/fic1 hola3  5200"
./mi_escribir disco /dir1/fic1 hola3  5200
echo "################################################################################"
echo "Debería haber cambiado el mtime porque he modificado el contenido del fichero, "
echo "pero no el ctime porque no ocupamos un bloque adicional ni modificamos el tamaño del fichero"
echo "./mi_stat disco /dir1/fic1"
./mi_stat disco /dir1/fic1
echo "################################################################################"
echo "sleep 2 #esperamos un poco para observar los sellos de tiempo"
sleep 2
echo "################################################################################"
echo "Escribimos más allá del tamaño actual del fichero, "
echo "pero en el mismo bloque que estaba direccionado por I0"
echo "./mi_escribir disco /dir1/fic1 hola4 256010"
./mi_escribir disco /dir1/fic1 hola4 256010
echo "################################################################################"
echo "Debería haber cambiado el mtime porque he modificado el contenido del fichero, "
echo "y también el ctime porque hemos modificado el tamaño del fichero"
echo "./mi_stat disco /dir1/fic1"
./mi_stat disco /dir1/fic1
echo "################################################################################"
echo "./mi_cat disco /dir1/fic1"
./mi_cat disco /dir1/fic1
