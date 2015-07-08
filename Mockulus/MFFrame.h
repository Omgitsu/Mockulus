//
//  MFFrame.h
//  Mockulus
//
//  Created by James Baker on 5/22/15.
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
#import "MFFrameImage.h"
#import "MFFrameLabel.h"
#import "MFStyle.h"

extern NSString * const kStyleTypeFrame;

@interface MFFrame : MFStyle

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *maskType;
@property (assign, nonatomic) NSInteger topBarHeight;
@property (assign, nonatomic) NSInteger bottomBarHeight;
@property (assign, nonatomic) NSInteger leftBorderWidth;
@property (assign, nonatomic) NSInteger rightBorderWidth;
@property (assign, nonatomic) NSInteger minimumWidth;
@property (strong, nonatomic) MFFrameLabel *titleLabel;
@property (assign, nonatomic) NSInteger titleLabelFontSize;
@property (strong, nonatomic) MFFrameLabel *urlLabel;
@property (strong, nonatomic) MFFrameImage *baseImage;
@property (strong, nonatomic) MFFrameImage *urlBarImage;

+ (instancetype)frameWithContentsOfDictionary:(NSDictionary*)dict;
- (instancetype)initWithContentsOfDictionary:(NSDictionary*)dict;

@end
