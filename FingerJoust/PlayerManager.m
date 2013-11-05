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

@synthesize playerArray, isTeamPlay, windEvent, bombEvent, hurricaneEvent, spikeEvent, missileEvent, frequencyEvent, gameSpeed, isGameUnlocked;

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
        gameSpeed = 1;
        frequencyEvent = 1;
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
        
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"unlockGame"]) {
            self.isGameUnlocked = YES;
        } else {
            self.isGameUnlocked = NO;
        }
        
        
    }
    return self;
}

-(void) unlockTheGame{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"unlockGame"];
}

-(BOOL) isPlayerActive:(int) playerNumber{
    for(Player *player in self.playerArray){
        if(player.playerNumber == playerNumber){
            return player.isActive;
        }
    }
    return NO;
}

-(float) getGameSpeedScaler{
    float scaler = 1;
    if(gameSpeed == 0){
        scaler = .6;
    }else if(gameSpeed == 1){
        scaler = 1;
    }else if(gameSpeed == 2){
        scaler = 1.5;
    }
    return scaler;
}

@end
