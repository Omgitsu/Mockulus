//
//  MFOptionsPreferencesView.m
//  Mockulus
//
//  Created by James Baker on 6/3/15.
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

#import "MFOptionsPreferencesView.h"
#import <PureLayout/PureLayout.h>
#import "MFMockupController.h"
#import "MFFrameController.h"
#import "MFMockup.h"
#import "MFMockupView.h"
#import "AppDelegate.h"
#import "MFOptionsStyleSelectView.h"
#import "MFMockupView.h"
#import "MFUserDefaultsController.h"

NSString * const kNotificationChangeBackgroundColor = @"Change Background color";

NSString * const kNotificationToggleLandscape = @"Toggle Landscape Mode";
NSString * const kNotificationToggleGlare = @"Toggle Glare";
NSString * const kNotificationToggleShadow = @"Toggle Shadow";
NSString * const kNotificationToggleLogo = @"Toggle Logo";
NSString * const kNotificationToggleStatusbar = @"Toggle Statusbar";
NSString * const kNotificationToggleURLTextField = @"Toggle URL TextField";
NSString * const kNotificationToggleTitleTextField = @"Toggle Title TextField";
NSString * const kNotificationToggleOperatingSystemBackground = @"Toggle OS Background";

NSString * const kNotificationChangeDesktopColor = @"Change Desktop Color";
NSString * const kNotificationChangeBaseImage = @"Change the base image";
NSString * const kNotificationChangeURLText = @"Change URL Text";
NSString * const kNotificationChangeTitleText = @"Change Title Text";

NSString * const kMotificationModeChangeScaling = @"Scaling mode has changed";
NSString * const kMotificationModeChangeAlignment = @"Alignment mode has changed";
NSString * const kMotificationModeChangeFrameAlignment = @"Frame alignment mode has changed";

NSString * const kMFOptionsScalingModeImageNameNone = @"fit-none-";
NSString * const kMFOptionsScalingModeImageNameHeight = @"fit-height-";
NSString * const kMFOptionsScalingModeImageNameWidth = @"fit-width-";
NSString * const kMFOptionsScalingModeImageNameFillScreen = @"fit-screen-";

NSString * const kMFOptionsAlignmentModeTopLeft = @"align-top-left-";
NSString * const kMFOptionsAlignmentModeTopCenter = @"align-top-center-";
NSString * const kMFOptionsAlignmentModeTopRight = @"align-top-right-";
NSString * const kMFOptionsAlignmentModeCenterLeft = @"align-left-";
NSString * const kMFOptionsAlignmentModeCenter = @"align-center-";
NSString * const kMFOptionsAlignmentModeCenterRight = @"align-right-";
NSString * const kMFOptionsAlignmentModeBottomLeft = @"align-bottom-left-";
NSString * const kMFOptionsAlignmentModeBottomCenter = @"align-bottom-center-";
NSString * const kMFOptionsAlignmentModeBottomRight = @"align-bottom-right-";


#pragma mark - Private

@interface MFOptionsPreferencesView ()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (assign, nonatomic) NSInteger compType;
@property (assign, nonatomic) BOOL controlsVisible;
@property (strong, nonatomic) NSArray *controls;
@property (strong, nonatomic) MFStyle *currentStyle;
@property (assign, nonatomic) NSInteger currentScalingMode;
@property (strong, nonatomic) NSArray *constraints;

@property (weak) IBOutlet NSPopUpButton *alternateBaseImageButton;
@property (weak) IBOutlet NSButton *landscapeToggleButton;
@property (weak) IBOutlet NSButton *glareToggleButton;
@property (weak) IBOutlet NSButton *logoToggleButton;
@property (weak) IBOutlet NSButton *shadowToggleButton;
@property (weak) IBOutlet NSButton *osBackgroundToggleButton;
@property (weak) IBOutlet NSButton *statusbarToggleButton;
@property (weak) IBOutlet NSColorWell *backgroundColorPicker;
@property (weak) IBOutlet NSTextField *backgroundColorPickerLabel;
@property (weak) IBOutlet NSColorWell *desktopColorPicker;
@property (weak) IBOutlet NSTextField *desktopColorPickerLabel;
@property (weak) IBOutlet NSButton *urlToggleButton;
@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSButton *titleToggleButton;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSSegmentedControl *scalingControl;
@property (strong, nonatomic) NSArray *alignmentControls;
@property (weak) IBOutlet NSSegmentedControl *alignmentControlTop;
@property (weak) IBOutlet NSSegmentedControl *alignmentControlCenter;
@property (weak) IBOutlet NSSegmentedControl *alignmentControlBottom;
@property (weak) IBOutlet NSSegmentedControl *frameAlignmentControl;

