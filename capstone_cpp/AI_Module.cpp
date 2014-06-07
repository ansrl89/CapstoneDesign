/*
 * AI_Module.cpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */


#include "AI_Module.hpp"

int leavedMission = 1;

int mission;
P_Q *global;
P_Q *local;

int x_Point = -1, y_Point = -1;
int x_Last = -1, y_Last = -1;
int robo_Direction = 0;
int turn_Flag = 0;


/*
 * AI_Module
 *
 * AI 모듈의 메인 함수와 같은 역할.
 * 최상위 함수로서 현재 상태에 따라 진입하는 함수가 다름.
 * Rule Based System 을 흉내냄.
 */
void *AI_Module(void*)
{
	// solving password, password is 4, 3, 2, 1
	send2Message(4);
	usleep(500000);
	send2Message(3);
	usleep(500000);
	send2Message(2);
	usleep(500000);
	send2Message(1);
	usleep(500000);
	// be ready with basic form
	send2Message(BASIC_MOTION);
	usleep(1000000);
	printf("AI module is started!\n");


	while(1)
	{
		if(isExistLocal()){
			//break;
			doLocalPlan(&local);
		}
		else if(isExistGlobal()){
			local = localPlanning(&global);
		}
		else if(isExistMission()){
			int m = receiveMission();
			global = globalPlanning(m);
		}

		else{	// 로컬 플랜, 글로벌 플랜, 미션 모두 존재하지 않는다면 정지
			//break;
			//sleep(1);
		}
	}
}

/*
 * 로컬 플랜을 실제로 수행하는 함수
 * 인자로 받은 로컬플랜에 따라 미션 번호를 추출하고, 미션 번호에 따라 해당하는 루티을 수행.
 */
void doLocalPlan(P_Q **l){

	P_Q *current = deQue(l);

	switch(current->command){
	// 라인 트레이싱
	case FIND_LINE:
		find_OnePoint(&x_Point, &y_Point);
		break;
	case CONQUEST_TASK:
		conquest_Task(&x_Point, &y_Point, &x_Last, &y_Last);
		break;
	case DECIDE_DIRECTION:
		robo_Direction = decide_Direction_By_OnePoint(x_Point, y_Point, &x_Last, &y_Last);
		break;
	case TURNING:
		turnning(robo_Direction);
		break;
	case GO_RUN:
		go_Run();
		break;

	// KICK
	case FIND_BALL:
		find_Ball(&x_Point, &y_Point);
		break;
	case GOTO_BALL:
		goTo_Ball(&x_Point, &y_Point);
		break;
	case SET_DIRECTION:

		break;
	case PLACE_ONELINE:

		break;
	case READY_FOR_KICK:
		ready_For_Kick();
		break;
	case KICKING:
		kicking();
		break;

	default:
		break;
	}

	deleteNode(current);

}

/*
 * 로컬플랜이 존재하는지 여부를 검사
 * 존재한다면 true, 그렇지 않다면 false 를 리턴
 */
int isExistLocal(){
	if(local != NULL){
		return TRUE;
	}

	else
		return FALSE;
}

/*
 * 글로벌 플랜이 존재하는지 여부를 검사
 * 존재한다면 true, 그렇지 않다면 false 를 리턴
 */
int isExistGlobal(){
	if(global != NULL){
		return TRUE;
	}

	else
		return FALSE;
}

/*
 * 미션이 존재하는지 여부를 검사
 * 미션이 존재한다면 남은 미션의 수를 1개 줄여주고, true 리턴
 * 그렇지 않다면 false 를 리턴
 */
int isExistMission(){
	if (leavedMission > 0)
	{
//		leavedMission--;
		return TRUE;

	}

	else{
		return 0;
	}
}

/*
 * 미션을 부여받음.
 *
 */
int receiveMission(){

	// 일단 라인트레이싱
	// 미션을 어떻게 입력받을지 고민 필요
	int re;

	printf("before received!!\n");

//	missionVariable = KICK;	 // 실제할 때는 주석
	// 이 부분은 네트워크에서 정해줄 것
	while(missionVariable < 0)
	{
		sleep(1);
	}

	printf("mission received!!\n");

	re = missionVariable;
	missionVariable = -1;

	return re;
}

/*
 * 주어진 미션에 대하여 글로벌 플래닝함
 */
