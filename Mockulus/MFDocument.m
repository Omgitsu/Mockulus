//
//  MFDocument.m
//  Mockulus
//
//  Created by James Baker on 6/7/15.
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

#import "MFDocument.h"
#import "MFMockupView.h"
#import "MFMockupImage.h"

NSString * const kNotificationNewDocumentOpened = @"A new document has been opened with the file dialogue";

@implementation MFDocument

#pragma mark - NSDocument Overrides

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return nil;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    BOOL readSuccess = NO;
    NSImage *newImage = [[NSImage alloc] initWithContentsOfURL:url];
    NSString *fileName = [[url absoluteString] lastPathComponent];
    
    if (!newImage && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:nil];
    }
    if (newImage) {
        readSuccess = YES;
        MFMockupImage *image = [MFMockupImage mockupImageWithImage:newImage fileName:fileName];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateMockup object:image];
    }
    return readSuccess;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

@end
