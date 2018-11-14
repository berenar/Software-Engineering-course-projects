#!/bin/bash
#5.1 y 5.3
for (( i = 1; i <= 5; i++ )); do #recorre archivos
	cat outputs/m$i/resultados_$i.txt | tail -n 4 > outputs/m$i/res_$i.txt
	for (( j = 1; j <= 4; j++ )); do #recorre lineas
		read -r LINE
		X="$(echo $LINE | awk '{print $4}')"
		echo "WRITE_$j:	$X" >> outputs/m$i/WRITE_m$i.txt 
	done < outputs/m$i/res_$i.txt
	gnuplot -e "IN_FILE='outputs/m$i/WRITE_m$i.txt';OUT_FILE='outputs/PLOTS/WRITE_m$i.png'" gnuplot_WRITE.gnuplot

	for (( j = 1; j <= 4; j++ )); do #recorre lineas
		read -r LINE
		X="$(echo $LINE | awk '{print $1}')"
		echo "CPU_$j:	$X" >> outputs/m$i/CPU_m$i.txt 
	done < outputs/m$i/res_$i.txt
	gnuplot -e "IN_FILE='outputs/m$i/CPU_m$i.txt';OUT_FILE='outputs/PLOTS/CPU_m$i.png'" gnuplot_CPU.gnuplot
done

#5.2
#arrays de concurrencias: C= concurrencia 1, CC= concurrencia 2, etc
for (( i = 1; i <=5; i++ )); do #recorre ficheros
	for (( j = 1; j <=1; j++ )); do #lee un fichero
		read -r LINE
		C[$i]="$(echo $LINE | awk '{print $5}')"
		read -r LINE
		CC[$i]="$(echo $LINE | awk '{print $5}')"
		read -r LINE
		CCC[$i]="$(echo $LINE | awk '{print $5}')"
		read -r LINE
		CCCC[$i]="$(echo $LINE | awk '{print $5}')"
	done < outputs/m$i/res_$i.txt
done
#transformar arrays en ficheros
for (( j = 1; j <=5; j++ )); do	echo "DOWN_$j:	${C[$j]}">>outputs/DOWN_c1.txt; done
for (( j = 1; j <=5; j++ )); do	echo "DOWN_$j:	${CC[$j]}">>outputs/DOWN_c2.txt; done
for (( j = 1; j <=5; j++ )); do	echo "DOWN_$j:	${CCC[$j]}">>outputs/DOWN_c3.txt; done
for (( j = 1; j <=5; j++ )); do echo "DOWN_$j:	${CCCC[$j]}">>outputs/DOWN_c4.txt; done
#crear gnuplots
for (( i = 1; i <= 4; i++ )); do
	gnuplot -e "IN_FILE='outputs/DOWN_c$i.txt';OUT_FILE='outputs/PLOTS/DOWN_c$i'" gnuplot_DOWN.gnuplot
done

echo "Gnuplots creados"