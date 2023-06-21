#include<stdio.h>
#include<omp.h>

int main(){

        int id;
        #pragma omp parallel private(id) num_threads(5)
        {
                id = omp_get_thread_num();
 //               scanf("Enter a number: %d\n",&id);
                printf("Cube of the thread id is: %d\n", id*id*id);

        }
        return 0;
}
