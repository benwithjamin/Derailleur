//
//  NSView+Extensions.m
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
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
