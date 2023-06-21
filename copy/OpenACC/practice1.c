#include<stdio.h>
#include<stdlib.h>

int main()
{	
	int N = 10;
	int *a, *aa;
	int i=0;
	
	a = (int *)malloc(N*sizeof(int));
	aa = (int *)malloc(N*sizeof(int));

	//Initialize the vectors
	for(i=0; i<N; i++ )
	{
		a[i] = i;
	}

	// Add two vectors
	#pragma acc parallel loop
	for(i=0; i<N; i++ )
	{
		aa[i] = a[i] * a[i];		
	}

	// print the output
	for(i=0; i<N; i++ )
	{
		printf("\t%d",aa[i]);
	}	
}

