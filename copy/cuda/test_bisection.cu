#include<stdio.h>
#include<stdlib.h>

#define ARRSIZE 100000

__global__ void arradd(int* md, int* nd, int* pd)
{
	int myid = threadIdx.x;
	
	pd[myid] = md[myid] + nd[myid];
}


int test_result(int *m, int *n, int *p, int *md, int *nd, int *pd, int num_threads)
{
        int size = num_threads*sizeof(int);
        int i, flag;
        flag = 0;
	    cudaMalloc(&md, size);
	    cudaMemcpy(md, m, size, cudaMemcpyHostToDevice);

	    cudaMalloc(&nd, size);
	    cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice);

	    cudaMalloc(&pd, size);

	    dim3   DimGrid(1, 1);     
	    dim3   DimBlock(num_threads, 1);   


	    arradd<<< DimGrid,DimBlock >>>(md,nd,pd);

	    cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);
	    
	    for(i=0;i<num_threads;i++)
	    {
	        if(p[i] != 2*i)
	        {
	            flag = 1;
	            break;
	        }
	    }
	    return flag;
}

int main()
{
	//int size = ARRSIZE * sizeof(int);
	int m[ARRSIZE], n[ARRSIZE], p[ARRSIZE],*md, *nd,*pd;
	int i=0;
	int start, end, num_threads;
    	int flag;
	for(i=0; i<ARRSIZE; i++ )
	{
		m[i] = i;
		n[i] = i;
		p[i] = 0;
	}
    start = 10000;
    end = 10000;
    printf("\n Choosing Start...");
    while(1)
    {   
        printf("\n Start = %d", start);
        flag = test_result(m, n, p, md, nd, pd, start);
	    if(flag != 0)   // Answers match
	    {
	        start = start/2;
	    }
	    else
	    {
	        break;
	    }
    }    
    
    printf("\n Choosing End...");
    while(1)
    {
	    printf("\n End = %d", end);
    	    flag = test_result(m, n, p, md, nd, pd, end);
	    if(flag == 0)   // Answers match
	    {
	        end = end *2;
	    }
	    else
	    {
	        break;
	    }	    
    }
    printf("\n Setting Start = %d and End = %d", start, end);    
    while(1)
    {
	    num_threads = (start + end)/2;
	    printf("\n Start = %d, End = %d, num_threads = %d", start, end,num_threads);
	    flag = test_result(m, n, p, md, nd, pd, num_threads);
	    if(flag == 0)   // Answers match
	    {
	        start = num_threads;
	        if((start == end) || ((end-start) == 1))
	        {
	            break;
	        }
	    }
	    else
	    {
	        end = num_threads;
	    }
    }
	printf("\nFinal value of num_threads = %d \n", num_threads);
		
	cudaFree(md); 
	cudaFree(nd);
	cudaFree(pd);	
}

