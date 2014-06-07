'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM TEMP AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 넘어진확인 AS BYTE	
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE
'***********************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER


'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3
CONST 하한전압 = 154  '약6V전압

CONST 머리이동속도 = 10
'************************************************



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************

GOSUB 자이로INIT
TEMPO 230
'MUSIC "cdefg"

SPEED 5
GOSUB MOTOR_ON


GOSUB 전원초기자세
GOSUB 기본자세
GOSUB 자이로ON
GOSUB All_motor_mode3

'PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '안녕하세요

GOTO BEFORE_MAIN	'시리얼 수신 루틴으로 가기
'GOTO main

'************************************************


'************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
SOUND_국민체조곡: '
    PRINT "SOUND 47!"
    RETURN
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    '    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************
    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 0, 0,1
    GYRODIR G6D, 1, 0, 0, 0,0
    GYRODIR G6B, 1, 0, 0, 0,0
    GYRODIR G6C, 1, 0, 0, 0,0


    GYROSENSE G6A,250,200,200,200,0
    GYROSENSE G6D,250,200,200,200,0


    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,180,180,0
    GYROSENSE G6D,250,180,180,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,150,150,0
    GYROSENSE G6D,200,150,150,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,100,100,0
    GYROSENSE G6D,200,100,100,100,0
    RETURN
    '***********************************************
자이로ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0
    GYROSET G6B, 3, 0, 0, 0, 0
    GYROSET G6C, 3, 0, 0, 0, 0

    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0
    GYROSET G6B, 0, 0, 0, 0, 0
    GYROSET G6C, 0, 0, 0, 0, 0

    자이로ONOFF = 0
    RETURN

    '************************************************
전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  40,  90, 100, 100, 100
    MOVE G6C,100,  40,  90, 100, 80, 100
    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80,100,100
    MOVE G6C,100,  30,  80,100,100
    WAIT
    mode = 0

    RETURN
    '******************************************	
고개정지안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    WAIT
    mode = 0

    RETURN
    '******************************************	
고개정지기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    '************************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 80, 100
    WAIT
    mode = 0
    'ETX 4800,33
    RETURN
    '******************************************	
기본자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 0
    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 30, 90, 100, 100, 100
    MOVE G6C,100, 30, 90, 100, 80, 100
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    '    ETX 4800,34
    RETURN
    '******************************************


    RETURN

    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, RX_EXIT_2

    GOTO RX_EXIT
RX_EXIT_2:

    ETX 4800, 1
    GOTO MAIN

    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************

One_Step:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100,40
        MOVE G6C,100,40
        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO One_Step_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100,40
        MOVE G6B, 100,40
        WAIT

        SPEED 10

        GOTO One_Step_2	

    ENDIF


    '*******************************


One_Step_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 146, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    MOVE G6A,112,  76, 146,  93, 96,100
    MOVE G6D,90, 100, 100, 115, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT
    HIGHSPEED SETOFF

    SPEED 8
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B, 100,40
    MOVE G6C, 100,40
    WAIT	

    SPEED 2
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********

One_Step_2:

    MOVE G6A,110,  76, 146,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 146,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT
    HIGHSPEED SETOFF
    SPEED 8

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6C, 100,40
    MOVE G6B, 100,40
    WAIT	
    SPEED 2
    GOSUB 기본자세2

    GOTO RX_EXIT

    '*******************************
    '**********************************************

연속전진:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100,40
        MOVE G6C,100,40
        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO 연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100,40
        MOVE G6B, 100,40
        WAIT

        SPEED 10

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 146,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속전진_2	

    ENDIF


    '*******************************


연속전진_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 146, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_2
    '    IF A = 11 THEN
    IF A = A_old THEN
        GOTO 연속전진_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B, 100,40
        MOVE G6C, 100,40
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********

연속전진_2:

    MOVE G6A,110,  76, 146,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

연속전진_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 146,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_4
    '    IF A = 11 THEN
    IF A = A_old THEN
        GOTO 연속전진_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100,40
        MOVE G6B, 100,40
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 연속전진_1
    '*******************************
basic_form_see_up:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    mode = 0
    'ETX 4800,33
    RETURN
    '***********
UP_STAIR_RIGHT_FOOT:
    GOSUB All_motor_mode3
    '	GOSUB Leg_motor_mode1

    GOSUB 자이로off

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6B,100,40,80
    MOVE G6C,100,40,80
    WAIT

    DELAY 100

    MOVE G6D, 88,  80, 132,  100, 110
    MOVE G6A,110,  76, 146,  93,  94
    WAIT

    DELAY 100


    MOVE G6D, 88,  90, 98,  120, 110
    MOVE G6A,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  90, 98,  150, 110
    MOVE G6A,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  50, 122,  145, 110
    MOVE G6A,114,  83, 140,  80,  94
    WAIT

    DELAY 100

    MOVE G6D, 95, 40, 135,  140, 107
    MOVE G6A,105,  100, 140,  75,  93
    WAIT

    DELAY 100

    MOVE G6D, 95, 40, 135,  150, 107
    MOVE G6A,105,  100, 140,  85,  93
    WAIT

    DELAY 100

    MOVE G6D, 100, 60, 120,  150, 100
    MOVE G6A,100,  95, 150,  80,  100
    WAIT



    MOVE G6D, 105,70, 107,  150, 90
    MOVE G6A,95,  100, 150,  80,  107
    MOVE G6C,100,70,80
    WAIT



    MOVE G6D, 110,90, 97,  150, 100
    MOVE G6A,80,  90, 170,  70,  103
    WAIT



    MOVE G6D, 113,97, 94,  140, 100
    MOVE G6A,80,  90, 160,  67,  105
    WAIT

    DELAY 500

    MOVE G6D, 113,97, 104,  125, 100
    MOVE G6A,80,  90, 160,  67,  105
    WAIT

    DELAY 100

    MOVE G6D, 113,97, 114,  110, 100
    MOVE G6A,80,  90, 160,  67,  105
    WAIT

    DELAY 100

    MOVE G6D, 113,97, 114,  110, 100
    MOVE G6A,80,  90, 140,  90,  105
    WAIT

    DELAY 100

    MOVE G6D, 113,97, 114,  110, 100
    MOVE G6A,80,  90, 120,  110,  105
    WAIT

    DELAY 100

    MOVE G6D, 105,97, 114,  110, 100
    MOVE G6A,90,  90, 120,  110,  105
    WAIT

    DELAY 100

    GOSUB 기본자세
    SPEED 8

    GOSUB 자이로on
    RETURN
    '*********
