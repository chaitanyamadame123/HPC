__kernel void pi(__global double* Sum, double N)
{
	int gid = get_global_id(0);
	double step_size = 1.0/N;
	double x = (gid)*step_size;
	Sum[gid] = 4.0/(1.0+x*x);
}
