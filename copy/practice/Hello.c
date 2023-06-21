#include<stdio.h>

//#define N 10000
/*
                N  PRIME_NUMBER

                1           0
               10           4
              100          25
            1,000         168
           10,000       1,229
          100,000       9,592
        1,000,000      78,498
       10,000,000     664,579
      100,000,000   5,761,455
    1,000,000,000  50,847,534

*/
int main()
{
	int i;

	#pragma acc parallel
	{
	#pragma acc loop vector(5)
	for(i=0;i<10;i++) 
	{
	 	printf("hello world good morning to one and all\n");
	}
}	}

