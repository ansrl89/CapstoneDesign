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

int decide_Direction_By_OnePoint(int x, int y, int *last_X, int *last_Y)
{
	// 기본 직진
	int direction = CENTER;

	// 못 찾았을 경우
	if(x == -1 && y == -1)
	{
		if(*last_X == -1)
		{
			cout << "last_X is -1 !!! " << endl;
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
	*x = *y = 0;

	// 선 찾음(노란색)
	POINT pos = findOneColor(LINE_SEARCH_SPACE_X1, LINE_SEARCH_SPACE_X2, LINE_SEARCH_SPACE_Y1, LINE_SEARCH_SPACE_Y2, RED);

	*x = pos.x;
	*y = pos.y;
}

void turnning(int direction, int *flag)
{
	if(direction == CENTER)
	{
//		cout << "go straight" << endl;
		*flag = FALSE;
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

		lastCommand = BASIC_MOTION;
		//usleep(3000000);
		*flag = TRUE;
	}
}

void go_Run(int flag)
{
	if(flag == FALSE)
	{
		currentCommand = RUN_STRAIGHT_50;
		//if(lastCommand != currentCommand)
		{
			send2Message(currentCommand);
			lastCommand = currentCommand;
		}
	}
}


void conquest_Task(int *last_X, int *last_Y)
{
	// 앞 쪽에서 장애물 발견하면
	// 시야의 아래쪽을 수평으로 검사
	POINT obstacle = findOneColor(5, 315, 230, 233, GREEN);

	//	장애물 발견 하였다면
	if(obstacle.x > 0 && obstacle.y > 0)
	{
		// 장애물 앞에가서 멈춤
		//usleep(2000000);	// 적당히 몇걸음 더 간후 정지
		send2Message(BASIC_MOTION);
		usleep(3000000);

		while(1)	// 최초로 찾은 뒤
		{
//			cout << "right" << endl;
			obstacle = findOneColor(7, 10, 10, 230, GREEN);	// 세로로 검사
			if(obstacle.x > 0 && obstacle.y > 0)
				break;

			send2Message(MOVE_RIGHT);
			usleep(200000);
		}
		// 장애물이 안보일 때까지 왼쪽 혹은 오른쪽으로 이동
		while(1)
		{
			cout << "right" << endl;
			// 오른쪽으로 이동하며 왼쪽을 검사
			obstacle = findOneColor(7, 10, 10, 230, GREEN);	// 세로로 검사
			if(obstacle.x == -1 && obstacle.y == -1)
			{
				for(int i=0; i<4; i++){
					send2Message(MOVE_RIGHT);
					usleep(200000);
				}
				break;
			}
			send2Message(MOVE_RIGHT);
			usleep(200000);
		}


		// 고개를 장애물 쪽으로 돌리고, 장애물을 지나칠때까지 전진
		usleep(1000000);
		send2Message(HEAD_3_1);
		usleep(2000000);
		send2Message(RUN_STRAIGHT_50);

		while(1)	// 최초로 찾은 뒤
		{
			obstacle = findOneColor(7, 10, 10, 230, GREEN);	// 세로로 검사
			if(obstacle.x > 0 && obstacle.y > 0)
				break;
		}
		while(1)	// 그 후 못 찾으면 장애물 지나친 것
		{
			obstacle = findOneColor(7, 10, 10, 230, GREEN);	// 세로로 검사
			if(obstacle.x == -1 && obstacle.y == -1)
				break;
		}
		// 몇걸음 더 가야함
		usleep(8000000);

		// 고개도 돌아감
		send2Message(BASIC_MOTION);
		usleep(300000);
		// 멈춘 후, 고개 원위치, 선을 찾아서 복귀
		*last_X = WIDTH/2 - 1;

		return;

	}

	// 앞쪽에서 계단 발견하면
	// 시야의 아래쪽을 수평으로 검사
/*
	POINT stair = findOneColor(5, 315, 10, 12, RED);

	// 계단 발견 하였다면
	if(stair.x > 0 && stair.y > 0)
	{
		// 계단 앞에서 멈춤
		sleep(2);	// 적당히 몇걸음 더 간후 정지
		send2Message(BASIC_MOTION);

		// 계단에 최대한 밀착
		// 동작 필요

		// 계단 오르기
		send2Message(BASIC_MOTION);

		// 계단 내려갈 준비
		send2Message(BASIC_MOTION);

		// 계단 내려가기
		send2Message(BASIC_MOTION);

		// 자세잡고 선을 찾아서 복귀
		send2Message(BASIC_MOTION);

		return;
	}
*/
}


