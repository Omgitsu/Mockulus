//
//  MFAboutView.m
//  Mockulus
//
//  Created by James Baker on 6/27/15.
//  Copyright (c) 2015 WDDG. All rights reserved.
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


#import "MFAboutView.h"
#import "AppDelegate.h"


NSString * const kAboutProgrammerName = @"James Baker @omgitsu";
NSString * const kAboutProgrammerURL = @"https://instagram.com/omgitsu/";
NSString * const kAboutTrademarkNotice = @"All trademarks and registered trademarks are the property of their respective owners.";
NSString * const kAboutAcknowledgementsURL = @"http://mockul.us/acknowledgements.pdf";

@implementation MFAboutView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self setup];
}


- (void)setup
{
    _gitHubButton.cursor = [NSCursor pointingHandCursor];
    
    // do the about text
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:10];
    // color: 162,162,151
    NSColor *color = [NSColor colorWithRed:0.63 green:0.63 blue:0.59 alpha:1];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:color,
                                 };
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Designed and programmed by "attributes:attributes];
    
    // Create hyperlink
    NSString *linkName = kAboutProgrammerName;
    NSURL *url = [NSURL URLWithString:kAboutProgrammerURL];
    NSMutableAttributedString *hyperlinkString = [[NSMutableAttributedString alloc] initWithString:linkName];
    [hyperlinkString beginEditing];
    [hyperlinkString addAttribute:NSLinkAttributeName value:url range:NSMakeRange(0, [hyperlinkString length])];
    [hyperlinkString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [hyperlinkString length])];
    [hyperlinkString addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, [hyperlinkString length])];
    [hyperlinkString endEditing];
    [string appendAttributedString:hyperlinkString];
    NSString *copyright = [NSString stringWithFormat:@"\n%@", kCopyrightNotice];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:copyright attributes:attributes]];
    NSString *trademark = [NSString stringWithFormat:@"\n%@", kTrademarkNotice];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:trademark attributes:attributes]];
    
    [_copyrightText setAttributedStringValue:string];
    
}

#pragma mark - Actions

-(IBAction)openGitHub:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:kProjectURL]];
}

-(IBAction)openAcknowledgements:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:kAboutAcknowledgementsURL]];
}

@end
