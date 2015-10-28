//
//  MFMockupView.m
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

#import <QuartzCore/QuartzCore.h>

#import "MFMockupView.h"
#import "MFMockupImage.h"
#import "Macros.h"
#import "MFViewCompositor.h"
#import "Utility.h"
#import "NSImage+Additions.h"
#import "WindowController.h"
#import "MFOptionsStyleSelectView.h"
#import "AppDelegate.h"
#import "MFMainMenu.h"
#import "MFOptionsPreferencesView.h"
#import "MFUserDefaultsController.h"
#import "MFMockupImage.h"
#import "NSScreen+RetinaDetection.h"

NSString * const kNotificationUpdateMockup = @"Update Mockup";
NSString * const kNotificationSaveFileStarted = @"File Save Process Started";
NSString * const kNotificationSaveFileCompleted = @"File Save Process Completed";
NSInteger const kChromeGutterWithShadow = 20;
CGFloat const kScalingFactorRetinaDefaultResolution = 0.5;
CGFloat const kScalingFactorRetinaHighResolution = 1;
CGFloat const kScalingFactorDefaultResolution = 1;

@implementation MFMockupView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}


- (void)setup {
    
    [self addObservers];
    
    _previousCompWidth = _compWidth = kInitialWindowWidth;
    _previousCompHeight = _compHeight = kInitialWindowHeight;
    
    // shadow setup
    _shadowBlurRadius = 6.0;
    _shadowOffset = 5;
    _imageOffsetWithShadow = _shadowBlurRadius + _shadowOffset;
    
    
    // Mockup Setup
    _mockupController = [MFMockupController sharedMFMockupController];
    
    // setup image views - very tiny!
    CGRect frame = CGRectZero;
    
    _mockupBackgroundFillView = [[MFImageView alloc] initWithFrame:frame];
    _mockupShadowImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupBaseImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupBackgroundImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupOSBackgroundImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupScreenImageView = [[MFDraggableImageView alloc] initWithFrame:frame];
    _mockupLogoImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupGlareImageView = [[MFImageView alloc] initWithFrame:frame];
    _mockupStatusbarImageView = [[MFImageView alloc] initWithFrame:frame];
    
    
    [self addSubview:_mockupBackgroundFillView];
    [self addSubview:_mockupShadowImageView];
    [self addSubview:_mockupBaseImageView];
    [self addSubview:_mockupBackgroundImageView];
    [self addSubview:_mockupOSBackgroundImageView];
    [self addSubview:_mockupScreenImageView];
    [self addSubview:_mockupLogoImageView];
    [self addSubview:_mockupStatusbarImageView];
    [self addSubview:_mockupGlareImageView];
    
    [_mockupBackgroundFillView display];
    [_mockupShadowImageView display];
    [_mockupBaseImageView display];
    [_mockupBackgroundImageView display];
    [_mockupOSBackgroundImageView display];
    [_mockupScreenImageView display];
    [_mockupLogoImageView display];
    [_mockupStatusbarImageView display];
    [_mockupGlareImageView display];
    
    _mockupViews = @[_mockupBackgroundFillView,
                     _mockupShadowImageView,
                     _mockupBaseImageView,
                     _mockupBackgroundImageView,
                     _mockupOSBackgroundImageView,
                     _mockupScreenImageView,
                     _mockupLogoImageView,
                     _mockupStatusbarImageView,
                     _mockupGlareImageView];
    
    // Frame Setup
    
    _frameController = [MFFrameController sharedMFFrameController];
    
    _frameBackgroundFillView = [[MFImageView alloc] initWithFrame:frame];
    _frameShadowImageView = [[MFImageView alloc] initWithFrame:frame];
    _frameBaseImageView = [[MFImageView alloc] initWithFrame:frame];
    _frameScreenImageView = [[MFImageView alloc] initWithFrame:frame];
    _frameURLBarImageView = [[MFImageView alloc] initWithFrame:frame];
    _frameUrlTextField = [[NSTextField alloc] initWithFrame:frame];
    _frameTitleTextField = [[NSTextField alloc] initWithFrame:frame];
    
    [self addSubview:_frameBackgroundFillView];
    [self addSubview:_frameShadowImageView];
    [self addSubview:_frameBaseImageView];
    [self addSubview:_frameScreenImageView];
    [self addSubview:_frameURLBarImageView];
    [self addSubview:_frameUrlTextField];
    [self addSubview:_frameTitleTextField];
    
    [_frameBackgroundFillView display];
    [_frameShadowImageView display];
    [_frameBaseImageView display];
    [_frameScreenImageView display];
    [_frameURLBarImageView display];
    [_frameUrlTextField display];
    [_frameTitleTextField display];
    
    _frameViews = @[_frameBackgroundFillView,
                    _frameShadowImageView,
                    _frameBaseImageView,
                    _frameScreenImageView,
                    _frameURLBarImageView,
                    _frameUrlTextField,
                    _frameTitleTextField];
    
    
    // configure the text fields
    
    NSArray *textFields = @[_frameUrlTextField, _frameTitleTextField];
    for (NSTextField *textField in textFields) {
        textField.selectable = NO;
        textField.editable = NO;
        textField.backgroundColor = [NSColor clearColor];
        textField.drawsBackground = YES;
        textField.bordered = NO;
        textField.textColor = [NSColor blackColor];
    }
    _frameUrlTextField.font = [NSFont labelFontOfSize:[NSFont systemFontSize]];
    _frameTitleTextField.font = [NSFont labelFontOfSize:[NSFont labelFontSize]];
    
    
    // load modes from defaults
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    _scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
    _alignmentMode = [[defaults valueForKey:kNSUserDefaultsKeyAlignmentMode] integerValue];
    
    [self setStyleType];
    [self loadNewStyle];
    [self setLandscapeMode];
    [self reloadCurrentImage];
    
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
    if (!self.hidden) {
        if ([[notification name] isEqualToString:kNotificationUpdateMockup]) {
            [self handleNewImage:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleShadow]) {
            [self toggleShadowImage:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleGlare]) {
            [self toggleGlareImage:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleLandscape]) {
            [self toggleLandscapeMode:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleLogo]) {
            [self toggleLogoImage:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleLogo]) {
            [self toggleLogoImage:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleStatusbar]) {
            [self toggleStatusbar:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleURLTextField]) {
            [self toggleURLTitle:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleTitleTextField]) {
            [self toggleTitle:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationToggleOperatingSystemBackground]) {
            [self toggleOSBackground:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationSaveFile]) {
            [self saveMockup];
        }
        if ([[notification name] isEqualToString:kNotificationStyleTypeChanged]) {
            [self handleStyleTypeChanged];
        }
        if ([[notification name] isEqualToString:kNotificationChangeDesktopColor]) {
            [self drawMockupDesktopBackgroundAndNudge:YES];
        }
        if ([[notification name] isEqualToString:kNotificationChangeURLText]) {
            [self updateURLTextField:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationChangeTitleText]) {
            [self updateTitleTextField:notification.object];
        }
        if ([[notification name] isEqualToString:kNotificationChangeBaseImage]) {
            [self changeBaseImageToImageWithTitle:notification.object];
        }
        if ([[notification name] isEqualToString:kMotificationModeChangeScaling]) {
            [self handleScalingModeChanged];
        }
        if ([[notification name] isEqualToString:kMotificationModeChangeAlignment]) {
            [self handleAlignmentModeChanged];
        }
        if ([[notification name] isEqualToString:kMotificationModeChangeFrameAlignment]) {
            [self handleFrameAlignmentModeChanged];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Style Types and Modes

- (void)handleScalingModeChanged
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if (self.scalingMode != [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue]
        || self.alignmentMode != [[defaults valueForKey:kNSUserDefaultsKeyAlignmentMode] integerValue]) {
        
        self.scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
        self.alignmentMode = [[defaults valueForKey:kNSUserDefaultsKeyAlignmentMode] integerValue];
        
        [self drawScreen:self.uneditedImage];
        
        // offset if landscape
        if (self.landscapeMode && self.compType == MFImageCompTypeMockup) {
            CGFloat offset = self.currentMockup.bottomGutter / 4;
            CGPoint origin = self.mockupScreenImageView.frame.origin;
            origin.x = origin.x + offset;
            [self.mockupScreenImageView setFrameOrigin:origin];
        }
    }
}

- (void)handleAlignmentModeChanged
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if (self.scalingMode != [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue]
        || self.alignmentMode != [[defaults valueForKey:kNSUserDefaultsKeyAlignmentMode] integerValue]) {
        
        self.scalingMode = [[defaults valueForKey:kNSUserDefaultsKeyScalingMode] integerValue];
        self.alignmentMode = [[defaults valueForKey:kNSUserDefaultsKeyAlignmentMode] integerValue];
        
        [self drawScreen:self.uneditedImage];
        
        // offset if landscape
        if (self.landscapeMode && self.compType == MFImageCompTypeMockup) {
            CGFloat offset = self.currentMockup.bottomGutter / 4;
            CGPoint origin = self.mockupScreenImageView.frame.origin;
            origin.x = origin.x + offset;
            [self.mockupScreenImageView setFrameOrigin:origin];
        }
    }
}

- (void)handleFrameAlignmentModeChanged
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    if (self.frameAlignmentMode != [[defaults objectForKey:kNSUserDefaultsKeyFrameAlignmentMode] integerValue]) {
        [self handleStyleTypeChanged];
    }
}

