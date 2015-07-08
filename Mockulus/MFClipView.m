//
//  MFClipView.m
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

#import "MFClipView.h"

#pragma mark - Private

@interface MFClipView()

@property (atomic, assign) BOOL centersDocumentView;

@end

@implementation MFClipView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

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
    _centersDocumentView = YES;
}


#pragma mark - Bounds

// http://stackoverflow.com/questions/22072105/how-do-you-get-nsscrollview-to-center-the-document-view-in-10-9-and-later/22072106#22072106

- (NSRect)constrainBoundsRect:(NSRect)proposedViewBoundsRect {
    
    NSRect constrainedViewBoundsRect = [super constrainBoundsRect:proposedViewBoundsRect];
    
    // Early out if you want to use the default NSClipView behavior.
    if (self.centersDocumentView == NO) {
        return constrainedViewBoundsRect;
    }
    
    NSRect documentViewFrameRect = [self.documentView frame];
    
    // If proposed clip view bounds width is greater than document view frame width, center it horizontally.
    if (proposedViewBoundsRect.size.width >= documentViewFrameRect.size.width) {
        // Adjust the proposed origin.x
        constrainedViewBoundsRect.origin.x = centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension(proposedViewBoundsRect.size.width, documentViewFrameRect.size.width);
    }
    
    // If proposed clip view bounds is hight is greater than document view frame height, center it vertically.
    if (proposedViewBoundsRect.size.height >= documentViewFrameRect.size.height) {
        
        // Adjust the proposed origin.y
        constrainedViewBoundsRect.origin.y = centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension(proposedViewBoundsRect.size.height, documentViewFrameRect.size.height);
    }
    
    return constrainedViewBoundsRect;
}


CGFloat centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension(CGFloat proposedContentViewBoundsDimension,
                                                                                                  CGFloat documentViewFrameDimension )
{
    CGFloat result = floor( (proposedContentViewBoundsDimension - documentViewFrameDimension) / -2.0F );
    return result;
}

@end
