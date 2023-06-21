__kernel void prime(__global int* prime_lst)
{
	int gid = get_global_id(0);
	int i;
	int flag = 0;
	prime_lst[gid] = 0;
	if((gid > 2))
	{
		for(i=2; i<gid;i++)
		{
			if((gid%i) == 0)
			{
			    flag = 1;
			    break;
			}	
		}
	        if(flag == 0)
        	{
        		prime_lst[gid] = 1;
        	}
	}
}