- (void)handleStyleTypeChanged
{
    [self setStyleType];
    [self loadNewStyle];
    [self setLandscapeMode];
    [self reloadCurrentImage];
}

- (void)setStyleType
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *currentStyleType = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleType];
    
    if ([currentStyleType isEqualToString:kStyleTypeFrame]) {
        self.compType = MFImageCompTypeFrame;
        [self toggleFramesOn];
        [self toggleMockupsOff];
    }
    if ([currentStyleType isEqualToString:kStyleTypeMockup]) {
        self.compType = MFImageCompTypeMockup;
        [self toggleFramesOff];
        [self toggleMockupsOn];
    }
    
}


- (void)loadNewStyle
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *currentStyleName = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleName];
    
    
    if (self.compType == MFImageCompTypeFrame)
    {
        self.currentFrame = self.frameController.frames[currentStyleName];
    }
    if (self.compType == MFImageCompTypeMockup) {
        self.currentMockup = self.mockupController.mockups[currentStyleName];
    }
    
}

- (void)setLandscapeMode
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    self.landscapeMode = [[defaults objectForKey:kNSUserDefaultsKeyEnableLandscapeMode] boolValue];
    
    if (self.landscapeMode && [self.currentMockup allowsLandscape]) {
        self.landscapeMode = YES;
    } else {
        self.landscapeMode = NO;
    }
}

#pragma mark - Shared Image Handling

- (void)reloadCurrentImage
{
    if (self.uneditedImage) {
        MFMockupImage *image = [MFMockupImage mockupImageWithImage:self.uneditedImage fileName:self.imageFileName];
        [self handleNewImage:image];
    }
}

- (void)handleNewImage:(MFMockupImage*)image
{
    NSImage *newImage = image.image;

    // the loaded image's size will frequently differ from the image representation's size
    // so resize the image to match the representation size
    // -- but only resize when it's really a new image
    
    if (newImage != self.uneditedImage) {
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData: [newImage TIFFRepresentation]];
        NSSize visualSize = CGSizeMake([imageRep pixelsWide], [imageRep pixelsHigh]);
        
        if (!CGSizeEqualToSize(newImage.size, visualSize)) {
            newImage = [newImage resizeImage:newImage toSize:visualSize interpolation:NSImageInterpolationNone];
        }
        
        // on non-retina screens, double the size
        if (![NSScreen isRetina]) {
            CGSize doubleSize = CGSizeDouble(newImage.size);
            newImage = [newImage resizeImage:newImage toSize:doubleSize interpolation:NSImageInterpolationNone];
        }
    }
    
    self.uneditedImage = newImage;
    self.imageFileName = image.fileName;
    
    if (self.compType == MFImageCompTypeFrame) {
        [self frameNewImage:newImage];
    } else {
        [self mockupNewImage:newImage];
    }
    [self resizeDropImageViewFrame];
    
}


