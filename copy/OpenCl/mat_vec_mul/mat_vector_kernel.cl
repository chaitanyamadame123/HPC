__kernel void matrix_vector(__global int* A, __global int* B, __global int* C, int N)
{
	int i = get_global_id(0);
	int j;
	int sum = 0;
	
	for(j=0;j<10;j++)
	{
		sum = sum + A[i*N+j]*B[j];	
	}
	C[i] =  sum;


}
