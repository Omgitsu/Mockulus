//
//  MFDocumentView.m
//  Mockulus
//
//  Created by James Baker on 4/29/15.
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

#import "MFDocumentView.h"

NSString * const kNotificationMockupFinishedRendering = @"The mockup has finished rendering";

#pragma mark - Private

@interface MFDocumentView()

@property (assign, nonatomic) CGFloat previousWidth;
@property (assign, nonatomic) CGFloat previousHeight;

@end

#pragma mark - Lifecycle

@implementation MFDocumentView

- (void)viewDidMoveToWindow
{
    _previousWidth = CGRectGetWidth(self.frame);
    _previousHeight = CGRectGetHeight(self.frame);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewResized:) name:NSViewFrameDidChangeNotification
                                               object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewResized:(NSNotification *)notification;
{
    // NSViewFrameDidChangeNotification can be called many times,
    if (CGRectGetHeight(self.frame) != self.previousHeight || CGRectGetWidth(self.frame) != self.previousWidth) {
        self.previousWidth = CGRectGetWidth(self.frame);
        self.previousHeight = CGRectGetHeight(self.frame);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMockupFinishedRendering object:nil];
    
}



@end
