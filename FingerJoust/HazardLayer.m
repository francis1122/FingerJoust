//
//  HazardLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "HazardLayer.h"
#import "GameLayer.h"
#import "HazardEvent.h"
#import "MissileEvent.h"
#import "WindEvent.h"
#import "HurricaneEvent.h"
#import "BombEvent.h"
#import "SpikeEdgeEvent.h"
#import "PlayerManager.h"
#import "HazardEvent.h"

@implementation HazardLayer

@synthesize eventArray, validEvents;

-(id)initWithGameLayer:(GameLayer*) gLayer{
    gameLayer = gLayer;
    if(self = [super init]){
        self.eventArray = [NSMutableArray array];
        self.validEvents = [NSMutableArray array];
        
        //add valid events
        PlayerManager *PM = [PlayerManager sharedInstance];
        if(PM.bombEvent == EventOn){
            NSNumber *eventNumber = [NSNumber numberWithInt:BombEvents];
            [self.validEvents addObject:eventNumber];
        }
        
        if(PM.windEvent == EventOn){
            NSNumber *eventNumber = [NSNumber numberWithInt:WindEvents];
            [self.validEvents addObject:eventNumber];
        }
        
        if(PM.missileEvent == EventOn){
            NSNumber *eventNumber = [NSNumber numberWithInt:MissileEvents];
            [self.validEvents addObject:eventNumber];
        }
        
        if(PM.hurricaneEvent == EventOn){
            NSNumber *eventNumber = [NSNumber numberWithInt:HurricaneEvents];
            [self.validEvents addObject:eventNumber];
        }
        
        if(PM.spikeEvent == EventOn){
            NSNumber *eventNumber = [NSNumber numberWithInt:SpikeEvents];
            [self.validEvents addObject:eventNumber];
        }
        
        if(PM.frequencyEvent == 0){
            frequency = -2;
        }else if(PM.frequencyEvent == 1){
            frequency = 1;
        }else if(PM.frequencyEvent == 2){
            frequency = 4;
        }
    }
    return self;
}

-(void) dealloc{
    [eventArray release];
    [validEvents release];
    [super dealloc];
}

-(void) resetLayer{
    roundTimerElapsed = 0;
    addAlways = NO;
    lastMissile = 0;
    lastBomb = 0;
    sinceLastEvent = frequency + 2 + arc4random()%6;
    for(int i = 0; i < self.eventArray.count; i++){
        HazardEvent *hazardEvent = [self.eventArray objectAtIndex:i];
        [hazardEvent isFinished];
        [self.eventArray removeObject: hazardEvent];
        i--;
    }
}

-(void) update:(ccTime) dt{
    roundTimerElapsed += dt;
    sinceLastEvent += dt;
    [self chooseEvent];
    PlayerManager *PM = [PlayerManager sharedInstance];
    if(!addAlways && roundTimerElapsed > 1.5){
        addAlways = YES;
        if(PM.windEvent == EventAlways){
            WindEvent *windEvent = [[[WindEvent alloc] initWithTime:20 WithForce:18 GameLayer:gameLayer] autorelease];
            [windEvent onStart];
            [self.eventArray addObject:windEvent];
        }
        
        if(PM.spikeEvent == EventAlways){
            SpikeEdgeEvent *spikeEvent = [[[SpikeEdgeEvent alloc] initWithTime:20 GameLayer:gameLayer] autorelease];
            [spikeEvent onStart];
            [self.eventArray addObject:spikeEvent];
        }
        
        if(PM.hurricaneEvent == EventAlways){
            HurricaneEvent *hurEvent = [[[HurricaneEvent alloc] initWithTime:20 WithHurricaneAmount:2 GameLayer:gameLayer] autorelease];
            [hurEvent onStart];
            [self.eventArray addObject:hurEvent];
        }
    }
    
    if( roundTimerElapsed  > 1.5 ){
        if(PM.missileEvent == EventAlways){
            lastMissile -= dt;
            if(lastMissile < 0){
                lastMissile = 5;
                int missileCount = 1 + arc4random()%2;
                MissileEvent *missileEvent = [[[MissileEvent alloc] initWithTime:4.5 MissileAmount:missileCount GameLayer:gameLayer] autorelease];
                [missileEvent onStart];
                [self.eventArray addObject:missileEvent];
            }
        }
        
        if(PM.bombEvent == EventAlways){
            lastBomb -=dt;
            if(lastBomb < 0){
                lastBomb = 4;
                int bombCount = 1 + arc4random()%2;
                BombEvent *bombEvent = [[[BombEvent alloc] initWithTime:6 WithBombAmount:bombCount GameLayer:gameLayer] autorelease];
                [bombEvent onStart];
                [self.eventArray addObject:bombEvent];
            }
        }
    }
    
    //run events
    for(int i = 0; i < self.eventArray.count; i++){
        HazardEvent *hazardEvent = [self.eventArray objectAtIndex:i];
        [hazardEvent update:dt];
        
        if(hazardEvent.isDone){
            [hazardEvent isFinished];
            [self.eventArray removeObject: hazardEvent];
            i--;
        }
    }
}

-(void) chooseEvent{
    int validCount = self.validEvents.count;

    if(validCount > 0 && roundTimerElapsed > 1.5 && sinceLastEvent > 9){
        sinceLastEvent = frequency;
        NSNumber *num = [self.validEvents objectAtIndex:(arc4random()%validCount)];
        int stu = [num intValue];
        if(stu == WindEvents){
            sinceLastEvent += arc4random()%3;
            WindEvent *windEvent = [[[WindEvent alloc] initWithTime:4 WithForce:18 GameLayer:gameLayer] autorelease];
            [windEvent onStart];
            [self.eventArray addObject:windEvent];
        }else if(stu == MissileEvents){
            sinceLastEvent += arc4random()%2;
            int missileCount = 1 + arc4random()%3;
            MissileEvent *missileEvent = [[[MissileEvent alloc] initWithTime:7 MissileAmount:missileCount GameLayer:gameLayer] autorelease];
            [missileEvent onStart];
            [self.eventArray addObject:missileEvent];
        }else if(stu == BombEvents){
            sinceLastEvent += arc4random()%3;
            int bombCount = 1 + arc4random()%2;
            BombEvent *bombEvent = [[[BombEvent alloc] initWithTime:5 WithBombAmount:bombCount GameLayer:gameLayer] autorelease];
            [bombEvent onStart];
            [self.eventArray addObject:bombEvent];
        }else if(stu == HurricaneEvents){
            sinceLastEvent += arc4random()%2;
            int hurricaneCount = 1+ arc4random()%2;
            HurricaneEvent *hurEvent = [[[HurricaneEvent alloc] initWithTime:5 WithHurricaneAmount:hurricaneCount GameLayer:gameLayer] autorelease];
            [hurEvent onStart];
            [self.eventArray addObject:hurEvent];
        }else if(stu == SpikeEvents){
            sinceLastEvent += arc4random()%3;
            SpikeEdgeEvent *spikeEvent = [[[SpikeEdgeEvent alloc] initWithTime:6 GameLayer:gameLayer] autorelease];
            [spikeEvent onStart];
            [self.eventArray addObject:spikeEvent];
        }
    }
}


@end
