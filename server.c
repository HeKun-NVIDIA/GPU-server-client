
#include "comm.h"
char* func(char*, char*);
int main()
{
    //char r[10];
    int shmid=CreatShmid(4097);
    daemon(1,1);
    if(shmid>0)
    {   
        //int i=0;
        char *addr=shmat(shmid,NULL,0);
        char data[10];
        char *result = NULL;
        result = (char*)malloc(10*sizeof(char));
        while(20)
        {
          if (addr[0]=='a')
            {
              memcpy(data,addr,10);
              /*for(int i=0; i<10; i++){ 
                  data[i]=data[i]+1;
              }*/
              //&data = func(data);
              printf("1.server receive data:\n %s\n", data);
              func(data,result);
              printf("4.Server receive the result from GPU:\n %s\n",result );
              memcpy(addr,result,10);
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
