//
//  NSImage+Additions.h
//  Mockulus
//
//  Created by James Baker on 6/9/15.
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


#import <Cocoa/Cocoa.h>

#pragma mark - Save as PNG

//  NSImage(WritePNG)

@interface NSImage(WritePNG)

- (BOOL)writePNGToURL:(NSURL*)URL outputScaling:(NSNumber*)scaling error:(NSError*__autoreleasing*)error;

@end


@interface NSImage(Resize)

- (NSImage*)resizeToScale:(NSNumber*)scale;
- (NSImage*)resizeImage:(NSImage*)sourceImage scale:(NSNumber*)scale;
- (NSImage*)resizeImage:(NSImage*)sourceImage toSize:(NSSize)newSize interpolation:(NSImageInterpolation)interpolation;

@end

#pragma mark - Masking

//  NSImage(Mask)

@interface NSImage(Mask)


/*!
 @brief  Returns a new image by using the maskImage for masking the caller object.
 @param maskImage
 Image used for masking. Please note that the mask image cannot have alpha channels, so e.g. PNG files with transparent pixels won't work.
 @return
 A new image created by masking the original one.
 */
- (NSImage *)maskUsingMaskImage:(NSImage *)maskImage;

@end


@interface NSImage(Clear)

+ (NSImage*)clearImageWithSize:(NSSize)size;

@end

#pragma mark - Conversions

// NSImage(Conversions)

@interface NSImage(Conversions)

- (CIImage*)ciImage;
- (CIImage*)ciImageForImage:(NSImage*)image;
- (CGImageRef)cgImageRef;
- (CGImageRef)cgImageRefForImage:(NSImage*)image;

@end

#pragma mark - Rotation

// NSImage(Rotation)
//  https://gist.github.com/Rm1210/10621763

@interface NSImage(Rotation)

/*!
 @brief  Rotates an image clockwise around its center by a given
 angle in degrees and returns the new image.
 
 @details  The width and height of the returned image are,
 respectively, the height and width of the receiver.
 
 */
- (NSImage*)imageRotatedByDegrees:(float)degrees;

@end

#pragma mark - Representation

// NSImage(Representation)
//  https://gist.github.com/Rm1210/10621763

@interface NSImage(Representation)

/*!
 @brief  Returns a NSBitmapImageRep for the image
 */
- (NSBitmapImageRep *)bitmapImageRepresentation;

/*!
 @brief  Returns an unscaled NSBitmapImageRep for the image
 */
-(NSBitmapImageRep *)unscaledBitmapImageRep;

@end
