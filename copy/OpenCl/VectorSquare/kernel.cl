__kernel void vecSq(__global int* A)
{
    int gid = get_global_id(0);

    A[gid] = A[gid] * A[gid];
}
