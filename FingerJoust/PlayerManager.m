//
//  PlayerManager.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "PlayerManager.h"
#import "Player.h"

@implementation PlayerManager

static PlayerManager *sharedInstance = nil;

@synthesize playerArray, isTeamPlay, windEvent, bombEvent, hurricaneEvent, spikeEvent, missileEvent;

+ (PlayerManager*)sharedInstance {
    @synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

-(id) init{
    if(self = [super init]){
        self.playerArray = [NSMutableArray array];
        windEvent = EventOn;
        bombEvent = EventOn;
        hurricaneEvent = EventOn;
        spikeEvent = EventOn;
        missileEvent = EventOn;
        
        for(int i = 0; i < 4; i++){
            Player *player = [[[Player alloc] init] autorelease];
            player.playerNumber = i;
            if(i < 2){
                player.team = 0;
            }else{
                player.team = 1;
            }
            [self.playerArray addObject:player];
        }
    }
    return self;
}

@end
