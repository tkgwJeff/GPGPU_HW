
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "err_handler.h"
#include <stdio.h>


using namespace std;

__device__ int mytoupper(int a){
	if (a >= 'a' && a <= 'z' )
	return a-'a'+'A';

}
__global__ void kernel(char* input, char *result, int size)
{
	
    int i = threadIdx.x + blockIdx.x*blockDim.x;
	int stride = blockDim.x*gridDim.x;
	
	while (i < size){
		//result[i] = mytoupper(input[i]);
		if (input[i] >= 'a' && input[i] <= 'z')
			result[i] = input[i] - 'a' + 'A';
		else result[i] = input[i];
		i += stride;
	}

}

int main()
{
	char input[] = "hello, cuda.";
	int size = sizeof(input);
	char *dev_input;
	char *dev_output;
	char *result;
	
	// copy string from host to device
	HANDLE_ERROR(cudaMalloc((void**)&dev_input, size*sizeof(char)));
	HANDLE_ERROR(cudaMemset(dev_input, 0, size*sizeof(char)));
	HANDLE_ERROR(cudaMemcpy(dev_input, input, size*sizeof(char), cudaMemcpyHostToDevice));

	HANDLE_ERROR(cudaMalloc((void**)&dev_output, size*sizeof(char)));
	HANDLE_ERROR(cudaMemset(dev_output, 0, size*sizeof(char)));

	result = (char*)malloc(size*sizeof(char));

	kernel<<<1, 256>>>(dev_input, dev_output,size);

	//copy result from device to host
	HANDLE_ERROR(cudaMemcpy(result, dev_output, size*sizeof(char), cudaMemcpyDeviceToHost));
	printf("result: %s \n", result);
	system("pause");
	// clean
	HANDLE_ERROR(cudaFree(dev_input));
	HANDLE_ERROR(cudaFree(dev_output));
	free(result);
	printf("done\n");
	system("pause");
    return 0;
}


