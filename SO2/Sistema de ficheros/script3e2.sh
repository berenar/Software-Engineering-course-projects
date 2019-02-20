echo "Comprobamos que al crear 17 subdirectorios los bloques de datos del padre son 2 (en un bloque caben 16 entradas de directorio), y que al eliminar un subdirectorio el directorio padre tiene 1 bloque de datos"
 
echo "################################################################################"
echo "$ ./mi_mkfs disco 100000"
./mi_mkfs disco 100000
echo "################################################################################"
echo "./mi_mkdir disco /d1/"
./mi_mkdir disco 6 /d1/
echo "################################################################################"
echo "creamos 17 subdirectorios sd0, sd1..., sd16 en d1"
echo
for i in $(seq 0 16)
do
    ./mi_mkdir disco 6 /d1/sd$i/
done
echo "################################################################################"
echo "Mostramos la metainformacion del directorio para ver que tiene 2 bloques de datos"
echo "./mi_stat disco /d1/"
./mi_stat disco /d1/
echo "################################################################################"
echo "Listamos el directorio para ver sus subdirectorios"
echo "./mi_ls disco /d1/"
./mi_ls disco /d1/
echo "################################################################################"
echo "Eliminamos el subdirectorio sd3 de d1"
echo "./mi_rm disco /d1/sd3/"
./mi_rm disco /d1/sd3/
echo "################################################################################"
echo "Mostramos la metainformacion de d1 para ver que ahora tiene 1 bloque de datos"
echo "./mi_stat disco /d1/"
./mi_stat disco /d1/
echo "################################################################################"
echo "Volvemos a listar el directorio para ver que se ha eliminado un subdirectorio"
echo "./mi_ls disco /d1/"
./mi_ls disco /d1/
