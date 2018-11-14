set terminal pngcairo font "arial,10" size 500,500
set output OUT_FILE
set boxwidth 0.75
set style fill solid
set xlabel 'Localización'
set ylabel 'Velocidad de descarga(Mbps)'
set key off
set yrange [0:60]
plot IN_FILE using 2:xtic(1) with boxes 