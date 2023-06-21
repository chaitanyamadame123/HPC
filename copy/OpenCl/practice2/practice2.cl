__kernel void practice2(__global double* A, __global double* B, __global double* C, double alpha)
{
    int gid = get_global_id(0);

    C[gid] = A[gid] + alpha * B[gid];
}
