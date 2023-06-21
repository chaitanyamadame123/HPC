#include<stdio.h>
#include<stdlib.h>
#define N 1000
#include<time.h>
#include<omp.h>

int main(){

        int A[N][N];
        int B[N][N];
        int C[N][N];
        int i, j, k, temp;
        #pragma omp parallel for private(i, j)
        for(i=0; i<N; i++){
                for(j=0; j<N; j++){
                        A[i][j] = 2;
                        B[i][j] = 3;

              //        printf("A[%d][%d] = %d\n",i, j, A[i][j]);
        //              printf("B[%d][%d] = %d\n",i, j, B[i][j]);

                }
        }
        double itime, ftime, exec_time;
        itime = omp_get_wtime();
        #pragma omp parallel private(i,j,k)
        {
                #pragma omp for reduction(+:temp)
                for(i=0; i<N; i++){
                        for(j=0; j<N; j++){
                                temp = 0;
                                for(k=0; k<N; k++){
                                //        printf("This iteration %d %d %d is being performed by %d.\n", i, j, k, omp_get_thread_num());
                                        temp += A[i][j] * B[j][k];
                                }
                        C[i][k] = temp;
         //             printf("%d",C[i][k]);
                        }
          //    printf("\n");
                }
        }

        ftime = omp_get_wtime();
        exec_time = ftime - itime;
        printf("Execetion Time: %f\n", exec_time);

        return 0;
}