#pragma mark - Mockup Image Processing

- (void)mockupNewImage:(NSImage*)newImage {
    
    self.hidden = NO;
    self.previousCompWidth = self.compWidth;
    self.previousCompHeight = self.compHeight;

    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    
    // draw the mockup
    
    // shadow

    NSImage *mockupShadowImage = self.currentMockup.shadowImage.image;
    NSPoint mockupShadowOrigin = self.currentMockup.shadowImage.frame.origin;
    
    if (self.landscapeMode) {
        mockupShadowImage = self.currentMockup.landscapeShadowImage.image;
        mockupShadowOrigin = self.currentMockup.landscapeShadowImage.frame.origin;
    }
    self.mockupShadowImageView.image = mockupShadowImage;
    [self.mockupShadowImageView setFrameOrigin:mockupShadowOrigin];
    [self.mockupShadowImageView setFrameSize:mockupShadowImage.size];
    [self.mockupShadowImageView setNeedsDisplay];
    
    BOOL enableShadow = [[defaults objectForKey:kNSUserDefaultsKeyEnableShadow] boolValue];
    if (!([self.currentMockup hasShadow] && enableShadow)) {
        self.mockupShadowImageView.alphaValue = 0.0;
    } else {
        self.mockupShadowImageView.alphaValue = 1.0;
    }
    
    // base
    
    NSImage *mockupBaseImage = self.currentMockup.baseImage.image;
    
    if (self.landscapeMode) {
        mockupBaseImage = [mockupBaseImage imageRotatedByDegrees:90];
    }
    [self.mockupBaseImageView setImage:mockupBaseImage];
    [self.mockupBaseImageView setFrameOrigin:self.currentMockup.baseImage.frame.origin];
    [self.mockupBaseImageView setFrameSize:mockupBaseImage.size];
    [self.mockupBaseImageView setNeedsDisplay];
    
    // screen desktop color fill

    [self drawMockupDesktopBackgroundAndNudge:NO];
    
    
    
    // mockup OS Background
    NSImage *mockupOSBackgroundImage = self.currentMockup.osBackgroundImage.image;
    
    if (self.landscapeMode) {
        mockupOSBackgroundImage = [mockupOSBackgroundImage imageRotatedByDegrees:90];
    }
    [self.mockupOSBackgroundImageView setImage:mockupOSBackgroundImage];
    [self.mockupOSBackgroundImageView setFrameOrigin:self.currentMockup.osBackgroundImage.frame.origin];
    [self.mockupOSBackgroundImageView setFrameSize:mockupOSBackgroundImage.size];
    [self.mockupOSBackgroundImageView setNeedsDisplay];
    
    BOOL enableOSBackground = [[defaults objectForKey:kNSUserDefaultsKeyEnableOperatingSystemBackground] boolValue];
    if (!([self.currentMockup hasOperatingSystemBackground] && enableOSBackground)) {
        self.mockupOSBackgroundImageView.alphaValue = 0.0;
    } else {
        self.mockupOSBackgroundImageView.alphaValue = 1.0;
    }
    
    
    // screen
    
    [self drawScreen:newImage];

    // logo / branding
    
    NSImage *mockupLogoImage = self.currentMockup.logoImage.image;
    NSPoint mockupLogoOrigin = self.currentMockup.logoImage.frame.origin;
    
    if (self.landscapeMode) {
        mockupLogoImage = [mockupLogoImage imageRotatedByDegrees:90];
        NSRect rotatedRect = [self rectForRotatedRect:self.currentMockup.logoImage.frame];
        mockupLogoOrigin = rotatedRect.origin;
    }
    self.mockupLogoImageView.image = mockupLogoImage;
    [self.mockupLogoImageView setFrameOrigin:mockupLogoOrigin];
    [self.mockupLogoImageView setFrameSize:mockupLogoImage.size ];
    [self.mockupLogoImageView setNeedsDisplay];
    
    BOOL enableLogo= [[defaults objectForKey:kNSUserDefaultsKeyEnableLogo] boolValue];
    if (!([self.currentMockup hasLogo] && enableLogo)) {
        self.mockupLogoImageView.alphaValue = 0.0;
    } else {
        self.mockupLogoImageView.alphaValue = 1.0;
    }
    
    NSImage *mockupStatusbarImage = self.currentMockup.statusbarImage.image;
    NSPoint mockupStatusbarOrigin = self.currentMockup.statusbarImage.frame.origin;
    
    if (self.landscapeMode) {
        mockupStatusbarImage = [mockupStatusbarImage imageRotatedByDegrees:90];
        NSRect rotatedRect = [self rectForRotatedRect:self.currentMockup.statusbarImage.frame];
        mockupStatusbarOrigin = rotatedRect.origin;
    }
    self.mockupStatusbarImageView.image = mockupStatusbarImage;
    [self.mockupStatusbarImageView setFrameOrigin:mockupStatusbarOrigin];
    [self.mockupStatusbarImageView setFrameSize:mockupStatusbarImage.size ];
    [self.mockupStatusbarImageView setNeedsDisplay];

    BOOL enableStatusbar = [[defaults objectForKey:kNSUserDefaultsKeyEnableStatusBar] boolValue];
    if (!([self.currentMockup hasStatusbar] && enableStatusbar) || self.landscapeMode) {
        self.mockupStatusbarImageView.alphaValue = 0.0;
    } else {
        self.mockupStatusbarImageView.alphaValue = 1.0;
    }
    
    
    // glare
    NSImage *mockupGlareImage = self.currentMockup.glareImage.image;
    NSPoint mockupGlareOrigin = self.currentMockup.glareImage.frame.origin;
    
    if (self.landscapeMode) {
        mockupGlareImage = [mockupGlareImage imageRotatedByDegrees:90];
        NSRect rotatedRect = [self rectForRotatedRect:self.currentMockup.glareImage.frame];
        mockupGlareOrigin = rotatedRect.origin;
    }
    self.mockupGlareImageView.image = mockupGlareImage;
    [self.mockupGlareImageView setFrameOrigin:mockupGlareOrigin];
    [self.mockupGlareImageView setFrameSize:mockupGlareImage.size ];
    [self.mockupGlareImageView setNeedsDisplay];
    
    BOOL enableGlare = [[defaults objectForKey:kNSUserDefaultsKeyEnableGlare] boolValue];
    if (!([self.currentMockup hasGlare] && enableGlare)) {
        self.mockupGlareImageView.alphaValue = 0.0;
    } else {
        self.mockupGlareImageView.alphaValue = 1.0;
    }
    
    
    // nudge all comps right if we're in landscape mode
    if (self.landscapeMode) {
        CGFloat offset = self.currentMockup.bottomGutter / 4;
        for (NSView *view in self.mockupViews) {
            CGPoint origin = view.frame.origin;
            origin.x = origin.x + offset;
            [view setFrameOrigin:origin];
        }
    }
    
    
    self.compHeight = self.mockupBaseImageView.image.size.height;
    self.compWidth = self.mockupBaseImageView.image.size.width;
    
}


