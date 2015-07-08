//
//  MFScrollView.m
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

#import "MFScrollView.h"
#import "MFDocumentView.h"
#import "WindowController.h"
#import "MFMockupView.h"
#import "MFUserDefaultsController.h"

NSString * const kNotificationUpdateZoomSlider = @"Update Zoom Slider";

#pragma mark - Private

@interface MFScrollView()

@property (assign, nonatomic) BOOL isLiveResizing;
@property (assign, nonatomic) BOOL imageHasLoaded;

@end

#pragma mark - Lifecycle

@implementation MFScrollView


- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)viewDidMoveToWindow
{
    self.minMagnification = 0.1;
    _isLiveResizing = NO;
    _imageHasLoaded = NO;
    [[self window] setDelegate:self];
}


- (void)setup
{
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
    
    if ([[notification name] isEqualToString:kNotificationChangeZoom]) {
        [self setMagnification:[notification.object floatValue]];
    }
    if ([[notification name] isEqualToString:kNotificationMockupFinishedRendering]) {
        [self handleMockupFinishedRendering];
    }
    if ([[notification name] isEqualToString:kNotificationToggleZoomToFit]) {
        [self handleZoomToFitToggled:notification.object];
    }
    if ([[notification name] isEqualToString:kNotificationUpdateMockup]) {
        self.imageHasLoaded = YES;
    }

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - resizing

- (void)handleMockupFinishedRendering
{
    [self zoomToFitWindowIfNeeded];
}

- (void)zoomToFitWindowIfNeeded
{
    if (self.imageHasLoaded) {
        NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
        if ([[defaults objectForKey:kNSUserDefaultsKeyZoomToFit] boolValue]) {
            [self zoomToFitWindow];
        }
    }
}

- (void)zoomToFitWindow
{
    NSView *docView = self.documentView;
    NSRect frame = self.contentView.frame;
    
    CGFloat newRatio = 0.0;
    CGFloat widthRatio =  CGRectGetWidth(frame) / CGRectGetWidth(docView.frame);
    CGFloat heightRatio =  CGRectGetHeight(frame) / CGRectGetHeight(docView.frame);
    
    if (widthRatio < heightRatio && widthRatio < 2.0) {
        newRatio = widthRatio;
    } else if (heightRatio < widthRatio && heightRatio < 2.0) {
        newRatio = heightRatio;
    }
    
    
    if (newRatio != 0.0) {
        
        // we only want to do zoom to values at every 10%, so reduce the ratio to the closest tick
        NSInteger intRatio = floorf(newRatio * 100);
        CGFloat mod = intRatio % 10;
        CGFloat reduceAmount = mod / 100;
        
        newRatio = newRatio - reduceAmount;
        
        // center point
        CGPoint centerPoint = CGPointZero;
        centerPoint.x = CGRectGetWidth(frame) / 2;
        centerPoint.y = CGRectGetHeight(frame) / 2;
        
        // magnify
        [self setMagnification:newRatio centeredAtPoint:centerPoint];
        NSNumber *ratio = [NSNumber numberWithFloat:newRatio];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateZoomSlider object:ratio];
    }
}



#pragma mark - Event Handling

- (void)handleZoomToFitToggled:(NSButton*)sender
{
    if (sender.state == NSOnState) {
        [self zoomToFitWindow];
    }
}


#pragma mark - NSWindowDelegate

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    return frameSize;
}

- (void)windowDidResize:(NSNotification *)notification
{
    if (!self.isLiveResizing) {
        [self zoomToFitWindowIfNeeded];
    }
}

- (void)windowWillStartLiveResize:(NSNotification *)notification
{
    self.isLiveResizing = YES;
}

- (void)windowDidEndLiveResize:(NSNotification *)notification
{
    self.isLiveResizing = NO;
    [self zoomToFitWindowIfNeeded];
}





@end
