//
//  MFMockupView.h
//  Mockulus
//
//  Created by James Baker on 5/11/15.
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

#import <AppKit/AppKit.h>
#import "MFMockupController.h"
#import "MFMockup.h"
#import "MFFrameController.h"
#import "MFFrame.h"
#import "MFDragDropImageView.h"
#import "MFImageView.h"
#import "MFDraggableImageView.h"

extern NSString * const kNotificationUpdateMockup;
extern NSString * const kNotificationSaveFileStarted;
extern NSString * const kNotificationSaveFileCompleted;
extern NSInteger const kChromeGutterWithShadow;
extern CGFloat const kScalingFactorRetinaDefaultResolution;
extern CGFloat const kScalingFactorRetinaHighResolution;
extern CGFloat const kScalingFactorDefaultResolution;

typedef NS_ENUM(NSInteger, MFImageCompType) {
    MFImageCompTypeFrame,
    MFImageCompTypeMockup
};

@interface MFMockupView : NSImageView

@end

#pragma mark - Private

@interface MFMockupView()

@property (assign, nonatomic) CGFloat landscapeMode;
@property (assign, nonatomic) NSInteger scalingMode;
@property (assign, nonatomic) NSInteger alignmentMode;
@property (assign, nonatomic) NSInteger frameAlignmentMode;
@property (assign, nonatomic) CGFloat shadowBlurRadius;
@property (assign, nonatomic) CGFloat shadowOffset;
@property (assign, nonatomic) CGFloat imageOffsetWithShadow;
@property (nonatomic, assign) CGFloat compHeight;
@property (nonatomic, assign) CGFloat compWidth;
@property (nonatomic, assign) CGFloat previousCompWidth;
@property (nonatomic, assign) CGFloat previousCompHeight;
@property (strong, nonatomic) NSImage *uneditedImage;
@property (copy, nonatomic) NSString *imageFileName;
@property (nonatomic, assign) NSInteger compType;
@property (weak) IBOutlet MFDragDropImageView *dragDropImageView;


// MockupViews
@property (nonatomic, strong) NSArray *mockupViews;
@property (nonatomic, assign) MFMockupController *mockupController;
@property (nonatomic, assign) MFMockup *currentMockup;
@property (nonatomic, strong) MFImageView *mockupBackgroundFillView;
@property (nonatomic, strong) MFImageView *mockupBaseImageView;
@property (nonatomic, strong) MFDraggableImageView *mockupScreenImageView;
@property (nonatomic, strong) MFImageView *mockupShadowImageView;
@property (nonatomic, strong) MFImageView *mockupBackgroundImageView;
@property (nonatomic, strong) MFImageView *mockupOSBackgroundImageView;
@property (nonatomic, strong) MFImageView *mockupLogoImageView;
@property (nonatomic, strong) MFImageView *mockupGlareImageView;
@property (nonatomic, strong) MFImageView *mockupStatusbarImageView;


// Frame Views
@property (nonatomic, strong) NSArray *frameViews;
@property (nonatomic, strong) MFFrameController *frameController;
@property (nonatomic, strong) MFFrame *currentFrame;
@property (nonatomic, strong) NSTextField *frameUrlTextField;
@property (nonatomic, strong) NSTextField *frameTitleTextField;
@property (nonatomic, strong) MFImageView *frameBackgroundFillView;
@property (nonatomic, strong) MFImageView *frameBaseImageView;
@property (nonatomic, strong) MFImageView *frameScreenImageView;
@property (nonatomic, strong) MFImageView *frameURLBarImageView;
@property (nonatomic, strong) NSImageView *frameShadowImageView;
@property (nonatomic, strong) NSImage *frameMaskImage;

@end



