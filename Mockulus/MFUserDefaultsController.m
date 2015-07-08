//
//  MFUserDefaultsController.m
//  Mockulus
//
//  Created by James Baker on 6/14/15.
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

#import "MFUserDefaultsController.h"
#import "MFOptionsPreferencesView.h"

// keys
NSString * const kNSUserDefaultsKeyCurrentStyleType = @"Current style type";
NSString * const kNSUserDefaultsKeyCurrentStyleName = @"Current style name";
NSString * const kNSUserDefaultsKeyApplicationHasRun = @"applicationHasRun";
NSString * const kNSUserDefaultsKeyEnableLandscapeMode = @"enableLandscapeMode";
NSString * const kNSUserDefaultsKeyEnableGlare = @"enableGlare";
NSString * const kNSUserDefaultsKeyEnableLogo = @"enableLogo";
NSString * const kNSUserDefaultsKeyEnableShadow = @"enableShadow";
NSString * const kNSUserDefaultsKeyEnableStatusBar = @"enableStatusbar";
NSString * const kNSUserDefaultsKeyBackgroundColor = @"backgroundColor";
NSString * const kNSUserDefaultsKeyEnableOperatingSystemBackground = @"enableOSBackground";
NSString * const kNSUserDefaultsKeyInterfaceBackgroundColor = @"interfaceBackgroundColor";
NSString * const kNSUserDefaultsKeyEnableURLTitle = @"enableURLTitle";
NSString * const kNSUserDefaultsKeyURLTitle = @"urlTitle";
NSString * const kNSUserDefaultsKeyEnableTitle = @"enableTitle";
NSString * const kNSUserDefaultsKeyFrameTitle = @"frameTitle";
NSString * const kNSUserDefaultsKeyZoomToFit = @"zoomToFit";
NSString * const kNSUserDefaultsKeyScalingMode = @"scalingMode";
NSString * const kNSUserDefaultsKeyAlignmentMode = @"alignmentMode";
NSString * const kNSUserDefaultsKeyAlignmentControlTopMode = @"alignmentControlTopMode";
NSString * const kNSUserDefaultsKeyAlignmentControlCenterMode = @"alignmentControlCenterMode";
NSString * const kNSUserDefaultsKeyAlignmentControlBottomMode = @"alignmentControlBottomMode";
NSString * const kNSUserDefaultsKeyFrameAlignmentMode = @"frameAlignmentMode";
NSString * const kNSUserDefaultsKeyShowOptionsPanel = @"showOptionsPanel";
NSString * const kNSUserDefaultsKeyShowInfoPanel = @"showInfoPanel";
NSString * const kNSUserDefaultsKeySaveAtHighResolutions = @"saveAtHighResolution";

@interface MFUserDefaultsController()

@property (strong, nonatomic) NSArray *activeDefaults;
@property (strong, nonatomic) NSDictionary *defaultUserDefaults;

@end

@implementation MFUserDefaultsController

#pragma mark - Lifecycle

