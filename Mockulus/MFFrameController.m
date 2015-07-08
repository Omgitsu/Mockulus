//
//  MFFrameController.m
//  Mockulus
//
//  Created by James Baker on 5/22/15.
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

#import "MFFrameController.h"
#import "MFFrame.h"

@implementation MFFrameController

#pragma mark - Lifecycle

+ (instancetype)sharedMFFrameController
{
    static dispatch_once_t predicate;
    static MFFrameController *instance = nil;
    dispatch_once(&predicate, ^{instance = [[self alloc] init];});
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Frames-Private" ofType:@"plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
            file = [[NSBundle mainBundle] pathForResource:@"Frames-Public" ofType:@"plist"];
        }
        _config = [[NSDictionary alloc] initWithContentsOfFile:file];
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSDictionary *frames = _config[@"frames"];
    _frames = [NSMutableDictionary dictionary];
    for (NSDictionary *key in frames) {
        MFFrame *frame = [MFFrame frameWithContentsOfDictionary:[frames objectForKey:key]];
        _frames[frame.title] = frame;
    }
}

@end
