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

#import "NSView+LayoutAdditions.h"

@implementation NSView (LayoutAdditions)

- (void)setHeight:(CGFloat)height
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.heightAnchor constraintEqualToConstant:height].active = YES;
}

- (void)setWidth:(CGFloat)width
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.widthAnchor constraintEqualToConstant:width].active = YES;
}

- (void)centerHorizontallyInSuperview
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
}

- (void)centerVerticallyInSuperview
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
}

- (void)centerInSuperview
{
	[self centerHorizontallyInSuperview];
	[self centerVerticallyInSuperview];
}

- (void)centerInSuperviewAdjustedVertically:(CGFloat)adjustment
{
	[self setTranslatesAutoresizingMaskIntoConstraints:YES];
	[self centerHorizontallyInSuperview];
	[self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor constant:adjustment].active = YES;
}

- (void)centerInSuperviewAdjustedHorizontally:(CGFloat)adjustment
{
	[self setTranslatesAutoresizingMaskIntoConstraints:YES];
	[self centerVerticallyInSuperview];
	[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor constant:adjustment].active = YES;
}

- (void)pinToSuperview
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[NSLayoutConstraint activateConstraints: @[
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
		[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
		[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor],
		[self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor]
	]];
}

- (void)pinToSuperviewWithPadding:(CGFloat)padding
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[NSLayoutConstraint activateConstraints: @[
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:padding],
		[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-padding],
		[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:padding],
		[self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:-padding]
	]];
}

- (void)pinToSuperviewWithEdgeInsets:(NSEdgeInsets)edgeInsets
{
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[NSLayoutConstraint activateConstraints: @[
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:edgeInsets.top],
		[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-edgeInsets.bottom],
		[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:edgeInsets.left],
		[self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:-edgeInsets.right]
	]];
}

@end
