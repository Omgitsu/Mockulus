//
//  MFDragDropImageView.m
//
//  Created by James Baker
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


#import "MFDragDropImageView.h"
#import "MFDocument.h"
#import "AppDelegate.h"
#import "MFMockupView.h"
#import "MFMockupImage.h"

#pragma mark - Private

@interface MFDragDropImageView()

@property (assign, nonatomic) BOOL highlight;
@property (copy, nonatomic) NSString *privateDragUTI;

@end

@implementation MFDragDropImageView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}


- (void)setup
{
    _privateDragUTI = @"com.WDDG.Mockulus";
    [self registerForDraggedTypes:[NSImage imageTypes]];
}


#pragma mark - NSDragging Protocols

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]] && [sender draggingSourceOperationMask] & NSDragOperationCopy) {
        self.highlight = YES;
        
        [self setNeedsDisplay: YES];
        [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent forView:self classes:[NSArray arrayWithObject:[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
            
            if (![[[draggingItem item] types] containsObject:self.privateDragUTI]) {
                *stop = YES;
            } else {
                [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
            }
            
        }];
        
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}


- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    self.highlight = NO;
    [self setNeedsDisplay:YES];
}


- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    self.highlight = NO;
    [self setNeedsDisplay:YES];
    return [NSImage canInitWithPasteboard:[sender draggingPasteboard]];
}


- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    if ([sender draggingSource] != self) {
        
        NSPasteboard *pboard = [sender draggingPasteboard];
        NSString *plist = [pboard stringForType:NSFilenamesPboardType];
        NSString *fileName;
        
        if (plist) {
            NSArray *files = [NSPropertyListSerialization propertyListWithData:[plist dataUsingEncoding:NSUTF8StringEncoding] options:NSPropertyListImmutable format:nil error:nil];
            
            if ([files count] == 1) {
                fileName = [[files objectAtIndex: 0] lastPathComponent];
            }
        }
        
        if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]]) {
            NSImage *newImage = [[NSImage alloc] initWithPasteboard:[sender draggingPasteboard]];
            if (newImage && fileName) {
                NSDictionary *imageInfo = @{@"image": newImage, @"imageFileName": fileName};
                [self handleNewDocumentDroppedOntoDropView:imageInfo];
            }
        }
    }
    
    return YES;
}

// requred for performDragOperation to fire
- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    // pass
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame
{
    NSRect ContentRect = self.window.frame;
    ContentRect.size = [self image].size;
    return [NSWindow frameRectForContentRect:ContentRect styleMask:[window styleMask]];
};


#pragma mark - New Document Handling

- (void)handleNewDocumentDroppedOntoDropView:(NSDictionary*)document
{
    [self setNewImage:document[@"image"] fileName:document[@"imageFileName"]];
}

- (void)setNewImage:(NSImage*)newImage fileName:(NSString*)fileName
{
    TICK;
    MFMockupImage *image = [MFMockupImage mockupImageWithImage:newImage fileName:fileName];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateMockup object:image];
    FTOCK(@"MFDragDropImageView:setImage:complete");
    
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.highlight) {
        [[NSColor grayColor]set];
        [NSBezierPath setDefaultLineWidth:5];
        [NSBezierPath strokeRect:dirtyRect];
    }
}

#pragma mark - Resizing

// we resize the frame and replace our image with a blank image to keep the drag and drop working
// this is also used for auto layout and window resizing
// this is called from MFMockupView

- (void)resizeFrame:(NSValue*)value
{
    NSSize size = [value sizeValue];
    
    NSImage *comp = [NSImage imageWithSize:size flipped:NO drawingHandler:nil];
    self.image = nil;
    self.image = comp;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    
}

@end
