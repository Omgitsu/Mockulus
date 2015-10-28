//
//  WindowController.m
//  Mockulus
//
//  Created by James Baker on 4/30/15.
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

#import "WindowController.h"
#import "MFMockupView.h"
#import "MFMainMenu.h"
#import "MFScrollView.h"
#import "MFUserDefaultsController.h"
#import "MFDocument.h"
#import "AppDelegate.h"

NSInteger const kInitialWindowHeight = 500;
NSInteger const kInitialWindowWidth = 500;
NSInteger const kSidebarWidth = 170;
NSString * const kNotificationWindowResized = @"The main window has changed size";
NSString * const kNotificationToggleSidebar = @"Toggle SideBar";
NSString * const kNotificationToggleZoomToFit = @"Toggle Zoom to Fit";
NSString * const kNotificationToggleInfoBar = @"Toggle the Info Bar";
NSString * const kNotificationChangeZoom = @"Change Zoom";

typedef NS_ENUM(NSInteger, WindowControllerControlPosition) {
    WindowControllerControlSegmentToggleInfo,
    WindowControllerControlSegmentToggleOptions,
};

@interface WindowController()

@property (assign, nonatomic) BOOL windowHasManuallyResized;
@property (assign, nonatomic) BOOL windowHasResized;
@property (assign, nonatomic) BOOL windowResizesToFitContent;

@end

@implementation WindowController

#pragma mark - Lifecycle

- (void)windowDidLoad
{
    [self setup];
}

- (void)setup {


    [_zoomSlider setTarget:self];
    [_zoomSlider setAction:@selector(sliderValueChanged:)];
    _saveButton.hidden = YES;
    _zoomSlider.hidden = YES;
    _sliderValueLabel.hidden = YES;
    _sliderValueLabel.stringValue = @"100%";
    _windowHasManuallyResized = NO;
    _windowHasResized = NO;
    _windowResizesToFitContent = NO;
    
    
    
    MFUserDefaultsController *defaults = [MFUserDefaultsController sharedController];
    _sideBarVisible = [[defaults valueForKey:kNSUserDefaultsKeyShowOptionsPanel] boolValue];
    _infoBarVisible = [[defaults valueForKey:kNSUserDefaultsKeyShowOptionsPanel] boolValue];
    
    [self addObservers];
    
    [self toggleSelectedSegmentImages];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if ([[notification name] isEqualToString:kNotificationUpdateMockup]) {
        [self toggleSaveButton];
    }
    if ([[notification name] isEqualToString:kNotificationUpdateZoomSlider]) {
        [self updateZoomSlider:notification.object];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileStarted]) {
        [self disableSaveButton];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileCompleted]) {
        [self enableSaveButton];
    }
    if ([[notification name] isEqualToString:kNotificationNewDocumentOpened]) {
        [self displayWindow];
    }
    if ([[notification name] isEqualToString:kNotificationNewDocumentDroppedOntoAppIcon]) {
        [self displayWindow];
    }
}


#pragma mark - Window Resizing

