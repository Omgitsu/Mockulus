//
//  MFOptionsStyleButton.m
//  Mockulus
//
//  Created by James Baker on 5/26/15.
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

#import "MFOptionsStyleButton.h"

#pragma mark - Private

@interface MFOptionsStyleButton()

@property (strong, nonatomic) NSDictionary *config;

@end

@implementation MFOptionsStyleButton

#pragma mark - Lifecycle

+ (instancetype)buttonWithFrame:(NSRect)frameRect contentsOfDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithFrame:frameRect contentsOfDictionary:dict];
}


- (instancetype)initWithFrame:(NSRect)frameRect contentsOfDictionary:(NSDictionary*)dict
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _config = dict;
        [self setup];
    }
    return self;
    
}

- (void)setup
{
    
    NSString *title = _config[@"title"];
    NSString *iconFile = _config[@"icon_file"];
    NSString *styleType = _config[@"type"];
    
    _styleName = title;
    _styleType = styleType;
    _selected = NO;
    
    NSInteger width = [_config[@"screen"][@"size"][@"width"] integerValue];
    NSInteger height = [_config[@"screen"][@"size"][@"height"] integerValue];
    
    if ([_styleType isEqualToString:@"mockup"]) {
        _styleInfo = [NSString stringWithFormat:@"%@ - native resolution: %lix%li",title,(long)width,(long)height];
    }
    if ([_styleType isEqualToString:@"frame"]) {
        NSInteger minimumWidth = [_config[@"minimum_width"] integerValue];
        _styleInfo = [NSString stringWithFormat:@"%@ - minimum width: %li",title,(long)minimumWidth];
    }
    
    // configure the button
    [self setButtonType:NSToggleButton];
    self.bezelStyle = NSTexturedSquareBezelStyle;
    self.title = title;
    self.image = [NSImage imageNamed:iconFile];
    [[self cell] setImageScaling:NSImageScaleNone];
    [[self cell] setImagePosition:NSImageBelow];
    self.alignment = NSCenterTextAlignment;
    self.bordered = NO;
    self.hidden = NO;
    self.transparent = NO;
    self.springLoaded = YES;
    self.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];
    
}



@end
