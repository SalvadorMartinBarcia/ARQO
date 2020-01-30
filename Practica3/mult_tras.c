//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "arqo3.h"

void compute_traspuesta(tipo **matrix, tipo **matrix2, tipo **res, int n);
void crear_traspuesta(tipo **matrix, tipo **trasp, int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **m=NULL,**m2=NULL,**m2_trasp=NULL,**res=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=2 )
	{
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n=atoi(argv[1]);
	m=generateMatrix(n);
	if( !m )
	{
		return -1;
	}

	m2=generateMatrix(n);
	if( !m2 )
	{
		freeMatrix(m);
		return -1;
	}

	res=generateEmptyMatrix(n);
	if( !res )
	{
		freeMatrix(m);
		freeMatrix(m2);
		return -1;
	}

    m2_trasp=generateEmptyMatrix(n);
	if( !m2_trasp )
	{
		freeMatrix(m);
		freeMatrix(m2);
		freeMatrix(res);
		return -1;
	}

    crear_traspuesta(m2, m2_trasp, n);
    
	
	gettimeofday(&ini,NULL);

	/* Main computation */
	compute_traspuesta(m,m2_trasp,res, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	freeMatrix(m);
	freeMatrix(m2);
	freeMatrix(res);
	freeMatrix(m2_trasp);
	return 0;
}


void compute_traspuesta(tipo **matrix, tipo **matrix2, tipo **res, int n)
{
	int i,j,k;
	
	for(i=0;i<n;i++)
	{
		for(j=0;j<n;j++)
		{
			for(k=0;k<n;k++)
			{
				res[i][j] += matrix[i][k]*matrix2[j][k];
			}
		}
	}
}

void crear_traspuesta(tipo **matrix, tipo **trasp, int n){
	int i,j,t;

    for(i=0;i<n;i++)
	{
        t = (n - 1) - i;
		for(j=0;j<n;j++)
		{
            trasp[i][j] += matrix[j][t];
		}
	}
}
