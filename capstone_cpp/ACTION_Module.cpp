/*
 * ACTION_Module.cpp
 *
 *  Created on: 2014. 3. 31.
 *      Author: keroro
 */


#include "ACTION_Module.hpp"

void send2Message(int message)
{
	write(uart_fd, &message, 1);
}

int receiveMessage()
{
	int buf;

	while(1)
	{
		if((buf = read(uart_fd, &buf, 1)) > 0)
			break;
	}

	return buf;
}

int send_n_ReceiveMessage(int message)
{
	send2Message(message);
	int buf = receiveMessage();

	return buf;
}


