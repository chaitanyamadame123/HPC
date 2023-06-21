#include<stdio.h>
#include<stdlib.h>

int main()
{
	int N = 10;
	double a[N], b[N], c[N], alpha;
	int i=0;
	
	alpha = 0.001;

	for(i=0; i<N; i++ )
	{
		a[i] = i;
		b[i] = i;
		c[i] = 0;
	}
	#pragma acc data copyin(a[0:N], b[0:N]) copyout(c[0:N])
	{
	#pragma acc parallel loop
	for(i=0; i<N; i++ )
	{
		c[i] = a[i] + alpha*b[i];		
	}
	}
	for(i=0; i<N; i++ )
	{
		printf("\t%lf",c[i]);
	}
		
}
