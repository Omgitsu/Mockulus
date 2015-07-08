//
//  NSWindow+Additions.h
//  Framer2000
//
//  Created by James Baker on 4/29/15.
//  Copyright (c) 2015 WDDG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow(Additions)

- (CGFloat)toolbarHeight;
- (void)resizeToSize:(NSSize)newSize animate:(BOOL)animate;
- (NSRect)windowFrameForSize:(NSSize)size;

@end
