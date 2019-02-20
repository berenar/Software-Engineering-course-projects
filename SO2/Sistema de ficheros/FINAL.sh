###########################################################################################
##########################SCRIPT PARA SIMULACION###########################################
###########################################################################################
rm disco
 make clean
make all
./mi_mkfs disco 100000
time ./simulacion disco > disco.txt
# time ./verificacion disco dir_simulacion > resultado.txt
# ls -l resultado.txt
# ./mi_cat disco dir_simulacion/informe.txt
# cat resultado.txt
