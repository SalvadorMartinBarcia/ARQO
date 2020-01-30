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

#P = (20 % 7) + 4
NumIterations=1
P=10
Ninicio=$((2000 + 512*P))
Npaso=64
Nfinal=$((Ninicio + 512))
fDAT_1=cache_1024.dat
fDAT_2=cache_2048.dat
fDAT_4=cache_4096.dat
fDAT_8=cache_8192.dat

touch $fDAT_1
touch $fDAT_2
touch $fDAT_4
touch $fDAT_8


# borrar el fichero DAT y el fichero PNG
rm -f  *.png

for ((N = Ninicio ; N <= Nfinal ; N += Npaso*2)); do
	echo "N: $N / $Nfinal..."
	slow1_R=0
	slow1_W=0
	slow2_R=0
	slow2_W=0

	slow1_R_2=0
	slow1_W_2=0
	slow2_R_2=0
	slow2_W_2=0

	slow1_R_4=0
	slow1_W_4=0
	slow2_R_4=0
	slow2_W_4=0

	slow1_R_8=0
	slow1_W_8=0
	slow2_R_8=0
	slow2_W_8=0

	fast1_R=0
	fast1_W=0
	fast2_R=0
	fast2_W=0

	fast1_R_2=0
	fast1_W_2=0
	fast2_R_2=0
	fast2_W_2=0

	fast1_R_4=0
	fast1_W_4=0
	fast2_R_4=0
	fast2_W_4=0

	fast1_R_8=0
	fast1_W_8=0
	fast2_R_8=0
	fast2_W_8=0


	aux_1_R=0
	aux_1_W=0
	aux_2_R=0
	aux_2_W=0

	N2=$( echo $N $Npaso| awk '{print $1 + $2}')
	for (( A = 0; A < NumIterations ; A++)); do

		valgrind --tool=cachegrind --cachegrind-out-file="slow1_1024.dat" --I1=1024,1,64 --D1=1024,1,64 --LL=8388608,1,64 ./slow $N
		aux=$(cg_annotate slow1_1024.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow1_R=$( echo $slow1_R $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow1_W=$( echo $slow1_W $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="slow2_1024.dat" --I1=1024,1,64 --D1=1024,1,64 --LL=8388608,1,64 ./slow $N2
		aux=$(cg_annotate slow2_1024.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_2_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow2_R=$( echo $slow2_R $aux_2_R| awk '{print $1 + $2}')
		aux_2_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow2_W=$( echo $slow2_W $aux_2_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="slow1_2048.dat" --I1=2048,1,64 --D1=2048,1,64 --LL=8388608,1,64 ./slow $N
		aux=$(cg_annotate slow1_2048.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow1_R_2=$( echo $slow1_R_2 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow1_W_2=$( echo $slow1_W_2 $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="slow2_2048.dat" --I1=2048,1,64 --D1=2048,1,64 --LL=8388608,1,64 ./slow $N2
		aux=$(cg_annotate slow2_2048.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow2_R_2=$( echo $slow2_R_2 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow2_W_2=$( echo $slow2_W_2 $aux_1_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="slow1_4096.dat" --I1=4096,1,64 --D1=4096,1,64 --LL=8388608,1,64 ./slow $N
		aux=$(cg_annotate slow1_4096.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow1_R_4=$( echo $slow1_R_4 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow1_W_4=$( echo $slow1_W_4 $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="slow2_4096.dat" --I1=4096,1,64 --D1=4096,1,64 --LL=8388608,1,64 ./slow $N2
		aux=$(cg_annotate slow2_4096.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow2_R_4=$( echo $slow2_R_4 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow2_W_4=$( echo $slow2_W_4 $aux_1_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="slow1_8192.dat" --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./slow $N
		aux=$(cg_annotate slow1_8192.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow1_R_8=$( echo $slow1_R_8 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow1_W_8=$( echo $slow1_W_8 $aux_1_W| awk '{print $1 + $2}')
		
		valgrind --tool=cachegrind --cachegrind-out-file="slow2_8192.dat" --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./slow $N2
		aux=$(cg_annotate slow2_8192.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		slow2_R_8=$( echo $slow2_R_8 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		slow2_W_8=$( echo $slow2_W_8 $aux_1_W| awk '{print $1 + $2}')




		valgrind --tool=cachegrind --cachegrind-out-file="fast1_1024.dat" --I1=1024,1,64 --D1=1024,1,64 --LL=8388608,1,64 ./fast $N
		aux=$(cg_annotate fast1_1024.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast1_R=$( echo $fast1_R $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast1_W=$( echo $fast1_W $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="fast2_1024.dat" --I1=1024,1,64 --D1=1024,1,64 --LL=8388608,1,64 ./fast $N2
		aux=$(cg_annotate fast2_1024.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast2_R=$( echo $fast2_R $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast2_W=$( echo $fast2_W $aux_1_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="fast1_2048.dat" --I1=2048,1,64 --D1=2048,1,64 --LL=8388608,1,64 ./fast $N
		aux=$(cg_annotate fast1_2048.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast1_R_2=$( echo $fast1_R_2 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast1_W_2=$( echo $fast1_W_2 $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="fast2_2048.dat" --I1=2048,1,64 --D1=2048,1,64 --LL=8388608,1,64 ./fast $N2
		aux=$(cg_annotate fast2_2048.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast2_R_2=$( echo $fast2_R_2 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast2_W_2=$( echo $fast2_W_2 $aux_1_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="fast1_4096.dat" --I1=4096,1,64 --D1=4096,1,64 --LL=8388608,1,64 ./fast $N
		aux=$(cg_annotate fast1_4096.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast1_R_4=$( echo $fast1_R_4 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast1_W_4=$( echo $fast1_W_4 $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="fast2_4096.dat" --I1=4096,1,64 --D1=4096,1,64 --LL=8388608,1,64 ./fast $N2
		aux=$(cg_annotate fast2_4096.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast2_R_4=$( echo $fast2_R_4 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast2_W_4=$( echo $fast2_W_4 $aux_1_W| awk '{print $1 + $2}')


		valgrind --tool=cachegrind --cachegrind-out-file="fast1_8192.dat" --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./fast $N
		aux=$(cg_annotate fast1_8192.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast1_R_8=$( echo $fast1_R_8 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast1_W_8=$( echo $fast1_W_8 $aux_1_W| awk '{print $1 + $2}')

		valgrind --tool=cachegrind --cachegrind-out-file="fast2_8192.dat" --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./fast $N2
		aux=$(cg_annotate fast2_8192.dat | head -n 20 | grep 'PROGRAM TOTALS')
		aux_1_R=$(echo ${aux//./} | awk '{print $5}' | sed -u 's/,//g')
		fast2_R_8=$( echo $fast2_R_8 $aux_1_R| awk '{print $1 + $2}')
		aux_1_W=$(echo ${aux//./} | awk '{print $8}' | sed -u 's/,//g')
		fast2_W_8=$( echo $fast2_W_8 $aux_1_W| awk '{print $1 + $2}')

	done
	slow1_R=$( echo $slow1_R $NumIterations| awk '{print $1 / $2}')
	slow1_W=$( echo $slow1_W $NumIterations| awk '{print $1 / $2}')
	fast1_R=$( echo $fast1_R $NumIterations| awk '{print $1 / $2}')
	fast1_W=$( echo $fast1_W $NumIterations| awk '{print $1 / $2}')
	echo "$N	$slow1_R	$slow1_W	$fast1_R	$fast1_W" >> $fDAT_1

	slow2_R=$( echo $slow2_R $NumIterations| awk '{print $1 / $2}')
	slow2_W=$( echo $slow2_W $NumIterations| awk '{print $1 / $2}')
	fast2_R=$( echo $fast2_R $NumIterations| awk '{print $1 / $2}')
	fast2_W=$( echo $fast2_W $NumIterations| awk '{print $1 / $2}')
	echo "$N2	$slow2_R	$slow2_W	$fast2_R	$fast2_W" >> $fDAT_1


	slow1_R_2=$( echo $slow1_R_2 $NumIterations| awk '{print $1 / $2}')
	slow1_W_2=$( echo $slow1_W_2 $NumIterations| awk '{print $1 / $2}')
	fast1_R_2=$( echo $fast1_R_2 $NumIterations| awk '{print $1 / $2}')
	fast1_W_2=$( echo $fast1_W_2 $NumIterations| awk '{print $1 / $2}')
	echo "$N	$slow1_R_2	$slow1_W_2	$fast1_R_2	$fast1_W_2" >> $fDAT_2

	slow2_R_2=$( echo $slow2_R_2 $NumIterations| awk '{print $1 / $2}')
	slow2_W_2=$( echo $slow2_W_2 $NumIterations| awk '{print $1 / $2}')
	fast2_R_2=$( echo $fast2_R_2 $NumIterations| awk '{print $1 / $2}')
	fast2_W_2=$( echo $fast2_W_2 $NumIterations| awk '{print $1 / $2}')
	echo "$N2	$slow2_R_2	$slow2_W_2	$fast2_R_2	$fast2_W_2" >> $fDAT_2


	slow1_R_4=$( echo $slow1_R_4 $NumIterations| awk '{print $1 / $2}')
	slow1_W_4=$( echo $slow1_W_4 $NumIterations| awk '{print $1 / $2}')
	fast1_R_4=$( echo $fast1_R_4 $NumIterations| awk '{print $1 / $2}')
	fast1_W_4=$( echo $fast1_W_4 $NumIterations| awk '{print $1 / $2}')
	echo "$N	$slow1_R_4	$slow1_W_4	$fast1_R_4	$fast1_W_4" >> $fDAT_4

	slow2_R_4=$( echo $slow2_R_4 $NumIterations| awk '{print $1 / $2}')
	slow2_W_4=$( echo $slow2_W_4 $NumIterations| awk '{print $1 / $2}')
	fast2_R_4=$( echo $fast2_R_4 $NumIterations| awk '{print $1 / $2}')
	fast2_W_4=$( echo $fast2_W_4 $NumIterations| awk '{print $1 / $2}')
	echo "$N2	$slow2_R_4	$slow2_W_4	$fast2_R_4	$fast2_W_4" >> $fDAT_4


	slow1_R_8=$( echo $slow1_R_8 $NumIterations| awk '{print $1 / $2}')
	slow1_W_8=$( echo $slow1_W_8 $NumIterations| awk '{print $1 / $2}')
	fast1_R_8=$( echo $fast1_R_8 $NumIterations| awk '{print $1 / $2}')
	fast1_W_8=$( echo $fast1_W_8 $NumIterations| awk '{print $1 / $2}')
	echo "$N	$slow1_R_8	$slow1_W_8	$fast1_R_8	$fast1_W_8" >> $fDAT_8

	slow2_R_8=$( echo $slow2_R_8 $NumIterations| awk '{print $1 / $2}')
	slow2_W_8=$( echo $slow2_W_8 $NumIterations| awk '{print $1 / $2}')
	fast2_R_8=$( echo $fast2_R_8 $NumIterations| awk '{print $1 / $2}')
	fast2_W_8=$( echo $fast2_W_8 $NumIterations| awk '{print $1 / $2}')
	echo "$N2	$slow2_R_8	$slow2_W_8	$fast2_R_8	$fast2_W_8" >> $fDAT_8
done
