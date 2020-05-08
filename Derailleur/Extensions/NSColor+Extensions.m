//
//  NSColor+Extensions.m
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
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