UP_STAIR_LEFT_FOOT:
    GOSUB All_motor_mode3
    '	GOSUB Leg_motor_mode1

    GOSUB 자이로off

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6C,100,40,80
    MOVE G6B,100,40,80
    WAIT

    DELAY 100

    MOVE G6A, 88,  80, 132,  100, 110
    MOVE G6D,110,  76, 146,  93,  94
    WAIT

    DELAY 100


    MOVE G6A, 88,  90, 98,  120, 110
    MOVE G6D,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  90, 98,  150, 110
    MOVE G6D,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  50, 122,  145, 110
    MOVE G6D,114,  83, 140,  80,  94
    WAIT

    DELAY 100

    MOVE G6A, 95, 40, 135,  140, 107
    MOVE G6D,105,  100, 140,  75,  93
    WAIT

    DELAY 100

    MOVE G6A, 95, 40, 135,  150, 107
    MOVE G6D,105,  100, 140,  85,  93
    WAIT

    DELAY 100

    MOVE G6A, 100, 60, 120,  150, 100
    MOVE G6D,100,  95, 150,  80,  100
    WAIT



    MOVE G6A, 105,70, 107,  150, 90
    MOVE G6D,95,  100, 150,  80,  107
    MOVE G6B,100,70,80
    WAIT



    MOVE G6A, 110,90, 97,  150, 100
    MOVE G6D,80,  90, 170,  70,  103
    WAIT



    MOVE G6A, 113,97, 94,  140, 100
    MOVE G6D,80,  90, 160,  67,  105
    WAIT

    DELAY 500

    MOVE G6A, 113,97, 104,  125, 100
    MOVE G6D,80,  90, 160,  67,  105
    WAIT

    DELAY 100

    MOVE G6A, 113,97, 114,  110, 100
    MOVE G6D,80,  90, 160,  67,  105
    WAIT

    DELAY 100

    MOVE G6A, 113,97, 114,  110, 100
    MOVE G6D,80,  90, 140,  90,  105
    WAIT

    DELAY 100

    MOVE G6A, 113,97, 114,  110, 100
    MOVE G6D,80,  90, 120,  110,  105
    WAIT

    DELAY 100

    MOVE G6A, 105,97, 114,  110, 100
    MOVE G6D,90,  90, 120,  110,  105
    WAIT

    DELAY 100

    GOSUB 기본자세
    SPEED 8

    GOSUB 자이로on
    RETURN

    '*********

DOWN_STAIR_RIGHT_FOOT:
    GOSUB All_motor_mode3
    '	GOSUB Leg_motor_mode1

    GOSUB 자이로off

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6C,100,40,80
    MOVE G6B,100,40,80
    WAIT

    DELAY 100

    MOVE G6D, 88,  80, 132,  100, 110
    MOVE G6A,110,  76, 146,  93,  94
    WAIT

    DELAY 100


    MOVE G6D, 88,  90, 98,  120, 114
    MOVE G6A,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  90, 110,  140, 114
    MOVE G6A,114,  80, 136,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  60, 120,  140, 114
    MOVE G6A,114,  90, 126,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  50, 130,  130, 114
    MOVE G6A,114,  100, 110,  93,  94
    WAIT

    DELAY 100


    MOVE G6D, 88,  40, 145,  130, 114
    MOVE G6A,114,  110, 100,  93,  94
    WAIT

    DELAY 100

    MOVE G6D, 88,  40, 145,  130, 114
    MOVE G6A,114,  125, 90,  83,  94
    WAIT

    DELAY 100



    MOVE G6D, 88,  30, 145,  130, 114
    MOVE G6A,114,  135, 80,  83,  94
    WAIT

    DELAY 100


    MOVE G6D, 84,  35, 145,  130, 114
    MOVE G6A,114,  140, 80,  83,  94
    WAIT

    DELAY 100


    '''''''''''''''''''''''''''''''
    MOVE G6D, 88,  35, 145,  130, 110
    MOVE G6A,110,  140, 80,  83,  96
    WAIT

    DELAY 100

    MOVE G6D, 94,  35, 145,  130, 105
    MOVE G6A,106,  142, 80,  83,  98
    WAIT

    DELAY 100

    MOVE G6D,100,  33, 145,  130, 100
    MOVE G6A,100,  145, 80,  83,  100
    WAIT

    DELAY 400
    
    
'''''''''''''''''''''
	MOVE G6D,100,  36, 135,  130, 100
    MOVE G6A,100,  140, 90,  73,  100
    MOVE G6C,100,40,80
    MOVE G6B,170,40,80
    WAIT
    
	DELAY 100
	
	MOVE G6D,100,  53, 130,  120, 100
    MOVE G6A,100,  132, 110,  63,  100
    WAIT

	DELAY 100
	
	MOVE G6D,100,  63, 125,  110, 100
    MOVE G6A,100,  128, 115,  58,  100
    WAIT
    
    DELAY 100
	
	MOVE G6D,110,  93, 105,  110, 96
    MOVE G6A,100,  128, 115,  58,  110
    WAIT
	

	DELAY 100
	
	MOVE G6D,114,  105, 105,  110, 96
    MOVE G6A,100,  128, 85,  58,  110
    WAIT
    
    DELAY 100
    
    MOVE G6D,114,  105, 105,  110, 96
    MOVE G6A,100,  128, 85,  108,  110
    MOVE G6C,100,40,80
    MOVE G6B,100,40,80
    WAIT
    
    
    DELAY 100

    MOVE G6D,114,  105, 105,  100, 96
    MOVE G6A,100,  108, 95,  100,  110
    MOVE G6C,100,40,80
    MOVE G6B,100,40,80
    WAIT

	DELAY 100


    MOVE G6D,104,  105, 105,  100, 96
    MOVE G6A,100,  108, 95,  110,  110
    MOVE G6C,100,40,80
    MOVE G6B,100,40,80
    WAIT

	DELAY 100

    GOSUB 기본자세
    SPEED 8

	DELAY 500
	
    GOSUB 자이로on
    RETURN

    '*********

DOWN_STAIR_LEFT_FOOT:
    GOSUB All_motor_mode3
    '	GOSUB Leg_motor_mode1

    GOSUB 자이로off

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40,80
    MOVE G6C,100,40,80
    WAIT

    DELAY 100

    MOVE G6A, 88,  80, 132,  100, 110
    MOVE G6D,110,  76, 146,  93,  94
    WAIT

    DELAY 100


    MOVE G6A, 88,  90, 98,  120, 114
    MOVE G6D,114,  73, 146,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  90, 110,  140, 114
    MOVE G6D,114,  80, 136,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  60, 120,  140, 114
    MOVE G6D,114,  90, 126,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  50, 130,  130, 114
    MOVE G6D,114,  100, 110,  93,  94
    WAIT

    DELAY 100


    MOVE G6A, 88,  40, 145,  130, 114
    MOVE G6D,114,  110, 100,  93,  94
    WAIT

    DELAY 100

    MOVE G6A, 88,  40, 145,  130, 114
    MOVE G6D,114,  125, 90,  83,  94
    WAIT

    DELAY 100



    MOVE G6A, 88,  30, 145,  130, 114
    MOVE G6D,114,  135, 80,  83,  94
    WAIT

    DELAY 100


    MOVE G6A, 84,  35, 145,  130, 114
    MOVE G6D,114,  140, 80,  83,  94
    WAIT

    DELAY 100


    '''''''''''''''''''''''''''''''
    MOVE G6A, 88,  35, 145,  130, 110
    MOVE G6D,110,  140, 80,  83,  96
    WAIT

    DELAY 100

    MOVE G6A, 94,  35, 145,  130, 105
    MOVE G6D,106,  142, 80,  83,  98
    WAIT

    DELAY 100

    MOVE G6A,100,  33, 145,  130, 100
    MOVE G6D,100,  145, 80,  83,  100
    WAIT

    DELAY 400
    
    
'''''''''''''''''''''
	MOVE G6A,100,  36, 135,  130, 100
    MOVE G6D,100,  140, 90,  73,  100
    MOVE G6B,100,40,80
    MOVE G6C,170,40,80
    WAIT
    
	DELAY 100
	
	MOVE G6A,100,  53, 130,  120, 100
    MOVE G6D,100,  132, 110,  63,  100
    WAIT

	DELAY 100
	
	MOVE G6A,100,  63, 125,  110, 100
    MOVE G6D,100,  128, 115,  58,  100
    WAIT
    
    DELAY 100
	
	MOVE G6A,110,  93, 105,  110, 96
    MOVE G6D,100,  128, 115,  58,  110
    WAIT
	

	DELAY 100
	
	MOVE G6A,114,  105, 105,  110, 96
    MOVE G6D,100,  128, 85,  58,  110
    WAIT
    
    DELAY 100
    
    MOVE G6A,114,  105, 105,  110, 96
    MOVE G6D,100,  128, 85,  108,  110
    MOVE G6B,100,40,80
    MOVE G6C,100,40,80
    WAIT
    
    
    DELAY 100

    MOVE G6A,114,  105, 105,  100, 96
    MOVE G6D,100,  108, 95,  100,  110
    MOVE G6B,100,40,80
    MOVE G6C,100,40,80
    WAIT

	DELAY 100


    MOVE G6A,104,  105, 105,  100, 96
    MOVE G6D,100,  108, 95,  110,  110
    MOVE G6B,100,40,80
    MOVE G6C,100,40,80
    WAIT

	DELAY 100

    GOSUB 기본자세
    SPEED 8

	DELAY 500
	
    GOSUB 자이로on
    RETURN

    '*********
