//
//  BluetoothManager.h
//  Derailleur
//
//  Created by Ben Smith on 06/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef BluetoothManager_h
#define BluetoothManager_h

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "BikeData.h"
#import "BluetoothStatuses.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BluetoothManagerDelegate <NSObject>

- (void) didUpdateStatus:(int)status;
- (void) didReceiveData:(ICGLiveStreamData*)data;

@end


@interface BluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, weak) id <BluetoothManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

#endif /* BluetoothManager_h */