- (IBAction)toggleLandscape:(id)sender;
- (IBAction)toggleGlare:(id)sender;
- (IBAction)toggleLogo:(id)sender;
- (IBAction)toggleShadow:(id)sender;
- (IBAction)toggleURLTextField:(id)sender;
- (IBAction)toggleTitleTextField:(id)sender;
- (IBAction)toggleStatusbar:(id)sender;
- (IBAction)toggleOSBackground:(id)sender;

@end


@implementation MFOptionsPreferencesView


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [self setup];
}

- (void)setup
{
    
    _urlTextField.delegate = self;
    _titleTextField.delegate = self;
    
    _controls = @[
                  _alternateBaseImageButton,
                  _scalingControl,
                  _alignmentControlTop,
                  _alignmentControlCenter,
                  _alignmentControlBottom,
                  _frameAlignmentControl,
                  _landscapeToggleButton,
                  _glareToggleButton,
                  _logoToggleButton,
                  _shadowToggleButton,
                  _statusbarToggleButton,
                  _osBackgroundToggleButton,
                  _backgroundColorPicker,
                  _backgroundColorPickerLabel,
                  _desktopColorPicker,
                  _desktopColorPickerLabel,
                  _urlToggleButton,
                  _urlTextField,
                  _titleToggleButton,
                  _titleTextField
                  ];
    _controlsVisible = NO;
    
    _alignmentControls = @[ _alignmentControlTop, _alignmentControlCenter, _alignmentControlBottom ];
    
    
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    
    [self addObservers];
    [self setCurrentStyle];
    [self showAndHideControls];
}

- (void)dealloc
{
    [_backgroundColorPicker removeObserver:self forKeyPath:@"color"];
    [_desktopColorPicker removeObserver:self forKeyPath:@"color"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Observers

- (void)addObservers
{
    [_backgroundColorPicker addObserver:self forKeyPath:@"color" options:0 context:NULL];
    [_desktopColorPicker addObserver:self forKeyPath:@"color" options:0 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:kNotificationStyleTypeChanged]) {
        [self updateControls];
    }
    if ([[notification name] isEqualToString:kNotificationUpdateMockup]) {
        _controlsVisible = YES;
        [self updateControls];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _backgroundColorPicker && [keyPath isEqualToString:@"color"]) {
        [self updateBackgroundColor:object];
    }
    if (object == _desktopColorPicker && [keyPath isEqualToString:@"color"]) {
        [self updateDesktopColor:object];
    }
}

#pragma mark - Style Setting

- (void)setCurrentStyle
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *currentStyleType = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleType];
    NSString *currentStyleName = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleName];
    
    if ([currentStyleType isEqualToString:kStyleTypeFrame]) {
        self.compType = MFImageCompTypeFrame;
        MFFrameController *frameController = [MFFrameController sharedMFFrameController];
        self.currentStyle = frameController.frames[currentStyleName];
        
    }
    if ([currentStyleType isEqualToString:kStyleTypeMockup]) {
        self.compType = MFImageCompTypeMockup;
        MFMockupController *mockupController = [MFMockupController sharedMFMockupController];
        self.currentStyle = mockupController.mockups[currentStyleName];
    }
    
}


#pragma mark - Constraints

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        [self applyConstraints];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
    
}

- (void)applyConstraints
{
    
    if (self.constraints) {
        [self.constraints autoRemoveConstraints];
    }
    
    NSView *weakSelf = self;
    NSInteger baseOffset = 6;
    
    self.constraints = [NSView autoCreateConstraintsWithoutInstalling:^{
        
        NSView *previousView = weakSelf;
        ALEdge previousEdge = ALEdgeTop;
        
        CGFloat totalHeight = (self.controlsVisible) ? 10 : 0;
        
        // these will be placed in order from top to bottom
        NSArray *buttons = @[
                             self.alternateBaseImageButton,
                             self.scalingControl,
                             self.alignmentControlTop,
                             self.alignmentControlCenter,
                             self.alignmentControlBottom,
                             self.frameAlignmentControl,
                             self.landscapeToggleButton,
                             self.glareToggleButton,
                             self.logoToggleButton,
                             self.shadowToggleButton,
                             self.statusbarToggleButton,
                             self.osBackgroundToggleButton,
                             self.backgroundColorPicker,
                             self.desktopColorPicker,
                             self.urlToggleButton,
                             self.urlTextField,
                             self.titleToggleButton,
                             self.titleTextField
                             ];
        
        for (NSView *view in buttons) {
            if (!view.hidden) {
                NSInteger offset = baseOffset;
                if (view == self.alignmentControlCenter || view == self.alignmentControlBottom) {
                    offset = 1;
                }
                [view autoPinEdge:ALEdgeTop toEdge:previousEdge ofView:previousView withOffset:offset];
                totalHeight += CGRectGetHeight(view.frame) + offset;
                previousView = view;
                previousEdge = ALEdgeBottom;
            }
        }
        
        if (totalHeight > 0) {
            [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:previousView withOffset:10];
        } else {
            [self autoSetDimension:ALDimensionHeight toSize:0];
        }
        
        
    }];
    
    [self.constraints autoInstallConstraints];
}

