//
//  PlayerManager.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager


static PlayerManager *sharedInstance = nil;

+ (PlayerManager*)sharedInstance {
    @synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

@end