계단오르기:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40,60
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 40, 115, 160, 114,
    MOVE G6D,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 70, 100, 160, 100,
    MOVE G6D,80,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 113, 90, 80, 160,95,
    MOVE G6D,70,  95, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,75,  90, 165,  70, 105
    WAIT

    SPEED 10
    MOVE G6A, 114, 80, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 8
    MOVE G6A, 114, 85, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT


    SPEED 6
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB 기본자세

    RETURN

    '*******************************

계단내려가기:
    GOSUB All_motor_mode3

    SPEED 머리이동속도
    SERVO 11,100
    SERVO 16,70

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 110
    MOVE G6A,115,  155, 35,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,105,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,110, 25, 170, 150, 94
    MOVE G6A,80,  130, 130,  85,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,111, 55, 130, 150, 94
    MOVE G6A,80,  120, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6D,110, 75, 120, 130, 94
    MOVE G6A,80,  85, 90,  150,114
    MOVE G6C,150,50
    MOVE G6B,130,40
    WAIT

    SPEED 8
    MOVE G6D,108, 75, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN

    '************************************************
연속후진:
    넘어진확인 = 0
    보행속도 = 12
    좌우속도 = 4
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100,40
        MOVE G6C,100,40
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100,40
        MOVE G6B, 100,40
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,110,  76, 145,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속후진_2

    ENDIF


연속후진_1:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_2
    IF A <> A_old THEN
연속후진_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF
    '**********

연속후진_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_1
    IF A <> A_old THEN
연속후진_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF  	

    GOTO 연속후진_1
    '**********************************************
'******************************************
GO_SHORT_STEP:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 146,  93, 101
        MOVE G6D,101,  76, 146,  93, 98
        MOVE G6B,100,  30
        MOVE G6C,100,  30
        WAIT

        GOTO GO_SHORT_STEP_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  76, 146,  93, 98
        MOVE G6B,100,  30
        MOVE G6C,100,  30
        WAIT

        GOTO GO_SHORT_STEP_4
    ENDIF


    '**********************

GO_SHORT_STEP_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  76, 146,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


GO_SHORT_STEP_2:

    MOVE G6A,103,   71, 140, 103,  100
    MOVE G6D, 95,  83, 145,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

'    ERX 4800,A, GO_SHORT_STEP_4
'    IF A <> A_old THEN
GO_SHORT_STEP_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
'        SPEED 15
'        GOSUB 안정화자세l
        SPEED 15
        GOSUB 기본자세2
		SPEED 5

        'DELAY 400
        GOTO RX_EXIT
'    ENDIF

    '*********************************

GO_SHORT_STEP_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


GO_SHORT_STEP_5:
    MOVE G6D,103,    71, 140, 103,  100
    MOVE G6A, 95,  83, 145,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

'    ERX 4800,A, GO_SHORT_STEP_1
'    IF A <> A_old THEN
GO_SHORT_STEP_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
'        SPEED 15
'        GOSUB 안정화자세
        SPEED 15
        GOSUB 기본자세2
		SPEED 5

        'DELAY 400
        GOTO RX_EXIT
'    ENDIF

    '*************************************

    '*********************************

    GOTO GO_SHORT_STEP_1

    '******************************************

    '******************************************
전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 146,  93, 101
        MOVE G6D,101,  76, 146,  93, 98
        MOVE G6B,100,  30
        MOVE G6C,100,  30
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  76, 146,  93, 98
        MOVE G6B,100,  30
        MOVE G6C,100,  30
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  76, 146,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


전진종종걸음_2:

    MOVE G6A,103,   71, 140, 103,  100
    MOVE G6D, 95,  83, 145,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 전진종종걸음_4
    IF A <> A_old THEN
전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
'        SPEED 15
'        GOSUB 안정화자세l
        SPEED 15
        GOSUB 기본자세2
		SPEED 5

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음_5:
    MOVE G6D,103,    71, 140, 103,  100
    MOVE G6A, 95,  83, 145,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN
전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
'        SPEED 15
'        GOSUB 안정화자세
        SPEED 15
        GOSUB 기본자세2
		SPEED 5

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO 전진종종걸음_1

    '******************************************
    '******************************************
    '******************************************
후진종종걸음:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 후진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 후진종종걸음_4
    ENDIF


    '**********************

후진종종걸음_1:
    MOVE G6D,104,  76, 146,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



후진종종걸음_3:
    MOVE G6A, 103,  77, 146,  89, 100
    MOVE G6D,95,   63, 146, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_3_stop
    ERX 4800,A, 후진종종걸음_4
    IF A <> A_old THEN
후진종종걸음_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

후진종종걸음_4:
    MOVE G6A,104,  76, 146,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


후진종종걸음_6:
    MOVE G6D, 103,  77, 146,  89, 100
    MOVE G6A,95,   63, 146, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_6_stop

    ERX 4800,A, 후진종종걸음_1
    IF A <> A_old THEN  'GOTO 후진종종걸음_멈춤
후진종종걸음_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 후진종종걸음_1




    '******************************************


    '******************************************
    '******************************************

    '******************************************
전진달리기50:
    넘어진확인 = 0
    GOSUB All_motor_mode3
    보행COUNT = 0
    DELAY 50
    SPEED 12
    '	SPEED 6
    HIGHSPEED SETON



    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO 전진달리기50_2
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 120, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO 전진달리기50_5
    ENDIF


    '**********************

전진달리기50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진달리기50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 146,  88,  100
    WAIT

전진달리기50_3:
    MOVE G6A,103,  68, 145, 103,  100
    MOVE G6D, 95, 86, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    '보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_3_stop

    ERX 4800,A, 전진달리기50_4
    IF A <> A_old THEN