- (NSRect)rectForRotatedRect:(NSRect)currentRect
{
    NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:currentRect];
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform rotateByDegrees:90];
    [boundsPath transformUsingAffineTransform:transform];
    NSRect rotatedRect = [boundsPath bounds];
    // offset by the height of the baseImage
    rotatedRect.origin.x += self.currentMockup.baseImage.image.size.height;
    return rotatedRect;
}


- (void)drawScreen:(NSImage*)newImage
{
    // normalize the image height and width
    
    CGSize newImageSize = [self sizeOfImage:newImage];
    NSInteger newImageWidth = newImageSize.width;
    NSInteger newImageHeight = newImageSize.height;
    
    NSPoint screenOrigin = self.currentMockup.screen.origin;
    NSSize screenSize = self.currentMockup.screen.size;
    NSPoint screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    if (self.landscapeMode) {
        NSRect rotatedRect = [self rectForRotatedRect:NSRectMake(screenOrigin, screenSize)];
        screenOrigin = rotatedRect.origin;
        screenSize = rotatedRect.size;
        screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
    }
    
    // default mockup render Interpolation to High
    // this will be set to None only when there is no scaling mode
    self.mockupScreenImageView.renderInterpolation = NSImageInterpolationHigh;
    
    NSSize scaledImageSize = CGSizeZero;
    switch (self.scalingMode) {
        case MFOptionsScalingModeNone:
            self.mockupScreenImageView.renderInterpolation = NSImageInterpolationNone;
            scaledImageSize = CGSizeMake(newImageWidth, newImageHeight);
            break;
        case MFOptionsScalingModeHeight:
            scaledImageSize = CGSizeMake(newImageWidth * (screenSize.height / newImageHeight), screenSize.height);
            break;
        case MFOptionsScalingModeWidth:
            scaledImageSize = CGSizeMake(screenSize.width, newImageHeight * (screenSize.width / newImageWidth));
            break;
        case MFOptionsScalingModeFillScreen:
            scaledImageSize = screenSize;
            break;
    }
    
    CGFloat imageCenteredX = round(screenCenter.x - (scaledImageSize.width / 2));
    CGFloat imageCenteredY = round(screenCenter.y - (scaledImageSize.height / 2));
    CGFloat imageTopMinY = round(screenSize.height - scaledImageSize.height);
    CGFloat imageRightMinX = round(screenSize.width - scaledImageSize.width);
    
    CGPoint scaledImageOrigin = CGPointZero;
    
    switch (self.alignmentMode) {
        case MFOptionsAlignmentModeTopLeft:
            scaledImageOrigin.x = 0;
            scaledImageOrigin.y = imageTopMinY;
            break;
            
        case MFOptionsAlignmentModeTopCenter:
            scaledImageOrigin.x = imageCenteredX;
            scaledImageOrigin.y = imageTopMinY;
            break;
            
        case MFOptionsAlignmentModeTopRight:
            scaledImageOrigin.x = imageRightMinX;
            scaledImageOrigin.y = imageTopMinY;
            break;
            
        case MFOptionsAlignmentModeLeftCenter:
            scaledImageOrigin.x = 0;
            scaledImageOrigin.y = imageCenteredY;
            break;
            
        case MFOptionsAlignmentModeCenter:
            scaledImageOrigin.x = imageCenteredX;
            scaledImageOrigin.y = imageCenteredY;
            break;
            
        case MFOptionsAlignmentModeRightCenter:
            scaledImageOrigin.x = imageRightMinX;
            scaledImageOrigin.y = imageCenteredY;
            break;
            
        case MFOptionsAlignmentModeBottomLeft:
            scaledImageOrigin.x = 0;
            scaledImageOrigin.y = 0;
            break;
            
        case MFOptionsAlignmentModeBottomCenter:
            scaledImageOrigin.x = imageCenteredX;
            scaledImageOrigin.y = 0;
            break;
            
        case MFOptionsAlignmentModeBottomRight:
            scaledImageOrigin.x = imageRightMinX;
            scaledImageOrigin.y = 0;
            break;
        default:
            break;
    }
    
    NSRect frame = NSRectMake(scaledImageOrigin, scaledImageSize);
    
    // now draw the stuff
    NSImage *comp = [NSImage imageWithSize:screenSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [newImage drawInRect:frame];
        return YES;
    }];
    
    self.mockupScreenImageView.image = nil;
    self.mockupScreenImageView.image = comp;
    [self.mockupScreenImageView setFrameOrigin:screenOrigin];
    [self.mockupScreenImageView setFrameSize:screenSize];
    [self.mockupScreenImageView setNeedsDisplay];
    self.mockupScreenImageView.draggableImageFrame = frame;
}


