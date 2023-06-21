#include<stdio.h>
#include<stdlib.h>
#define N 1000
#include<sys/time.h>
#include<time.h>
int main(){

        int A[N][N];
        int B[N];
        int C[N];
        int i, j, k, temp;

        for(i=0; i<N; i++){
        	B[i] = 2;
                for(j=0; j<N; j++){
                        A[i][j] = 2;
                        
        //              printf("A[%d][%d] = %d\n",i, j, A[i][j]);
        //              printf("B[%d][%d] = %d\n",i, j, B[i][j]);
                }
        }
        clock_t start_t, end_t;
        double execution_time;
        start_t = clock();

        struct timeval start, end;
        gettimeofday(&start, NULL);
	#pragma acc parallel loop 	
        for(i=0; i<N; i++){
                temp = 0;
                for(j=0; j<N; j++)
		{
       		         temp += A[i][j] * B[i];
          	        // printf("%d",temp);
                }
                C[i] = temp;
	//	printf("%d\n",C[i]);
         }

        

        gettimeofday(&end, NULL);
        long seconds = (end.tv_sec - start.tv_sec);
        long micros  = ((seconds * 1000000) + end.tv_usec) - (start.tv_usec);

        printf("Time of Multiplication: %ld and %ld.\n", seconds, micros);

        end_t = clock();
        execution_time = ((double)(end_t - start_t))/CLOCKS_PER_SEC;
        printf("Time for Multiplication: %f\n",execution_time);
        return 0;
}
