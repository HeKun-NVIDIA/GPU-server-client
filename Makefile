all:server.exe client.exe

server.exe:server.o comm.o
	g++ server.o comm.o addfunc.o -o server.exe -lcudart -L/usr/local/cuda/lib64

client.exe:client.o comm.o
	gcc client.o comm.o -o client.exe

server.o:server.c
	gcc -c server.c -o server.o
client.o:client.c
	gcc -c client.c -o client.o
comm.o:comm.c comm.h
	gcc -c comm.c -o comm.o
addfunc.o:addfunc.cu
	nvcc -c addfunc.cu
clean:
	rm -rf *.o *.exe
