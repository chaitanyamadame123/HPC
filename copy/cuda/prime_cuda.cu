#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#define THDS_PER_BLK 256
#define N 1000000
__global__ void prime_calc(int* cnt_arr_d)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;
	int i;
	int flag = 0;
	cnt_arr_d[myid] = 0;
	if((myid > 2) && (myid < N))
	{
		for(i=2; i<myid;i++)
		{
			if((myid%i) == 0)
			{
			    flag = 1;
			    break;
			}	
		}
	        if(flag == 0)
        	{
        		cnt_arr_d[myid] = 1;
        	}
	}
}
int main()
{
	int *cnt_arr_d;
	int cnt_arr[N];
	int i=0;
	int total = 0;
	double exe_time;
	struct timeval stop_time, start_time;
    	int thds_per_block = THDS_PER_BLK;
	int num_blocks = (N/thds_per_block)+1;
	
	gettimeofday(&start_time, NULL);
	
	cudaMalloc(&cnt_arr_d, N*sizeof(int));

	prime_calc<<< num_blocks,thds_per_block >>>(cnt_arr_d); 

	cudaMemcpy(cnt_arr, cnt_arr_d, N*sizeof(int), cudaMemcpyDeviceToHost);

	for(i=0; i<N; i++)
	{
		total += cnt_arr[i];
	}
	
    	gettimeofday(&stop_time, NULL);	
	exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));
	
    	printf("\n Total = %d and exe_time = %lf\n", total+1, exe_time);	
	cudaFree(cnt_arr_d);
	
}
