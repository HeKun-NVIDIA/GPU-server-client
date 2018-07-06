# GPU-server-client
本次任务完成了三个主要模块
1.守护进程server
  它负责在系统进程中等待client的输入数据，通过ipc shared memory获得数据，并调用GPU kernel model计算，
  最后将计算的结果返回给client

2.客户端client
  用户通过固定的shared memory id 将要计算的数据传给server，并在server完成计算后读取计算结果，并显示出来
 
3.GPU Kernel model
  他是调用GPU资源的模块，获得server端传过来的数据，然后调用GPU进行计算，最后将结果返回给server
  
安装：
    nvcc -c addfunc.cu
	make

停止server：
    ./stop.sh
由于server.exe使用了守护进程，所以必须调用stop.sh才能停止server.exe

清除：
	make clean
