//
//  MFMainMenu.m
//  Mockulus
//
//  Created by James Baker on 6/1/15.
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

#import "MFMainMenu.h"
#import "MFMockupView.h"

NSString * const kNotificationSaveFile = @"Save File";

#pragma mark - Private

@interface MFMainMenu()

@property (weak) IBOutlet NSMenuItem *saveMenuItem;

- (IBAction)save:(id)sender;

@end

@implementation MFMainMenu

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    _saveMenuItem.enabled = NO;
    [self addObservers];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:kNotificationUpdateMockup]) {
        [self enableSaveMenuItem];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileStarted]) {
        [self disableSaveMenuItem];
    }
    if ([[notification name] isEqualToString:kNotificationSaveFileCompleted]) {
        [self enableSaveMenuItem];
    }
}

#pragma mark - Menu Item Management

- (void)enableSaveMenuItem
{
    self.saveMenuItem.enabled = YES;
}

- (void)disableSaveMenuItem
{
    self.saveMenuItem.enabled = NO;
}

#pragma mark - Actions

- (IBAction)save:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSaveFile object:nil];
}

- (IBAction)showAboutWindow:(id)sender
{
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    self.aboutWindow = [storyBoard instantiateControllerWithIdentifier:@"AboutWindowController"]; // instantiate your window controller

//    self.aboutWindow = [[MFAboutWindowController alloc] initWithWindowNibName:@"MFAboutWindowController"];
    [self.aboutWindow showWindow:self];
}

@end
