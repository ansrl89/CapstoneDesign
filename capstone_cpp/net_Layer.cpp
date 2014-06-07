/*
 * net_Layer.cpp
 *
 *  Created on: 2014. 4. 15.
 *      Author: keroro
 */

#include "net_Layer.hpp"

//int peerTcpSocket = -1;

void error_handling(char *message)
{
	fputs(message, stderr);
	fputc('\n', stderr);
	exit(1);
}

void *net_Layer(void*)
{
	int tcpServ_sock;	// 서버 역할

	struct sockaddr_in tcpServer_addr;
	struct sockaddr_in tcpClient_addr;

	int clnt_addr_size;
	int clnt_len;

	fd_set reads, temps;
	int fd_max;

	char *tcpport = "8090";

	// data variable
//	int number;
//	int *command = &number;
	char command[1024];

	// peer management variable
	int socketList[MAX_NUMBER_OF_PEER]	= {-1, -1, -1, -1, -1};
	int peerType[MAX_NUMBER_OF_PEER]	= {-1, -1, -1, -1, -1};

	for(int i=0; i <MAX_NUMBER_OF_PEER; i++)
	{
		socketList[i] = peerType[i] = -1;
	}

	// NEED TO CREATE A SOCKET FOR TCP SERVER
	tcpServ_sock = socket(PF_INET, SOCK_STREAM, 0);	// 서버 소켓 오픈
	memset(&tcpServer_addr, 0, sizeof(tcpServer_addr));	// 체크
	tcpServer_addr.sin_family = AF_INET;
	tcpServer_addr.sin_addr.s_addr = htonl(INADDR_ANY);	//inet_addr("127.0.0.1");
	tcpServer_addr.sin_port = htons(atoi(tcpport));

	// NEED TO bind
	if (bind(tcpServ_sock, (struct sockaddr*) &tcpServer_addr,	sizeof(tcpServer_addr)))
		error_handling("bind() error");
	// NEED TO listen
	if (listen(tcpServ_sock, 5) == -1)
		error_handling("listen() error");

	cout << "bind & listen success!" << endl;
	// initialize the select mask variables and set the
	// mask with stdin and the tcp server socket

	FD_ZERO(&reads);
	// file descripter set
//	FD_SET(fileno(stdin), &reads);
	FD_SET(tcpServ_sock, &reads);
	fd_max = tcpServ_sock;

	while(1)
		{
			memset(command, 0x0, sizeof(command));
			temps = reads;	// 감시변수를 임시 변수에 복사한다음에

			if(select(fd_max+1, &temps, 0, 0, NULL) == -1)
				error_handling("select() error");

			if(FD_ISSET(tcpServ_sock, &temps))	// 내가 서버. 여기에 연결 요청이 온다.
			{
				int i;
				int ip_addr[4];
				//connect request from a peer
				// accept 함수.
				clnt_addr_size = sizeof(tcpClient_addr);
				int idx = -1;

				for(int k=0; k<MAX_NUMBER_OF_PEER; k++)
				{
					if(socketList[k] < 0)
					{
						idx = k;
						break;
					}
					if(k == MAX_NUMBER_OF_PEER-1)
					{
						printf("peer failed\n");
					}
				}

//				peerTcpSocket = accept(tcpServ_sock, (struct sockaddr*) &tcpClient_addr, (socklen_t*)&clnt_addr_size);
				socketList[idx] = accept(tcpServ_sock, (struct sockaddr*) &tcpClient_addr, (socklen_t*)&clnt_addr_size);

				if(socketList[idx] == -1)
					error_handling("accept() error");

				FD_SET(socketList[idx], &reads);
				if(fd_max < socketList[idx])
					fd_max = socketList[idx];

				for(i=0; i<4; i++)
					ip_addr[i] = (int)(*(((unsigned char*)&tcpClient_addr.sin_addr.s_addr) + i));	// ip 주소 추출

				printf("connection from host %d.%d.%d.%d, port %d, socket %d\n", ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3], tcpClient_addr.sin_port, socketList[idx]);
			}
			//else if(FD_ISSET(peerTcpSocket, &temps))	// 채팅 상대방에게서 메시지가 도착했다.
			else
			{
				for(int k=0; k<MAX_NUMBER_OF_PEER; k++)
				{
					if(FD_ISSET(socketList[k], &temps))
					{
						FD_CLR(socketList[k], &temps);

						if(peerType[k] == UNDEFINED)
						{
							clnt_len = read(socketList[k], command, 1024);	// command 에는 문자열, clnt_len 에는 문자열 길이

							if(strcmp(command, "imkoh\n") == 0)
							{
								peerType[k] = DESKTOP;
								peer_Desktop = socketList[k];
							}
							else if(strcmp(command, "imchai\n") == 0)
								peerType[k] = ANDROID;
							else if(strcmp(command, "stream\n") == 0)
							{
								peerType[k] = STREAM;

								stream_Android = socketList[k];

							}
							else if(clnt_len == 0){ // 연결 종료 요청인 경우
								FD_CLR(socketList[k], &reads);
								close(socketList[k]);
								printf("peer's Connection Closed %d\n", socketList[k]);
								printf("The peerType was ");
								if(peerType[k] == DESKTOP)
									printf(" DESKTOP!\n");
								else if(peerType[k] == ANDROID)
									printf(" ANDROID!\n");
								else
									printf(" UNDEFINED!\n");

								socketList[k] = peerType[k] = -1;
							}
							//else
								//printf("peerType error!\n");
						}

						else if(peerType[k] == DESKTOP)
						{
							clnt_len = read(socketList[k], command, 1024);	// command 에는 문자열, clnt_len 에는 문자열 길이

							if(clnt_len == 0){ // 연결 종료 요청인 경우
								FD_CLR(socketList[k], &reads);
								close(socketList[k]);
								printf("peer's Connection Closed %d\n", socketList[k]);
								printf("The peerType was ");
								if(peerType[k] == DESKTOP)
									printf(" DESKTOP!\n");
								else if(peerType[k] == ANDROID)
									printf(" ANDROID!\n");
								else
									printf(" UNDEFINED!\n");

								socketList[k] = peerType[k] = -1;
								peer_Desktop = -1;
							}

						}

						else if(peerType[k] == ANDROID)
						{
							// message from a peer
							command[0] = command[1] = command[2] = 0;
							clnt_len = read(socketList[k], command, 1024);	// command 에는 문자열, clnt_len 에는 문자열 길이

							if(clnt_len == 0){ // 연결 종료 요청인 경우
								FD_CLR(socketList[k], &reads);
								close(socketList[k]);
								printf("peer's Connection Closed %d\n", socketList[k]);
								printf("The peerType was ");
								if(peerType[k] == DESKTOP)
									printf(" DESKTOP!\n");
								else if(peerType[k] == ANDROID)
									printf(" ANDROID!\n");
								else
									printf(" UNDEFINED!\n");

								socketList[k] = peerType[k] = -1;
							}
							else	// 여기에 명령 처리 코드
							{

								write(fileno(stdout), command, clnt_len);
								printf("\n");

								if(command[0] == 'm')
								{
									if(command[1] == '3')
									{
										lineStopFlag = 1;
									}
									else
									{
										printf("mission : %d\n", (command[1]-48));
										missionVariable = command[1] - 48;
									}
								}
								else
								{
									int com = 0;
									for(int i=0; i<3; i++)
									{
										if(command[i] > 0)
											com = com * 10 + (command[i] - 48);
									}

									send2Message(com);
								}
							}

						}

						else if(peerType[k] == STREAM)
						{
							clnt_len = read(socketList[k], command, 1024);

							if(clnt_len == 0){ // 연결 종료 요청인 경우
								stream_Android = -1;

								FD_CLR(socketList[k], &reads);
								close(socketList[k]);
								printf("peer's Connection Closed %d\n", socketList[k]);
								printf("The peerType was ");
								if(peerType[k] == DESKTOP)
									printf(" DESKTOP!\n");
								else if(peerType[k] == ANDROID)
									printf(" ANDROID!\n");
								else if(peerType[k] == STREAM)
									printf(" STREAM App!\n");
								else
									printf(" UNDEFINED!\n");

								socketList[k] = peerType[k] = -1;

							}
						}
					}
				}



			}
		}//while End
}
