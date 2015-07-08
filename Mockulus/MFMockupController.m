//
//  MFMockupController.m
//  Mockulus
//
//  Created by James Baker on 5/11/15.
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

#import "MFMockupController.h"
#import "MFMockup.h"

@implementation MFMockupController

#pragma mark - Lifecycle

+ (instancetype)sharedMFMockupController
{
    static dispatch_once_t predicate;
    static MFMockupController *instance = nil;
    dispatch_once(&predicate, ^{instance = [[self alloc] init];});
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Mockups-Private" ofType:@"plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
            file = [[NSBundle mainBundle] pathForResource:@"Mockups-Public" ofType:@"plist"];
        }
        _config = [[NSDictionary alloc] initWithContentsOfFile:file];
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSDictionary *mockups = _config[@"mockups"];
    _mockups = [NSMutableDictionary dictionary];
    for (NSDictionary *key in mockups) {
        MFMockup *mockup = [MFMockup mockupWithContentsOfDictionary:[mockups objectForKey:key]];
        _mockups[mockup.title] = mockup;
    }
}

@end
