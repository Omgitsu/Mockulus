//
//  MFMockup.m
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

#import "MFMockup.h"
#import "Utility.h"

NSString * const kStyleTypeMockup = @"mockup";

#pragma mark - Private

@interface MFMockup()

@property (strong, nonatomic) NSDictionary *config;

@end

@implementation MFMockup

#pragma mark - Lifecycle

+ (instancetype)mockupWithContentsOfDictionary:(NSDictionary*)dict
{
    return [[MFMockup alloc] initWithContentsOfDictionary:dict];
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
    _screen = [self rectForScreenFromDictionary:_config[@"screen"]];
    
    if (_config[@"allows_landscape"]){
        _allowsLandscape = [_config[@"allows_landscape"] boolValue];
    } else {
        _allowsLandscape = NO;
    }

    
    if ([_config[@"base"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"base"]];
        NSString *fileName = _config[@"base"][@"file"];
        _baseImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
        
        // alternate base images
        if (_config[@"base"][@"alternates"]) {
            
            NSMutableDictionary *alternateMockupImages = [NSMutableDictionary dictionary];
            NSDictionary *alternates = _config[@"base"][@"alternates"];
            for (NSString *alternateTitle in alternates) {
                NSString *alternateFileName = [alternates objectForKey:alternateTitle];
                if (alternateFileName) {
                    MFMockupImage *alternateImage = [MFMockupImage mockupImageWithFileName:alternateFileName frame:frame];
                    alternateMockupImages[alternateTitle] = alternateImage;
                }
            }
            _defaultBaseImageTitle = _config[@"base"][@"default_base"];
            _baseImages = alternateMockupImages;
        }
    }
    
    if ([_config[@"glare"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"glare"]];
        NSString *fileName = _config[@"glare"][@"file"];
        _glareImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    if ([_config[@"shadow"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"shadow"]];
        NSString *fileName = _config[@"shadow"][@"file"];
        _shadowImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    if ([_config[@"shadow"][@"landscape_file"] length] > 0) {
        NSString *fileName = _config[@"shadow"][@"landscape_file"];
        CGRect frame =  CGRectZero;
        frame.size = [NSImage imageNamed:fileName].size;
        _landscapeShadowImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    if ([_config[@"logo"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"logo"]];
        NSString *fileName = _config[@"logo"][@"file"];
        _logoImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    if ([_config[@"statusbar"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"statusbar"]];
        NSString *fileName = _config[@"statusbar"][@"file"];
        _statusbarImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    
    if ([_config[@"background"][@"file"] length] > 0) {
        CGRect frame = [self rectForImageFromDictionary:_config[@"background"]];
        NSString *fileName = _config[@"background"][@"file"];
        _osBackgroundImage = [MFMockupImage mockupImageWithFileName:fileName frame:frame];
    }
    
    if (_config[@"bottom_gutter"]) {
        _bottomGutter = [_config[@"bottom_gutter"] integerValue] * 2;
    } else {
        _bottomGutter = 0;
    }
    
}

#pragma mark - CG Helpers

- (CGRect)rectForScreenFromDictionary:(NSDictionary*)dict
{
    CGRect frame = CGRectZero;
    frame.size.width = [dict[@"size"][@"width"] floatValue];
    frame.size.height = [dict[@"size"][@"height"] floatValue];
    frame.origin.x = [dict[@"origin"][@"x"] floatValue];
    frame.origin.y = [dict[@"origin"][@"y"] floatValue];
    
    return frame;
}

- (CGRect)rectForImageFromDictionary:(NSDictionary*)dict
{
    NSImage *image = [NSImage imageNamed:dict[@"file"]];
    
    CGRect frame = CGRectZero;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    frame.origin.x = [dict[@"origin"][@"x"] floatValue];
    frame.origin.y = [dict[@"origin"][@"y"] floatValue];
    
    return frame;
}

#pragma mark - MFStyle Overrides

- (BOOL)allowsLandscape
{
    return _allowsLandscape;
}

- (BOOL)hasShadow
{
    if (self.shadowImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasLogo
{
    if (self.logoImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasGlare
{
    if (self.glareImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasStatusbar
{
    if (self.statusbarImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasOperatingSystemBackground
{
    if (self.osBackgroundImage) {
        return YES;
    }
    return NO;
}

- (BOOL)hasAlternateBaseImages
{
    if (self.baseImages) {
        return YES;
    }
    return NO;
}

@end
