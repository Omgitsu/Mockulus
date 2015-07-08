//
//  MFMockupImage.m
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

#import "MFMockupImage.h"

@implementation MFMockupImage

#pragma mark - Lifecycle

+ (instancetype)mockupImageWithImage:(NSImage*)image fileName:(NSString*)fileName
{
    return [[MFMockupImage alloc] initWithImage:image fileName:fileName];
}

+ (instancetype)mockupImageWithFileName:(NSString*)fileName frame:(CGRect)frame
{
    return [[MFMockupImage alloc] initWithFileName:fileName frame:frame];
}

- (instancetype)initWithFileName:(NSString*)fileName frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        _frame = frame;
        _image = [NSImage imageNamed:fileName];
    }
    return self;
}

- (instancetype)initWithImage:(NSImage*)image fileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        _image = image;
    }
    return self;
}


@end
