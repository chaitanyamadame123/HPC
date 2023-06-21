#include<stdio.h>
#include<stdlib.h>
#include<omp.h>
#include<time.h>

int main()
{
        static long num_step =1000000000;
        double steps;
        int i;
        double Pi, x, sum=0.0;
        double start, end;
	
	steps = 1.0/(double)num_step;
	
	start = omp_get_wtime();
        
	#pragma omp parallel num_threads(10) 
	{
	#pragma omp single
	printf("%d\n",omp_get_num_threads());

	#pragma omp for private(i,x) reduction(+:sum)
        for(i=0; i<num_step; i++)
        {
                x=(i) *steps;
                sum = sum + 4.0/(1.0 + x*x);

        //	printf("Thread %d is performing %d iteration.\n",omp_get_thread_num(), i);      
        }
	}
	end = omp_get_wtime();
        Pi = steps* sum;
	printf("Time Required %f.\n", end-start);
        printf("Estimated Value of Pi is %f.\n", Pi);
	return 0;
}

