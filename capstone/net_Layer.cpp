/*
 * net_Layer.cpp
 *
 *  Created on: 2014. 4. 15.
 *      Author: keroro
 */

#include "net_Layer.hpp"

int peerTcpSocket = -1;

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
				peerTcpSocket = accept(tcpServ_sock, (struct sockaddr*) &tcpClient_addr, (socklen_t*)&clnt_addr_size);

				if(peerTcpSocket == -1)
					error_handling("accept() error");

				FD_SET(peerTcpSocket, &reads);
				if(fd_max < peerTcpSocket)
					fd_max = peerTcpSocket;

				for(i=0; i<4; i++)
					ip_addr[i] = (int)(*(((unsigned char*)&tcpClient_addr.sin_addr.s_addr) + i));	// ip 주소 추출

				printf("connection from host %d.%d.%d.%d, port %d, socket %d\n", ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3], tcpClient_addr.sin_port, peerTcpSocket);
			}
			else if(FD_ISSET(peerTcpSocket, &temps))	// 채팅 상대방에게서 메시지가 도착했다.
			{
				FD_CLR(peerTcpSocket, &temps);
				// message from a peer
				command[0] = command[1] = command[2] = 0;
				clnt_len = read(peerTcpSocket, command, 1024);	// command 에는 문자열, clnt_len 에는 문자열 길이

				if(clnt_len == 0){ // 연결 종료 요청인 경우
					FD_CLR(peerTcpSocket, &reads);
					close(peerTcpSocket);
					printf("peer's Connection Closed %d\n", peerTcpSocket);
					peerTcpSocket = -1;
				}
				else	// 여기에 명령 처리 코드
				{

					write(fileno(stdout), command, clnt_len);
					printf("\n");
					int com = 0;
					for(int i=0; i<3; i++)
					{
						if(command[i] > 0)
							com = com * 10 + (command[i] - 48);
					}

					send2Message(com);

				}
			}
		}//while End
}
