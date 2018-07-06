
#include "comm.h"
static int commShmid(int size,int flag)
{
    key_t key=ftok(PATHNAME,PROJ_ID);
    if(key>0)
    {   
        return shmget(key,size,flag);
    }   
    else
    {   
        perror("ftok");
        return -1; 
    }   
}
 
int CreatShmid(int size)
{
    return commShmid(size,IPC_CREAT|IPC_EXCL|0666);
}
int GetShmid(int size)
{
    return commShmid(size,IPC_CREAT);
}
int Destory(int shmid)
{
    return shmctl(shmid,0,IPC_RMID);
}
