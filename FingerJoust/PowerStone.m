//
//  PowerStone.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/31/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "PowerStone.h"


@implementation PowerStone

@synthesize timeAlive, bodyRadius;

-(id) init{
    if(self = [super init]){
        bodyRadius = 10;
    }
    return self;
}

-(void) randomSpot{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    self.position = ccp( 286 + arc4random()%(int)(winSize.width - 572) , arc4random()%(int)winSize.height);
    
}

-(void) update:(ccTime)dt{
    timeAlive += dt;
    if(timeAlive > 10){
        //kill yourself
    }
}

- (void) draw{

        ccDrawColor4F(0.0f, 0.0f, 0.0f, 1.0f);
    ccDrawSolidCircle( CGPointZero, bodyRadius, 30);
    
    [super draw];
    
}


@end