- (void)resizeWindow:(NSValue*)value
{
    
    if (!self.windowHasResized && self.windowResizesToFitContent) {
        
        NSSize size = [value sizeValue];
        CGFloat compWidth = size.width;
        CGFloat compHeight = size.height;
        
        NSWindow *window = [self window];
        NSScreen *screen = [self window].screen;
        NSRect screenRect = [screen visibleFrame];
        NSRect rectCurrentFrame = [window frame];
        NSRect proposedFrame = rectCurrentFrame;
        
        proposedFrame.size = CGSizeMake(compWidth, compHeight);
        proposedFrame = [window frameRectForContentRect:proposedFrame];
        
        // deal with the difference in size between the frame and window sizes
        
        CGFloat yOffsetWindow = CGRectGetHeight([window frameRectForContentRect:CGRectMake(0, 0, 100, 100)]) - CGRectGetHeight([window contentRectForFrameRect:CGRectMake(0, 0, 100, 100)]);
        
        CGFloat xOffsetWindow = CGRectGetWidth([window frameRectForContentRect:CGRectMake(0, 0, 100, 100)]) - CGRectGetWidth([window contentRectForFrameRect:CGRectMake(0, 0, 100, 100)]) + kSidebarWidth;
        
        proposedFrame.origin.y = CGRectGetMinY(rectCurrentFrame) - compHeight + CGRectGetHeight(rectCurrentFrame) - (yOffsetWindow / 2);
        proposedFrame.size.width = CGRectGetWidth(proposedFrame) + xOffsetWindow;
        
        if (proposedFrame.size.width >= CGRectGetWidth(screenRect)) {
            proposedFrame.size.width = CGRectGetWidth(screenRect);
            proposedFrame.origin.x = CGRectGetMinX(screenRect);
        }
        
        if (proposedFrame.size.height >= CGRectGetHeight(screenRect)) {
            proposedFrame.size.height = CGRectGetHeight(screenRect);
            proposedFrame.origin.y = CGRectGetMinY(screenRect);
        }
        
        if (![self rightFrameEdgeIsOnScreen:proposedFrame]) {
            // shift the x position to the left by the ammount it's offscreen
            CGFloat rightEdgePosition = CGRectGetMinX(proposedFrame) + CGRectGetWidth(proposedFrame);
            CGFloat rightScreenEdgePosition = CGRectGetMinX(screenRect) + CGRectGetWidth(screenRect);
            proposedFrame.origin.x = CGRectGetMinX(proposedFrame) + rightScreenEdgePosition - rightEdgePosition;
        }
        
        if (![self bottomFrameEdgeIsOnScreen:proposedFrame]) {
            // set the bottom origin to be the screen origin.y
            proposedFrame.origin.y = CGRectGetMinY(screenRect);
        }
        
        if (![self topFrameEdgeIsOnScreen:proposedFrame]) {
            // move the frame down by diff of top edge and screen top edge
            CGFloat topEdgePosition = CGRectGetMinY(proposedFrame) + CGRectGetHeight(proposedFrame);
            CGFloat topEdgeScreenPosition = CGRectGetMinY(screenRect) + CGRectGetHeight(screenRect);
            proposedFrame.origin.y = CGRectGetMinY(proposedFrame) + topEdgeScreenPosition - topEdgePosition;
        }
        
        // only resize window if we are sizing up
        if (CGRectGetWidth(rectCurrentFrame) < CGRectGetWidth(proposedFrame)
            || CGRectGetHeight(rectCurrentFrame) < CGRectGetHeight(proposedFrame)) {
            [window setFrame:proposedFrame display:YES animate:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWindowResized object:nil];
        }
        
    }
    
}

- (BOOL)rightFrameEdgeIsOnScreen:(NSRect)frame
{
    NSScreen *myScreen = [self window].screen;
    NSRect screenRect = [myScreen visibleFrame];
    CGFloat rightEdgePosition = CGRectGetMinX(frame) + CGRectGetWidth(frame);
    CGFloat rightScreenEdgePosition = CGRectGetMinX(screenRect) + CGRectGetWidth(screenRect);
    
    return rightEdgePosition <= rightScreenEdgePosition;
}

- (BOOL)topFrameEdgeIsOnScreen:(NSRect)frame
{
    NSScreen *myScreen = [self window].screen;
    NSRect screenRect = [myScreen visibleFrame];
    CGFloat topEdgePosition = CGRectGetMinY(frame) + CGRectGetHeight(frame);
    CGFloat topScreenEdgePosition = CGRectGetMinY(screenRect) + CGRectGetHeight(screenRect);
    
    return topEdgePosition <= topScreenEdgePosition;
}

- (BOOL)bottomFrameEdgeIsOnScreen:(NSRect)frame
{
    NSScreen *myScreen = [self window].screen;
    NSRect screenRect = [myScreen visibleFrame];
    CGFloat bottomEdgePosition = CGRectGetMinY(frame);
    CGFloat bottomScreenEdgePosition = CGRectGetMinY(screenRect);
    return bottomEdgePosition >= bottomScreenEdgePosition;
}

