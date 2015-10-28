//
//  AppDelegate.m
//  Mockulus
//
//  Created by James Baker on 4/29/15.
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

#import "AppDelegate.h"
#import "MFMockupView.h"
#import "WindowController.h"
#import "MFOptionsPreferencesView.h"
#import "MFUserDefaultsController.h"
#import "MFMockupImage.h"

NSString * const kCopyrightNotice = @"Copyright © WDDG, Inc.";
NSString * const kTrademarkNotice = @"Apple, the Apple logo, MacBook, MacBook Air, MacBook Pro, iMac, iPhone, iPad, Apple Watch, OS X, Thunderbolt Display and Safari are trademarks of Apple Inc., registered in the U.S. and other countries. All trademarks and registered trademarks are the property of their respective owners.";
NSString * const kProjectURL = @"https://github.com/Omgitsu/mockulus";
NSString * const kNotificationNewDocumentDroppedOntoAppIcon = @"A new document has been dropped onto the application icon";
NSString * const kNotificationApplicationLaunched = @"Application Launched";

// testing flags
BOOL const kDebugResetUserDefaults = NO;
BOOL const kDebugDeactivateLicense = NO;
BOOL const kDebugLogUserDefaults = NO;


@implementation AppDelegate

#pragma mark - Lifecycle

+ (void)initialize
{
    [self initDefaults];
    if (kDebugResetUserDefaults) {
        [self resetUserDefaults];
    }
    [super initialize];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
#if DEBUG
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
#endif
    
    NSWindow *window = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    window.titleVisibility = NSWindowTitleHidden;
    window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    
    NSRect rectNewFrame = [window frameRectForContentRect:NSMakeRect(0, 0, kInitialWindowWidth, kInitialWindowHeight)];
    NSRect rectCurrentFrame = [window frame];
    
    rectNewFrame.origin = NSMakePoint(CGRectGetMinX(rectCurrentFrame),
                                      CGRectGetMinY(rectCurrentFrame) + CGRectGetHeight(rectCurrentFrame) - CGRectGetHeight(rectNewFrame));
    
    
    [window setFrame:rectNewFrame display:YES animate:NO];
    
    if (kDebugLogUserDefaults) NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - File Opening

// called when a document is dropped onto the application's dock icon

-(BOOL)application:(NSApplication *)sender openFile:(NSString *)fileName
{
    NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:fileName];
    fileName = [fileName lastPathComponent];
    
    if (newImage) {
        MFMockupImage *image = [MFMockupImage mockupImageWithImage:newImage fileName:fileName];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewDocumentDroppedOntoAppIcon object:image];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateMockup object:image];
        return YES;
    }
    
    return NO;
}



#pragma mark - User Defaults

+ (void)initDefaults
{
    MFUserDefaultsController *defaults = [MFUserDefaultsController sharedController];
    [defaults setMissingUserDefaultsToDefaultValues];
}


+ (void)resetUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    MFUserDefaultsController *defaults = [MFUserDefaultsController sharedController];
    [defaults deleteUserDefaults];
}



@end