전진달리기50_3_stop:

        MOVE G6D,90,  93, 115, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        '        GOSUB 안정화자세
        GOSUB 기본자세2
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

전진달리기50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진달리기50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  78, 146,  88,  100
    WAIT


전진달리기50_6:
    MOVE G6D,103,  68, 145, 103,  100
    MOVE G6A, 95, 86, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_6_stop
    ERX 4800,A, 전진달리기50_1
    IF A <> A_old THEN
전진달리기50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        '        GOSUB 안정화자세
        GOSUB 기본자세2
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    GOTO 전진달리기50_1



    '******************************************
    '************************************************
오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************

왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************
    '******************************************
오른쪽옆으로70연속:


오른쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    '  ERX 4800, A ,오른쪽옆으로70연속_loop
    '    IF A = A_OLD THEN  GOTO 오른쪽옆으로70연속_loop
    '오른쪽옆으로70연속_stop:
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로70연속:

왼쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,왼쪽옆으로70연속_loop	
    '    IF A = A_OLD THEN  GOTO 왼쪽옆으로70연속_loop
    '왼쪽옆으로70연속_stop:

    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
    '************************************************
    '*********************************************

왼쪽턴3:

왼쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB 기본자세2


    GOTO RX_EXIT

    '**********************************************
오른쪽턴3:


오른쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB 기본자세2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴10:

    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴10:

    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽턴20:

    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
오른쪽턴20:

    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************	


    '**********************************************
왼쪽턴45:

왼쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    'DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,왼쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴45_LOOP
    '
    GOTO RX_EXIT

    '**********************************************
오른쪽턴45:

오른쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,오른쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴45_LOOP
    '
    GOTO RX_EXIT
    '**********************************************
왼쪽턴60:

왼쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2
    '  DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,왼쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴60_LOOP

    GOTO RX_EXIT

    '**********************************************
오른쪽턴60:

오른쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,오른쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴60_LOOP

    GOTO RX_EXIT
    '****************************************
    '************************************************
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 150, 170,  40, 140
    MOVE G6D,100, 150, 170,  40, 140
    MOVE G6B, 150, 150,  45, , ,100
    MOVE G6C, 150, 150,  45, ,120
    WAIT

    MOVE G6B, 190
    MOVE G6C, 190
    WAIT

    SPEED 15
    MOVE G6A,  90, 155,  110, 120, 150
    MOVE G6D,  90, 155,  110, 120, 150
    MOVE G6B, 190, 10,  15
    MOVE G6C, 190, 10,  15
    WAIT

    SPEED 10	
    MOVE G6A,  55, 165,  25, 162, 150
    MOVE G6D,  55, 165,  25, 162, 150
    MOVE G6B,  165, 10, 90
    MOVE G6C,  165, 10, 90
    WAIT

    DELAY 50


    SPEED 10	
    MOVE G6A,  70, 145,  25, 145, 130
    MOVE G6D,  70, 145,  25, 145, 130
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT


    SPEED 8
    MOVE G6A,  100, 145,  25, 145, 100
    MOVE G6D,  100, 145,  25, 145, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    SPEED 6
    MOVE G6A,100, 140,  40, 140, 100, 100
    MOVE G6D,100, 140,  40, 140, 100, 100
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOSUB All_motor_mode3


    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset


    SPEED 15

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,40,  140,  15, , ,100
    MOVE G6C,40,  140,  15, , 60
    WAIT

    MOVE G6A,100,  76, 65,  93, 100, 100
    MOVE G6D,100,  76, 65,  93, 100, 100
    MOVE G6B,10,  50,  15
    MOVE G6C,10,  50,  15
    WAIT


    SPEED 10
    MOVE G6A,80, 160,  55, 40, 140,
    MOVE G6D,80, 160,  55, 40, 140,
    MOVE G6B,10,  10,  95
    MOVE G6C,10,  10,  95
    WAIT

    SPEED 10
    MOVE G6A,70, 165,  70, 30, 140,
    MOVE G6D,70, 165,  70, 30, 140,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 10
    MOVE G6A,65, 165,  45, 70, 140,
    MOVE G6D,65, 165,  45, 70, 140,
    MOVE G6B,30,  30,  95
    MOVE G6C,30,  30,  95
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,70, 145,  35, 130, 130,
    MOVE G6D,70, 145,  35, 130, 130,
    MOVE G6B,100,  40,  95
    MOVE G6C,100,  40,  95
    WAIT

    SPEED 6
    MOVE G6A,100, 140,  37, 140, 90
    MOVE G6D,100, 140,  37, 140, 90
    WAIT
    WAIT


    SPEED 8
    GOSUB 기본자세
    넘어진확인 = 1
    GOSUB All_motor_mode3
    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '******************************************

    '**********************************************

머리하왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    SERVO 16,60
    RETURN
머리중왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    SERVO 16,70
    RETURN
머리상왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    SERVO 16,90
    RETURN

머리하왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,50
    SERVO 16,60
    RETURN
머리중왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,50
    SERVO 16,70
    RETURN
머리상왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,50
    SERVO 16,90
    RETURN

머리하오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,120
    SERVO 16,60
    RETURN
머리중오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,120
    SERVO 16,70
    RETURN
머리상오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,120
    SERVO 16,90
    RETURN

머리하오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    SERVO 16,60
    RETURN
머리중오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    SERVO 16,70
    RETURN
머리상오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    SERVO 16,90
    RETURN

머리하중앙:
    SPEED 머리이동속도
    SERVO 11,100
    SERVO 16,60
    RETURN
머리중중앙:
    SPEED 머리이동속도
    SERVO 11,100
    SERVO 16,70
    RETURN
머리상중앙:
    SPEED 머리이동속도
    SERVO 11,100
    SERVO 16,90
    RETURN

머리상하정면:
    SPEED 머리이동속도
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    RETURN

    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 80
    ETX 4800,35
    RETURN
    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
    RETURN

    '******************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '**************************************************
오른발공차기:

    GOSUB 자이로off

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    DELAY 200

    SPEED 10
    MOVE G6A,113,  75, 145,  100,  95	
    MOVE G6D, 83,  85, 122,  105, 114
    WAIT


    DELAY 500

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 10
    MOVE G6A,113,  73, 145,  85,  95	
    MOVE G6D, 83,  20, 162,  155, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT

    HIGHSPEED SETOFF

    DELAY 500


    SPEED 8
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT	

    DELAY 200

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400


    GOSUB 자이로on

    RETURN
    '**************************************************
왼발공차기:

    GOSUB 자이로off

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT

    DELAY 200

    SPEED 10
    MOVE G6D,113,  75, 145,  100,  95	
    MOVE G6A, 83,  85, 122,  105, 114
    WAIT


    DELAY 500

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 10
    MOVE G6D,113,  73, 145,  85,  95	
    MOVE G6A, 83,  20, 162,  155, 114
    MOVE G6B,50
    MOVE G6C,150
    WAIT

    HIGHSPEED SETOFF

    DELAY 500


    SPEED 8
    MOVE G6D,113,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    DELAY 200

    SPEED 8
    MOVE G6D,113,  77, 145,  95,  95	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6D,110,  77, 145,  93,  93, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400


    GOSUB 자이로on
    RETURN


    '******************************************
