/*
 * AI_Module.hpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */

#ifndef AI_MODULE_HPP_
#define AI_MODULE_HPP_

#include "shared_Data.hpp"
#include "cam_Module.hpp"
#include "ACTION_Module.hpp"
#include <stdio.h>
#include <stdlib.h>

/*
 * 미션 번호
 */
#define LINE 1
#define KICK 2
#define OBSTACLE 3
#define STAIR 4

/*
 * 글로벌 플랜 번호
 * 10 번대는 라인트레이싱
 * 20 번대는 패널티킥
 * 30 번대는 장애물 회피
 * 40 번대는 계단 오르기
 */
#define LINE_IMAGE_PROCESSING		11
#define RUNNING						12
#define CONTINUE_OR_STOP				13


/*
 * 로컬 플랜 번호
 */
// line
#define FIND_LINE				111
#define DECIDE_DIRECTION		112
#define TURNING				113
#define GO_RUN				114

#define CONQUEST_TASK		115
// ~~


typedef struct plan_Que P_Q;
struct plan_Que
{
	int command;
	P_Q *nextNode;
} ;



void *AI_Module(void*);	// main

int isExistLocal();		// 로컬 플랜이 존재하는지 확인
int isExistGlobal();		// 글로벌 플랜이 존재하는지 확인
int isExistMission();	// 미션ㅇ티 존재하는지 확인
int receiveMission();	// 미션을 부여받음

P_Q *globalPlanning(int m);	// 미션에 대하여 글로벌 플랜 생성
P_Q *localPlanning(P_Q **g);	// 글로벌 플랜에 대하여 로컬 플랜 생성
void doLocalPlan(P_Q **l);	// 로컬플랜을 수행

/*
 * 글로벌 플랜 세부
 */
P_Q *makeGlobalPlan_Line();
P_Q *makeGlobalPlan_Kick();
P_Q *makeGlobalPlan_Obstacle();
P_Q *makeGlobalPlan_Stair();

/*
 * 큐 오퍼레이션
 */
P_Q *deQue(P_Q **obj);
void enQue(P_Q *root, P_Q *obj);
P_Q *makeNode(int n);
void deleteNode(P_Q *obj);


/*
 * doLocalPlan
 */
int decide_Direction_By_OnePoint(int x, int y, int *last_X, int *last_Y);
void find_OnePoint(int *x, int *y);
void turnning(int direction, int *flag);
void go_Run(int flag);

void conquest_Task(int *last_X, int *last_Y);

#endif /* AI_MODULE_HPP_ */