- (void)drawMockupDesktopBackgroundAndNudge:(BOOL)nudge
{
    NSPoint screenOrigin = self.currentMockup.screen.origin;
    NSSize screenSize = self.currentMockup.screen.size;
    
    if (self.landscapeMode) {
        NSRect rotatedRect = [self rectForRotatedRect:NSRectMake(screenOrigin, screenSize)];
        if (nudge) {
            CGFloat offset = self.currentMockup.bottomGutter / 4;
            rotatedRect.origin.x = rotatedRect.origin.x + offset;
        }
        screenOrigin = rotatedRect.origin;
        screenSize = rotatedRect.size;
    }
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSData *desktopBackgroundColorWheelData = [defaults objectForKey:kNSUserDefaultsKeyInterfaceBackgroundColor];
    NSColor *mockupDesktopBackgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:desktopBackgroundColorWheelData];
    NSImage *colorFill = [NSImage imageWithSize:screenSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [mockupDesktopBackgroundColor set];
        NSRectFill (CGRectMake(0,0,screenSize.width,screenSize.height));
        return YES;
    }];
    
    
    self.mockupBackgroundImageView.image = nil;
    self.mockupBackgroundImageView.image = colorFill;
    [self.mockupBackgroundImageView setFrameOrigin:screenOrigin];
    [self.mockupBackgroundImageView setFrameSize:screenSize];
    [self.mockupBackgroundImageView setNeedsDisplay];
}

- (void)changeBaseImageToImageWithTitle:(NSString*)title
{
    MFMockupImage *newBaseImage = self.currentMockup.baseImages[title];
    NSImage *mockupBaseImage = newBaseImage.image;
    
    self.currentMockup.baseImage = newBaseImage;
    
    if (self.landscapeMode) {
        mockupBaseImage = [mockupBaseImage imageRotatedByDegrees:90];
    }
    [self.mockupBaseImageView setImage:mockupBaseImage];
    [self.mockupBaseImageView setFrameSize:mockupBaseImage.size];
    [self.mockupBaseImageView setNeedsDisplay];
        
}


#pragma mark - Frame Image Processing

