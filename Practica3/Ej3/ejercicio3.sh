#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -o valgrind.out
#$ -j y

# Anadir valgrind al path
export PATH=$PATH:/share/apps/tools/valgrind/bin
# Indicar ruta librerías valgrind
export VALGRIND_LIB=/share/apps/tools/valgrind/lib/valgrind

# inicializar variables
#P = (20 % 7) + 4
P=4
NumIterations=1
Ninicio=$((256 + 16*P))
Npaso=16
Nfinal=$((Ninicio + 160))
fDAT=mult.dat


# borrar el fichero DAT
rm -f $fDAT mult_normal.dat mult_tras.dat

# generar el fichero DAT vacio
touch $fDAT

echo "Running matrix multiplication..."


for ((N = Ninicio ; N <= Nfinal ; N += Npaso*2)); do
	echo "N: $N / $Nfinal..."

	N2=$( echo $N $Npaso| awk '{print $1 + $2}')

	# reseteo de los acumuladores

	totalTimeNormal1=0.0
    totalTimeNormal2=0.0

	totalTimeTras1=0.0
    totalTimeTras2=0.0


    norm_R_1=0.0
    norm_R_2=0.0
    norm_W_1=0.0
    norm_W_2=0.0

    tras_R_1=0.0
    tras_R_2=0.0
    tras_W_1=0.0
    tras_W_2=0.0


	for (( A = 0; A < NumIterations ; A++)); do
		## TIEMPOS DE EJECUCION NORMAL

		# tiempo total de N y N2 de la multiplicacion normal
		execTime=$(./mult_normal $N | grep 'time' | awk '{print $3}')
		totalTimeNormal1=$( echo $execTime $totalTimeNormal1| awk '{print $1 + $2}')

		execTime=$(./mult_normal $N2 | grep 'time' | awk '{print $3}')
		totalTimeNormal2=$( echo $execTime $totalTimeNormal2| awk '{print $1 + $2}')


		# tiempo total de N y N2 de la multiplicacion traspuesta
		execTime=$(./mult_tras $N | grep 'time' | awk '{print $3}')
		totalTimeTras1=$( echo $execTime $totalTimeTras1| awk '{print $1 + $2}')

		execTime=$(./mult_tras $N2 | grep 'time' | awk '{print $3}')
		totalTimeTras2=$( echo $execTime $totalTimeTras2| awk '{print $1 + $2}')


		## ERRORES DE CACHE de multiplicacion normal

		# tiempo total de errores de cache de multiplicacion normal para N
        valgrind --tool=cachegrind --cachegrind-out-file="mult_normal.dat" ./mult_normal $N
        aux=$(cg_annotate mult_normal.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		norm_R_1=$( echo $norm_R_1 $aux_R| awk '{print $1 + $2}')
		aux_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		norm_W_1=$( echo $norm_W_1 $aux_W| awk '{print $1 + $2}')



		# tiempo total de errores de cache de multiplicacion normal para N2
        valgrind --tool=cachegrind --cachegrind-out-file="mult_normal.dat" ./mult_normal $N2
        aux=$(cg_annotate mult_normal.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		norm_R_2=$( echo $norm_R_2 $aux_R| awk '{print $1 + $2}')
		aux_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		norm_W_2=$( echo $norm_W_2 $aux_W| awk '{print $1 + $2}')


		## ERRORES DE CACHE de multiplicacion traspuesta

		# tiempo total de errores de cache de multiplicacion traspuesta para N
        valgrind --tool=cachegrind --cachegrind-out-file="mult_tras.dat" ./mult_tras $N
        aux=$(cg_annotate mult_tras.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		tras_R_1=$( echo $tras_R_1 $aux_R| awk '{print $1 + $2}')
		aux_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		tras_W_1=$( echo $tras_W_1 $aux_W| awk '{print $1 + $2}')



		# tiempo total de errores de cache de multiplicacion traspuesta para N2
        valgrind --tool=cachegrind --cachegrind-out-file="mult_tras.dat" ./mult_tras $N2
        aux=$(cg_annotate mult_tras.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		tras_R_2=$( echo $tras_R_2 $aux_R| awk '{print $1 + $2}')
		aux_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		tras_W_2=$( echo $tras_W_2 $aux_W| awk '{print $1 + $2}')
	done

	# Calculando el tiempo y los errores medios

	totalTimeNormal1=$( echo $totalTimeNormal1 $NumIterations| awk '{print $1 / $2}')
    totalTimeNormal2=$( echo $totalTimeNormal2 $NumIterations| awk '{print $1 / $2}')

	totalTimeTras1=$( echo $totalTimeTras1 $NumIterations| awk '{print $1 / $2}')
    totalTimeTras2=$( echo $totalTimeTras2 $NumIterations| awk '{print $1 / $2}')

    norm_R_1=$( echo $norm_R_1 $NumIterations| awk '{print $1 / $2}')
    norm_R_2=$( echo $norm_R_2 $NumIterations| awk '{print $1 / $2}')
    norm_W_1=$( echo $norm_W_1 $NumIterations| awk '{print $1 / $2}')
    norm_W_2=$( echo $norm_W_2 $NumIterations| awk '{print $1 / $2}')

    tras_R_1=$( echo $tras_R_1 $NumIterations| awk '{print $1 / $2}')
    tras_R_2=$( echo $tras_R_2 $NumIterations| awk '{print $1 / $2}')
    tras_W_1=$( echo $tras_W_1 $NumIterations| awk '{print $1 / $2}')
    tras_W_2=$( echo $tras_W_2 $NumIterations| awk '{print $1 / $2}')


	echo "$N	$totalTimeNormal1	$norm_R_1	$norm_W_1	$totalTimeTras1	$tras_R_1	$tras_W_1" >> $fDAT
	echo "$N	$totalTimeNormal2	$norm_R_2	$norm_W_2	$totalTimeTras2	$tras_R_2	$tras_W_2" >> $fDAT
done
