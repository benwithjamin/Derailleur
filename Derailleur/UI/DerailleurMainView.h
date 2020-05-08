//
//  DerailleurMainView.h
//  Derailleur
//
//  Created by Ben Smith on 05/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BluetoothManager.h"
#import "StatusDot.h"

NS_ASSUME_NONNULL_BEGIN

@interface DerailleurMainView : NSView <BluetoothManagerDelegate>

@property (nonatomic, strong) NSView *cadenceView;
@property (nonatomic, strong) NSTextField *cadenceLabel;

@property (nonatomic, strong) NSView *resistanceView;
@property (nonatomic, strong) NSTextField *resistanceLabel;

@property (nonatomic, strong) NSStackView *metricsStack;

@property (nonatomic, strong) NSView *statusBar;
@property (nonatomic, strong) NSTextField *statusLabel;
@property (nonatomic, strong) StatusDot *statusDot;

@property (nonatomic, strong) BluetoothManager* bluetoothManager;

@end

NS_ASSUME_NONNULL_END