#pragma mark - Control Visibility

- (void)showAndHideControls
{
    if (!self.controlsVisible) {
        [self hideAllControls];
        return;
    }
    
    [self showAllControls];
    
    self.landscapeToggleButton.hidden = ([self.currentStyle allowsLandscape]) ? NO : YES;
    self.scalingControl.hidden = (self.compType == MFImageCompTypeFrame) ? YES : NO;
    self.alignmentControlTop.hidden = (self.compType == MFImageCompTypeFrame || self.scalingControl.selectedSegment == MFOptionsScalingModeFillScreen) ? YES : NO;
    self.alignmentControlCenter.hidden = (self.compType == MFImageCompTypeFrame || self.scalingControl.selectedSegment == MFOptionsScalingModeFillScreen) ? YES : NO;
    self.alignmentControlBottom.hidden = (self.compType == MFImageCompTypeFrame || self.scalingControl.selectedSegment == MFOptionsScalingModeFillScreen) ? YES : NO;
    self.frameAlignmentControl.hidden = (self.compType == MFImageCompTypeFrame) ? NO : YES;
    self.shadowToggleButton.hidden = ([self.currentStyle hasShadow]) ? NO : YES;
    self.osBackgroundToggleButton.hidden = ([self.currentStyle hasOperatingSystemBackground]) ? NO : YES;
    self.alternateBaseImageButton.hidden = ([self.currentStyle hasAlternateBaseImages]) ? NO : YES;
    self.logoToggleButton.hidden = ([self.currentStyle hasLogo]) ? NO : YES;
    self.glareToggleButton.hidden = ([self.currentStyle hasGlare]) ? NO : YES;
    self.statusbarToggleButton.hidden = ([self.currentStyle hasStatusbar] && self.landscapeToggleButton.state == NSOffState) ? NO : YES;
    self.desktopColorPicker.hidden = (self.compType == MFImageCompTypeFrame) ? YES : NO;
    self.desktopColorPickerLabel.hidden = (self.compType == MFImageCompTypeFrame) ? YES : NO;
    self.urlToggleButton.hidden = ([self.currentStyle hasURL]) ? NO : YES;
    self.urlTextField.hidden = ([self.currentStyle hasURL] && self.urlToggleButton.state == NSOnState) ? NO : YES;
    self.titleToggleButton.hidden = ([self.currentStyle hasTitle]) ? NO : YES;
    self.titleTextField.hidden = ([self.currentStyle hasTitle] && self.titleToggleButton.state == NSOnState) ? NO : YES;
    
}

- (void)hideAllControls
{
    for (NSView *control in self.controls) {
        control.hidden = YES;
    }
}

- (void)showAllControls
{
    for (NSView *control in self.controls) {
        control.hidden = NO;
    }
}

#pragma mark - Control Management

- (void)updateControls
{
    [self setCurrentStyle];
    
    if ([self.currentStyle hasAlternateBaseImages])
    {
        [self configureAlternateBaseImageButton];
    }
    [self showAndHideControls];
    [self applyConstraints];
}


- (void)configureAlternateBaseImageButton
{
    [self.alternateBaseImageButton removeAllItems];
    MFMockup *mockup = (MFMockup*)self.currentStyle;
    
    NSMutableArray *alternateImageTitles = [NSMutableArray arrayWithArray:[mockup.baseImages allKeys]];
    [alternateImageTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *alternateImageTitle in alternateImageTitles) {
        [self.alternateBaseImageButton addItemWithTitle:alternateImageTitle];
    }
    [self.alternateBaseImageButton selectItemWithTitle:mockup.defaultBaseImageTitle];
}


#pragma mark - Segmented Controls Actions

