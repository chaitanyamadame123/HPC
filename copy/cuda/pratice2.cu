#include<stdio.h>
#include<stdlib.h>
#define N 10
#define THDS_PER_BLK 256


__device__ double calc(double a, double b)
{
	double alpha = 0.001;
	double ans = a + alpha*b;
	return ans;
}

__global__ void calc_square(double* a_d, double* b_d, double* c_d)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;
	
	c_d[myid] = calc(a_d[myid], b_d[myid]);
}

int main()
{
	double *a_d, *b_d, *c_d;
	int size = N * sizeof(double);
	double a[N], b[N], c[N];
	int i=0;
	
    	int thds_per_block = THDS_PER_BLK;
	int num_blocks = (N/thds_per_block)+1;
	
	//Initialize the vectors
	for(i=0; i<N; i++ )
	{
		a[i] = i;
		b[i] = i;
		c[i] = 0;
	}
	
	cudaMalloc(&a_d, size);
	cudaMemcpy(a_d, a, size, cudaMemcpyHostToDevice);	
	
	cudaMalloc(&b_d, size);
	cudaMemcpy(b_d, b, size, cudaMemcpyHostToDevice);
	
	cudaMalloc(&c_d, size);
	
	calc_square<<< num_blocks,thds_per_block >>>(a_d, b_d, c_d); 
	
	cudaMemcpy(c, c_d, size, cudaMemcpyDeviceToHost);


	// print the output
	for(i=0; i<N; i++ )
	{
		printf("\t%lf",c[i]);
	}
	
	cudaFree(a_d);
	cudaFree(b_d);
	cudaFree(c_d);	
}

