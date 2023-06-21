#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#define N 9000000

#define THDS_PER_BLK 256
__global__ void sum_reduce(double *arr, double *sum)
{
    int myid = blockIdx.x*blockDim.x + threadIdx.x;
	double tmp_sum = 0.0;
	__shared__ double tmp[THDS_PER_BLK];
    if(myid<N)
    {
        tmp[threadIdx.x] = arr[myid];
        __syncthreads();
        if(threadIdx.x == 0)
        {
            for(int i=0;i<THDS_PER_BLK;i++)
            {
                tmp_sum += tmp[threadIdx.x]; 
            }
            sum[blockIdx.x] = tmp_sum;
        }
    }
}

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
	double *sum, *sum_d, *sum_small_d;
	int i=0;
	double total = 0.0;
	double pi, step;
	double exe_time;
	step = 1.0/(double)N;
	struct timeval stop_time, start_time;
    
    int thds_per_block = THDS_PER_BLK;
	int num_blocks = (N/thds_per_block)+1;
	
	sum = (double *)malloc(N*sizeof(double));
	
	cudaMalloc(&sum_d, N*sizeof(double));
	cudaMalloc(&sum_small_d, num_blocks*sizeof(double));
	
	gettimeofday(&start_time, NULL);
	
	
	pi_calc<<< num_blocks,thds_per_block >>>(sum_d);
	cudaDeviceSynchronize();
	
	sum_reduce<<< num_blocks,thds_per_block >>>(sum_d, sum_small_d);
	cudaMemcpy(sum, sum_small_d, num_blocks*sizeof(double), cudaMemcpyDeviceToHost);
	
	for(i=0; i<num_blocks; i++)
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
