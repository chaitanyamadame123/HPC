__kernel void mat_mat_mul(__global int* A, __global int* B, __global int* C, int N)
{
    	int gid = get_global_id(0);
	int i = gid / N;	
	int j = gid % N;
	int k;
	int sum = 0;
	
	
	for(k=0;k<N;k++)
	{
		sum = sum + A[i*N+k]*B[k*N+j];	
	}
	C[i*N+j] =  sum;


}
