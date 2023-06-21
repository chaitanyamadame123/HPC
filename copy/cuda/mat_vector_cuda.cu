#include<stdio.h>
#include<stdlib.h>
#define N 32
__global__ void mat_vector_mul(int *A_d, int *B_d, int *C_d)
{
	int myid = blockIdx.x*blockDim.x + threadIdx.x;
	int blk_id = blockIdx.x;
	C_d[blk_id] += A_d[myid] * B_d[blk_id];
}

int main()
{
	int size = N * sizeof(int);
	int A[N][N], B[N], C[N], *A_d, *B_d, *C_d;
	int i, j;
	
        for(i=0; i<N; i++)
        {
        	B[i] = 1;
                for(j=0; j<N; j++)
                {
                        A[i][j] = 1;
                }
        }
        
        cudaMalloc(&A_d, N*N*sizeof(int));
        cudaMalloc(&B_d, size);
        cudaMalloc(&C_d, size);
        
        cudaMemcpy(A_d, A, N*size, cudaMemcpyHostToDevice);
        cudaMemcpy(B_d, B, size, cudaMemcpyHostToDevice);
        
        dim3 blocks(32,1);
        dim3 threads(32,1);
        
        mat_vector_mul<<< blocks, threads >>>(A_d, B_d, C_d);
        
        cudaMemcpy(C, C_d, size, cudaMemcpyDeviceToHost);
        
        for(i=0; i<N; i++)
        {
        	printf("\t%d", C[i]);
        }
        
        cudaFree(A_d);
        cudaFree(B_d);
        cudaFree(C_d);
}