- (void)frameNewImage:(NSImage*)newImage {
    
    self.hidden = NO;
    self.previousCompWidth = self.compWidth;
    self.previousCompHeight = self.compHeight;
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    self.frameAlignmentMode = [[defaults objectForKey:kNSUserDefaultsKeyFrameAlignmentMode] integerValue];
    
    CGSize newImageSize = [self sizeOfImage:newImage];
    NSInteger screenImageWidth = newImageSize.width;
    NSInteger screenImageHeight = newImageSize.height;
    
    // on non-retina screens cut the image size in half
    if (![NSScreen isRetina]) {
        screenImageWidth = screenImageWidth / 2;
        screenImageHeight = screenImageHeight / 2;
    }
    
    BOOL imageSmallerThanMinimumWidth = NO;
    CGFloat compWidth = self.currentFrame.leftBorderWidth + screenImageWidth + self.currentFrame.rightBorderWidth;
    NSInteger screenMinimumWidth = self.currentFrame.minimumWidth;
    if (compWidth < screenMinimumWidth) {
        compWidth = screenMinimumWidth + self.currentFrame.leftBorderWidth + self.currentFrame.rightBorderWidth;
        imageSmallerThanMinimumWidth = YES;
    }
    
    CGFloat compHeight = self.currentFrame.bottomBarHeight + screenImageHeight + self.currentFrame.topBarHeight;
    CGSize compSize = CGSizeMake(compWidth, compHeight);
    CGSize compWithShadowSize = CGSizeMake(compWidth + kChromeGutterWithShadow, compHeight + kChromeGutterWithShadow);

    
    // base
    
    CGRect baseFillRect = CGRectMake(self.imageOffsetWithShadow, self.imageOffsetWithShadow, compSize.width, compSize.height);
    NSImage *baseImageComp = [NSImage imageWithSize:compWithShadowSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [self.currentFrame.baseImage.image drawInRect:baseFillRect];
        return YES;
    }];
    
    [self.frameBaseImageView setFrameOrigin:CGPointZero];
    [self.frameBaseImageView setFrameSize:compWithShadowSize];
    self.frameBaseImageView.image = nil;
    self.frameBaseImageView.image = baseImageComp;
    [self.frameBaseImageView setNeedsDisplay];
    
    
    // shadow
    
    NSImage *shadowImageComp = [NSImage imageWithSize:compWithShadowSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowBlurRadius:self.shadowBlurRadius];
        [shadow setShadowOffset:NSMakeSize(self.shadowOffset, -self.shadowOffset)];
        [shadow set];
        [self.currentFrame.baseImage.image drawInRect:baseFillRect];
        
        return YES;
    }];
    
    
    [self.frameShadowImageView setFrameOrigin:CGPointZero];
    [self.frameShadowImageView setFrameSize:compWithShadowSize];
    self.frameShadowImageView.image = nil;
    self.frameShadowImageView.image = shadowImageComp;
    [self.frameShadowImageView setNeedsDisplay];
    
    BOOL enableShadow = [[defaults objectForKey:kNSUserDefaultsKeyEnableShadow] boolValue];
    if (!enableShadow) {
        [self.frameShadowImageView setAlphaValue:0.0];
    } else {
        [self.frameShadowImageView setAlphaValue:1.0];
    }
    
    // screen

    NSSize screenImageSize = CGSizeMake(screenImageWidth, screenImageHeight);
    NSPoint screenImageOrigin = CGPointZero;
    
    if (imageSmallerThanMinimumWidth) {
        
        NSInteger frameAlignment = [[defaults objectForKey:kNSUserDefaultsKeyFrameAlignmentMode] integerValue];
        switch (frameAlignment) {
            case MFOptionsFrameAlignmentModeLeft:
                screenImageOrigin.x = 0;
                break;
                
            case MFOptionsFrameAlignmentModeCenter:
                screenImageOrigin.x = self.currentFrame.minimumWidth / 2 - screenImageWidth / 2;
                break;
                
            case MFOptionsFrameAlignmentModeRight:
                screenImageOrigin.x = screenMinimumWidth - screenImageWidth;
                break;
        }
    }
    
    NSRect screenImageFrame = NSRectMake(screenImageOrigin, screenImageSize);
    
    // composite Screen - used for mask, etc.
    
    NSInteger screenCompositeImageWidth = (imageSmallerThanMinimumWidth) ? self.currentFrame.minimumWidth : screenImageWidth;
    NSInteger screenCompositeImageHeight = screenImageHeight;
    NSSize screenCompositeImageSize = CGSizeMake(screenCompositeImageWidth, screenCompositeImageHeight);
    NSPoint screenCompositeImageOrigin = CGPointMake(self.currentFrame.leftBorderWidth + self.imageOffsetWithShadow, self.currentFrame.bottomBarHeight+self.imageOffsetWithShadow);
    
    // create the screen comp
    NSImage *screenCompositeImage = [NSImage imageWithSize:screenCompositeImageSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        
        
#if DEBUG // paint the BG red for debugging
        NSRect debugScreenImageFrame = NSRectMake(CGPointZero, screenCompositeImageSize);
        [[NSColor redColor] set];
        NSRectFill(debugScreenImageFrame);
#endif
        [NSGraphicsContext saveGraphicsState];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
        [newImage drawInRect:screenImageFrame];
        [NSGraphicsContext restoreGraphicsState];
        return YES;
    }];
    
    // create the mask image
    NSImage *maskedNewImage;
    
    if ([self.currentFrame.maskType isEqualToString:@"yosemite"]) {
        
        NSRect maskImageFrame = NSRectMake(CGPointZero, screenCompositeImageSize);
        // load the mask
        NSImage *yosemiteFrameBottomMask = [NSImage imageNamed:@"yosemite-frame-bottom-mask"];
        
        NSImage *screenMaskImage = [NSImage imageWithSize:screenCompositeImageSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            [NSGraphicsContext saveGraphicsState];
            [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
            [yosemiteFrameBottomMask drawInRect:maskImageFrame];
            [NSGraphicsContext restoreGraphicsState];
            return YES;
        }];
        
        // mask the composite with the new mask image
        maskedNewImage = [screenCompositeImage maskUsingMaskImage:screenMaskImage];
        
    } else {
        maskedNewImage = screenCompositeImage;
    }
    


    
    // set the composite
    self.frameScreenImageView.image = nil;
    self.frameScreenImageView.image = maskedNewImage;
    [self.frameScreenImageView setFrameOrigin:screenCompositeImageOrigin];
    [self.frameScreenImageView setFrameSize:screenCompositeImageSize];
    [self.frameScreenImageView setNeedsDisplay];
    
    // url bar background
    
    if ([self.currentFrame hasUrlBar]) {
    
        CGFloat urlBarGutterLeft = floorf(CGRectGetMinX(self.currentFrame.urlBarImage.frame) / 2);
        CGFloat urlBarGutterRight = floorf(self.currentFrame.baseImage.image.size.width
                                        - self.currentFrame.urlBarImage.image.size.width
                                        - CGRectGetMinX(self.currentFrame.urlBarImage.frame) / 2);
        
        CGFloat urlBarWidth = compSize.width - urlBarGutterLeft - urlBarGutterRight;
        CGFloat urlBarHeight = floorf(CGRectGetHeight(self.currentFrame.urlBarImage.frame) / 2);
        CGSize urlBarSize = CGSizeMake(urlBarWidth, urlBarHeight);
        CGPoint urlBarOrigin = CGPointZero;
        urlBarOrigin.x = self.currentFrame.leftBorderWidth + self.imageOffsetWithShadow + urlBarGutterLeft;
        urlBarOrigin.y = floorf(CGRectGetMaxY(self.frameScreenImageView.frame) + CGRectGetMinY(self.currentFrame.urlBarImage.frame) / 2);

        CGRect urlBarFillRect = CGRectMake(0, 0, urlBarWidth, urlBarHeight);
        NSImage *urlBarImageComp = [NSImage imageWithSize:urlBarSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            [self.currentFrame.urlBarImage.image drawInRect:urlBarFillRect];
            return YES;
        }];

        [self.frameURLBarImageView setFrameOrigin:urlBarOrigin];
        [self.frameURLBarImageView setFrameSize:urlBarSize];
        self.frameURLBarImageView.image = nil;
        self.frameURLBarImageView.image = urlBarImageComp;
        self.frameURLBarImageView.alphaValue = 1.0;
        [self.frameURLBarImageView setNeedsDisplay];
    
    } else {
        self.frameURLBarImageView.alphaValue = 0.0;
        self.frameURLBarImageView.frame = CGRectZero;
    }
    
    [self.frameURLBarImageView setNeedsDisplay];

    // url title
    if ([self.currentFrame hasURL]) {
        NSString *URL = [defaults objectForKey:kNSUserDefaultsKeyURLTitle];
        [self drawURLTextField:URL];
    } else {
        self.frameUrlTextField.alphaValue = 0.0;
    }
    
    // frame title
    if ([self.currentFrame hasTitle]) {
        NSString *title = [defaults objectForKey:kNSUserDefaultsKeyFrameTitle];
        [self drawTitleTextField:title];
    } else {
        self.frameTitleTextField.alphaValue = 0.0;
    }
    
    self.compHeight = compHeight+kChromeGutterWithShadow;
    self.compWidth = compWidth+kChromeGutterWithShadow;
    
}

- (void)drawTitleTextField:(NSString*)title
{
    
    
    NSFont *labelFont = [NSFont labelFontOfSize:self.currentFrame.titleLabelFontSize];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
    CGSize titleSize = CGSizeZero;
    
    // hacky way to avoid cutting off characters
    titleSize.width = titleString.size.width + self.currentFrame.titleLabelFontSize;
    titleSize.height = titleString.size.height;
    
    CGPoint titleOrigin = CGPointZero;
    
    if (self.currentFrame.titleLabel.center) {
        self.frameTitleTextField.alignment = NSCenterTextAlignment;
        titleOrigin.x = CGRectGetMidX(self.frameScreenImageView.frame) - titleSize.width / 2;
    } else {
        self.frameUrlTextField.alignment = NSLeftTextAlignment;
        titleOrigin.x = self.currentFrame.titleLabel.origin.x / 2 + self.imageOffsetWithShadow;
    }
    
    titleOrigin.y =  CGRectGetMaxY(self.frameScreenImageView.frame) + self.currentFrame.titleLabel.origin.y / 2 - titleSize.height / 2;
    
    [self.frameTitleTextField setFrameOrigin:titleOrigin];
    [self.frameTitleTextField setFrameSize:titleSize];
    [self.frameTitleTextField setFont:[NSFont labelFontOfSize:self.currentFrame.titleLabelFontSize]];
    
    self.frameTitleTextField.stringValue = title;
    [self.frameTitleTextField setNeedsDisplay];
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    BOOL enableTitle= [[defaults objectForKey:kNSUserDefaultsKeyEnableTitle] boolValue];
    if (enableTitle) {
        self.frameTitleTextField.alphaValue = 1.0;
    } else {
        self.frameTitleTextField.alphaValue = 0.0;
    }
}

