fDAT=slow_fast_time.dat
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Multiplicacion de matrices"
set ylabel "Number of errors"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "mult_time.png"
plot "$fDAT" using 1:3 with lines lw 2 title "normal_mr", \
	 "$fDAT" using 1:4 with lines lw 2 title "normal_mw", \
	 "$fDAT" using 1:6 with lines lw 2 title "trasp_mr", \
     "$fDAT" using 1:7 with lines lw 2 title "trasp_mw"
replot
quit
END_GNUPLOT
