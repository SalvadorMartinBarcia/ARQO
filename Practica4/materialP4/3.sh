#!/bin/bash

# inicializar variables
P=5
Ninicio=$((512+$P))
Nfinal=$((1424+512+$P))
Npaso=64
Reps=4



# borrar el fichero DAT y el fichero PNG
rm -f *.dat *.png

# generar los ficheros DAT vacíos
touch multiplicacion_serie.dat multiplicacion_par3_hilo4.dat


for ((N = Ninicio; N < Nfinal ; N += Npaso)); do
    echo "N: $N / $Nfinal..."

    timeSerie=0
    timeThread4=0
    accelerationT4=0

    #COMMENTS

    for ((I = 0 ; I < Reps ; I += 1)); do
    timeSerie=$(awk '{print $1+$2}' <<< "$timeSerie $(./mul_serie $N | grep 'time' | awk '{print $3}')")
    timeThread4=$(awk '{print $1+$2}' <<< "$timeThread4 $(./mul_par3 $N | grep 'time' | awk '{print $3}')")

    done

    timeSerie=$(awk '{print $1/$2}' <<< "$timeSerie $Reps")
    timeThread4=$(awk '{print $1/$2}' <<< "$timeThread4 $Reps")
    accelerationT4=$(awk '{print $1/$2}' <<< "$timeSerie $timeThread4")


    echo "$N	$timeSerie" >> multiplicacion_serie.dat
    echo "$N	$timeThread4 $accelerationT4" >> multiplicacion_par3_hilo4.dat


done



echo "Generating plot...\n"
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Tiempo de Ejecucion"
set ylabel "Tiempo de Ejecucion (s)"
set xlabel "Tamaño matriz"
set key right bottom
set grid
set term png
set output "comparison3.png"
plot "multiplicacion_serie.dat" using 1:2 with lines lw 2 title "Serie", \
		 "multiplicacion_par3_hilo4.dat" using 1:2 with lines lw 2 title "Bucle 3 4 Hilos"

replot
quit
END_GNUPLOT


echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Speedup"
set ylabel "Speedup"
set xlabel "Tamaño matriz"
set key right bottom
set grid
set term png
set output "acceleration3.png"
plot "multiplicacion_par3_hilo4.dat" using 1:3 with lines lw 2 title "Bucle 3 4 Hilos"

replot
quit
END_GNUPLOT

