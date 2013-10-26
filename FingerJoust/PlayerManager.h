//
//  PlayerManager.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    EventOff,
    EventOn,
    EventAlways
} EventSettingState;

typedef enum {
    WindEvents,
    MissileEvents,
    HurricaneEvents,
    SpikeEvents,
    BombEvents
} Events;


@interface PlayerManager : NSObject{
    NSMutableArray *playerArray;
    BOOL isTeamPlay;
    
    EventSettingState windEvent;
    EventSettingState bombEvent;
    EventSettingState hurricaneEvent;
    EventSettingState spikeEvent;
    EventSettingState missileEvent;
    // 0 = low, 1 = normal, 2 = often
    int frequencyEvent;
    
    //0 = slow, 1 = normal, 2 = fast
    int gameSpeed;
}

@property BOOL isTeamPlay;
@property (nonatomic, retain) NSMutableArray *playerArray;
@property EventSettingState windEvent, bombEvent, hurricaneEvent, spikeEvent, missileEvent;
@property int frequencyEvent, gameSpeed;

+ (PlayerManager*)sharedInstance;
-(BOOL) isPlayerActive:(int) playerNumber;
-(float) getGameSpeedScaler;


@end