왼발공차기_old:

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6D,113,  75, 145,  100,  95	
    MOVE G6A, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 10
    MOVE G6D,107,  73, 145,  85,  95	
    MOVE G6A, 83,  20, 162,  155, 114
    MOVE G6B,50
    MOVE G6C,150
    WAIT


    DELAY 200
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6D,112,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6D,113,  77, 145,  95,  95	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6D,110,  77, 145,  93,  93, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN

    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************
    '************************************************


인사:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  35,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    '인사
    SPEED 8
    MOVE G6A,100,  55, 145,  145, 100, 100
    MOVE G6D,100,  55, 145,  145, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    DELAY 1000
    '일어나기
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  40,  80
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOSUB All_motor_Reset


    RETURN
    '************************************************
    '******************************************
환호성:
    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  80, 145,  75, 100
    MOVE G6D,100,  80, 145,  75, 100
    MOVE G6B,100,  180,  120
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 2

        MOVE G6B,100,  145,  100
        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6B,100,  180,  130
        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset
    RETURN


    ''************************************************
패배액션2:
    GOSUB Arm_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  185,  170
    WAIT	

    SPEED 4
    FOR i = 1 TO 8
        MOVE G6C,100,  170,  185
        WAIT

        MOVE G6C,100,  185,  170
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_Reset

    RETURN
    ''************************************************
    '**********************************************	
복고댄스:

    DIM w1 AS BYTE
    GOSUB Leg_motor_mode2
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90
    MOVE G6C,100,  70,  90	
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT	



    SPEED 4
    MOVE G6A,94,  94, 145,  45, 106
    MOVE G6D,94,  94, 145,  45, 106
    WAIT	

    HIGHSPEED SETON


    FOR I= 1 TO 3
        SPEED 6
        FOR w1= 0 TO 2

            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 12
        MOVE G6C,100,  100,  190,
        MOVE G6B,100,  75,  100,
        MOVE G6A, 95,  94, 145,  45, 107,
        MOVE G6D, 89,  94, 145,  45, 113,
        WAIT

        SPEED 12
        MOVE G6C,100,  150,  140,
        MOVE G6B,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 200
        SPEED 6
        FOR w1= 0 TO 2


            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 15
        MOVE G6B,100,  100,  190,
        MOVE G6C,100,  75,  100,
        MOVE G6D, 89,  94, 145,  45, 113,
        MOVE G6A, 95,  94, 145,  45, 107,
        WAIT

        SPEED 12
        MOVE G6B,100,  150,  140,
        MOVE G6C,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 100
    NEXT I
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3	
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 98, 100
    MOVE G6D,100,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    SPEED 5
    DELAY 50
    GOSUB 기본자세


    RETURN

    '************************************************

    '******************************************
좌우뒤들기댄스:

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6A,88,  76, 145,  93, 110
    MOVE G6D,88,  76, 145,  93, 110
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT

    DELAY 500
    HIGHSPEED SETON

    SPEED 8	
    MOVE G6B,100,  100,  120
    MOVE G6C,100,  50,  90
    WAIT

    SPEED 15
    MOVE G6B,100,  150,  180
    MOVE G6C,100,  60,  100
    WAIT
    DELAY 400

    HIGHSPEED SETOFF
    GOSUB Arm_motor_mode3
    SPEED 6
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    HIGHSPEED SETON
    GOSUB Arm_motor_mode1
    SPEED 8
    MOVE G6C,100,  150,  100
    MOVE G6B,100,  100,  100
    WAIT
    DELAY 300

    SPEED 15
    MOVE G6C,100,  150,  150
    MOVE G6B,100,  50,  100
    WAIT
    DELAY 300
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode4

    FOR I = 2 TO 5
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETON
    FOR I = 2 TO 4
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETOFF

    DELAY 300
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    GOSUB 기본자세



    '**********************************************
국민체조시작:
    GOSUB SOUND_국민체조곡
    GOSUB 국민체조_1	'시작
    GOSUB 국민체조_2	'다리운동
    GOSUB 국민체조_3	'팔운동
    GOSUB 국민체조_4	'머리운동
    GOSUB 국민체조_5 	'가슴운동
    GOSUB 국민체조_6	'옆꾸리운동
    GOSUB 국민체조_7	'등배운동
    GOSUB 국민체조_8 	'몸통운동

    GOSUB 국민체조_9	'온몸운동
    GOSUB 국민체조_10   '뜀뛰기운동
    GOSUB 국민체조_11   '팔다리운동
    GOSUB 국민체조_12	'숨고르기



    RETURN
    '**********************************************
    '**********************************************

국민체조_1: '시작
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    FOR i = 1 TO 4'7

        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,110,  30,  80
        MOVE G6B,110,  30,  80
        WAIT

        MOVE G6D,100,  85, 125,  105, 100, 100
        MOVE G6A,100,  85, 125,  105, 100, 100
        MOVE G6C,90,  30,  80
        MOVE G6B,90,  30,  80
        WAIT


    NEXT i

    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,110,  30,  80
    MOVE G6B,110,  30,  80
    WAIT

    SPEED 4
    FOR i = 1 TO 4

        MOVE G6C,120,  30,  80
        MOVE G6B,80,  30,  80
        WAIT

        MOVE G6C,80,  30,  80
        MOVE G6B,120,  30,  80
        WAIT

    NEXT i

    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    RETURN
    '**********************************************

국민체조_2: '다리운동
    GOSUB All_motor_mode3

    FOR i = 1 TO 4
        SPEED 7
        MOVE G6D,100,  74, 145,  90, 100, 100
        MOVE G6A,100,  74, 145,  90, 100, 100
        MOVE G6C,180,  30,  80
        MOVE G6B,180,  30,  80
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  185,  100
        MOVE G6B,100,  185,  100
        WAIT
        DELAY 100

        SPEED 9
        MOVE G6A,100, 60, 178, 76, 100, 100
        MOVE G6D,100, 60, 178, 76, 100, 100
        MOVE G6C,100,  100,  100
        MOVE G6B,100,  100,  100
        WAIT

        DELAY 100
        SPEED 7
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80, 100, 100, 100
        MOVE G6C,100,  30,  80, 100, 100, 100
        WAIT
        DELAY 100


    NEXT i


    SPEED 8
    MOVE G6B,130,  30,  80, 100, 100, 100
    MOVE G6C,130,  30,  80, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    FOR i = 1 TO 4
        SPEED 8
        MOVE G6A,100,  110, 70,  143, 100, 100    'MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 70,  143, 100, 100    'MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT

        SPEED 5
        MOVE G6A,100,  122, 50,  150, 100, 100     'MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 50,  150, 100, 100     'MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  110, 70,  143, 100, 100     'MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 70,  143, 100, 100     'MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  15,  60, 100, 100, 100
        MOVE G6C,150,  15,  60, 100, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,100,  122, 50,  150, 100, 100     'MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 50,  150, 100, 100     'MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 10
        MOVE G6A,100,  33, 160,  145, 100, 100     'MOVE G6A,100,  33, 170,  155, 100, 100
        MOVE G6D,100,  33, 160,  145, 100, 100     'MOVE G6D,100,  33, 170,  155, 100, 100
        MOVE G6B,170,  15,  60, 100, 100, 100
        MOVE G6C,170,  15,  60, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145, 88, 100, 100     'MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145, 88, 100, 100     'MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  80, 100, 100, 100
        MOVE G6C,100,  40,  80, 100, 100, 100
        WAIT
        DELAY 100

    NEXT i



    RETURN

    '**********************************************

