//
//  Vortex.m
//  FingerJoust
//
//  Created by Hunter Francis on 9/4/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "Vortex.h"


@implementation Vortex

@synthesize pEffect, velocity;

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
}


@end