- (IBAction)switchScaling:(NSSegmentedControl *)sender {
    [self showAndHideControls];
    [self applyConstraints];
    [self toggleSelectedSegmentImagesOffForControl:sender];
    [self toggleSelectedSegmentImageOnForControl:sender];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMotificationModeChangeScaling object:nil];
}


- (IBAction)switchAlignment:(NSSegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegment;
    [self deselectAlignmentControlsExcluding:sender];
    [self toggleAllAlignmentControlImagesOff];
    [self toggleSelectedSegmentImageOnForControl:sender];
    
    NSInteger newMode = -1;
    
    if (sender == self.alignmentControlTop) {
        switch (selectedSegment) {
            case 0:
                newMode = MFOptionsAlignmentModeTopLeft;
                break;
            case 1:
                newMode = MFOptionsAlignmentModeTopCenter;
                break;
            case 2:
                newMode = MFOptionsAlignmentModeTopRight;
                break;
            default:
                break;
        }
    }
    
    if (sender == self.alignmentControlCenter) {
        switch (selectedSegment) {
            case 0:
                newMode = MFOptionsAlignmentModeLeftCenter;
                break;
            case 1:
                newMode = MFOptionsAlignmentModeCenter;
                break;
            case 2:
                newMode = MFOptionsAlignmentModeRightCenter;
                break;
            default:
                break;
        }
    }
    
    if (sender == self.alignmentControlBottom) {
        switch (selectedSegment) {
            case 0:
                newMode = MFOptionsAlignmentModeBottomLeft;
                break;
            case 1:
                newMode = MFOptionsAlignmentModeBottomCenter;
                break;
            case 2:
                newMode = MFOptionsAlignmentModeBottomRight;
                break;
            default:
                break;
        }
    }
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    [defaults setObject:[NSNumber numberWithInteger:newMode] forKey:kNSUserDefaultsKeyAlignmentMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMotificationModeChangeAlignment object:nil];
}

- (IBAction)switchFrameAlignment:(NSSegmentedControl *)sender {
    [self toggleSelectedSegmentImagesOffForControl:sender];
    [self toggleSelectedSegmentImageOnForControl:sender];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMotificationModeChangeFrameAlignment object:nil];
}


#pragma mark - Segmented Controls Management

- (void)toggleSelectedSegmentImagesOn
{
    NSArray *controls = @[
                          self.scalingControl,
                          self.alignmentControlTop,
                          self.alignmentControlCenter,
                          self.alignmentControlBottom,
                          self.frameAlignmentControl
                          ];
    
    for (NSSegmentedControl *control in controls) {
        [self toggleSelectedSegmentImageOnForControl:control];
    }
}


- (void)toggleSelectedSegmentImageOnForControl:(NSSegmentedControl*)control
{
    NSInteger selectedSegment = control.selectedSegment;
    if (selectedSegment == -1) {
        return;
    }
    
    NSDictionary *controlImages = [self controlImagesForControl:control];
    NSString *controlImageName = controlImages[[NSNumber numberWithInteger:selectedSegment]];
    controlImageName = [controlImageName stringByAppendingString:@"on"];
    NSImage *controlImage = [NSImage imageNamed:controlImageName];
    [control setImage:controlImage forSegment:selectedSegment];
}


- (void)toggleSelectedSegmentImagesOffForControl:(NSSegmentedControl*)control
{
    
    NSDictionary *controlImages = [self controlImagesForControl:control];
    
    for (NSNumber *key in controlImages) {
        NSInteger segmentIndex = [key integerValue];
        NSString *segmentImageName = controlImages[key];
        segmentImageName = [segmentImageName stringByAppendingString:@"off"];
        NSImage *segmentOnImage = [NSImage imageNamed:segmentImageName];
        [control setImage:segmentOnImage forSegment:segmentIndex];
    }
}

- (void)toggleAllAlignmentControlImagesOff
{
    for (NSSegmentedControl *control in self.alignmentControls) {
        [self toggleSelectedSegmentImagesOffForControl:control];
    }
}