국민체조_3: '팔운동

    FOR i = 1 TO 3
        SPEED 9
        MOVE G6A,100, 60, 173, 76, 100, 100
        MOVE G6D,100, 60, 173, 76, 100, 100
        MOVE G6C,185,  30,  80
        MOVE G6B,185,  30,  80
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  90
        MOVE G6B,100,  30,  90
        WAIT

        DELAY 100

    NEXT i

    FOR i = 1 TO 3
        SPEED 10
        MOVE G6A,100, 63, 173, 76, 100, 100
        MOVE G6D,100, 63, 173, 76, 100, 100
        MOVE G6C,60,  180,  130
        MOVE G6B,60,  180,  130
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6A,100,  76, 145,  90, 100, 100
        MOVE G6D,100,  76, 145,  90, 100, 100
        MOVE G6C,130,  30,  90
        MOVE G6B,130,  30,  90
        WAIT

        DELAY 100

    NEXT i


    RETURN


    '**********************************************

국민체조_4: '머리운동
    GOSUB All_motor_mode3
    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 9                                      '이부분 자체 추가 
    MOVE G6A,100,  76, 125,  135, 100, 100        'MOVE G6A,94,  68, 125,  155, 105, 100
    MOVE G6D,100,  76, 125,  135, 100, 100       ' MOVE G6D,94,  68, 125,  155, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 120,  120, 100, 100        'MOVE G6A,94,  68, 125,  155, 105, 100
    MOVE G6D,100,  76, 120,  120, 100, 100       ' MOVE G6D,94,  68, 125,  155, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT


    FOR i = 1 TO 1



        SPEED 9
        MOVE G6A,100,  78, 110,  140, 100, 100    'MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,100,  68, 125,  135, 100, 100     'MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 50
        WAIT

        SPEED 7
        MOVE G6A,100,  70, 130,  136, 100, 100     'MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,100,  58, 145,  135, 100, 100     'MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6A,100,  86, 132,  85, 100, 100     'MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,100,  81, 142,  80, 100, 100     'MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************

        SPEED 9
        MOVE G6D,100,  86, 135, 95, 100, 100      'MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,100,  81, 145, 90, 100, 100      'MOVE G6A,84,  81, 155, 100, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 7
        MOVE G6D,100,  70, 130,  126, 100, 100     'MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,100,  58, 145,  125, 100, 100     'MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,100,  78, 110,  145, 100, 100     'MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,100,  68, 125,  140, 100, 100      'MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

    NEXT i


    SPEED 9
    MOVE G6A,100,  78, 110,  145, 100, 100        'MOVE G6A,104,  78, 110,  160, 100, 100
    MOVE G6D,100,  68, 125,  140, 100, 100         'MOVE G6D,84,  68, 125,  155, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 50
    WAIT

    SPEED 7
    MOVE G6A,100,  86, 145,  75, 100, 100         'MOVE G6A,100,  86, 145,  75, 95, 100
    MOVE G6D,100,  81, 155,  70, 100, 100         'MOVE G6D,84,  81, 155,  70, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 6
    MOVE G6D,100,  85, 145,  75, 100, 100         'MOVE G6D,94,  85, 145,  75, 105, 100
    MOVE G6A,100,  85, 145,  75, 100, 100         'MOVE G6A,94,  85, 145,  75, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT
    DELAY 100

    FOR i = 1 TO 2

        SPEED 9
        MOVE G6A,100,  86, 145,  75, 100, 100     'MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,100,  81, 155,  70, 100, 100     'MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60,
        MOVE G6B,70,  20,  60,, , 50
        WAIT

        SPEED 8
        MOVE G6A,100,  70, 130,  136, 100, 100     'MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,100,  58, 145,  135, 100, 100     'MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 8
        MOVE G6A,100,  78, 110,  140, 100, 100    'MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,100,  68, 125,  135, 100, 100     'MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60,
        WAIT

        SPEED 8
        MOVE G6D,100,  78, 110,  140, 100, 100     'MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,100,  68, 125,  135, 100, 100      'MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 8
        MOVE G6D,100,  70, 130,  136, 100, 100       'MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,100,  58, 145,  135, 100, 100       'MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,100,  86, 135,  75, 100, 100       'MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,100,  81, 145,  70, 100, 100       'MOVE G6A,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************



    NEXT i

    SPEED 8
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

국민체조_5: '가슴운동
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  75, 145, 105, 100, 100     'MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  75, 145, 105, 100, 100     'MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 7
    MOVE G6A,100,  76, 145, 105, 100, 100     'MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145, 105, 100, 100     'MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  50
    MOVE G6B,70,  20,  50
    WAIT

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 140,  95, 100, 100    'MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 140,  95, 100, 100    'MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  77, 150,  90, 100, 100    'MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  77, 150,  90, 100, 100    'MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 6
        MOVE G6A, 100,  74, 150,  105, 100, 100     'MOVE G6A, 100,  64, 145,  135, 100, 100
        MOVE G6D, 100,  74, 150,  105, 100, 100     'MOVE G6D, 100,  64, 145,  135, 100, 100
        MOVE G6B,  60,  30,  30, 100, 100, 100
        MOVE G6C,  60,  30,  30, 100, 100, 100
        WAIT

        FOR i = 1 TO 2

            SPEED 3
            MOVE G6A, 100,  70, 150,  95, 100, 100   'MOVE G6A, 100,  64, 145,  135, 100, 100
            MOVE G6D, 100,  70, 150,  95, 100, 100   'MOVE G6D, 100,  64, 145,  135, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 3
            MOVE G6A, 100,  74, 145,  85, 100, 100   'MOVE G6A, 100,  74, 125,  145, 100, 100
            MOVE G6D, 100,  74, 145,  85, 100, 100   'MOVE G6D, 100,  74, 125,  145, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

    NEXT j

    SPEED 5
    MOVE G6A, 100,  74, 150,  95, 100, 100   'MOVE G6A, 100,  64, 145,  135, 100, 100
    MOVE G6D, 100,  74, 150,  95, 100, 100   'MOVE G6D, 100,  64, 145,  135, 100, 100
    MOVE G6B,  60,  30,  30, 100, 100, 100
    MOVE G6C,  60,  30,  30, 100, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 150,  95, 100, 100      'MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 150,  95, 100, 100      'MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

국민체조_6: '옆꾸리운동
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6D,96,  116, 67,  133, 130, 100
            MOVE G6A,85,  86, 125,  103, 85, 100
            MOVE G6C,100,  45,  90,
            MOVE G6B,100,  180,  115,, , 160        'MOVE G6B,100,  180,  140,, , 160
            WAIT

            SPEED 11
            MOVE G6D,96,  86, 125,  103, 110, 100
            MOVE G6A,91,  76, 145,  93, 100, 100
            MOVE G6C,100,  35,  80,
            MOVE G6B,100,  35,  80,, ,100
            WAIT
        NEXT i
        '***********************************
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6A,96,  116, 67,  133, 130, 100
            MOVE G6D,85,  86, 125,  103, 85, 100
            MOVE G6B,100,  45,  90,, , 40
            MOVE G6C,100,  180,  115,              'MOVE G6C,100,  180,  140,
            WAIT

            SPEED 11
            MOVE G6A,96,  86, 125,  103, 110, 100
            MOVE G6D,91,  76, 145,  93, 100, 100
            MOVE G6B,100,  35,  80,, , 100
            MOVE G6C,100,  35,  80,
            WAIT
        NEXT i
    NEXT j

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,, , 100
    MOVE G6C,100,  30,  80,
    WAIT


    RETURN
    '**********************************************
