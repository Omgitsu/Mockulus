//
//  MFDraggableImageView.m
//  Mockulus
//
//  Created by James Baker on 6/20/15.
//  Copyright (c) 2015 WDDG. All rights reserved.
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
// THE

#import "MFDraggableImageView.h"
#import "Utility.h"
#import "Macros.h"
#import "MFUserDefaultsController.h"
#import "MFOptionsPreferencesView.h"

@implementation MFDraggableImageView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
   _imageView = [[NSImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imageView];
    [_imageView display];
}

- (void)viewDidMoveToWindow
{
    // hacky workaround to set this view as a responder
    [[self window] performSelector:@selector(makeFirstResponder:) withObject:self afterDelay:0];
}

#pragma mark - Setters

- (void)setImage:(NSImage *)image
{
    CGRect imageViewFrame = NSRectMake(CGPointZero, image.size);
    _imageView.image = nil;
    _imageView.image = image;
    [_imageView setFrame:imageViewFrame];
    [_imageView setNeedsDisplay];
}

- (void)setDraggableImageFrame:(CGRect)draggableImageFrame
{
    _draggableImageFrame = [[self superview] convertRect:draggableImageFrame fromView:self];
}


#pragma mark - Mouse Events

- (BOOL)acceptsFirstMouse:(NSEvent *)e {
    return YES;
}




-(void)mouseDown:(NSEvent *)theEvent
{
    // convert the click location into the view coords
    NSPoint clickLocation = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL itemHit = [self isPointInSubview:clickLocation];
    BOOL itemDraggable = [self isItemDraggable];
    
    if (itemHit && itemDraggable) {
        self.dragging = YES;
        self.lastDragLocation = clickLocation;
        
        // set the cursor to the closed hand cursor
        // for the duration of the drag
        [[NSCursor closedHandCursor] push];
    }
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    if (self.dragging) {
        NSPoint newDragLocation = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
        
        CGFloat xOffset = ([self itemCanMoveHorizontally]) ? (newDragLocation.x - self.lastDragLocation.x) : 0;
        CGFloat yOffset = ([self itemCanMoveVertically]) ? (newDragLocation.y - self.lastDragLocation.y) : 0;
        
        [self offsetLocationByX:xOffset andY:yOffset];
        
        // save the new drag location for the next drag event
        self.lastDragLocation = newDragLocation;
    }
}


-(void)mouseUp:(NSEvent *)theEvent
{
    self.dragging = NO;
    
    // finished dragging, restore the cursor
    [NSCursor pop];
    
    // the item has moved, we need to reset our cursor
    // rectangle
    [[self window] invalidateCursorRectsForView:self];
}

#pragma mark - First Responder

- (BOOL)acceptsFirstResponder
{
    return YES;
}

#pragma mark - Keydown Events

-(IBAction)moveUp:(id)sender
{
    [self offsetLocationByX:0.0f andY: 10.0f];
    [[self window] invalidateCursorRectsForView:self];
}

-(IBAction)moveDown:(id)sender
{
    [self offsetLocationByX:0.0f andY:-10.0f];
    [[self window] invalidateCursorRectsForView:self];
}

-(IBAction)moveLeft:(id)sender
{
    [self offsetLocationByX:-10.0f andY:0.0f];
    [[self window] invalidateCursorRectsForView:self];
}

-(IBAction)moveRight:(id)sender
{
    [self offsetLocationByX:10.0f andY:0.0f];
    [[self window] invalidateCursorRectsForView:self];
}

#pragma mark - Cursor

-(void)resetCursorRects
{
    // remove the existing cursor rects
    [self discardCursorRects];
    
    // add the draggable item's bounds as a cursor rect
    CGFloat cursorX = CGRectGetMinX(self.imageView.frame);
    CGFloat cursorY = CGRectGetMinY(self.imageView.frame) + CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.draggableImageFrame);
    CGPoint cursorOrigin = CGPointMake(cursorX, cursorY);
    CGRect cursorRect = NSRectMake(cursorOrigin, self.draggableImageFrame.size);
    [self addCursorRect:cursorRect cursor:[NSCursor openHandCursor]];
    
}

#pragma mark - Hit Testing and Movement Contraints

- (BOOL)isPointInSubview:(NSPoint)testPoint
{
    BOOL itemHit = NSPointInRect(testPoint, self.draggableImageFrame);
    return itemHit;
}

- (BOOL)isItemDraggable
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSInteger scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
    
    if (scalingMode != MFOptionsScalingModeFillScreen) {
        return YES;
    }
    
    return NO;
}

- (BOOL)itemCanMoveVertically
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSInteger scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
    
    if (scalingMode == MFOptionsScalingModeNone || scalingMode == MFOptionsScalingModeWidth) {
        return YES;
    }
    
    return NO;
}

- (BOOL)itemCanMoveHorizontally
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSInteger scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
    
    if (scalingMode == MFOptionsScalingModeNone || scalingMode == MFOptionsScalingModeHeight) {
        return YES;
    }
    
    return NO;
}



#pragma mark - Movement

- (void)offsetLocationByX:(float)x andY:(float)y
{
    
    int invertDeltaY = [self isFlipped] ? -1: 1;
    CGFloat newX = self.imageView.frame.origin.x + x;
    CGFloat newY = self.imageView.frame.origin.y + y * invertDeltaY;
    [self.imageView setFrameOrigin:CGPointMake(newX, newY)];
    
    // move the draggableImageFrame
    CGPoint newDraggableImageFrameOrigin = CGPointMake(self.draggableImageFrame.origin.x + x, self.draggableImageFrame.origin.y + y * invertDeltaY);
    _draggableImageFrame = NSRectMake(newDraggableImageFrameOrigin, self.draggableImageFrame.size);
}

@end
