#include<stdio.h>
#include<stdlib.h>
#define N 1000000000

int main(){

        double step;
        int i;
        double x, pi, sum = 0.0;

        step = 1.0/(double)N;

        for(i=0; i<N; i++){
                x = (i)*step;
                sum = sum + 4.0/(1.0+x*x);
        }
        pi = step*sum;
        printf("Approximate Value of pi is %f.\n", pi);
        return 0;
}