- (void)drawURLTextField:(NSString*)URL
{
    
    NSFont *labelFont = [NSFont labelFontOfSize:[NSFont systemFontSize]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    
    NSAttributedString *urlString = [[NSAttributedString alloc] initWithString:URL attributes:attributes];
    
    CGSize urlTitleSize = CGSizeZero;
    if (CGRectIsEmpty(self.frameURLBarImageView.frame)) {
        urlTitleSize.width = urlString.size.width + 10;
    } else {
        urlTitleSize.width = CGRectGetWidth(self.frameURLBarImageView.frame);
    }
    urlTitleSize.height = urlString.size.height;
    
    CGPoint urlTitleOrigin = CGPointZero;
    
    if (self.currentFrame.urlLabel.center) {
        self.frameUrlTextField.alignment = NSCenterTextAlignment;
        urlTitleOrigin.x = CGRectGetMidX(self.frameScreenImageView.frame) - urlTitleSize.width / 2;
    } else {
        self.frameUrlTextField.alignment = NSLeftTextAlignment;
        urlTitleOrigin.x = self.currentFrame.urlLabel.origin.x / 2 + self.imageOffsetWithShadow;
    }
    
    urlTitleOrigin.y =  CGRectGetMaxY(self.frameScreenImageView.frame) + self.currentFrame.urlLabel.origin.y / 2 - urlTitleSize.height / 2;
    
    [self.frameUrlTextField setFrameOrigin:urlTitleOrigin];
    [self.frameUrlTextField setFrameSize:urlTitleSize];
    
    self.frameUrlTextField.stringValue = URL;
    [self.frameUrlTextField setNeedsDisplay];
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    BOOL enableURLTitle= [[defaults objectForKey:kNSUserDefaultsKeyEnableURLTitle] boolValue];
    if (enableURLTitle) {
        self.frameUrlTextField.alphaValue = 1.0;
    } else {
        self.frameUrlTextField.alphaValue = 0.0;
    }
}

- (void)updateURLTextField:(NSString*)URL
{
    [self drawURLTextField:URL];
}



- (void)updateTitleTextField:(NSString*)title
{
    [self drawTitleTextField:title];
}


#pragma mark - Sizing

- (NSSize)sizeOfImage:(NSImage*)image
{
    NSSize size = CGSizeZero;
    size.width = (int)image.size.width;
    size.height = (int)image.size.height;
    
    // on non-retina screens cut the image size in half
    if (![NSScreen isRetina]) {
        size = CGSizeHalf(size);
    }
    
    return size;
}

#pragma mark - Resizing

- (void)resizeDropImageViewFrame
{
    NSValue *value = [NSValue valueWithSize:CGSizeMake(self.compWidth, self.compHeight)];
    [self.dragDropImageView resizeFrame:value];
    
}

#pragma mark - Compositing and Saving

- (NSArray*)gatherViewsForComposite
{

    [self prepareBackgroundFillView];
    
    NSArray *allViews;
    
    if (self.compType == MFImageCompTypeFrame) {
        allViews = self.frameViews;
    }
    
    if (self.compType == MFImageCompTypeMockup) {
        allViews = self.mockupViews;
    }
    
    NSMutableArray *orderedViews= [NSMutableArray array];
    NSArray *subviews = self.subviews;
    
    for (NSView *view in subviews) {
        if ([allViews containsObject:view]) {
            [orderedViews addObject:view];
        }
    }
    
    NSMutableArray *views = [NSMutableArray array];
    for (NSView *view in orderedViews) {
        if (view.alphaValue > 0.0
            || view == self.mockupBackgroundFillView
            || view == self.frameBackgroundFillView) {
            
            // hacky way to copy the View. doesn't save ivars in subclasses
            NSData *archivedView = [NSKeyedArchiver archivedDataWithRootObject:view];
            NSView *viewCopy = [NSKeyedUnarchiver unarchiveObjectWithData:archivedView];
            
            // set the interpolation on the copy since it was not copied over
            if ([view isKindOfClass:[MFImageView class]]) {
                ((MFImageView*)viewCopy).renderInterpolation = ((MFImageView*)view).renderInterpolation;
            }
            [views addObject:viewCopy];
        }
    }
    return views;
}


- (void)prepareBackgroundFillView
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSData *colorWheelData = [defaults objectForKey:kNSUserDefaultsKeyBackgroundColor];
    NSColor *fillColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorWheelData];
    
    NSPoint fillOrigin = CGPointZero;
    NSSize fillSize = CGSizeMake(self.compWidth, self.compHeight);
    NSPoint frameOrigin = fillOrigin;
    
    if (self.compType == MFImageCompTypeMockup) {
        
        NSInteger gutter = self.currentMockup.bottomGutter /  2;
        if (!self.landscapeMode) {
            fillSize = CGSizeMake(fillSize.width,fillSize.height +  gutter);
        } else {
            fillSize = CGSizeMake(fillSize.width +  gutter, fillSize.height);
            frameOrigin = CGPointMake(frameOrigin.x - gutter, frameOrigin.y);
        }
    }
    
    NSSize frameSize = fillSize;
    NSRect fillFrame = NSRectMake(fillOrigin, fillSize);
    
    NSImage *colorFill = [NSImage imageWithSize:fillSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [fillColor set];
        NSRectFill(fillFrame);
        return YES;
    }];
    
    self.frameBackgroundFillView.image = colorFill;
    self.frameBackgroundFillView.alphaValue = 0.0;
    [self.frameBackgroundFillView setFrameOrigin:frameOrigin];
    [self.frameBackgroundFillView setFrameSize:frameSize];
    [self.frameBackgroundFillView setNeedsDisplay];
    
    self.mockupBackgroundFillView.image = colorFill;
    self.mockupBackgroundFillView.alphaValue = 0.0;
    [self.mockupBackgroundFillView setFrameOrigin:frameOrigin];
    [self.mockupBackgroundFillView setFrameSize:frameSize];
    [self.mockupBackgroundFillView setNeedsDisplay];
    
}


