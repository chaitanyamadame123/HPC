#include<stdio.h>
#include<stdlib.h>
#define N 100
#define THDS_PER_BLK 256

__device__ int square(int myid)
{
	int sq = myid*myid;
	return sq;
}

__global__ void calc_square(int* a_d)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;
	a_d[myid] = square(myid);
}

int main()
{
	int *a_d;
	int size = N * sizeof(int);
	int a[N];
	int i=0;
	
    	int thds_per_block = THDS_PER_BLK;
	int num_blocks = (N/thds_per_block)+1;
	
	//Initialize the vectors
	for(i=0; i<N; i++ )
	{
		a[i] = i;
	}
	
	cudaMalloc(&a_d, size);
	cudaMemcpy(a_d, a, size, cudaMemcpyHostToDevice);	
	
	calc_square<<< num_blocks,thds_per_block >>>(a_d); 
	
	cudaMemcpy(a, a_d, N*sizeof(int), cudaMemcpyDeviceToHost);


	// print the output
	for(i=0; i<N; i++ )
	{
		printf("\t%d",a[i]);
	}
	
	cudaFree(a_d);	
}

