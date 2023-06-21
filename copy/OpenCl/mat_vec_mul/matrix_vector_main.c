#include <stdio.h>
#include <stdlib.h>

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

#define ARRSIZE 10
#define MAX_SOURCE_SIZE (0x100000)

int main()
{
	cl_platform_id platform_id = NULL;
	cl_device_id device_id = NULL;
	cl_context context = NULL;
	cl_command_queue command_queue = NULL;
	cl_program program = NULL;
	cl_kernel kernel = NULL;
	cl_uint ret_num_devices;
	cl_uint ret_num_platforms;
	cl_int ret;
	cl_char device_name[300];
	
	cl_mem Ad = NULL;
	cl_mem Bd = NULL;
	cl_mem Cd = NULL;

	int *A, *B, *C;
	int N = ARRSIZE;
	FILE *fp;
	const char fileName[] = "./mat_vector_kernel.cl";
	size_t source_size;
	char *source_str;
	cl_int i;

	// Open Kernel file
	fp = fopen(fileName, "r");
	if (!fp) 
	{
		fprintf(stderr, "Failed to load kernel.\n");
		exit(1);
	}
	source_str = (char *)malloc(MAX_SOURCE_SIZE);
	source_size = fread( source_str, 1, MAX_SOURCE_SIZE, fp );
	fclose( fp );
	
	A = (int *)malloc(ARRSIZE*ARRSIZE*sizeof(int));
	B = (int *)malloc(ARRSIZE*sizeof(int));
	C = (int *)malloc(ARRSIZE*sizeof(int));
	
	int k, j;
	//Initialize data to some value
	for(k=0;k<ARRSIZE;k++)
	{
		for(j=0;j<ARRSIZE;j++)
		{
			A[k*ARRSIZE+j] = 1;	
		}
		B[k] = 1;
	}
	

	// Retrieve platform and device information
	ret = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
	ret = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);

	clGetDeviceInfo(device_id, CL_DEVICE_NAME, sizeof(device_name), &device_name, NULL);
	printf("\nDevice Name :  %s \n",device_name);

	// Create OpenCL context
	context = clCreateContext( NULL, 1, &device_id, NULL, NULL, &ret);

	// Create command queue 
	command_queue = clCreateCommandQueue(context, device_id, 0, &ret);

	//Allocate memory
	Ad = clCreateBuffer(context, CL_MEM_READ_ONLY, ARRSIZE*ARRSIZE * sizeof(int), NULL, &ret);
	Bd = clCreateBuffer(context, CL_MEM_READ_ONLY, ARRSIZE * sizeof(int), NULL, &ret);
	Cd = clCreateBuffer(context, CL_MEM_WRITE_ONLY, ARRSIZE * sizeof(int), NULL, &ret);

	
	// Copy data to allocated memory
	ret = clEnqueueWriteBuffer(command_queue, Ad, CL_TRUE, 0, ARRSIZE * ARRSIZE * sizeof(int), A, 0, NULL, NULL);
	ret = clEnqueueWriteBuffer(command_queue, Bd, CL_TRUE, 0, ARRSIZE * sizeof(int), B, 0, NULL, NULL);

	// Create program from the input kernel source
	program = clCreateProgramWithSource(context, 1, (const char **)&source_str, (const size_t *)&source_size, &ret);

	// Build kernel program
	ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);

	if (ret == CL_BUILD_PROGRAM_FAILURE) {
	    //l_logError("Could not build Kernel!");
	    // Determine the size of the log
	    size_t log_size;
	    printf(" reta: %i\n", clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size));

	    // Allocate memory for the log
	    char *log = (char *) malloc(log_size);

	    // Get the log
	    printf(" retb: %i\n", clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, log_size, log, NULL));

	    // Print the log
	    printf(" ret-val: %i\n", ret);
	    printf("%s\n", log);
	}

	// Create Kernel
	kernel = clCreateKernel(program, "matrix_vector", &ret);

	// Set kernel arguments 
	ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), &Ad);
	ret = clSetKernelArg(kernel, 1, sizeof(cl_mem), &Bd);
	ret = clSetKernelArg(kernel, 2, sizeof(cl_mem), &Cd);
	ret = clSetKernelArg(kernel, 3, sizeof(int), &N);

	printf("Launching Kernel...\n");
	fflush(0);

	// Create launch configuraion
	size_t global_work_size = ARRSIZE;

	// Execute kernel
	ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, &global_work_size, NULL, 0, NULL, NULL);
	

	// Copy results back
	ret = clEnqueueReadBuffer(command_queue, Cd, CL_TRUE, 0, ARRSIZE*sizeof(int), C, 0, NULL, NULL);
	

	// Print results
	for(i=0; i<ARRSIZE; i++) 
	{
		printf("\t%d", C[i]);
	}

	// Release all
	ret = clFlush(command_queue);
	ret = clFinish(command_queue);
	ret = clReleaseKernel(kernel);
	ret = clReleaseProgram(program);
	ret = clReleaseMemObject(Ad);
	ret = clReleaseMemObject(Bd);
	ret = clReleaseMemObject(Cd);
	ret = clReleaseCommandQueue(command_queue);
	ret = clReleaseContext(context);

	free(source_str);
	
	free(A);
	free(B);
	free(C);

	return 0;
}
