/*
 * shared_Data.h
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */

#ifndef SHARED_DATA_H_
#define SHARED_DATA_H_

#include <iostream>
#include "opencv2/highgui/highgui.hpp"

using namespace std;
using namespace cv;

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/signal.h>
#include <sys/ioctl.h>
#include <sys/time.h>

#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ctype.h>

//network
//#include <sys/types.h>
//#include <sys/socket.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>

// basic define
#define TRUE 1
#define FALSE 0

// semaphore define
#define SEMPERM 0600
#define SEMKEY 0x200

// image size
#define WIDTH 160
#define HEIGHT 120

typedef union semun {
	int val;
	struct semid_ds *buf;
	ushort *array;
} semun;


extern int stream_Android;

extern int lineStopFlag;

extern int missionVariable;

extern int peer_Desktop;


extern int uart_fd;
extern VideoCapture cap;
extern Mat frame;
extern char frameBuf[WIDTH*HEIGHT*3];
extern int semid;


int initsem(key_t semkey);
int p(int semid);
int v(int semid);



#endif /* SHARED_DATA_H_ */
