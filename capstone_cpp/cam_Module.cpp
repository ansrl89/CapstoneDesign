/*
 * cam_Module.cpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */

#include "cam_Module.hpp"

//const ColorBoundary blue_B = {190, 250, 70, 100, 70, 100};

  // 7호관 2층
//const ColorBoundary blue_B = {190, 250, 39, 100, 32, 100};
//const ColorBoundary red_B = {345, 15, 45, 100, 40, 100};
//const ColorBoundary yellow_B = {50, 76, 50, 100, 81, 100};
//const ColorBoundary green_B = {120, 168, 47, 100, 18, 100};

  // 코봇 동방
const ColorBoundary blue_B = {175, 250, 40, 100, 40, 100};;

const ColorBoundary red_B = {338, 20, 45, 100, 35, 100};
const ColorBoundary yellow_B = {50, 80, 40, 100, 40, 100};
//const ColorBoundary green_B = {100, 140, 47, 100, 20, 100};
const ColorBoundary green_B = {71 , 100, 40, 100, 35, 100};


//const ColorBoundary green_B = {100, 170, 20, 100, 30, 100};
const ColorBoundary error_B = {-1, -1, -1, -1, -1, -1};

void *videoFrame(void*)
{
	while(1)
	{
		bool bSuccess = cap.read(frame);

		if (!bSuccess)
		{
			cout << "Cannot read a frame from camera" << endl;
			exit(1);
		}
		p(semid);
		memcpy(frameBuf, frame.data,sizeof(char)*WIDTH*HEIGHT*3);
		v(semid);

		if(peer_Desktop > 0)
		{
			write(peer_Desktop, frameBuf, sizeof(char)*WIDTH*HEIGHT*3);
		}

		if(stream_Android > 0)
			write(stream_Android, frameBuf, sizeof(char)*WIDTH*HEIGHT*3);
	}

}

POINT findOneColor(int start_X, int end_X, int start_Y, int end_Y, int color)
{
	// 찾는 색 분석
	ColorBoundary color_B = getBoundary(color);

//	// 카메라 읽기
//	bool bSuccess = cap.read(frame);
//
//	if (!bSuccess)
//	{
//		cout << "Cannot read a frame from camera" << endl;
//		exit(1);
//	}

//	unsigned char *input = (unsigned char*)(frame.data);
	char input[WIDTH*HEIGHT*3];
	p(semid);
	memcpy(input, frameBuf,sizeof(char)*WIDTH*HEIGHT*3);
	v(semid);
	//	char *input = frameBuf;
	int cn = frame.channels();

	// 변수 초기화
	int cnt = 0;
	int flag = FALSE;
	float r, g, b;
	POINT s_pt = {-1, -1};
	POINT e_pt = {-1, -1};

	int left = 0, right = 0;

	for(int i = start_Y;i < end_Y ;i++)
	{
		for(int j = start_X;j < end_X ;j++)
		{
			if(flag == TRUE && cnt == 0)
			{
				POINT p;
				p.x = (s_pt.x + e_pt.x)/2;
				p.y = (s_pt.y + e_pt.y)/2;
				return p;
			}

			b = input[frame.cols*cn*i + j*cn + 0];
			g = input[frame.cols*cn*i + j*cn + 1];
			r = input[frame.cols*cn*i + j*cn + 2];

			float h, s, v;
			RGBtoHSV(r, g, b, &h, &s, &v);

			HSV hsv = {h, s, v};

			if(isColor(hsv, color_B) == TRUE)
			{
				if(j > WIDTH/2)
					right++;
				else if(j < WIDTH/2)
					left++;
			}
//			cout << h << " " << s << " " << v << " " << endl;

			/*
			if(isColor(hsv, color_B) == TRUE)
			{
				cnt++;
			}
			else
				cnt = 0;

			if(cnt > NOISE_COUNT)
			{
			   flag = TRUE;

			   if(s_pt.x == -1 && s_pt.y == -1)
			   {
				  s_pt.x = j;
				  s_pt.y = i;
			   }
			   else
			   {
				  e_pt.x = j;
				  e_pt.y = i;
			   }
			}
			*/
		}
	}

	POINT r_p;
	if(left + right > 30)
	{
//		cout << "left : " << left << ", right : " << right << endl;
		if(left > right)
		{
			r_p.x = r_p.y = 10;
			return r_p;
		}
		else if(right > left)
		{
			r_p.x = WIDTH-10;
			r_p.y = 10;
			return r_p;
		}
	}
	else
	{
		r_p.x = -1;
		r_p.y = -1;
		return r_p;
	}
	return r_p;
}

