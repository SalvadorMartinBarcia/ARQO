# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
#P = (20 % 7) + 4
P=10
NumIterations=4
Ninicio=$((10000 + 1024*P))
Npaso=64
Nfinal=$((Ninicio + 1024))
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
# bucle para N desde P hasta Q
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	slowTimeTotal=0.0
	fastTimeTotal=0.0
	for (( A = 0; A < NumIterations ; A++)); do
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		slowTimeTotal=$( echo $slowTime $slowTimeTotal| awk '{print $1 + $2}')
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		fastTimeTotal=$( echo $fastTime $fastTimeTotal| awk '{print $1 + $2}')
	done

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos
	slowTime=$( echo $slowTimeTotal $NumIterations| awk '{print $1 / $2}')
	fastTime=$( echo $fastTimeTotal $NumIterations| awk '{print $1 / $2}')
	echo "$N	$slowTime	$fastTime" >> $fDAT
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