- (void)saveMockup
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *currentStyleType = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleName];
    
    NSString *newFileName = [NSString stringWithFormat:@"%@ %@",[self.imageFileName stringByDeletingPathExtension], currentStyleType];
    if ([[defaults objectForKey:kNSUserDefaultsKeySaveAtHighResolutions] boolValue] && [NSScreen isRetina]) {
        newFileName = [NSString stringWithFormat:@"%@@2x",newFileName];
    }
    newFileName = [NSString stringWithFormat:@"%@.png",newFileName];
    newFileName = [newFileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
 
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:newFileName];
    
    
    // only show @2x button if on retina
    if ([NSScreen isRetina]) {
        NSViewController *controller = [[NSViewController alloc] initWithNibName:@"MFSavePanelOptionsController" bundle:[NSBundle mainBundle]];
        NSView *optionsView = controller.view;
        [panel setAccessoryView:optionsView];
    }
    
    // offset
    NSSize offset = CGSizeZero;
    if (self.compType == MFImageCompTypeMockup && self.landscapeMode) {
        offset = CGSizeMake(self.currentMockup.bottomGutter, 0);
    }
    
    MFMockupView *weakSelf = self;
    
    // save() block
    void (^save)(void) = ^{
        
        MFMockupView *strongSelf = weakSelf;
        
        FTICK(@"save()");
        
        __block NSArray *viewList;
        
        // block main thread for gathering and notifications
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSaveFileStarted object:nil];
            viewList = [strongSelf gatherViewsForComposite];
        });
        FTOCK(@"views gathered");
        
        MFViewCompositor *compositor = [MFViewCompositor compositor];
        NSImage *image = [compositor compositeViews:viewList offset:offset];
        
        // defaults can change based on the optionsView, so reload them
        // on non-retina screens, default to High Resolution (@2x actually renders as @1x -- sorry bout that)
        NSNumber *scalingFactor;
        NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
        
        if ([NSScreen isRetina]) {
            if ([[defaults objectForKey:kNSUserDefaultsKeySaveAtHighResolutions] boolValue]) {
                scalingFactor = [NSNumber numberWithFloat:kScalingFactorRetinaHighResolution];
            } else {
                scalingFactor = [NSNumber numberWithFloat:kScalingFactorRetinaDefaultResolution];
            }
        } else {
            scalingFactor = [NSNumber numberWithFloat:kScalingFactorDefaultResolution];
        }
        

        
        // save
        NSURL *saveURL = [panel URL];
        [image writePNGToURL:saveURL outputScaling:scalingFactor error:nil];
        
        // notifications need to be on the main thread
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSaveFileCompleted object:nil];
        });
        FTOCK(@"save()");
        
    };
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                save();
            });
        }
    }];
}

#pragma mark - Frame/Mockup Master Toggles


- (void)toggleMockupsOn
{
    for (NSView *view in self.mockupViews) {
        view.hidden = NO;
    }
}

- (void)toggleMockupsOff
{
    for (NSView *view in self.mockupViews) {
        view.hidden = YES;
    }
}

- (void)toggleFramesOn
{
    for (NSView *view in self.frameViews) {
        view.hidden = NO;
    }
}

- (void)toggleFramesOff
{
    for (NSView *view in self.frameViews) {
        view.hidden = YES;
    }
}

#pragma mark - Individual View Toggles

- (void)toggleLandscapeMode:(id)sender
{
    BOOL previousState = self.landscapeMode;
    if([sender state] == NSOnState) {
        self.landscapeMode = YES;
    } else {
        self.landscapeMode = NO;
    }
    [self setLandscapeMode];
    if (self.landscapeMode != previousState) {
        [self reloadCurrentImage];
    }
}

- (void)toggleShadowImage:(id)sender
{
    NSImageView *image = [self currentShadowImage];
    if([sender state] == NSOnState) {
        [[image animator] setAlphaValue:1.0];
    } else {
        [[image animator] setAlphaValue:0.0];
    }
    [image setNeedsDisplay];
}

- (NSImageView*)currentShadowImage
{
    if (self.compType == MFImageCompTypeFrame) {
        return self.frameShadowImageView;
    }
    return self.mockupShadowImageView;
}

- (void)toggleLogoImage:(id)sender
{
    NSImageView *image = self.mockupLogoImageView;
    if([sender state] == NSOnState) {
        [[image animator] setAlphaValue:1.0];
    } else {
        [[image animator] setAlphaValue:0.0];
    }
    [image setNeedsDisplay];
    
}

- (void)toggleGlareImage:(id)sender
{
    NSImageView *image = self.mockupGlareImageView;
    if([sender state] == NSOnState) {
        [[image animator] setAlphaValue:1.0];
    } else {
        [[image animator] setAlphaValue:0.0];
    }
    [image setNeedsDisplay];
}

- (void)toggleOSBackground:(id)sender
{
    NSImageView *image = self.mockupOSBackgroundImageView;
    if([sender state] == NSOnState) {
        [[image animator] setAlphaValue:1.0];
    } else {
        [[image animator] setAlphaValue:0.0];
    }
    [image setNeedsDisplay];
}

- (void)toggleURLTitle:(id)sender
{
    NSTextField *title = self.frameUrlTextField;
    if([sender state] == NSOnState) {
        [[title animator] setAlphaValue:1.0];
    } else {
        [[title animator] setAlphaValue:0.0];
    }
    [title setNeedsDisplay];
}

- (void)toggleTitle:(id)sender
{
    NSTextField *title = self.frameTitleTextField;
    if([sender state] == NSOnState) {
        [[title animator] setAlphaValue:1.0];
    } else {
        [[title animator] setAlphaValue:0.0];
    }
    [title setNeedsDisplay];
}

- (void)toggleStatusbar:(id)sender
{
    NSImageView *title = self.mockupStatusbarImageView;
    if([sender state] == NSOnState) {
        [[title animator] setAlphaValue:1.0];
    } else {
        [[title animator] setAlphaValue:0.0];
    }
    [title setNeedsDisplay];
}




@end
