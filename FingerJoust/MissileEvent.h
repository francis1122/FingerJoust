//
//  MissleEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"

@class GameLayer;
@interface MissileEvent : HazardEvent{
    int missilesLeft;
    float fireNextMissile;
    NSMutableArray *missileArray;
}

@property (nonatomic, retain) NSMutableArray *missileArray;

-(id) initWithTime:(float) time MissileAmount:(int) missileAmount GameLayer:(GameLayer*)gLayer;
-(void) checkCollisions;
-(void) createMissile;
@end
