//
//  NSImage+Additions.m
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
//

#import <QuartzCore/QuartzCore.h>
#import "NSImage+Additions.h"
#import "Macros.h"

#pragma mark - Save as PNG

@implementation NSImage(WritePNG)

- (BOOL)writePNGToURL:(NSURL*)URL outputScaling:(NSNumber*)scaling error:(NSError*__autoreleasing*)error
{
    
    BOOL result = YES;
    
    NSImage *image = self;
    NSData  *tiffData = [image TIFFRepresentation];
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    
    // create CIImage from bitmap
    CIImage *ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:kCIInputAspectRatioKey];
    [filter setValue:scaling forKey:kCIInputScaleKey];
    CIImage *outputImage = [filter outputImage];
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *scaledImage = [[NSImage alloc] initWithSize:rep.size];
    [scaledImage addRepresentation:rep];
    
    NSData *imageData = [scaledImage TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    [imageData writeToURL:URL atomically:NO];
    
    return result;
}

@end


#pragma mark - NSImage(Resize)

@implementation NSImage(Resize)

- (NSImage*)resizeToScale:(NSNumber*)scale;
{
    NSData  *tiffData = [self TIFFRepresentation];
    NSBitmapImageRep * bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    
    // create CIImage from bitmap
    CIImage *image = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:kCIInputAspectRatioKey];
    [filter setValue:scale forKey:kCIInputScaleKey];
    
    CIImage *outputImage = [filter outputImage];
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *newImage = [[NSImage alloc] initWithSize:rep.size];
    [newImage addRepresentation:rep];
    
    return newImage;
}

- (NSImage*)resizeImage:(NSImage*)sourceImage scale:(NSNumber*)scale;
{

    NSData  *tiffData = [sourceImage TIFFRepresentation];
    NSBitmapImageRep * bitmap = [NSBitmapImageRep imageRepWithData:tiffData];

    // create CIImage from bitmap
    CIImage *image = [[CIImage alloc] initWithBitmapImageRep:bitmap];

    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:kCIInputAspectRatioKey];
    [filter setValue:scale forKey:kCIInputScaleKey];

    CIImage *outputImage = [filter outputImage];

    // 4
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *newImage = [[NSImage alloc] initWithSize:rep.size];
    [newImage addRepresentation:rep];
    
    return newImage;
}

- (NSImage*)resizeImage:(NSImage*)sourceImage toSize:(NSSize)newSize interpolation:(NSImageInterpolation)interpolation
{
    if ([sourceImage isValid]){
        NSImage *newImage = [NSImage imageWithSize:newSize flipped:NO drawingHandler:nil];
        [newImage lockFocus];
        [NSGraphicsContext saveGraphicsState];
        NSImageInterpolation imageInterpolation = (interpolation) ? interpolation : NSImageInterpolationHigh;
        [[NSGraphicsContext currentContext] setImageInterpolation:imageInterpolation];
        [sourceImage drawInRect:NSRectMake(CGPointZero, newSize)];
        [NSGraphicsContext restoreGraphicsState];
        [newImage unlockFocus];
        return newImage;
    }
    return nil;
}

@end


#pragma mark - Masking

@implementation NSImage(Mask)

- (NSImage*)maskUsingMaskImage:(NSImage *)maskImage
{

    if (maskImage == nil) return self;
    
    // create CIImage from bitmap
    CIImage *ciInputImage = [self ciImage];
    CIImage *ciMaskImage = [maskImage ciImage];
    CIImage *ciBackgroundImage = [[NSImage clearImageWithSize:[ciInputImage extent].size] ciImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];
    [filter setValue:ciInputImage forKey:kCIInputImageKey];
    [filter setValue:ciMaskImage forKey:kCIInputMaskImageKey];
    [filter setValue:ciBackgroundImage forKey:kCIInputBackgroundImageKey];
    CIImage *outputImage = [filter outputImage];
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *maskedImage = [[NSImage alloc] initWithSize:rep.size];
    [maskedImage addRepresentation:rep];
    
    return maskedImage;
}

@end


#pragma mark - Clear Images

@implementation NSImage(Clear)


+ (NSImage*)clearImageWithSize:(NSSize)size
{
    NSImage *image = [NSImage imageWithSize:size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [[NSColor clearColor] set];
        NSRectFill(dstRect);
        return YES;
    }];
    return image;
}

@end


#pragma mark - Conversions

@implementation NSImage(Conversions)


- (CIImage*)ciImage
{
    return [self ciImageForImage:self];
}


- (CIImage*)ciImageForImage:(NSImage*)image
{
    NSData  *tiffData = [image TIFFRepresentation];
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    CIImage *ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    return ciImage;
}


- (CGImageRef)cgImageRef
{
    return [self cgImageRefForImage:self];
}


- (CGImageRef)cgImageRefForImage:(NSImage *)image
{
    NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
    CGImageRef cgImage = [image CGImageForProposedRect:&imageRect context:NULL hints:nil];
    return cgImage;
}


@end

#pragma mark - Rotation

// NSImage(Rotation)
//  https://gist.github.com/Rm1210/10621763

@implementation NSImage(Rotation)

- (NSImage *)imageRotatedByDegrees:(float)degrees {
    
    degrees = fmod(degrees, 360.);
    if (0 == degrees) {
        return self;
    }
    NSSize size = [self size];
    NSSize maxSize;
    if (90. == degrees || 270. == degrees || -90. == degrees || -270. == degrees) {
        maxSize = NSMakeSize(size.height, size.width);
    } else if (180. == degrees || -180. == degrees) {
        maxSize = size;
    } else {
        maxSize = NSMakeSize(20+MAX(size.width, size.height), 20+MAX(size.width, size.height));
    }
    
    NSAffineTransform *rot = [NSAffineTransform transform];
    [rot rotateByDegrees:degrees];
    NSAffineTransform *center = [NSAffineTransform transform];
    [center translateXBy:maxSize.width / 2. yBy:maxSize.height / 2.];
    [rot appendTransform:center];
    NSImage *image = [[NSImage alloc] initWithSize:maxSize];
    [image lockFocus];
    [rot concat];
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    NSPoint corner = NSMakePoint(-size.width / 2., -size.height / 2.);
    [self drawAtPoint:corner fromRect:rect operation:NSCompositeCopy fraction:1.0];
    [image unlockFocus];
    
    return image;
}

@end


#pragma mark - Representation

// NSImage(Representation)
//  https://gist.github.com/Rm1210/10621763

@implementation NSImage(Representation)

- (NSBitmapImageRep *)bitmapImageRepresentation
{
    
    NSInteger width = [self size].width;
    NSInteger height = [self size].height;
    
    if (width < 1 || height < 1) return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [self drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}

-(NSBitmapImageRep *)unscaledBitmapImageRep {
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:self.size.width
                             pixelsHigh:self.size.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSDeviceRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    rep.size = self.size;
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawAtPoint:NSMakePoint(0, 0)
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0];
    
    [NSGraphicsContext restoreGraphicsState];
    return rep;
}

@end