POINT find_Pos_Of_Color(int minX, int maxX, int color)
{
	// 찾는 색 분석
	ColorBoundary color_B = getBoundary(color);

	char input[WIDTH*HEIGHT*3];
	p(semid);
	memcpy(input, frameBuf,sizeof(char)*WIDTH*HEIGHT*3);
	v(semid);
	//	char *input = frameBuf;
	int cn = frame.channels();

	// 변수 초기화
	int flag = FALSE;
	float r, g, b;
	POINT reValue = {-1, -1};


	for(int i = HEIGHT-10;i > 1 ;i--)
	{
		for(int j = minX;j < maxX ;j++)
		{
			b = input[frame.cols*cn*i + j*cn + 0];
			g = input[frame.cols*cn*i + j*cn + 1];
			r = input[frame.cols*cn*i + j*cn + 2];

			float h, s, v;
			RGBtoHSV(r, g, b, &h, &s, &v);

			HSV hsv = {h, s, v};

			if(isColor(hsv, color_B) == TRUE)
			{
				int cnt = 0;
				for(int m = -2; m < 3; m++)
				{
					for(int n = -2; n < 3; n++)
					{
						int checkY = (i+m);
						int checkX = (j+n);

						if(checkX < 1 || checkX > WIDTH-1 || checkY < 1 || checkY > HEIGHT-1)
							continue;

						b = input[frame.cols*cn*checkY + checkX*cn + 0];
						g = input[frame.cols*cn*checkY + checkX*cn + 1];
						r = input[frame.cols*cn*checkY + checkX*cn + 2];

						float h2, s2, v2;
						RGBtoHSV(r,g,b,&h2,&s2,&v2);
						HSV hsv2 = {h, s, v};

						if(isColor(hsv2, color_B) == TRUE)
							cnt++;
					}
				}

				if (cnt >= 15)
				{
					reValue.x = j;
					reValue.y = i;

					return reValue;
				}
			}
		}
	}

	// 여기까지오면 못 찾은것
	return reValue;

}



int isColor(HSV hsv, ColorBoundary color_B){

    if(color_B.hmax < color_B.hmin){    // 색이 Red 일 경우
	    if(hsv.h >= color_B.hmin && hsv.h <= 360 &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return TRUE;

        else if(hsv.h >= 0 && hsv.h <= color_B.hmax &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return TRUE;

        else
            return FALSE;
    }

    else{    // 그 외 경우

        if(hsv.h >= color_B.hmin && hsv.h <= color_B.hmax &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return TRUE;

        else
            return FALSE;
    }

}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;

	min = MIN_3(r, g, b);
	max = MAX_3(r, g, b);
	*v = max; // v

	delta = max - min;

	if(delta == 0){

		*s = 0;
		*h = 0;
		*v = *v / 255.0;
		return;
	}

	if( max != 0 )
		*s = delta / max; // s
	else {
		// r = g = b = 0 // s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}

	if( r == max )
		*h = ( g - b ) / delta; // between yellow & magenta

	else if( g == max )
		*h = 2 + ( b - r ) / delta; // between cyan & yellow

	else
		*h = 4 + ( r - g ) / delta; // between magenta & cyan

	*h *= 60; // degrees
	if( *h < 0 )
		*h += 360;

	*s *= 100;
	*v = *v / 255 * 100;
}


ColorBoundary getBoundary(int color)
{
	ColorBoundary color_B = error_B;

	switch(color)
	{
	case RED:
		color_B = red_B;
		break;
	case BLUE:
		color_B = blue_B;
		break;
	case GREEN:
		color_B = green_B;
		break;
	case YELLOW:
		color_B = yellow_B;
		break;
	default:
		color_B = error_B;
		break;
	}

	return color_B;
}

