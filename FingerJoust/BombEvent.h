//
//  BombEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"

@class BombSprite;
@interface BombEvent : HazardEvent{
    NSMutableArray *bombArray;
}

@property (nonatomic, retain) NSMutableArray *bombArray;

-(id) initWithTime:(float) time WithBombAmount:(float) force GameLayer:(GameLayer*)gLayer;
-(void) checkBombBoundaries:(BombSprite*) bomb;
@end
