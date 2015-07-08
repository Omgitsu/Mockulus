//
//  MFDropImageViewController.m
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

#import "MFDropImageViewController.h"
#import "MFMockupView.h"
#import "MFOptionsPreferencesView.h"
#import "MFUserDefaultsController.h"

#pragma mark - Private

@interface MFDropImageViewController ()

@property (weak) IBOutlet NSImageView *backgroundImageView;
@property (weak) IBOutlet MFProgressView *progressView;

@end

#pragma mark - Lifecycle

@implementation MFDropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    _progressView.alphaValue = 0.0;
    [self addObservers];
    [self setupBackground];

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
    if ([[notification name] isEqualToString:kNotificationChangeBackgroundColor]) {
        [self changeBackgroundColor:notification.object];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileStarted]) {
        [self displayProgressViewWithTitle:@"Saving"];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileCompleted]) {
        [self hideProgressView];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupBackground
{

    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSData *colorWheelData = [defaults objectForKey:kNSUserDefaultsKeyBackgroundColor];
    NSColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorWheelData];
    [self setBackgroundColor:color];
    
}

#pragma mark - ProgressView

- (void)displayProgressViewWithTitle:(NSString*)title
{
    [self.progressView startProgressIndicator];
    self.progressView.label.stringValue = title;
    [[self.progressView animator] setAlphaValue:1.0];
    
}

- (void)hideProgressView
{
    [self.progressView stopProgressIndicator];
    [[self.progressView animator] setAlphaValue:0.0];
}

#pragma mark - Background Image

- (void)changeBackgroundColor:(id)sender
{
    NSColor *color = [sender color];
    [self setBackgroundColor:color];
}

- (void)setBackgroundColor:(NSColor*)color
{
    NSRect frame = self.view.frame;
    
    NSImage *newImage = [NSImage imageWithSize:frame.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [color set];
        NSRectFill (frame);
        return YES;
    }];
    
    self.backgroundImageView.image = nil;
    self.backgroundImageView.image = newImage;
    [self.backgroundImageView setNeedsDisplay];
}


@end
