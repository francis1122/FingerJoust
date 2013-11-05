//
//  SpikeEdgeEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/23/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"

@class Jouster;
@interface SpikeEdgeEvent : HazardEvent{
    NSMutableArray *spikeArray;
    CCSprite *rightSpike, *leftSpike, *bottomSpike, *topSpike;
    BOOL isRetracting;
    CCSequence *startUp;
}

@property (nonatomic, retain) NSMutableArray *spikeArray;

-(id) initWithTime:(float) time GameLayer:(GameLayer*)gLayer;

-(void) checkSpikeBoundaries:(Jouster*) jouster;
@end
