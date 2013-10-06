//
//  Vortex.m
//  FingerJoust
//
//  Created by Hunter Francis on 9/4/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "Vortex.h"


@implementation Vortex

@synthesize pEffect;

-(id) init{
    if(self = [super init]){
        self.bodyRadius = 20;
    }
    return self;
}

-(void) randomSpot{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    self.position = ccp( 286 + arc4random()%(int)(winSize.width - 572) , arc4random()%(int)winSize.height);
    
}

-(void) update:(ccTime)dt{
    self.timeAlive += dt;
    if(self.timeAlive > 4){
        //kill yourself
    }
}

- (void) draw{
    
    ccDrawColor4F(0.0f, 1.0f, 1.0f, 1.0f);
    ccDrawSolidCircle( CGPointZero, self.bodyRadius, 30);
    
    [super draw];
    
}

@end
