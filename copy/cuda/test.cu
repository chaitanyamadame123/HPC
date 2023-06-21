#include<stdio.h>
#include<stdlib.h>

__global__ void arradd(int* md, int* nd, int* pd)
{
	int myid = threadIdx.x;
	
	pd[myid] = md[myid] + nd[myid];
}


int main()
{
	int N = 1024;
	int size = N * sizeof(int);
	int m[N], n[N], p[N],*md, *nd,*pd;
	int i=0;

	for(i=0; i<N; i++ )
	{
		m[i] = i;
		n[i] = i;
		p[i] = 0;
	}

	cudaMalloc(&md, size);
	cudaMemcpy(md, m, size, cudaMemcpyHostToDevice);

	cudaMalloc(&nd, size);
	cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice);

	cudaMalloc(&pd, size);

	dim3   DimGrid(1, 1);     
	dim3   DimBlock(N, 1);   


	arradd<<< DimGrid,DimBlock >>>(md,nd,pd);

	cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);

//	printf("Task Done...\n");
	for(i=0; i<N; i++ )
	{
		if(p[i] != (i+i)){
			printf("Failed at %d.\n",i);
			break;
		}
	}
		
	cudaFree(md); 
	cudaFree(nd);
	cudaFree(pd);	
}

