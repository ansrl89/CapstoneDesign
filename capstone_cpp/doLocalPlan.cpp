/*
 * doLocalPlan.cpp
 *
 *  Created on: 2014. 3. 31.
 *      Author: keroro
 */

#include "AI_Module.hpp"

#define LEFT 	-1
#define RIGHT	 1
#define CENTER 0

int lastCommand = -1;
int currentCommand = -1;
int runFlag = 0;

int decide_Direction_By_OnePoint(int x, int y, int *last_X, int *last_Y)
{
	// 기본 직진
	int direction = CENTER;

	// 못 찾았을 경우
	if(x == -1 && y == -1)
	{
		if(*last_X == -1)
		{
//			cout << "last_X is -1 !!! " << endl;
		}
		else if(*last_X < WIDTH/2)
		{

			direction = LEFT;
		}

		else
		{

			direction = RIGHT;
		}

		return direction;
	}


	// 찾았을 경우
	// 찾은 경우에만 이전 찾은점 저장, 못 찾으면 저장하면 안됨
	*last_X = x;
	*last_Y = y;
	// 직진
	return direction;
}

void find_OnePoint(int *x, int *y)
{
	// 초기화
	*x = *y = -1;

	// 선 찾음
	POINT pos = findOneColor(20, 140, 50, HEIGHT-1, RED);

	*x = pos.x;
	*y = pos.y;
}

void turnning(int direction)
{
	if(direction == CENTER)
	{
//		cout << "go straight" << endl;

		runFlag = 1;
		return;
	}

	else
	{
		// 방향을 전환해준다
		if(direction == LEFT)
		{
//			cout << "left" << endl;
			send2Message(TURNLEFT_20);
		}

		else if(direction == RIGHT)
		{
//			cout << "right" << endl;
			send2Message(TURNRIGHT_20);

		}

		lastCommand = BASIC_MOTION_WITHOUT_HEAD;
//		send2Message(BASIC_MOTION_WITHOUT_HEAD);
		usleep(1000000);

		runFlag = 0;
	}
}

void go_Run()
{
	if(runFlag == 1){
		currentCommand = RUN_STRAIGHT_50;
		if (lastCommand != currentCommand) {
			send2Message(currentCommand);
			lastCommand = currentCommand;
		}
	}

}


void conquest_Task(int *x, int *y, int *last_X, int *last_Y)
{

	// 앞 쪽에서 장애물 발견하면
	// 시야의 아래쪽을 수평으로 검사
	POINT obstacle = findOneColor(5, WIDTH-5, 102, 105, GREEN);

	//	장애물 발견 하였다면
	if(obstacle.x > 0 && obstacle.y > 0)
	{
		// 장애물 앞에가서 멈춤
		//usleep(200000);	// 적당히 몇걸음 더 간후 정지
		send2Message(BASIC_MOTION_WITHOUT_HEAD);
		runFlag = 0;
		usleep(1500000);

		while(1)	// 최초로 찾은 뒤
		{
//			cout << "right" << endl;
			obstacle = findOneColor(3, 7, 10, 110, GREEN);	// 세로로 검사
			if(obstacle.x > 0 && obstacle.y > 0)
				break;

			send2Message(MOVE_RIGHT);
			usleep(800000);
		}
		// 장애물이 안보일 때까지 왼쪽 혹은 오른쪽으로 이동
		while(1)
		{
			cout << "right" << endl;
			// 오른쪽으로 이동하며 왼쪽을 검사
			obstacle = findOneColor(3, 7, 10, 110, GREEN);	// 세로로 검사
			if(obstacle.x == -1 && obstacle.y == -1)
			{
				for(int i=0; i<13; i++){
					send2Message(MOVE_RIGHT);
					usleep(800000);
				}
				break;
			}
			send2Message(MOVE_RIGHT);
			usleep(800000);
		}

		// 고개를 장애물 쪽으로 돌리고, 장애물을 지나칠때까지 전진
		usleep(1000000);
		send2Message(HEAD_3_1);
		usleep(1000000);
		send2Message(WALK_STRAIGHT);

		while(1)	// 최초로 찾은 뒤
		{
			obstacle = findOneColor(3, 7, 10, 110, GREEN);	// 세로로 검사
			if(obstacle.x > 0 && obstacle.y > 0)
				break;
		}
		while(1)	// 그 후 못 찾으면 장애물 지나친 것
		{
			obstacle = findOneColor(3, 7, 10, 110, GREEN);	// 세로로 검사
			if(obstacle.x == -1 && obstacle.y == -1)
				break;
		}
		// 몇걸음 더 가야함
		usleep(3500000);
		send2Message(BASIC_MOTION);
		usleep(1500000);

		// 고개도 돌아감
		send2Message(BASIC_MOTION);
		usleep(1500000);
		send2Message(BASIC_MOTION);
		usleep(800000);
		// 멈춘 후, 고개 원위치, 선을 찾아서 복귀
		*last_X = WIDTH/2 - 10;
		*y = *x = -1;

		lastCommand = BASIC_MOTION_WITHOUT_HEAD;

		return;

	}

	// 앞쪽에서 계단 발견하면
	// 시야의 아래쪽을 수평으로 검사

	POINT stair = findOneColor(50, 110, 102, 105, BLUE);

	// 계단 발견 하였다면
	if(stair.x > 0 && stair.y > 0)
	{
		// 계단 앞에서 멈춤
		//usleep(2000000);	// 적당히 몇걸음 더 간후 정지
		usleep(1000000);
		send2Message(BASIC_MOTION_WITHOUT_HEAD);
		runFlag = 0;
		usleep(2500000);

		// 계단에 최대한 밀착
		// 동작 필요

//		send2Message(WALK_ONESTEP);
//		usleep(3500000);
		// 계단 오르기
		send2Message(UP_STAIR_RIGHT);
		usleep(13000000);	// 10sec
		// 계단 내려가기
		send2Message(DOWN_STAIR_RIGHT);
		usleep(16000000);	// 13sec

		usleep(1000000);

		// 자세잡고 선을 찾아서 복귀
		//send2Message(BASIC_MOTION);

		lastCommand = BASIC_MOTION_WITHOUT_HEAD;

		return;
	}

}




