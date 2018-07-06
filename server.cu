
#include "comm.h"
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void charAdd(char *a, char *c)
{
  int i = threadIdx.x;
  if(i<10)
  {
    printf("a[i]: %d\n",a[i]);
    c[i] = a[i]+1;
    printf("c[i]: %d\n",c[i]);
  }
}

int main()
{
    //char r[10];
    cudaError_t err = cudaSuccess;
    char *d_s = NULL;
    char *d_c = NULL;
    size_t size = 10*sizeof(char);
    int shmid=CreatShmid(4097);
    daemon(1,1);

    err=cudaMalloc((void **)&d_s, size);
    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to allocate device vector A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    err=cudaMalloc((void **)&d_c, size);
    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to allocate device vector A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    if(shmid>0)
    {   
        //int i=0;
        char *addr=shmat(shmid,NULL,0);
        char data[10];
        while(20)
        {
          if (addr[0]=='a')
            {
              memcpy(data,addr,10);
              err = cudaMemcpy(d_s, data, size, cudaMemcpyHostToDevice);
              if (err != cudaSuccess)
              {
                  fprintf(stderr, "Failed to copy string s from host to device (error code %s)!\n", cudaGetErrorString(err));
                  exit(EXIT_FAILURE);
              }
              /*for(int i=0; i<10; i++){ 
                  data[i]=data[i]+1;
              }*/
              charAdd<<<1,10>>>(d_s, d_c);
              err = cudaGetLastError();

              if (err != cudaSuccess)
              {
                  fprintf(stderr, "Failed to launch vectorAdd kernel (error code %s)!\n", cudaGetErrorString(err));
                  exit(EXIT_FAILURE);
              }
              err = cudaMemcpy(data, d_c, size, cudaMemcpyDeviceToHost);
              if (err != cudaSuccess)
              {
                  fprintf(stderr, "Failed to copy vector d_s from device to host (error code %s)!\n", cudaGetErrorString(err));
                  exit(EXIT_FAILURE);
              }
              cudaFree(d_s);
              cudaFree(d_c);
              memcpy(addr,data,10);
            }  
        }   
        if(shmdt(addr)==-1)
        {   
            perror("shmat");
            return -3; 
        }   
 
    }   
   else
    {   
        perror("CreatShmid");
        return -1;
    }
    if(Destory(shmid)<0)
    {
        perror("Destory");
        return -2;
    }
    return 0;
}
