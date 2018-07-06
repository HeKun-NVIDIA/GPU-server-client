#!/bin/bash  
result=$(ipcs -m | grep 4097)
result_split=($result)
shmid=${result_split[1]}
if [ $shmid ];then
    echo "shared memory id is: "
    echo $shmid
    ipcrm -m $shmid
    echo "stop shared memory"
else
    echo "shared memory have free"
fi

psc=$(ps -aux | grep server.exe)
echo $psc
psc_split=($psc)
num=${#psc_split[@]}
psid=${psc_split[1]}
if [ $num -gt 15 ];then
	kill $psid
	echo "Kill server.exe"
else
	echo "Server.exe has already stop"
fi

