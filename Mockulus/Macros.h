//
//  Macros.h
//  Mockulus
//
//  Created by James Baker on 5/10/15.
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

CG_INLINE CGSize
CGSizeHalf(CGSize size)
{
    CGSize newSize; newSize.width = size.width/2; newSize.height = size.height/2; return newSize;
}

CG_INLINE CGPoint
CGPointHalf(CGPoint point)
{
    CGPoint newPoint; newPoint.x = point.x/2; newPoint.y = point.y/2; return newPoint;
}

CG_INLINE CGSize
CGSizeDouble(CGSize size)
{
    CGSize newSize; newSize.width = size.width*2; newSize.height = size.height*2; return newSize;
}

CG_INLINE CGPoint
CGPointDouble(CGPoint point)
{
    CGPoint newPoint; newPoint.x = point.x*2; newPoint.y = point.y*2; return newPoint;
}

CG_INLINE CGPoint
CGPointCenter(CGPoint origin, CGSize size)
{
    CGPoint newPoint;
    newPoint.x = origin.x + size.width / 2;
    newPoint.y = origin.y + size.height / 2;
    return newPoint;
}

CG_INLINE NSRect
NSRectNew()
{
    NSRect newRect; newRect.origin.x = 0; newRect.origin.y = 0; newRect.size.height = 0; newRect.size.width = 0; return newRect;
}

CG_INLINE NSRect
NSRectMake(CGPoint origin, CGSize size)
{
    NSRect newRect; newRect.origin.x = origin.x; newRect.origin.y = origin.y; newRect.size.height = size.height; newRect.size.width = size.width; return newRect;
}

