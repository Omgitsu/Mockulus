//
//  NSWindow+Additions.m
//  Framer2000
//
//  Created by James Baker on 4/29/15.
//  Copyright (c) 2015 WDDG. All rights reserved.
//

#import "NSWindow+Additions.h"

@implementation NSWindow(Additions)

- (CGFloat)toolbarHeight {
    NSToolbar *toolbar = [self toolbar];
    CGFloat toolbarHeight = 0.0;
    NSRect windowFrame;
    
    if (toolbar && [toolbar isVisible]) {
        windowFrame = [[self class] contentRectForFrameRect:[self frame]
                                                  styleMask:[self styleMask]];
        toolbarHeight = NSHeight(windowFrame) -
        NSHeight([[self contentView] frame]);
    }
    return toolbarHeight;
}

- (void)resizeToSize:(NSSize)newSize animate:(BOOL)animate {
    
    NSRect newFrame = [self windowFrameForSize:newSize];
    [self setFrame:newFrame display:YES animate:animate];
}

- (NSRect)windowFrameForSize:(NSSize)newSize {
    CGFloat newHeight = newSize.height + [self toolbarHeight];
    CGFloat newWidth = newSize.width;
    
    NSRect newFrame = [[self class] contentRectForFrameRect:[self frame]
                                                styleMask:[self styleMask]];
    
    newFrame.origin.y += newFrame.size.height;
    newFrame.origin.y -= newHeight;
    newFrame.size.height = newHeight;
    newFrame.size.width = newWidth;
    
    newFrame = [[self class] frameRectForContentRect:newFrame
                                         styleMask:[self styleMask]];
    return newFrame;
}

@end
