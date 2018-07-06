
#include "comm.h"
int main()
{
    int shmid=GetShmid(4097);
    if(shmid>0)
    {   
        int i=0;
        char *addr=shmat(shmid,NULL,0);
        char data[]="abcdefghij";
        /*for(int c=0; c <10; c++)
        {
            data[c]=c;
            printf("%d",data[c]);
        }*/
        //sleep(1);
        printf("Client copy string %s to shared memory.\n", data );
        printf("Server will do the options: data[i] = data[i] + 1\n");
        printf("The output should be:\n bcdefghijk\n");
        memcpy(addr,data,10);
        
        sleep(5);
        printf("5.After sleep(5), the client read data from shared memory:\n %s\n",addr);
        //printf("%s\n",addr);
        /*while(i<10)
        {   
            printf("%s\n",addr);
            //addr[i]=i;
            //isleep(1);
            sleep(1);
        }*/
       // sleep(1);
       // printf("%s\n",addr);   
        if(shmdt(addr)==-1)
        {   
            perror("shmdt");
            return-1;
        }   
    }   
    else
    {   
        perror("GetShmid");
      return -2;
    }
    return 0;
}
