/*
 * ACTION_Module.hpp
 *
 *  Created on: 2014. 3. 31.
 *      Author: keroro
 */

#ifndef ACTION_MODULE_HPP_
#define ACTION_MODULE_HPP_

#include "shared_Data.hpp"


// control
#define RUN_STRAIGHT_50				2
#define TURNLEFT_10					1
#define TURNLEFT_20					4
#define TURNLEFT_45					7
#define TURNRIGHT_10					3
#define TURNRIGHT_20					6
#define TURNRIGHT_45					9
#define WALK_STRAIGHT				5
#define WALK_ONESTEP					8
#define SHORT_WALK_ONE				10

#define BASIC_MOTION					26
#define BASIC_MOTION_WITHOUT_HEAD	29

#define MOVE_RIGHT		24
#define MOVE_LEFT			22

#define KICK_LEFT			15
#define KICK_RIGHT		20

#define UP_STAIR_LEFT	17
#define UP_STAIR_RIGHT	27
#define DOWN_STAIR_LEFT	18
#define DOWN_STAIR_RIGHT	23

// Head control
#define HEAD_1_1		63
#define HEAD_1_2		60
#define HEAD_1_3		12
#define HEAD_1_4		66
#define HEAD_1_5		69

#define HEAD_2_1		64
#define HEAD_2_2		61
#define HEAD_2_3		73
#define HEAD_2_4		67
#define HEAD_2_5		70

#define HEAD_3_1		14
#define HEAD_3_2		62
#define HEAD_3_3		11
#define HEAD_3_4		67
#define HEAD_3_5		13


// 국민체조
#define AEROBIC		45
#define AEROBIC1		46
#define AEROBIC2		47
#define AEROBIC3		48
#define AEROBIC4		49
#define AEROBIC5		50
#define AEROBIC6		51
#define AEROBIC7		52
#define AEROBIC8		53
#define AEROBIC9		54
#define AEROBIC10		55
#define AEROBIC11		56
#define AEROBIC12		57



void send2Message(int message);
int receiveMessage();
int send_n_ReceiveMessage(int message);


#endif /* ACTION_MODULE_HPP_ */
