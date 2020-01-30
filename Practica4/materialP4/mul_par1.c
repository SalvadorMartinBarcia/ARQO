//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "arqo4.h"
#include <omp.h>

void compute(float **matrix, float **matrix2, float **res, int n);

int main( int argc, char *argv[])
{
	int n;
	float **m=NULL,**m2=NULL,**res=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(float));

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


	
	gettimeofday(&ini,NULL);

	/* Main computation */
	compute(m,m2,res, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	freeMatrix(m);
	freeMatrix(m2);
	freeMatrix(res);
	return 0;
}


void compute(float **matrix, float **matrix2, float **res, int n)
{
	int i,j,k, result=0;
	
	for(i=0;i<n;i++)
	{
		for(j=0;j<n;j++)
		{
            #pragma omp parallel for reduction(+:result) private(k) shared(res,matrix,matrix2,n)
			for(k=0;k<n;k++)
			{
				result += matrix[i][k]*matrix2[k][j];
			}
            res[i][j] =result;
		}
	}
}