P_Q *globalPlanning(int m){

	P_Q *obj = NULL;

	switch(m){
	case LINE:
		obj = makeGlobalPlan_Line();
		break;
	case KICK:
		obj = makeGlobalPlan_Kick();
		break;
	case OBSTACLE:
		obj = makeGlobalPlan_Obstacle();
		break;
	case STAIR:
		obj = makeGlobalPlan_Stair();
		break;
	default:
		break;
	}

	return obj;
}

/*
 * 주어진 글로벌 플랜에 대해서 로컬 플래닝함
 */
P_Q *localPlanning(P_Q **g){
	P_Q *root = NULL, *obj1, *obj2;
	P_Q *currentGlobalPlan = deQue(g);

	switch(currentGlobalPlan->command){
	/*
	 * 라인트레이싱
	 */
	case LINE_IMAGE_PROCESSING:
		root = makeNode(FIND_LINE);
		obj2 = makeNode(CONQUEST_TASK);
		obj1 = makeNode(DECIDE_DIRECTION);

		enQue(root, obj2);
		enQue(root, obj1);

		break;
	case RUNNING:
		root = makeNode(TURNING);
		obj1 = makeNode(GO_RUN);

		enQue(root, obj1);
		break;
	case CONTINUE_OR_STOP:
		// 종료 사인을 받으면 종료해야 함
		// 계속 할 거라면
		if(lineStopFlag == 0)
		{
			if((*g) != NULL)
				deleteNode(*g);

			*g = makeGlobalPlan_Line();
		}
		// 종료 해야한다면
		else
		{
			lineStopFlag = 0;
			send2Message(BASIC_MOTION);
			usleep(1000000);
		}

		break;

	/*
	 * 패널티킥
	 */
	case APPROACH_BALL:
		root = makeNode(FIND_BALL);
		obj1 = makeNode(GOTO_BALL);

		enQue(root, obj1);
		break;
	case SET_POS:
		root = makeNode(SET_DIRECTION);
		obj1 = makeNode(PLACE_ONELINE);

		enQue(root, obj1);
		break;
	case KICK_IN:
		root = makeNode(READY_FOR_KICK);
		obj1 = makeNode(KICKING);

		enQue(root, obj1);
		break;

	default:
		break;
	}

	deleteNode(currentGlobalPlan);

	return root;
}

/*
 * 라인트레이싱 미션에 대해서 글로벌 플래닝함
 */
P_Q *makeGlobalPlan_Line(){
	P_Q *root = makeNode(LINE_IMAGE_PROCESSING);
	P_Q *obj1 = makeNode(RUNNING);
	P_Q *obj2 = makeNode(CONTINUE_OR_STOP);

	enQue(root, obj1);
	enQue(root, obj2);

	return root;
}

/*
 * 패널티킥 미션에 대해서 글로벌 플래닝함
 */
P_Q *makeGlobalPlan_Kick(){
	P_Q *root = makeNode(APPROACH_BALL);
	P_Q *obj1 = makeNode(SET_POS);
	P_Q *obj2 = makeNode(KICK_IN);

	enQue(root, obj1);
	enQue(root, obj2);

	return root;
}

/*
 * 장애물회피 미션에 대해서 글로벌 플래닝함
 */
P_Q *makeGlobalPlan_Obstacle(){
	return NULL;
}

/*
 * 계단오르기 미션에 대해서 글로벌 플래닝함
 */
P_Q *makeGlobalPlan_Stair(){
	return NULL;
}



/*
 * 큐에서 제일 앞의 오브젝트를 꺼내어 반환함
 */
P_Q *deQue(P_Q **obj){

	if(*obj == NULL)
	{
		// err
		printf("stack err\n");

		exit(1);
		return NULL;
	}

	P_Q *re = *obj;
	*obj = (*obj)->nextNode;

	re->nextNode = NULL;

	return re;

}

/*
 * 큐의 가장 마지막 부분에 새로운 오브젝트를 추가함
 * 첫 인자는 새로운 노드를 추가할 큐.
 * 두 번째 인자는 새로운 노드
 */
void enQue(P_Q *root, P_Q *obj){

	if(root == NULL)
	{

	}

	else
	{
		P_Q *tmp = root;
		while(tmp->nextNode != NULL)
		{
			tmp = tmp->nextNode;
		}

		tmp->nextNode = obj;
		}
	}

/*
 * 노드를 생성하여 초기화 함
 */
P_Q *makeNode(int n){
	P_Q *obj = (P_Q*)malloc(sizeof(P_Q));

	obj->command = n;
	obj->nextNode = NULL;

	return obj;
}

void deleteNode(P_Q *obj)
{
	if(obj->nextNode != NULL)
		deleteNode(obj->nextNode);

	free(obj);
}

