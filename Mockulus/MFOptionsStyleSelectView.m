//
//  MFOptionsStyleView.m
//  Mockulus
//
//  Created by James Baker on 5/26/15.
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

#import "MFOptionsStyleSelectView.h"
#import "MFOptionsStyleButton.h"
#import <PureLayout/PureLayout.h>
#import "AppDelegate.h"
#import "MFUserDefaultsController.h"

NSString * const kNotificationStyleTypeChanged = @"The Style type has changed";
NSString * const kNotificationUpdateInfoLabel = @"Update the info label";

#pragma mark - Private

@interface MFOptionsStyleSelectView()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (assign, nonatomic) CGFloat buttonWidth;
@property (strong, nonatomic) NSArray *buttons;

@end

#pragma mark - Lifecycle

@implementation MFOptionsStyleSelectView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    _buttonWidth = 130;
    
    NSRect frame = CGRectMake(0, 0, _buttonWidth, 0);
    NSArray *fileNames = @[@"Mockups", @"Frames"];
    NSMutableArray *buttonList = [NSMutableArray array];
    
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    NSString *currentStyleName = [defaults valueForKey:kNSUserDefaultsKeyCurrentStyleName];
    
    for (NSString *fileName in fileNames) {
        
        NSString *privateFile = [fileName stringByAppendingString:@"-Private"];
        NSString *file = [[NSBundle mainBundle] pathForResource:privateFile ofType:@"plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
            NSString *publicFile = [fileName stringByAppendingString:@"-Public"];
            file = [[NSBundle mainBundle] pathForResource:publicFile ofType:@"plist"];
        }
        
        NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:file][[fileName lowercaseString]];
        
        NSMutableArray *sortedKeys = [NSMutableArray arrayWithArray:[config allKeys]];
        [sortedKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        for (NSString *key in sortedKeys) {
            
            NSDictionary *frameConfig = config[key];
            
            NSImage *buttonImage = [NSImage imageNamed:frameConfig[@"icon_file"]];
            frame.size.height = ceilf(buttonImage.size.height * 1);
            
            MFOptionsStyleButton *newButton = [MFOptionsStyleButton buttonWithFrame:frame contentsOfDictionary:frameConfig];
            
            [self addSubview:newButton];
            [buttonList addObject:newButton];
            [newButton display];
            [newButton setTarget:self];
            [newButton setAction:@selector(styleButtonClicked:)];
            
            if ([currentStyleName isEqualToString:frameConfig[@"title"]]) {
                [self toggleButtonOn:newButton];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateInfoLabel object:newButton.styleInfo];
            }
            
        }
        
    }
    
    _buttons = buttonList;
}


// this will pin the subviews to the top instead of the bottom

-(BOOL)isFlipped {
    return YES;
}


#pragma mark - Constraints

- (void)updateConstraints {
    
    if (!_didSetupConstraints) {
        [self setupContraints];
        _didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)setupContraints
{
    
    CGFloat totalHeight = 0;
    CGFloat titleHeight = 30;
    CGFloat gutterBetweenButtons = 15;
    MFOptionsStyleButton *previousButton;
    
    // auto layout
    
    for (MFOptionsStyleButton *button in _buttons) {
        CGFloat height = CGRectGetHeight(button.frame) + titleHeight;
        totalHeight = totalHeight + height + gutterBetweenButtons;
        
        [button autoSetDimension:ALDimensionWidth toSize:_buttonWidth];
        [button autoSetDimension:ALDimensionHeight toSize:height];
        [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        if (!previousButton) {
            [button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        } else {
            [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousButton withOffset:gutterBetweenButtons];
        }
        
        previousButton = button;
    }
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                         toItem:nil
                         attribute:NSLayoutAttributeWidth
                         multiplier:1.0
                         constant:totalHeight]];
    
}

- (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (BOOL)translatesAutoresizingMaskIntoConstraints
{
    return [super translatesAutoresizingMaskIntoConstraints];
}

#pragma mark - Button Handling

- (void)styleButtonClicked:(MFOptionsStyleButton*)sender
{
    if (!sender.selected) {
        [self toggleAllButtonsOff];
        [self enableAllButtons];
        [self setNewStyle:sender.styleName type:sender.styleType];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateInfoLabel object:sender.styleInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStyleTypeChanged object:nil];
    }
    [self toggleButtonOn:sender];
    
}

- (void)setNewStyle:(NSString*)styleName type:(NSString*)styleType
{
    NSUserDefaults *defaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    [defaults setValue:styleName forKey:kNSUserDefaultsKeyCurrentStyleName];
    [defaults setValue:styleType forKey:kNSUserDefaultsKeyCurrentStyleType];
}

- (void)enableButton:(MFOptionsStyleButton*)button
{
    button.enabled = YES;
    button.selected = NO;
}

- (void)disableButton:(MFOptionsStyleButton*)button
{
    button.enabled = NO;
    button.selected = NO;
}

- (void)toggleButtonOff:(MFOptionsStyleButton*)button
{
    button.state = NSOffState;
    button.selected = NO;
}

- (void)toggleButtonOn:(MFOptionsStyleButton*)button
{
    button.state = NSOnState;
    button.selected = YES;
}

- (void)enableAllButtons
{
    for (MFOptionsStyleButton *button in _buttons) {
        [self enableButton:button];
    }
}

- (void)disableAllButtons
{
    for (MFOptionsStyleButton *button in _buttons) {
        [self disableButton:button];
    }
}

- (void)toggleAllButtonsOff
{
    for (MFOptionsStyleButton *button in _buttons) {
        [self toggleButtonOff:button];
    }
}

@end
