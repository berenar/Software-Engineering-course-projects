#!/bin/bash
#borra y crea directorios necesarios

if [[ -d outputs ]]; then rm -rf outputs; fi
mkdir outputs outputs/PLOTS/
if [[ -d d ]]; then rm -rf d; fi
mkdir d
for (( i = 1; i <= 5; i++ )); do
	mkdir outputs/m$i d/d$i
	for (( j = 1; j <= 4; j++ )); do
		mkdir outputs/m$i/c$j
	done
done
rm -rf d/d5
echo "Árbol de directorios creado"