+ (instancetype)sharedController
{
    static dispatch_once_t predicate;
    static MFUserDefaultsController *instance = nil;
    dispatch_once(&predicate, ^{instance = [[self alloc] init];});
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    // test for private or public version
    // which style to use as initial style depends on this
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Mockups-Private" ofType:@"plist"];
    NSString *currentStyleName = ([[NSFileManager defaultManager] fileExistsAtPath:file]) ? @"iPhone 6" : @"Generic Phone";
    
    _defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    _activeDefaults = @[
                          kNSUserDefaultsKeyCurrentStyleType,
                          kNSUserDefaultsKeyCurrentStyleName,
                          kNSUserDefaultsKeyApplicationHasRun,
                          kNSUserDefaultsKeyEnableLandscapeMode,
                          kNSUserDefaultsKeyEnableGlare,
                          kNSUserDefaultsKeyEnableLogo,
                          kNSUserDefaultsKeyEnableShadow,
                          kNSUserDefaultsKeyEnableStatusBar,
                          kNSUserDefaultsKeyEnableOperatingSystemBackground,
                          kNSUserDefaultsKeyBackgroundColor,
                          kNSUserDefaultsKeyInterfaceBackgroundColor,
                          kNSUserDefaultsKeyEnableURLTitle,
                          kNSUserDefaultsKeyURLTitle,
                          kNSUserDefaultsKeyEnableTitle,
                          kNSUserDefaultsKeyFrameTitle,
                          kNSUserDefaultsKeyZoomToFit,
                          kNSUserDefaultsKeyScalingMode,
                          kNSUserDefaultsKeyAlignmentMode,
                          kNSUserDefaultsKeyAlignmentControlTopMode,
                          kNSUserDefaultsKeyAlignmentControlCenterMode,
                          kNSUserDefaultsKeyAlignmentControlBottomMode,
                          kNSUserDefaultsKeyFrameAlignmentMode,
                          kNSUserDefaultsKeyShowOptionsPanel,
                          kNSUserDefaultsKeyShowInfoPanel,
                          kNSUserDefaultsKeySaveAtHighResolutions,
                          kNSUserDefaultsKeyFrameAlignmentMode,
                          ];
    
    _defaultUserDefaults = @{
                              kNSUserDefaultsKeyCurrentStyleType: @"mockup",
                              kNSUserDefaultsKeyCurrentStyleName: currentStyleName,
                              kNSUserDefaultsKeyApplicationHasRun: @YES,
                              kNSUserDefaultsKeyEnableLandscapeMode: @NO,
                              kNSUserDefaultsKeyEnableGlare: @YES,
                              kNSUserDefaultsKeyEnableLogo: @YES,
                              kNSUserDefaultsKeyEnableShadow: @YES,
                              kNSUserDefaultsKeyEnableStatusBar: @YES,
                              kNSUserDefaultsKeyEnableOperatingSystemBackground: @YES,
                              kNSUserDefaultsKeyBackgroundColor: [NSKeyedArchiver archivedDataWithRootObject:[NSColor clearColor]],
                              kNSUserDefaultsKeyInterfaceBackgroundColor: [NSKeyedArchiver archivedDataWithRootObject:[NSColor clearColor]],
                              kNSUserDefaultsKeyEnableURLTitle: @YES,
                              kNSUserDefaultsKeyURLTitle: @"www.mockul.us",
                              kNSUserDefaultsKeyEnableTitle: @YES,
                              kNSUserDefaultsKeyFrameTitle: @"Mockulus",
                              kNSUserDefaultsKeyZoomToFit: @YES,
                              kNSUserDefaultsKeyScalingMode: [NSNumber numberWithInteger:MFOptionsScalingModeNone],
                              kNSUserDefaultsKeyAlignmentMode: [NSNumber numberWithInteger:MFOptionsAlignmentModeCenter],
                              kNSUserDefaultsKeyAlignmentControlTopMode: @-1,
                              kNSUserDefaultsKeyAlignmentControlCenterMode: @1, // toggle center button on
                              kNSUserDefaultsKeyAlignmentControlBottomMode: @-1,
                              kNSUserDefaultsKeyFrameAlignmentMode: @1,
                              kNSUserDefaultsKeyShowOptionsPanel: @NO,  // actually will show it - toggles the button to the down/on state
                              kNSUserDefaultsKeyShowInfoPanel: @NO, // actually will show it - toggles the button to the down/on state
                              kNSUserDefaultsKeySaveAtHighResolutions: @YES
                              };
}

- (void)deleteUserDefaults
{
    for (NSString *key in self.activeDefaults) {
        [self.defaults removeObjectForKey:key];
    }
}

- (void)setUserDefaultsToDefaultValues
{
    for (NSString *key in self.activeDefaults) {
        [self.defaults setObject:[self.defaultUserDefaults objectForKey:key] forKey:key];
    }
}

- (void)setMissingUserDefaultsToDefaultValues
{
    for (NSString *key in self.activeDefaults) {
        if (![self.defaults objectForKey:key]) {
            [self.defaults setObject:[self.defaultUserDefaults objectForKey:key] forKey:key];
        }
        
    }
}

- (void)flipBooleanForKey:(NSString *)key
{
    if ([self.defaults objectForKey:key]) {
        BOOL value = [[self.defaults objectForKey:key] boolValue];
        if (value == YES) {
            [self.defaults setValue:@NO forKey:key];
        } else if (value == NO) {
            [self.defaults setValue:@YES forKey:key];
        }
    }
}

- (id)valueForKey:(NSString *)key
{
    return [self.defaults valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.defaults setValue:value forKey:key];
}

@end
