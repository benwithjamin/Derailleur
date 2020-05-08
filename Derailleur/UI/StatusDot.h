//
//  StatusDot.h
//  Derailleur
//
//  Created by Ben Smith on 06/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#define RED		1
#define AMBER	2
#define GREEN	3

@interface StatusDot : NSView

- (void) stopFlashing;
- (void) startFlashing;
- (void) setColour: (NSInteger)colour;

@end

NS_ASSUME_NONNULL_END
