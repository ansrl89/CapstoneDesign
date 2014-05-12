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

#define BASIC_MOTION					16
#define BASIC_MOTION_WITHOUT_HEAD	5

#define MOVE_RIGHT		12
#define MOVE_LEFT			11
#define WALK_STRAIGHT	-1

// Head control
#define HEAD_1_1		-1
#define HEAD_1_2		-1
#define HEAD_1_3		-1
#define HEAD_1_4		-1
#define HEAD_1_5		-1

#define HEAD_2_1		-1
#define HEAD_2_2		-1
#define HEAD_2_3		-1
#define HEAD_2_4		-1
#define HEAD_2_5		-1

#define HEAD_3_1		13
#define HEAD_3_2		-1
#define HEAD_3_3		-1
#define HEAD_3_4		-1
#define HEAD_3_5		-1


void send2Message(int message);
int receiveMessage();
int send_n_ReceiveMessage(int message);


#endif /* ACTION_MODULE_HPP_ */
