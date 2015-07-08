//
//  MFOptionsPreferencesView.h
//  Mockulus
//
//  Created by James Baker on 6/3/15.
//  Copyright (c) 2015 WDDG, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>
#import "MFStyle.h"

extern NSString * const kNotificationChangeBackgroundColor;

extern NSString * const kNotificationToggleLandscape;
extern NSString * const kNotificationToggleGlare;
extern NSString * const kNotificationToggleShadow;
extern NSString * const kNotificationToggleLogo;
extern NSString * const kNotificationToggleStatusbar;
extern NSString * const kNotificationToggleURLTextField;
extern NSString * const kNotificationToggleTitleTextField;
extern NSString * const kNotificationToggleOperatingSystemBackground;

extern NSString * const kNotificationChangeDesktopColor;
extern NSString * const kNotificationChangeBaseImage;
extern NSString * const kNotificationChangeURLText;
extern NSString * const kNotificationChangeTitleText;

extern NSString * const kMotificationModeChangeScaling;
extern NSString * const kMotificationModeChangeAlignment;
extern NSString * const kMotificationModeChangeFrameAlignment;

extern NSString * const kMFOptionsScalingModeImageNameNone;
extern NSString * const kMFOptionsScalingModeImageNameHeight;
extern NSString * const kMFOptionsScalingModeImageNameWidth;
extern NSString * const kMFOptionsScalingModeImageNameFillScreen;

extern NSString * const kMFOptionsAlignmentModeTopLeft;
extern NSString * const kMFOptionsAlignmentModeTopCenter;
extern NSString * const kMFOptionsAlignmentModeTopRight;
extern NSString * const kMFOptionsAlignmentModeCenterLeft;
extern NSString * const kMFOptionsAlignmentModeCenter;
extern NSString * const kMFOptionsAlignmentModeCenterRight;
extern NSString * const kMFOptionsAlignmentModeBottomLeft;
extern NSString * const kMFOptionsAlignmentModeBottomCenter;
extern NSString * const kMFOptionsAlignmentModeBottomRight;

typedef NS_ENUM(NSInteger, MFOptionsFrameAlignmentMode) {
    MFOptionsFrameAlignmentModeLeft,
    MFOptionsFrameAlignmentModeCenter,
    MFOptionsFrameAlignmentModeRight
};

typedef NS_ENUM(NSInteger, MFOptionsScalingMode) {
    MFOptionsScalingModeNone,
    MFOptionsScalingModeHeight,
    MFOptionsScalingModeWidth,    
    MFOptionsScalingModeFillScreen
};

typedef NS_ENUM(NSInteger, MFOptionsAlignmentMode) {
    MFOptionsAlignmentModeTopLeft,
    MFOptionsAlignmentModeTopCenter,
    MFOptionsAlignmentModeTopRight,
    MFOptionsAlignmentModeLeftCenter,
    MFOptionsAlignmentModeCenter,
    MFOptionsAlignmentModeRightCenter,
    MFOptionsAlignmentModeBottomLeft,
    MFOptionsAlignmentModeBottomCenter,
    MFOptionsAlignmentModeBottomRight
};


@interface MFOptionsPreferencesView : NSView <NSTextFieldDelegate>

@end


