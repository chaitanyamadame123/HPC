#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#define N 9000000

__global__ void pi_calc(double *sum)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;	
	double x, step;
	if(myid<N)
	{
	    step = 1.0/(double)N;
        x = (myid)*step;
        sum[myid] = 4.0/(1.0+x*x);
    }
}
/*
step = 1.0/(double)N;
        for(i=0; i<N; i++){
                x = (i)*step;
                sum = sum + 4.0/(1.0+x*x);
        }
        pi = step*sum;
*/
int main()
{
	double *sum, *sum_d;
	int i=0;
	double total = 0.0;
	double pi, step;
	double exe_time;
	step = 1.0/(double)N;
	struct timeval stop_time, start_time;
    
	sum = (double *)malloc(N*sizeof(double));
	cudaMalloc(&sum_d, N*sizeof(double));
	
	
	gettimeofday(&start_time, NULL);
	
	int thds_per_block = 256;
	int num_blocks = (N/thds_per_block)+1;
	
	pi_calc<<< num_blocks,thds_per_block >>>(sum_d);
	cudaMemcpy(sum, sum_d, N*sizeof(double), cudaMemcpyDeviceToHost);
	
	for(i=0; i<N; i++)
	{
        total += sum[i];
    }
    pi = step*total;
    
    gettimeofday(&stop_time, NULL);	
	exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));
	    
    printf("\n pi = %lf and exe_time = %lf\n", pi, exe_time);	
    cudaFree(sum_d); 
    free(sum);
}
