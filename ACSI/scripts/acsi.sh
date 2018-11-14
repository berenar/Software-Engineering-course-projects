#!/bin/bash
#Práctica final ACSI. Bernat Pericàs Serra i Antonio Boutaour Sanchez. 2017.

M=$1			#número de script/servicio monitorizado (depende del parámetro de entrada)
MB=$M 	#guardamos el valor de M ya que cambiará durante la ejecución
echo "-------$M.sh-------"
MIN=1		#mínima concurrencia
MAX=4		#máxima concurrencia
N=$MIN		#concurrencia actual (valor inicial=minimo nivel de concurrencia deseado)
PIDS=()		#array de pids de procesos concurrentes que se monitorizaran
PID_TOP=0	#pid del top que monitoriza los procesos concurrentes
PID_IOTOP=0	#pid del iotop que monitoriza los procesos concurrentes
#variables para contar números de líneas (para hacer medias)
L=0			#número de veces que aparece el comando (TOP)
LL=0		#número de veces que aparece el comando (IOTOP)
LLL=0		#número de veces que aparece el comando (WGET)
LLLL=0		#número de veces que aparece el comando (TIME)
ARCHIVO=ubuntu.iso 		#nombre del archivo con el que se hacen las pruebas
ADDRESS=192.168.1.54/ubuntu.iso 	#dirección para la prueba M=3 i M=4
URL=https://www.dropbox.com/s/zn3q6rk85lz4v7v/ubuntu.iso?dl=1	#link al archivo para la prueba M=5

if ((MB>=0))&&((MB<=6)); then
	if ((MB==0)); then
		#crear estructura de directorios necesaria
		./0.sh
	fi

	if ((MB>=1))&&((MB<=5)); then	#si M vale 1,2,3,4 o 5
		while [[ (($N -le $MAX)) ]]; do #recorrer niveles de concurrencia
			#lanzar procesos que monitorizan
			echo "Concurrencia: $N"
			top -b -d 1 > outputs/m$M/c$N/top_output.log &
			PID_TOP=$!

			iotop -b -P -q -k > outputs/m$M/c$N/iotop_output.log &
			PID_IOTOP=$!

			echo "logs de tiempo" > outputs/m$M/c$N/time_output.log

			#lanzar los procesos concurrentes que seran monitorizados
			#tambien se ejecuta el comando "time" en cada ejecución
			for (( i = 1; i < ($N+1); i++ )); do
				#ejecuta un comando u otro dependiendo de M
				case $M in
					1) { /usr/bin/time -f "\t%e r,\t%U u,\t%S s" cp $ARCHIVO d/d$i/; }									2>> outputs/m$M/c$N/time_output.log &;;
					2) { /usr/bin/time -f "\t%e r,\t%U u,\t%S s" cp /media/bernat/some_label/$ARCHIVO d/d$i/; } 		2>> outputs/m$M/c$N/time_output.log &;;
					3) { /usr/bin/time -f "\t%e r,\t%U u,\t%S s" wget -o outputs/m$M/c$i/wget.log $ADDRESS -P d/d$i; } 	2>> outputs/m$M/c$N/time_output.log &;;
					4) { /usr/bin/time -f "\t%e r,\t%U u,\t%S s" wget -o outputs/m$M/c$i/wget.log $ADDRESS -P d/d$i; }	2>> outputs/m$M/c$N/time_output.log &;;
					5) { /usr/bin/time -f "\t%e r,\t%U u,\t%S s" wget -o outputs/m$M/c$i/wget.log $URL -P d/d$i; }		2>> outputs/m$M/c$N/time_output.log &;;
				esac
				PIDS[${#PIDS[@]}]=$!	#guardar el pid del comando lanzao en la última posición del array de PIDS
			done

			sleep 1	#esperar 1 segundo para prevenir errores

			#esperar a que acaben todos los procesos concurrentes
			for i in "${PIDS[@]}"; do
				wait $i
			done

			#matar todos los procesos que monitorizan
			disown $PID_TOP; kill -9 $PID_TOP
			disown $PID_IOTOP; kill -9 $PID_IOTOP
			#borrar array
			unset PIDS
			((N++)) #incrementar N para pasar al siguiente nivel de concurrencia
		done

		#tratar resultados
		echo "CPU	RAM	READ	WRITE	DOWN	TOTAL_T	USER_T	SYSTEM_T" > outputs/m$M/resultados_$M.txt #header del fichero
		N=$MIN	#reiniciamos la variable N al valor inicial para volver a hacer una iteración
		while [[ (($N -le $MAX)) ]]; do
			#contar numero de veces que aparece el proceso que se monitoriza (cp en este caso)
			L="$(cat outputs/m$M/c$N/top_output.log | grep -w "cp" | wc -l)"	#lineas top
			LS=$(($L%$N))	#lineas sobrantes
		 	CPU="$(cat outputs/m$M/c$N/top_output.log | grep -w "cp" | head -n -$LS | awk -v N=$N '{C+=$9} END {print C/(NR/N)}')" 
		 	RAM="$(cat outputs/m$M/c$N/top_output.log | grep -w "cp" | head -n -$LS | awk -v N=$N '{C+=$6} END {print C/(NR/N)}')" 
			
			LL="$(cat outputs/m$M/c$N/iotop_output.log | grep -w "cp" | wc -l)"
		 	READ="$(cat outputs/m$M/c$N/iotop_output.log | grep -w "cp" | awk -v LL=$LL '{X+=$4} END {print X/LL}')"
		 	WRITE="$(cat outputs/m$M/c$N/iotop_output.log | grep -w "cp" | awk -v LL=$LL '{X+=$6} END {print X/LL}')"
		 	#DOWN="$(cat outputs/m$M/c$N/wget.log)"
		 
		 	if ((M=1))||((M=2)); then
		 		DOWN=-1
		 	else
		 		LLL="$(cat outputs/m$M/c$N/wget.log | grep "saved" | wc -l)"
	 			DOWN="$(cat outputs/m$M/c$N/wget.log | grep "saved" | sed 's/(//g' | awk '{D+=$3} END {print D/$LLL}')"
		 	fi
		 	
		 	LLLL="$(cat outputs/m$M/c$N/time_output.log | wc -l)"
		 	TOTAL_T="$(cat outputs/m$M/c$N/time_output.log | awk '{T+=$1} END {print T/$LLLL}')"
		 	USER_T="$(cat outputs/m$M/c$N/time_output.log | awk '{T+=$3} END {print T/$LLLL}')"
			SYSTEM_T="$(cat outputs/m$M/c$N/time_output.log | awk '{T+=$5}END {print T/$LLLL}')"

			#escribir los valores de las variables en el fichero de los resultados
			echo "$CPU	$RAM	$READ	$WRITE	$DOWN	$TOTAL_T	$USER_T	$SYSTEM_T" >> outputs/m$M/resultados_$M.txt
			((N++)) #incrementamos N para realizar la iteraciń del siguiente nivel de concurrencia
		done
	fi

	if ((MB==6)); then
		#crear plots a partir de los resutados obtenidos
		./gnuplot.sh
		
	fi

else
	echo "Parámetro de entrada no válido. $1 entre [0,6]"
fi