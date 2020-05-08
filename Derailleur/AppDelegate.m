//
//  AppDelegate.m
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <IOKit/pwr_mgt/IOPMLib.h>

#import "AppDelegate.h"
#import "DerailleurMainView.h"
#import "NSColor+DerailleurColours.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSWindow *window;

@end

@implementation AppDelegate
{
	IOPMAssertionID preventSleepAssertion;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSSize windowSize = NSMakeSize(500, 300);
	NSSize screenSize = NSScreen.mainScreen.frame.size;
	
	NSRect windowRect = NSMakeRect(screenSize.width / 2 - windowSize.width / 2, screenSize.height / 2 - windowSize.height / 2, windowSize.width, windowSize.height);
	
	_window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:NO];
	
	[_window setMovableByWindowBackground:YES];
	[_window setTitleVisibility:NSWindowTitleHidden];
	[_window setTitlebarAppearsTransparent:YES];
	[_window setAppearance:[NSAppearance appearanceNamed: NSAppearanceNameDarkAqua]];
	
	[_window setContentView: [[DerailleurMainView alloc] init]];
	
	[_window makeKeyAndOrderFront:nil];
	
	/* Prevent display from sleeping until the application closes */
	IOPMAssertionCreateWithName(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, CFSTR("Derailleur displaying data"), &preventSleepAssertion);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	/* Remove IOPMAssertion preventing display from sleeping while idle */
	IOPMAssertionRelease(preventSleepAssertion);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}


@end
