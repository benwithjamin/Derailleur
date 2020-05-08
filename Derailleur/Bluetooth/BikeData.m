//
//  BikeData.m
//  Derailleur
//
//  Created by Ben Smith on 06/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import "BikeData.h"

void flushDataframe(BikeDataframe *dataFrame)
{
	memset(dataFrame->buffer, 0, 256);
	
	dataFrame->crc = 0;
	dataFrame->len = 0;
	dataFrame->message_id = 0;
}
