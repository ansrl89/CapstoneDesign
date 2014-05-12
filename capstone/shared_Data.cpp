/*
 * shared_Data.cpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */

#include "shared_Data.hpp"



// 모터 컨트롤 파일 디스크립터
int uart_fd;

// 카메라 객체
VideoCapture cap(-1);
Mat frame;
char frameBuf[WIDTH*HEIGHT*3]; // 3은 freme.channels() 의 결과값

//	semaphore id
int semid;

int initsem(key_t semkey) {

	int status = 0, semid;

	if ((semid = semget(semkey, 1, SEMPERM | IPC_CREAT | IPC_EXCL)) == -1)
	{
		if (errno == EEXIST)
		{
			semid = semget (semkey, 1, 0);
		}
	}
	else {
		semun arg;
		arg.val = 1;
		status = semctl(semid, 0, SETVAL, arg);
	}

	if (semid == -1 || status == -1) {
		perror("initsem failed\n");
		return (-1);
	}

	return (semid);

}

int p(int semid)
{
	struct sembuf p_buf;

	p_buf.sem_num = 0;
	p_buf.sem_op = -1;
	p_buf.sem_flg = SEM_UNDO;

	if(semop(semid, &p_buf, 1) == -1)
	{
		perror("p(semid) failed");
		exit(1);

	}
	return 0;
}

int v(int semid)
{
	struct sembuf v_buf;

	v_buf.sem_num = 0;
	v_buf.sem_op = 1;
	v_buf.sem_flg = SEM_UNDO;

	if(semop(semid, &v_buf, 1) == -1)
	{
		perror("v(semid) failed");
		exit(1);
	}
}



/*

main()
{
	key_t semkey = 0x200;
	int i;
	for (1=0; i<3; i++)
	{
		if (fork() == 0)
		handlesem(semkey);
	}
}

 */
