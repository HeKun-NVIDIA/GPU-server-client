#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_runtime.h>

#define CHECK(res) if(res!=cudaSuccess){exit(-1);}
__global__ void Kerneltest(char *da, char *dr)
{
  unsigned int i=  threadIdx.x;
  if (i <10)
  {
    dr[i] = da[i]+1;
  }
}
 
extern "C" int func(char *data, char *result) 
{
  char *da = NULL;
  char *ha = NULL;
  char *dr = NULL;
  char *hr = NULL;
  cudaError_t res;
  int r;
  printf("2.GPU recieve :\n %s\n",data );
  res = cudaMalloc((void**)(&da), 10*sizeof(char));CHECK(res)
  res = cudaMalloc((void**)(&dr), 10*sizeof(char));CHECK(res)
  ha = (char*)malloc(10*sizeof(char));
  hr = (char*)malloc(10*sizeof(char));
 
  for (r = 0; r < 10; r++)
  {
    ha[r] = data[r];
  }
  res = cudaMemcpy((void*)(da), (void*)(ha), 10*sizeof(char), cudaMemcpyHostToDevice);CHECK(res)
  Kerneltest<<<1, 10>>>(da, dr);
  res = cudaMemcpy((void*)(hr), (void*)(dr), 10*sizeof(char), cudaMemcpyDeviceToHost);CHECK(res)
  memcpy(result,hr,10);
  printf("3.GPU func result:\n %s\n", result );
  cudaFree((void*)da);
  cudaFree((void*)dr);
  free(ha);
  free(hr);

  return 0;
}

