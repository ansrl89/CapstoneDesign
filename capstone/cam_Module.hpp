/*
 * cam_Module.hpp
 *
 *  Created on: 2014. 3. 27.
 *      Author: keroro
 */

#ifndef CAM_MODULE_HPP_
#define CAM_MODULE_HPP_

#include "shared_Data.hpp"
#include <iostream>

#include <string.h>

#define max(a,b) (((a)>(b))? (a):(b))
#define min(a,b) (((a)<(b))? (a):(b))

#define MAX_3(a, b, c)	( ((a)>(b)) ? ( (((a)>(c)) ? (a) : (c)) ) : ( (((b)>(c)) ? (b) : (c)) ) )
#define MIN_3(a, b, c)	( ((a)>(b)) ? ( (((b)>(c)) ? (c) : (b)) ) : ( (((a)>(c)) ? (c) : (a)) ) )

#define NOISE_COUNT 3

#define LINE_SEARCH_SPACE_X1	60
#define LINE_SEARCH_SPACE_X2	260
#define LINE_SEARCH_SPACE_Y1	120
#define LINE_SEARCH_SPACE_Y2	239
//#define LINE_SEARCH_SPACE_Y2	1	// for debugging

typedef struct{
	int x;
	int y;
} POINT;

typedef struct {
  int hmin;
  int hmax;
  int smin;
  int smax;
  int vmin;
  int vmax;
} ColorBoundary;

typedef struct {
  float h;
  float s;
  float v;
} HSV;

extern const ColorBoundary blue_B;
extern const ColorBoundary red_B;
extern const ColorBoundary yellow_B;
extern const ColorBoundary green_B;
extern const ColorBoundary error_B;
#define RED	1
#define BLUE	2
#define GREEN	3
#define YELLOW 4


void *videoFrame(void*);


int isColor(HSV hsv, ColorBoundary color_B);
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v );
ColorBoundary getBoundary(int color);

POINT findOneColor(int start_X, int end_X, int start_Y, int end_Y, int color);



#endif /* CAM_MODULE_HPP_ */