///////////////////////////////////////////////////////////////////
// KICK

void find_Ball(int *x, int *y)
{
	// 초기화
	*x = *y = -1;

	// ball 찾음
	POINT pos = findOneColor(1, WIDTH-1, 1, HEIGHT-1, BLUE);

	printf("Here Find Ball!!\n");

	*x = pos.x;
	*y = pos.y;

}

void goTo_Ball(int *x, int *y)
{
	int last_X = *x;
	int last_Y = *y;

	while(1)
	{
		printf("Here goTo_Ball Loop!!\n");
		POINT ball = find_Pos_Of_Color(40, 120, BLUE);

		if(ball.x != -1 && ball.y != -1)
		{
			// 찾았다면
			last_X = ball.x;
			last_Y = ball.y;

			// 전진 or 접근완료
			if(ball.y > 100)
			{
				// 멈추고 루프탈출
				send2Message(BASIC_MOTION);
				usleep(400000);
				printf("stop\n");
				break;
			}
			else
			{
				printf("go\n");
				send2Message(RUN_STRAIGHT_50);
			}
		}
		else
		{
			// 못찾으면
			// 찾을 때까지 회전

			if(last_X > WIDTH/2)
			{
				send2Message(TURNRIGHT_20);
				printf("ball right\n");
			}
			else if(last_X <= WIDTH/2 && last_X >= 0)
			{
				send2Message(TURNLEFT_20);
				printf("ball left\n");
			}
			else
			{
				printf("Here no ball\n");
			}

			usleep(300000);
		}
	}
}

void ready_For_Kick()
{
	usleep(1000000);

	send2Message(HEAD_1_3);

	usleep(500000);

	while(1){
		POINT ball = find_Pos_Of_Color(1, WIDTH-1, BLUE);

		if(ball.x > 0 || ball.y > 0)
		{
			if(ball.x < 55)
			{
				send2Message(MOVE_LEFT);

				usleep(800000);
			}

			else if(ball.x > 105)
			{
				send2Message(MOVE_RIGHT);

				usleep(800000);
			}

			else if(ball.y < 100)
			{
//				send2Message(SHORT_WALK_ONE);
				send2Message(WALK_ONESTEP);

				usleep(2000000);
			}

			else
				break;
		}

		else if(ball.x == -1 && ball.y == -1)
		{
			printf("not found ball in being ready for kick\n");

		}
	}

}


void kicking()
{
	usleep(1000000);

	POINT ball = find_Pos_Of_Color(1, WIDTH-1, BLUE);

	send2Message(BASIC_MOTION);

	usleep(1000000);

	if(ball.x < WIDTH/2)
		send2Message(KICK_LEFT);
	else
		send2Message(KICK_RIGHT);

	usleep(5000000);

	send2Message(BASIC_MOTION);

	usleep(1000000);
}