국민체조_7: '등배운동

    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2
            SPEED 5
            MOVE G6A,100,  33, 158,  155, 100      'MOVE G6A,100,  33, 178,  155, 100
            MOVE G6D,100,  33, 158,  155, 100      'MOVE G6D,100,  33, 178,  155, 100
            MOVE G6B,165,  15,  90
            MOVE G6C,165,  15,  90
            WAIT

            SPEED 5
            MOVE G6A,100,  76, 145,  93, 100
            MOVE G6D,100,  76, 145,  93, 100
            MOVE G6B,100,  30,  80
            MOVE G6C,100,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 155,  70, 100, 100   'MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 155,  70, 100, 100   'MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100   'MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100   'MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 10
        MOVE G6C,100,  40,  90
        MOVE G6B,100,  40,  90
        WAIT
    NEXT j


    RETURN
    '**********************************************
국민체조_8: '몸통운동
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT



    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************


    RETURN

    '**********************************************
국민체조_9: '온몸운동
    GOSUB All_motor_mode3

    FOR i = 1 TO 5
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  80
        MOVE G6B,100,  30,  80
        WAIT

        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,120,  30,  80
        MOVE G6C,120,  30,  80


        SPEED 6
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,189,  70,  80
        MOVE G6C,189,  70,  80
        WAIT

        SPEED 15
        MOVE G6C,189,  40,  15
        MOVE G6B,189,  40,  15
        WAIT

        DELAY 100

        SPEED 15
        MOVE G6C,100,  40,  80
        MOVE G6B,100,  40,  80
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
국민체조_10: '뜀뛰기운동
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 3
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 3
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i

    NEXT j


    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN

    '**********************************************
    '**********************************************
국민체조_11: '팔다리운동


    FOR i = 1 TO 4
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT


        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        SPEED 10
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
국민체조_12: '숨고르기 


    SPEED 12
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  125                    ' MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  120                    ' MOVE G6B,100,  185,  130
    WAIT


    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  125                    ' MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  120                    ' MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100     
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  125                    ' MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  120                    ' MOVE G6B,100,  185,  130
    WAIT
    '******************
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 6
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  125                    ' MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  120                    ' MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    '******************
    SPEED 4
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  125                    ' MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  120                    ' MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT



    RETURN

    '**********************************************

    '**********************************************

    '**********************************************
    '************************************************
    '************************************************
    '******************************************

    '******************************************	
BEFORE_MAIN:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정

    ERX 4800, A, BEFORE_MAIN

    IF A <> 4 THEN
        GOTO BEFORE_MAIN
    ENDIF

    MUSIC "F"
PASSWORD1:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정

    ERX 4800, A, PASSWORD1

    IF A <> 3 THEN
        GOTO PASSWORD1
    ENDIF

    MUSIC "E"
PASSWORD2:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정

    ERX 4800, A, PASSWORD2

    IF A <> 2 THEN
        GOTO PASSWORD1
    ENDIF

    MUSIC "D"
PASSWORD3:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정

    ERX 4800, A, PASSWORD3

    IF A <> 1 THEN
        GOTO PASSWORD3
    ENDIF

    MUSIC "C"

MAIN: '라벨설정


        GOSUB 앞뒤기울기측정
        GOSUB 좌우기울기측정

    ERX 4800,A,MAIN	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    '    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32,KEY33,KEY34,KEY35,KEY36,KEY37,KEY38,KEY39,KEY40

    '    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

    IF A = 1 THEN
        GOTO 왼쪽턴10
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 2 THEN
        GOTO 전진달리기50
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 3 THEN
        GOTO 오른쪽턴10
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 4 THEN
        GOTO 왼쪽턴20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 5 THEN
        GOSUB 연속전진
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 6 THEN
        GOTO 오른쪽턴20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 7 THEN
        GOTO 왼쪽턴45
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 8 THEN
        GOTO One_Step
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 9 THEN
        GOTO 오른쪽턴45
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 10 THEN '0
		GOTO GO_SHORT_STEP
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 11 THEN ' ▲
        GOSUB 머리상중앙
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 12 THEN ' ▼
        GOSUB 머리하중앙
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 13 THEN '▶
        GOSUB 머리상오른쪽60도
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 14 THEN ' ◀
        GOSUB 머리상왼쪽60도
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 15 THEN ' A
        GOSUB 왼발공차기
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 16 THEN ' POWER

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 17 THEN ' C
        GOSUB UP_STAIR_LEFT_FOOT
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 18 THEN ' E
        GOSUB DOWN_STAIR_LEFT_FOOT
        GOTO RX_EXIT

        '*******************************************


    ELSEIF A = 19 THEN ' P2

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 20 THEN ' B	
        GOSUB 오른발공차기
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 21 THEN ' △

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 22 THEN ' *	
        GOSUB 왼쪽옆으로20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 23 THEN ' G
        GOSUB DOWN_STAIR_RIGHT_FOOT
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 24 THEN ' #
        GOSUB 오른쪽옆으로20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 25 THEN ' P1

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 26 THEN ' ■“가
        GOSUB 기본자세
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 27 THEN ' D
        GOSUB UP_STAIR_RIGHT_FOOT
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 28 THEN ' ◁

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 29 THEN ' □
        GOSUB 기본자세2
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 30 THEN ' ▷

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 31 THEN ' ▽
        GOTO RX_EXIT

        '*******************************************

    ELSEIF A = 32 THEN ' F

        GOTO RX_EXIT

        '*******************************************
        '여기서서부터 리모콘 밖

    ELSEIF A = 40 THEN
        GOSUB 인사
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 41 THEN
        GOSUB 환호성
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 42 THEN
        GOSUB 패배액션2
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 43 THEN
        GOSUB 복고댄스
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 44 THEN
        GOSUB 좌우뒤들기댄스
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 45 THEN
        GOSUB 국민체조시작
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 46 THEN
        GOSUB 국민체조_1	'시작
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 47 THEN
        GOSUB 국민체조_2	'다리운동
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 48 THEN
        GOSUB 국민체조_3	'팔운동

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 49 THEN
        GOSUB 국민체조_4	'머리운동

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 50 THEN
        GOSUB 국민체조_5 	'가슴운동

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 51 THEN
        GOSUB 국민체조_6	'옆꾸리운동

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 52 THEN
        GOSUB 국민체조_7	'등배운동

        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 53 THEN
        GOSUB 국민체조_8 	'몸통운동
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 54 THEN
        GOSUB 국민체조_9	'온몸운동
        GOTO RX_EXIT
        '*******************************************

    ELSEIF A = 55 THEN
        GOSUB 국민체조_10   '뜀뛰기운동
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 56 THEN
        GOSUB 국민체조_11   '팔다리운동
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 57 THEN

        GOSUB 국민체조_12	'숨고르기

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 58 THEN



        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 59 THEN



        GOTO RX_EXIT
        '*******************************************

		ELSEIF A = 60 THEN
		GOSUB 머리하왼쪽30도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 61 THEN
