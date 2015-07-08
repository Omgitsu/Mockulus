//
//  MFImageCompositor.m
//  Mockulus
//
//  Created by James Baker on 5/24/15.
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
//  references:
//  http://stackoverflow.com/questions/11261501/sub-pixel-anti-aliasing-in-nsbitmapimagerep
//  http://stackoverflow.com/questions/14068306/convert-nstextfield-to-nsimage
//  http://www.stairways.com/blog/2009-04-21-nsimage-from-nsview

#import "MFViewCompositor.h"
#import "Macros.h"
#import "Utility.h"
#import "MFImageView.h"

#pragma mark - Private

@interface MFViewCompositor()

@property (strong, nonatomic) NSArray *viewList;
@property (strong, nonatomic) NSView *superview;

@end

@implementation MFViewCompositor

#pragma mark - Lifecycle

+ (instancetype)compositorWithViews:(NSArray *)views superview:(NSView*)superview
{
    return [[MFViewCompositor alloc] initCompositorWithViews:views superview:superview];
}

+ (instancetype)compositor
{
    return [[MFViewCompositor alloc] init];
}

- (instancetype)initCompositorWithViews:(NSArray *)views superview:(NSView*)superview;
{
    self = [super init];
    if (self) {
        _viewList = views;
        _superview = superview;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // pass
    }
    return self;
}

#pragma mark - Composition


- (NSArray*)viewsOrderedByZIndexFromArray:(NSArray*)views
{
    NSMutableArray *orderedList = [NSMutableArray array];
    NSArray *subviews = self.superview.subviews;
    
    for (NSView *view in subviews) {
        if ([views containsObject:view]) {
            [orderedList addObject:view];
        }
    }
    
    return orderedList;
}

- (NSImage*)imageForView:(id)someView
{
    NSView *view = someView;
    NSRect myRect = view.bounds;
    NSSize imgSize = myRect.size;
    
    if ([someView isKindOfClass:[MFImageView class]])
    {
        [(MFImageView*)view setRendering:YES];
    }
    
    NSImage* image = [[NSImage alloc]initWithSize:imgSize];
    
    if (!view.hidden) {
        
        NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc]
                                    initWithBitmapDataPlanes:NULL
                                    pixelsWide:imgSize.width * 4
                                    pixelsHigh:imgSize.height * 4
                                    bitsPerSample:8
                                    samplesPerPixel:4
                                    hasAlpha:YES
                                    isPlanar:NO
                                    colorSpaceName:NSCalibratedRGBColorSpace
                                    bytesPerRow:0
                                    bitsPerPixel:0];
        
        [bitmap setSize:imgSize];
        [view cacheDisplayInRect:myRect toBitmapImageRep:bitmap];
        [image addRepresentation:bitmap];
    }
    
    if ([someView isKindOfClass:[MFImageView class]])
    {
        [(MFImageView*)view setRendering:NO];
    }
    
    return image;
}

- (CGRect)unionFrameForViews:(NSArray*)views
{
    CGRect unionFrame = CGRectZero;
    for (NSView *view in views) {
        unionFrame = CGRectUnion(unionFrame, view.frame);
    }
    return unionFrame;
}

- (NSImage*)compositeViews:(NSArray*)views offset:(NSSize)offset
{
    CGRect compFrame = [self unionFrameForViews:views];
    compFrame = CGRectOffset(compFrame, offset.width, offset.height);
    
    
    NSImage *comp = [NSImage imageWithSize:compFrame.size flipped:NO drawingHandler:nil];
    [comp lockFocus];
    for (NSView *view in views) {
        
        CGRect fillRect = view.frame;
        fillRect = CGRectOffset(fillRect, CGRectGetMinX(compFrame), CGRectGetMinY(compFrame));
        NSImage *image = [self imageForView:view];
        NSImageInterpolation renderInterpolation = NSImageInterpolationNone;
        
        // default to MFImageView's desired interpolation
        if ([view isKindOfClass:[MFImageView class]]) {
            renderInterpolation = ((MFImageView*)view).renderInterpolation;
        }
        
        // always render textfields at high
        if ([view isKindOfClass:[NSTextField class]]) {
            renderInterpolation = NSImageInterpolationHigh;
        }
        
        [NSGraphicsContext saveGraphicsState];
        [[NSGraphicsContext currentContext] setImageInterpolation:renderInterpolation];
        [image drawInRect:fillRect];
        [NSGraphicsContext restoreGraphicsState];
    }
    
    [comp unlockFocus];
    return comp;
}

- (NSImage*)compositeViews
{
    NSArray *views = [self viewsOrderedByZIndexFromArray:self.viewList];
    return [self compositeViews:views offset:CGSizeZero];
}


@end