- (BOOL)leftFrameEdgeIsOnScreen:(NSRect)frame
{
    NSScreen *myScreen = [self window].screen;
    NSRect screenRect = [myScreen visibleFrame];
    CGFloat leftEdgePosition = CGRectGetMinX(frame);
    CGFloat leftScreenEdgePosition = CGRectGetMinX(screenRect);
    
    return leftEdgePosition >= leftScreenEdgePosition;
}

#pragma mark - Button Management

- (void)toggleSaveButton
{
    self.saveButton.hidden = NO;
    self.zoomSlider.hidden = NO;
    self.sliderValueLabel.hidden = NO;
}

- (void)enableSaveButton
{
    self.saveButton.enabled = YES;
    self.saveButton.hidden = NO;
}

- (void)disableSaveButton
{
    self.saveButton.enabled = NO;
    self.saveButton.hidden = YES;
}

#pragma mark - Actions

- (void)displayWindow
{
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)toggleVisibility:(NSSegmentedControl*)sender
{
    switch (sender.selectedSegment) {
        case WindowControllerControlSegmentToggleInfo:
            [self toggleInfoBar];
            break;
            
        case WindowControllerControlSegmentToggleOptions:
            [self toggleSideBar];
            break;
    }
    [self toggleSelectedSegmentImages];
}

- (void)updateZoomSlider:(NSNumber*)value
{
    self.zoomSlider.floatValue = [value floatValue];
    NSInteger labelValue = floorf([value floatValue] * 100);
    self.sliderValueLabel.stringValue = [NSString stringWithFormat:@"%ld%%",(long)labelValue];
}

- (IBAction)toggleZoomToFit:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleZoomToFit object:sender];
}

- (void)sliderValueChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeZoom object:sender];
    NSInteger labelValue = floorf([sender floatValue] * 100);
    self.sliderValueLabel.stringValue = [NSString stringWithFormat:@"%ld%%",(long)labelValue];
}

- (void)toggleInfoBar
{
    MFUserDefaultsController *defaults = [MFUserDefaultsController sharedController];
    [defaults flipBooleanForKey:kNSUserDefaultsKeyShowInfoPanel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleInfoBar object:nil];
}

- (void)toggleSelectedSegmentImages
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *bottomDrawerImageName = @"bottom-drawer-";
    NSString *rightDrawerImageName = @"right-drawer-";
    
    if ([[defaults valueForKey:kNSUserDefaultsKeyShowInfoPanel] boolValue]) {
        bottomDrawerImageName = [bottomDrawerImageName stringByAppendingString:@"on"];
    } else {
        bottomDrawerImageName = [bottomDrawerImageName stringByAppendingString:@"off"];
    }
    
    if ([[defaults valueForKey:kNSUserDefaultsKeyShowOptionsPanel] boolValue]) {
        rightDrawerImageName = [rightDrawerImageName stringByAppendingString:@"on"];
    } else {
        rightDrawerImageName = [rightDrawerImageName stringByAppendingString:@"off"];
    }
    
    NSImage *bottomDrawerImage = [NSImage imageNamed:bottomDrawerImageName];
    NSImage *rightDrawerImage = [NSImage imageNamed:rightDrawerImageName];
    
    [self.visibilityControl setImage:bottomDrawerImage forSegment:WindowControllerControlSegmentToggleInfo];
    [self.visibilityControl setImage:rightDrawerImage forSegment:WindowControllerControlSegmentToggleOptions];
}

- (void)toggleSideBar
{
    MFUserDefaultsController *defaults = [MFUserDefaultsController sharedController];
    [defaults flipBooleanForKey:kNSUserDefaultsKeyShowOptionsPanel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleSidebar object:nil];
}

- (IBAction)saveButtonDidExecute:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSaveFile object:nil];
}


@end
