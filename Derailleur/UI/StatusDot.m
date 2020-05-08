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

#import "StatusDot.h"
#import <QuartzCore/QuartzCore.h>

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
