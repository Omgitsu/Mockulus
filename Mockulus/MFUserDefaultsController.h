//
//  MFUserDefaultsController.h
//  Mockulus
//
//  Created by James Baker on 6/14/15.
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

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

extern NSString * const kNSUserDefaultsKeyCurrentStyleType;
extern NSString * const kNSUserDefaultsKeyCurrentStyleName;
extern NSString * const kNSUserDefaultsKeyApplicationHasRun;
extern NSString * const kNSUserDefaultsKeyEnableLandscapeMode;
extern NSString * const kNSUserDefaultsKeyEnableGlare;
extern NSString * const kNSUserDefaultsKeyEnableLogo;
extern NSString * const kNSUserDefaultsKeyEnableShadow;
extern NSString * const kNSUserDefaultsKeyEnableStatusBar;
extern NSString * const kNSUserDefaultsKeyEnableOperatingSystemBackground;
extern NSString * const kNSUserDefaultsKeyBackgroundColor;
extern NSString * const kNSUserDefaultsKeyInterfaceBackgroundColor;
extern NSString * const kNSUserDefaultsKeyEnableURLTitle;
extern NSString * const kNSUserDefaultsKeyURLTitle;
extern NSString * const kNSUserDefaultsKeyEnableTitle;
extern NSString * const kNSUserDefaultsKeyFrameTitle;
extern NSString * const kNSUserDefaultsKeyZoomToFit;
extern NSString * const kNSUserDefaultsKeyScalingMode;
extern NSString * const kNSUserDefaultsKeyAlignmentMode;
extern NSString * const kNSUserDefaultsKeyAlignmentControlTopMode;
extern NSString * const kNSUserDefaultsKeyAlignmentControlCenterMode;
extern NSString * const kNSUserDefaultsKeyAlignmentControlBottomMode;
extern NSString * const kNSUserDefaultsKeyFrameAlignmentMode;
extern NSString * const kNSUserDefaultsKeyShowOptionsPanel;
extern NSString * const kNSUserDefaultsKeyShowInfoPanel;
extern NSString * const kNSUserDefaultsKeySaveAtHighResolutions;

@interface MFUserDefaultsController : NSObject

@property (strong, nonatomic) NSUserDefaults *defaults;

+ (instancetype)sharedController;
- (void)deleteUserDefaults;
- (void)setUserDefaultsToDefaultValues;
- (void)setMissingUserDefaultsToDefaultValues;
- (void)flipBooleanForKey:(NSString *)key;

@end
