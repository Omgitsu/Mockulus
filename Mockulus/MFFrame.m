//
//  MFFrame.m
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

#import "MFFrame.h"
#import "Utility.h"

NSString * const kStyleTypeFrame = @"frame";

#pragma mark - Private

@interface MFFrame()

@property (strong, nonatomic) NSDictionary *config;

@end

@implementation MFFrame

#pragma mark - Lifecycle

+ (instancetype)frameWithContentsOfDictionary:(NSDictionary*)dict
{
    return [[MFFrame alloc] initWithContentsOfDictionary:dict];
}

- (instancetype)initWithContentsOfDictionary:(NSDictionary*)dict
{
    if(self = [super init]) {
        _config = dict;
        [self setup];
        return self;
    } else {
        return nil;
    }
}

- (void)setup
{
    _title = _config[@"title"];
    _maskType = _config[@"mask_type"];
    _topBarHeight = [_config[@"top_bar_height"] integerValue];
    _bottomBarHeight = [_config[@"bottom_bar_height"] integerValue];
    _leftBorderWidth = [_config[@"left_border_width"] integerValue];
    _rightBorderWidth = [_config[@"right_border_width"] integerValue];
    _minimumWidth = [_config[@"minimum_width"] integerValue];
    
    if ([_config[@"base"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"base"]];
        NSString *fileName = _config[@"base"][@"file"];
        _baseImage = [MFFrameImage frameImageWithFileName:fileName frame:frame];
    }
    
    if ([_config[@"url_bar"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"url_bar"]];
        frame.size.width = CGRectGetWidth(frame) * 2;
        frame.size.height = CGRectGetHeight(frame) * 2;
        NSString *fileName = _config[@"url_bar"][@"file"];
        _urlBarImage = [MFFrameImage frameImageWithFileName:fileName frame:frame];
    }
    
    if ([_config[@"title_label"][@"available"] boolValue] == YES){
        _titleLabel = [MFFrameLabel frameLabelWithContentsOfDictionary:_config[@"title_label"]];
        _titleLabelFontSize = (int)[_config[@"title_label"][@"size"] integerValue];
    }
    
    if ([_config[@"url_label"][@"available"] boolValue] == YES){
        _urlLabel = [MFFrameLabel frameLabelWithContentsOfDictionary:_config[@"url_label"]];
    }
    
}

#pragma mark - CG Helpers

- (CGPoint)pointForConfiguration:(NSDictionary*)dict
{
    CGFloat x = [dict[@"origin"][@"x"] floatValue];
    CGFloat y = [dict[@"origin"][@"y"] floatValue];
    return CGPointMake(x, y);
}

- (CGRect)rectForConfiguration:(NSDictionary*)dict
{
    CGFloat width = [dict[@"size"][@"width"] floatValue];
    CGFloat height = [dict[@"size"][@"height"] floatValue];
    CGFloat x = [dict[@"origin"][@"x"] floatValue] * 2;
    CGFloat y = [dict[@"origin"][@"y"] floatValue] * 2;
    return CGRectMake(x, y, width, height);
}

- (CGRect)rectForImageFromDictionary:(NSDictionary*)dict
{
    NSImage *image = [NSImage imageNamed:dict[@"file"]];
    
    CGRect frame = CGRectZero;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    frame.origin.x = [dict[@"origin"][@"x"] floatValue] * 2;
    frame.origin.y = [dict[@"origin"][@"y"] floatValue] * 2;
    
    return frame;
}

#pragma mark - MFStyle Overrides

- (BOOL)hasShadow
{
    return YES;
}

- (BOOL)hasUrlBar
{
    if (self.urlBarImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasTitle
{
    if (self.titleLabel) {
        return YES;
    }
    return NO;
}
- (BOOL)hasURL
{
    if (self.urlLabel) {
        return YES;
    }
    return NO;
}


@end
