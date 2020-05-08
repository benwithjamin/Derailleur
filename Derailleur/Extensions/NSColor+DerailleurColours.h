//
//  NSColor+DerailleurColours.h
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef NSColor_Extensions_h
#define NSColor_Extensions_h

#import <Cocoa/Cocoa.h>

@interface NSColor (DerailleurColours)

+ (NSColor *) lightGrey;
+ (NSColor *) darkGrey;

- (NSColor *) lightenByPercentage: (CGFloat) percentage;

@end

#endif /* NSColor_Extensions_h */
