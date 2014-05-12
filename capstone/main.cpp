/*
 * main.cpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C" {
	#include <pthread.h>
}
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/signal.h>
#include <sys/types.h>
#include <time.h>

#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ctype.h>

#include <sys/signal.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>


#include "shared_Data.hpp"
#include "cam_Module.hpp"
#include "AI_Module.hpp"
#include "ACTION_Module.hpp"
#include "net_Layer.hpp"

#define BAUDRATE B4800
#define MODEDEVICE "/dev/ttyAMA0"


void init();
void terminate_System();
void make_Thread();

int open_serial(void);
void open_Cam();
void init_Semaphore();

int main(int argc, char* argv[])
{
	// 장치 초기화
	init();

	// 쓰레드 분리
	make_Thread();

//	AI_Module(NULL);
	// 프로그램 마무리
	terminate_System();

	return 0;
}

void init()
{
	// 모터 제어 보드 초기화
	uart_fd = open_serial();

	// 카메라 초기화
	open_Cam();

	// 네트워크 초기화?

	// 세마포 초기화
	init_Semaphore();

	// 시작 신호 받음
//	receiveMessage();
}

void terminate_System()
{
	printf("Terminate System\n");
}


void make_Thread()
{
	printf("threads init!\n");

	int thr_id[4];
	pthread_t p_threads[4];


	// video Frame
	thr_id[2] = pthread_create(&p_threads[2], NULL, videoFrame, (void*) NULL);
	if (thr_id[2] < 0) {
		perror("network thread create error : ");
		exit(1);
	}

	sleep(1);

/*	// AI_Module
	thr_id[0] = pthread_create(&p_threads[0], NULL, AI_Module, (void*)NULL);
	if (thr_id[0] < 0) {
		perror("AI_Module thread create error : ");
		exit(0);
	}
*/
	// Network Layer
	thr_id[1] = pthread_create(&p_threads[1], NULL, net_Layer, (void*) NULL);
	if (thr_id[1] < 0) {
		perror("network thread create error : ");
		exit(1);
	}

	int status;
//	pthread_join(p_threads[0], (void **)&status);
	pthread_join(p_threads[1], (void **)&status);
	pthread_join(p_threads[2], (void **)&status);

	printf("Threads join completely!\n");
}

int open_serial(void)
{
    char fd_serial[20];
    int fd;
    struct termios oldtio, newtio;

    strcpy(fd_serial, MODEDEVICE); //FFUART

    fd = open(fd_serial, O_RDWR | O_NOCTTY );
    if (fd <0) {
       printf("Serial %s  Device Error\n", fd_serial );
       //exit(1);
    }
    else
    	printf("robot uart ctrl %s\n", MODEDEVICE);

    tcgetattr(fd,&oldtio); /* save current port settings */
    bzero(&newtio, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
    newtio.c_lflag = 0;
    newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 1;   /* blocking read until 8 chars received */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    return fd;
}

void open_Cam()
{
	if (!cap.isOpened())
   {
	  cout << "Cannot open camera" << endl;
	  exit(1);
   }

   cap.set(CV_CAP_PROP_FRAME_WIDTH, WIDTH);
   cap.set(CV_CAP_PROP_FRAME_HEIGHT, HEIGHT);


}

void init_Semaphore()
{
	key_t semkey = SEMKEY;

	if((semid = initsem(semkey)) < 0)
			exit(1);

	printf("sem init comlete!\n");

}
