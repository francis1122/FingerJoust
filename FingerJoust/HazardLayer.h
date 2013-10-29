//
//  HazardLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;
@interface HazardLayer : CCLayer {
    GameLayer *gameLayer;
    
    float roundTimerElapsed;
    float sinceLastEvent;
    NSMutableArray *eventArray;
    
    BOOL addAlways;
    BOOL noEvents;
    
    float lastMissile;
    float lastBomb;
    NSMutableArray *validEvents;
    
    float frequency;
}

@property (nonatomic, retain) NSMutableArray *validEvents;
@property (nonatomic, retain) NSMutableArray *eventArray;


-(id)initWithGameLayer:(GameLayer*) gLayer;
-(void) resetLayer;

-(void) chooseEvent;

@end
