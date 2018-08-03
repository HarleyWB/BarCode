//
//  FftOpencvFun.h
//  NewProject
//
//  Created by Lu Jianfeng on 6/27/14.
//  Copyright (c) 2014 Steven. All rights reserved.
//

#ifndef __NewProject__FftOpencvFun__
#define __NewProject__FftOpencvFun__




#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include <opencv2/opencv.hpp>
#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
using namespace cv;
using namespace std;

#define PI 3.14159

#define TRUE  1
#define FALSE 0

#define VIDEO_WIDTH     1280
#define VIDEO_HEIGHT    720
#define G_IMAGE_WIDTH   512
#define G_IMAGE_HEIGHT  512

bool FftOpencvFun(IplImage* pInputImg, char* pout);
#endif /* defined(__NewProject__FftOpencvFun__) */

