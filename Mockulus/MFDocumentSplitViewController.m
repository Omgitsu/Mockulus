//
//  MFDocumentSplitViewController.m
//  Mockulus
//
//  Created by James Baker on 6/8/15.
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

#import "MFDocumentSplitViewController.h"
#import "WindowController.h"
#import "MFUserDefaultsController.h"

@implementation MFDocumentSplitViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidAppear {
    [self toggleInfoBar:nil];
}

- (void)setup {
    [self addObservers];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:kNotificationToggleInfoBar]) {
        [self toggleInfoBar:notification.object];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)toggleInfoBar:(NSButton*)sender
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if ([[defaults objectForKey:kNSUserDefaultsKeyShowInfoPanel] boolValue]) {
        [[[[self splitViewItems] lastObject] animator] setCollapsed:YES];
    } else {
        [[[[self splitViewItems] lastObject] animator] setCollapsed:NO];
    }
}

@end
