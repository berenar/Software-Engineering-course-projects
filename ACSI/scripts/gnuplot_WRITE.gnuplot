set terminal pngcairo font "arial,10" size 500,500
set output OUT_FILE
set boxwidth 0.75
set style fill solid
set xlabel 'Nivel de concurrencia'
set ylabel 'Velocidad de escritura(Kb/s)'
set key off
set yrange [0:50000]
plot IN_FILE using 2:xtic(1) with boxes 