- (NSDictionary*)controlImagesForControl:(NSSegmentedControl*)control
{
    NSDictionary *scalingControlImages = @{
                                           @0: kMFOptionsScalingModeImageNameNone,
                                           @1: kMFOptionsScalingModeImageNameHeight,
                                           @2: kMFOptionsScalingModeImageNameWidth,
                                           @3: kMFOptionsScalingModeImageNameFillScreen,
                                           };
    
    NSDictionary *alignmentControlImagesTop = @{
                                                @0: kMFOptionsAlignmentModeTopLeft,
                                                @1: kMFOptionsAlignmentModeTopCenter,
                                                @2: kMFOptionsAlignmentModeTopRight,
                                                };
    
    NSDictionary *alignmentControlImagesCenter = @{
                                                   @0: kMFOptionsAlignmentModeCenterLeft,
                                                   @1: kMFOptionsAlignmentModeCenter,
                                                   @2: kMFOptionsAlignmentModeCenterRight,
                                                   };
    NSDictionary *alignmentControlImagesBottom = @{
                                                   @0: kMFOptionsAlignmentModeBottomLeft,
                                                   @1: kMFOptionsAlignmentModeBottomCenter,
                                                   @2: kMFOptionsAlignmentModeBottomRight,
                                                   };
    
    NSDictionary *controlImages;
    if (control == self.scalingControl) {
        controlImages = scalingControlImages;
    }
    if (control == self.alignmentControlTop) {
        controlImages = alignmentControlImagesTop;
    }
    if (control == self.alignmentControlCenter) {
        controlImages = alignmentControlImagesCenter;
    }
    if (control == self.alignmentControlBottom) {
        controlImages = alignmentControlImagesBottom;
    }
    if (control == self.frameAlignmentControl) {
        controlImages = alignmentControlImagesCenter;
    }
    
    return controlImages;
}


- (void)deselectAlignmentControlsExcluding:(NSSegmentedControl*)excludedControl
{
    for (NSSegmentedControl *control in self.alignmentControls) {
        if (control != excludedControl) {
            [self deselectSegmentedControl:control];
        }
    }
}

- (void)deselectAllAlignmentSegmentedControls
{
    for (NSSegmentedControl *control in self.alignmentControls) {
        [self deselectSegmentedControl:control];
    }
}

- (void)deselectSegmentedControl:(NSSegmentedControl*)control
{
    if ([control selectedSegment] != -1) {
        [control setSelected:NO forSegment:[control selectedSegment]];
    }
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if (control == self.alignmentControlTop) {
        [defaults setValue:@-1 forKey:kNSUserDefaultsKeyAlignmentControlTopMode];
    }
    if (control == self.alignmentControlCenter) {
        [defaults setValue:@-1 forKey:kNSUserDefaultsKeyAlignmentControlCenterMode];
    }
    if (control == self.alignmentControlBottom) {
        [defaults setValue:@-1 forKey:kNSUserDefaultsKeyAlignmentControlBottomMode];
    }
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if (textField == self.urlTextField) {
        [defaults setValue:[textField stringValue] forKey:kNSUserDefaultsKeyURLTitle];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeURLText object:[textField stringValue]];
    }
    if (textField == self.titleTextField) {
        [defaults setValue:[textField stringValue] forKey:kNSUserDefaultsKeyFrameTitle];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeTitleText object:[textField stringValue]];
    }
}

#pragma mark - IBActions

- (IBAction)toggleLandscape:(id)sender
{
    self.statusbarToggleButton.hidden = ([self.currentStyle hasStatusbar] && self.landscapeToggleButton.state == NSOffState) ? NO : YES;
    [self applyConstraints];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleLandscape object:sender];
}

- (IBAction)toggleGlare:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleGlare object:sender];
}

- (IBAction)toggleLogo:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleLogo object:sender];
}

- (IBAction)toggleShadow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleShadow object:sender];
}

- (IBAction)toggleStatusbar:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleStatusbar object:sender];
}

- (IBAction)toggleOSBackground:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleOperatingSystemBackground object:sender];
}

- (IBAction)toggleURLTextField:(id)sender
{
    if([sender state] == NSOnState) {
        self.urlTextField.hidden = NO;
    } else {
        self.urlTextField.hidden = YES;
    }
    [self applyConstraints];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleURLTextField object:sender];
}

- (IBAction)toggleTitleTextField:(id)sender
{
    if([sender state] == NSOnState) {
        self.titleTextField.hidden = NO;
    } else {
        self.titleTextField.hidden = YES;
    }
    [self applyConstraints];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToggleTitleTextField object:sender];
}

- (IBAction)changeBaseImage:(NSPopUpButton*)sender
{
    NSString *baseImageKey = sender.titleOfSelectedItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeBaseImage object:baseImageKey];
}

- (IBAction)updateBackgroundColor:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeBackgroundColor object:sender];
}

- (IBAction)updateDesktopColor:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeDesktopColor object:sender];
}


@end
