//
//  WindEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "WindEvent.h"
#import "GameLayer.h"
#import "HazardEvent.h"
#import "Jouster.h"

@implementation WindEvent



-(id) initWithTime:(float) time WithForce:(float) force GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        timeSpan = time;
        windForce = force;
        windEffect = [[[CCParticleSystemQuad alloc] initWithFile: @"WindEffect.plist"] autorelease];
        //setup stats based on 4 different positions
        windEffect.position = ccp(winSize.width/2, winSize.height/2);;
        windEffect.sourcePosition = ccp(0,0);
        windEffect.posVar = ccp(winSize.width/2, winSize.height/2);
        angle = arc4random()%360;
        windEffect.angle = angle;
        
        [gameLayer.hazardLayer addChild:windEffect];
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}


-(void) update:(ccTime) dt{
    [super update:dt];
    for(Jouster *jouster in gameLayer.jousterArray){
        CGPoint vel = ccp(cos(angle*(M_PI / 180)), sin(angle*(M_PI / 180)));
        vel = ccpMult(vel, windForce);
        jouster.outsideVelocity = ccpAdd(jouster.outsideVelocity, vel);
    }

}


-(void) isFinished{
    [windEffect stopSystem];
}

-(void) onStart{
    
}

@end
