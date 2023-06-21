#include<stdio.h>
#include<stdlib.h>

__global__ void PI( double steps, double* sum_arr_d)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;	
        double x, sum=0.0;
        x = (myid)*steps;
        sum = sum + 4.0/(1.0+x*x);
        sum_arr_d[myid] = sum;
        
}


int main()
{
        static long num_step = 1000000;
	double sum_arr[1000000], *sum_arr_d;
	double steps;
	int i; 
	double total=0.0, pi;
	
	int size = 1000000 * sizeof(double);
	steps = 1.0/(double)num_step;
	
	cudaMalloc(&sum_arr_d, size);
	
	dim3   DimGrid(1000, 1);     
	dim3   DimBlock(1000, 1);   
	
	PI<<< DimGrid,DimBlock >>>(steps, sum_arr_d);
	
	cudaMemcpy(sum_arr, sum_arr_d, size, cudaMemcpyDeviceToHost);

	for(i=0; i<1000000; i++ )
	{
		total+=sum_arr[i];
	}
	pi = steps * total;
	printf("PI = %lf ,  sum = %lf\n",pi, total);
	cudaFree(sum_arr_d);	
}

