//
//  DerailleurMainView.m
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import "DerailleurMainView.h"
#import "NSColor+DerailleurColours.h"
#import "NSView+LayoutAdditions.h"
#import "StatusDot.h"

@implementation DerailleurMainView

- (void) drawRect: (NSRect) dirtyRect
{
    [super drawRect:dirtyRect];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		_bluetoothManager = [[BluetoothManager alloc] init];
		[_bluetoothManager setDelegate:self];
		
		[self setupViews];
		[self setupLayout];
	}
	return self;
}

- (void) setupViews
{
	[self setWantsLayer:YES];
	[self.layer setBackgroundColor:[[NSColor darkGrey] CGColor]];
	
	/* Set up cadence view and associated subviews */
	_cadenceView = [[NSView alloc] init];
	
	[_cadenceView setWantsLayer:YES];
	[[_cadenceView layer] setCornerRadius:10];
	[[_cadenceView layer] setBackgroundColor: [[NSColor lightGrey] CGColor]];
	[_cadenceView setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSTextField *cadenceTitle = [[NSTextField alloc] init];
	
	[cadenceTitle setEditable:NO];
	[cadenceTitle setBezeled:NO];
	[cadenceTitle setDrawsBackground:NO];
	[cadenceTitle setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
	[cadenceTitle setAlignment:NSTextAlignmentCenter];
	[cadenceTitle setFont:[NSFont boldSystemFontOfSize:18]];
	[cadenceTitle setStringValue:@"Cadence (RPM)"];
	
	[_cadenceView addSubview:cadenceTitle];
	[cadenceTitle centerHorizontallyInSuperview];
	[cadenceTitle.bottomAnchor constraintEqualToAnchor:_cadenceView.bottomAnchor constant: -20].active = YES;
	
	/* Set up cadence label */
	_cadenceLabel = [[NSTextField alloc] init];
	
	[_cadenceLabel setEditable:NO];
	[_cadenceLabel setBezeled:NO];
	[_cadenceLabel setDrawsBackground:NO];
	[_cadenceLabel setTextColor: [NSColor whiteColor]]; // TODO: change the text colour?
	[_cadenceLabel setStringValue:@"0"];
	[_cadenceLabel setAlignment:NSTextAlignmentCenter];
	[_cadenceLabel setFont: [NSFont boldSystemFontOfSize:75]];
	
	[_cadenceView addSubview:_cadenceLabel];
	
	/* Set up resistance view and associated subviews */
	_resistanceView = [[NSView alloc] init];
	
	[_resistanceView setWantsLayer:YES];
	[[_resistanceView layer] setCornerRadius:10];
	[[_resistanceView layer] setBackgroundColor: [[NSColor lightGrey] CGColor]];
	[_resistanceView setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSTextField *resistanceTitle = [[NSTextField alloc] init];
	
	[resistanceTitle setEditable:NO];
	[resistanceTitle setBezeled:NO];
	[resistanceTitle setDrawsBackground:NO];
	[resistanceTitle setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
	[resistanceTitle setAlignment:NSTextAlignmentCenter];
	[resistanceTitle setFont:[NSFont boldSystemFontOfSize:18]];
	[resistanceTitle setStringValue:@"Resistance"];
	
	[_resistanceView addSubview:resistanceTitle];
	[resistanceTitle centerHorizontallyInSuperview];
	[resistanceTitle.bottomAnchor constraintEqualToAnchor:_resistanceView.bottomAnchor constant: -20].active = YES;
	
	/* Set up resistance label */
	_resistanceLabel = [[NSTextField alloc] init];
	
	[_resistanceLabel setEditable:NO];
	[_resistanceLabel setBezeled:NO];
	[_resistanceLabel setDrawsBackground:NO];
	[_resistanceLabel setTextColor: [NSColor whiteColor]]; // TODO: change the text colour?
	[_resistanceLabel setStringValue:@"0%"];
	[_resistanceLabel setAlignment:NSTextAlignmentCenter];
	[_resistanceLabel setFont: [NSFont boldSystemFontOfSize:75]];
	
	[_resistanceView addSubview:_resistanceLabel];
	
	/* Set up metrics stack view and add subviews */
	_metricsStack = [[NSStackView alloc] init];
	
	[_metricsStack setOrientation:NSUserInterfaceLayoutOrientationHorizontal];
	[_metricsStack setAlignment:NSLayoutAttributeCenterY];
	[_metricsStack setDistribution:NSStackViewDistributionFillEqually];
	[_metricsStack setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_metricsStack setSpacing:15];
	
	[_metricsStack addArrangedSubview:_cadenceView];
	[_metricsStack addArrangedSubview:_resistanceView];
	
	[self addSubview:_metricsStack];
	
	/* Set up status bar and associated subviews */
	_statusBar = [[NSView alloc] init];
	
	[_statusBar setWantsLayer:YES];
	[[_statusBar layer] setCornerRadius:5];
	[[_statusBar layer] setBackgroundColor:[[NSColor lightGrey] CGColor]];
	[_statusBar setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	_statusLabel = [[NSTextField alloc] init];
	
	[_statusLabel setEditable:NO];
	[_statusLabel setBezeled:NO];
	[_statusLabel setDrawsBackground:NO];
	[_statusLabel setTextColor:[[NSColor lightGrey] lightenByPercentage:40]];
	[_statusLabel setAlignment:NSTextAlignmentLeft];
	[_statusLabel setFont:[NSFont boldSystemFontOfSize:11]];
	[_statusLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[_statusBar addSubview:_statusLabel];
	
	[self addSubview:_statusBar];
	
	_statusDot = [[StatusDot alloc] init];
	
	[_statusBar addSubview:_statusDot];
}

- (void) setupLayout
{
	[_cadenceLabel centerInSuperviewAdjustedVertically:-15];
	[_resistanceLabel centerInSuperviewAdjustedVertically:-15];
	
	[NSLayoutConstraint activateConstraints:@[
		[_statusBar.heightAnchor constraintEqualToConstant:25],
		[_statusBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20],
		[_statusBar.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20],
		[_statusBar.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20],
		
		[_statusDot.heightAnchor constraintEqualToConstant:10],
		[_statusDot.widthAnchor constraintEqualToConstant:10],
		[_statusDot.centerYAnchor constraintEqualToAnchor:_statusBar.centerYAnchor],
		[_statusDot.rightAnchor constraintEqualToAnchor:_statusBar.rightAnchor constant:-10],
		
		[_statusLabel.leftAnchor constraintEqualToAnchor:_statusBar.leftAnchor constant:10],
		[_statusLabel.centerYAnchor constraintEqualToAnchor:_statusBar.centerYAnchor],
		
		[_metricsStack.topAnchor constraintEqualToAnchor:self.topAnchor constant:30],
		[_metricsStack.bottomAnchor constraintEqualToAnchor:_statusBar.topAnchor constant:-15],
		[_metricsStack.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20],
		[_metricsStack.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20]
	]];
}

- (void)didUpdateStatus:(int)status {
	[_statusLabel setStringValue:[NSString stringWithUTF8String:STATUS_MESSAGES[status]]];
	
	switch (status) {
		case BLUETOOTH_POWERED_ON_SCANNING:
		case BIKE_DISCOVERED:
			[_statusDot setColour: AMBER];
			break;
			
		case BLUETOOTH_POWERED_OFF:
			[_statusDot setColour: RED];
			break;
			
		case BLUETOOTH_UNAUTHORISED:
		case BLUETOOTH_UNSUPPORTED:
		case BIKE_UNABLE_TO_CONNECT:
		case BIKE_UNABLE_TO_DISCOVER:
		case BIKE_ERROR:
			[_statusDot stopFlashing];
			[_statusDot setColour: RED];
			break;
			
		case BIKE_CONNECTED:
			[_statusDot stopFlashing];
			[_statusDot setColour: GREEN];
			break;
		
		case BIKE_CONNECTED_RECEIVING:
			[_statusDot startFlashing];
			[_statusDot setColour: GREEN];
			break;
	}
}

- (void)didReceiveData:(ICGLiveStreamData *)data
{
	[_cadenceLabel setStringValue: [NSString stringWithFormat:@"%d", data->cadence]];
	[_resistanceLabel setStringValue: [NSString stringWithFormat:@"%d%%", data->brake_level]];
}

@end
