//
//	Derailleur
//	Copyright (c) 2020 Ben Smith
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

#import "NSColor+DerailleurColours.h"

@implementation NSColor (DerailleurColours)

+ (NSColor *)lightGrey
{
	return [NSColor colorWithRed:54.0f/255.0f green:55.0f/255.0f blue:59.0f/255.0f alpha:1.0];
}

+ (NSColor *)darkGrey
{
	CGColorRef colour = CGColorCreateGenericRGB(35.0f/255.0f, 36.0f/255.0f, 42.0f/255.0f, 1);
	
	return [NSColor colorWithCGColor:colour];
	
//	return [NSColor colorWithRed:35.0f/255.0f green:36.0f/255.0f blue:42.0f/255.0f alpha:1.0];
}

- (NSColor *)lightenByPercentage:(CGFloat)percentage
{
	CGFloat red, green, blue, alpha;
	[self getRed:&red green:&green blue:&blue alpha:&alpha];
	
	return [NSColor colorWithRed:MIN(red + percentage / 100, 1.0) green:MIN(green + percentage / 100, 1.0) blue:MIN(blue + percentage / 100, 1.0) alpha:alpha];
}

@end