GOSUB 머리중왼쪽30도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 62 THEN

GOSUB 머리상왼쪽30도

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 63 THEN

GOSUB 머리하왼쪽60도

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 64 THEN

GOSUB 머리중왼쪽60도

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 65 THEN
GOSUB 머리상왼쪽60도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 66 THEN

GOSUB 머리하오른쪽30도

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 67 THEN
GOSUB 머리중오른쪽30도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 68 THEN

GOSUB 머리상오른쪽30도

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 69 THEN
GOSUB 머리하오른쪽60도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 70 THEN
GOSUB 머리중오른쪽60도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 71 THEN
GOSUB 머리상오른쪽60도


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 72 THEN
GOSUB 머리하중앙


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 73 THEN

GOSUB 머리중중앙

        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 74 THEN
GOSUB 머리상중앙


        GOTO RX_EXIT
        '*******************************************
        ELSEIF A = 75 THEN


        GOTO RX_EXIT
        '*******************************************

    ENDIF

    GOTO MAIN


    '
    'KEY1:
    '    ETX  4800,1
    '    GOTO 왼쪽턴10
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY2:
    '    ETX  4800,2
    '    ' GOTO 전진달리기50
    '    'BUTTON_NO = A
    '    ' GOSUB Number_Play
    '    ' GOSUB SOUND_PLAY_CHK
    '    GOSUB 계단오르기
    '    GOTO RX_EXIT
    '
    'KEY3:
    '    ETX  4800,3
    '
    '    GOTO 오른쪽턴10
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY4:
    '    ETX  4800,4
    '    GOTO 왼쪽턴20
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY5:
    '    ETX  4800,5
    '
    '    '   J = AD(5)	'적외선거리값 읽기
    '    '   BUTTON_NO = J
    '    '   GOSUB Number_Play
    '    '   GOSUB SOUND_PLAY_CHK
    '    '   GOSUB GOSUB_RX_EXIT
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY6:
    '    ETX  4800,6
    '    GOTO 오른쪽턴20
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY7:
    '    ETX  4800,7
    '    GOTO 오른쪽턴45
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY8:
    '    ETX  4800,8
    '    GOTO 연속전진
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY9:
    '    ETX  4800,9
    '    GOTO 오른쪽턴45
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY10: '0
    '    ETX  4800,10
    '    'GOTO 전진달리기50
    '    'GOTO 계단오르기
    '    GOTO RX_EXIT
    '    '***************
    'KEY11: ' ▲
    '    ETX  4800,11
    '
    '    'GOTO 연속전진
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY12: ' ▼
    '    ETX  4800,12
    '    'GOTO 연속후진
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY13: '▶
    '    ETX  4800,13
    '    ' GOTO 오른쪽옆으로70연속
    '    GOTO 머리상왼쪽60도
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY14: ' ◀
    '    ETX  4800,14
    '    ' GOTO 왼쪽옆으로70연속
    '    GOTO 머리하왼쪽60도
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY15: ' A
    '    ETX  4800,15
    '    ' GOTO 왼쪽옆으로20
    '    GOTO 머리하왼쪽30도
    '    GOTO RX_EXIT
    '    '***************
    'KEY16: ' POWER
    '    ETX  4800,16
    '
    '    ' GOSUB Leg_motor_mode3
    '    ' IF MODE = 0 THEN
    '    '     SPEED 10
    '    '     MOVE G6A,100, 140,  37, 145, 100, 100
    '    '     MOVE G6D,100, 140,  37, 145, 100, 100
    '    '     WAIT
    '    '  ENDIF
    '    '  SPEED 4
    '    '  GOSUB 앉은자세	
    '    ' GOSUB 종료음
    '
    '    GOSUB GOSUB_RX_EXIT
    'KEY16_1:
    '
    '    '  IF 모터ONOFF = 1  THEN
    '    '      OUT 52,1
    '    '     DELAY 200
    '    '     OUT 52,0
    '    '     DELAY 200
    '    '  ENDIF
    '    '  ERX 4800,A,KEY16_1
    '    '  ETX  4800,A
    '    '  IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
    '    '     SPEED 10
    '    '     MOVE G6A,100, 140,  37, 145, 100, 100
    '    '     MOVE G6D,100, 140,  37, 145, 100, 100
    '    '     WAIT
    '    '      GOSUB Leg_motor_mode2
    '    '      GOSUB 기본자세2
    '    '     GOSUB 자이로ON
    '    '     GOSUB All_motor_mode3
    '    '     GOTO RX_EXIT
    '    '  ENDIF
    '    '
    '    '  GOSUB GOSUB_RX_EXIT
    '    '  GOTO KEY16_1
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY17: ' C
    '    ETX  4800,17
    '
    '    GOTO 머리하오른쪽30도
    '    GOTO RX_EXIT
    '    '***************
    'KEY18: ' E
    '    ETX  4800,18	
    '    GOTO 머리하오른쪽60도
    '    GOTO RX_EXIT
    '    '***************
    'KEY19: ' P2
    '    ETX  4800,19
    '    GOTO 오른쪽턴60
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY20: ' B	
    '    ETX  4800,20
    '    GOTO 머리상왼쪽30도
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY21: ' △
    '    ETX  4800,21
    '    GOTO 머리중왼쪽30도
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY22: ' *	
    '    ETX  4800,22
    '    GOTO 왼쪽턴45
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY23: ' G
    '    ETX  4800,23
    '    GOTO 머리상오른쪽60도
    '    GOTO RX_EXIT
    '    '***************
    'KEY24: ' #
    '    ETX  4800,24
    '    GOTO 오른쪽턴45
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY25: ' P1
    '    ETX  4800,25
    '    GOTO 왼쪽턴60
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY26: ' ■
    '    ETX  4800,26
    '    GOTO 머리중왼쪽60도
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY27: ' D
    '    ETX  4800,27
    '
    '    GOTO 머리상오른쪽30도
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY28: ' ◁
    '    ETX  4800,28
    '    GOTO 머리하중앙
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY29: ' □
    '    ETX  4800,29
    '
    '    GOTO 머리중중앙
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY30: ' ▷
    '    ETX  4800,30
    '    GOTO 머리상중앙
    '    GOTO RX_EXIT
    '    '***************
    'KEY31: ' ▽
    '    ETX  4800,31
    '    GOSUB 머리중오른쪽30도
    '
    '    GOTO RX_EXIT
    '    '***************
    '
    'KEY32: ' F
    '    ETX  4800,32
    '    GOSUB 머리중오른쪽60도
    '    GOTO RX_EXIT
    '    '***************
    'KEY33:
    '    ETX  4800,33
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY34:
    '    ETX  4800,34
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY35:
    '    ETX  4800,35
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY36:
    '    ETX  4800,36
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY37:
    '    ETX  4800,37
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY38:
    '    ETX  4800,38
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY39:'
    '    ETX  4800,39
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    'KEY40:
    '    ETX  4800,40
    '
    '
    '
    '    GOTO RX_EXIT
    '    '***************
    '
    '
    '
    '
    '
    '
    '
    '
    '