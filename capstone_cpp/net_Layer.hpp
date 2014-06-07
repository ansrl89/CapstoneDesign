/*
 * net_Layer.hpp
 *
 *  Created on: 2014. 4. 15.
 *      Author: keroro
 */

#ifndef NET_LAYER_HPP_
#define NET_LAYER_HPP_

#include "shared_Data.hpp"
#include "ACTION_Module.hpp"

#define MAX_NUMBER_OF_PEER	5

// peertype
#define UNDEFINED	-1
#define DESKTOP	1
#define ANDROID	2
#define STREAM	3


void *net_Layer(void*);
void error_handling(char *message);


#endif /* NET_LAYER_HPP_ */
