//
//  NSView+LayoutExtensions.h
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef NSView_LayoutExtensions_h
#define NSView_LayoutExtensions_h

#import <Cocoa/Cocoa.h>

@interface NSView (LayoutAdditions)

- (void) setHeight: (CGFloat) height;
- (void) setWidth: (CGFloat) width;

- (void) centerVerticallyInSuperview;
- (void) centerHorizontallyInSuperview;

- (void) centerInSuperview;
- (void) centerInSuperviewAdjustedVertically:(CGFloat) adjustment;
- (void) centerInSuperviewAdjustedHorizontally:(CGFloat) adjustment;

- (void) pinToSuperview;
- (void) pinToSuperviewWithPadding:(CGFloat) padding;
- (void) pinToSuperviewWithEdgeInsets:(NSEdgeInsets) edgeInsets;

@end

#endif /* NSView_LayoutExtensions_h */
