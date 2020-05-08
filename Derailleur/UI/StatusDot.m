//
//  StatusDot.m
//  Derailleur
//
//  Created by Ben Smith on 06/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import "StatusDot.h"
#import <QuartzCore/QuartzCore.h>

/*
 let red: NSColor = .init(red: 251/255, green: 73/255, blue: 71/255, alpha: 1.0)
 let orange: NSColor = .init(red: 253/255, green: 180/255, blue: 37/255, alpha: 1.0)
 let green: NSColor = .init(red: 35/255, green: 174/255, blue: 41/255, alpha: 1.0)
 */

@implementation StatusDot
{
	CABasicAnimation *flashAnimation;
}

- (void)layout
{
	[super layout];
	[self.layer setCornerRadius: self.frame.size.height / 2];
}

- (void) startFlashing
{
	flashAnimation = [[CABasicAnimation alloc] init];
	
	[flashAnimation setKeyPath:@"opacity"];
	[flashAnimation setDuration:0.5];
	[flashAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
	[flashAnimation setToValue:[NSNumber numberWithFloat:0.25f]];
	[flashAnimation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[flashAnimation setAutoreverses:YES];
	[flashAnimation setRepeatCount: INFINITY];
	
	[self.layer addAnimation:flashAnimation forKey:nil];
}

- (void) stopFlashing
{
	[self.layer removeAllAnimations];
}

- (void)setColour:(NSInteger)colour
{
	switch (colour) {
		case RED:
			[self.layer setBackgroundColor: [[NSColor colorWithRed:251.0f/255.0f green:73.0f/255.0f blue:71.0f/255.0f alpha:1.0f] CGColor]];
			break;
			
		case AMBER:
			[self.layer setBackgroundColor: [[NSColor colorWithRed:253.0f/255.0f green:180.0f/255.0f blue:37.0f/255.0f alpha:1.0f] CGColor]];
			break;
			
		case GREEN:
			[self.layer setBackgroundColor: [[NSColor colorWithRed:35.0f/255.0f green:174.0f/255.0f blue:41.0f/255.0f alpha:1.0f] CGColor]];
			break;
	}
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self setupLayer];
		[self startFlashing];
	}
	return self;
}

- (void) setupLayer
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self setWantsLayer:YES];
}

@end
