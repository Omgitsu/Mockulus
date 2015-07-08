//
//  MFOptionsStyleScrollView.m
//  Mockulus
//
//  Created by James Baker on 6/1/15.
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

#import "MFOptionsStyleScrollView.h"

@implementation MFOptionsStyleScrollView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self scrollToTop];
}

#pragma mark - Scrolling

// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Scrolling.html

- (void)scrollToTop;
{
    if ([self hasVerticalScroller]) {
        self.verticalScroller.floatValue = 0;
    }
    
    NSPoint newScrollOrigin;
    
    // assume that the scrollview is an existing variable
    if ([[self documentView] isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    } else {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([[self documentView] frame]) - NSHeight([[self contentView] bounds]));
    }
    
    [[self documentView] scrollPoint:newScrollOrigin];
    
}

- (void)scrollToBottom;
{
    NSPoint newScrollOrigin;
    
    // assume that the scrollview is an existing variable
    if ([[self documentView] isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([[self documentView] frame]) - NSHeight([[self contentView] bounds]));
    } else {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    }
    
    [[self documentView] scrollPoint:newScrollOrigin];
    
}

@end
