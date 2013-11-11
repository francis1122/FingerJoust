//
//  JousterB.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/13/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterB.h"
#import "MathHelper.h"
#import "Player.h"
#import "CCWarpSprite.h"


@implementation JousterB

-(id) initWithPlayer:(Player *) p{
    if(self = [super initWithPlayer:p]){
        
    }
    return self;
}

-(void) resetJouster{
    [super resetJouster];
    previousVelocity = ccp(1,0);
    joustPosition = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius);
    aliveTicker = 0;
    aliveTicker = 3 * (arc4random()%5)/10;
}

-(void) update:(ccTime)dt{


    aliveTicker += dt * 3.6;

    CGPoint desiredLocation = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius * 1.5);
    joustVelocity = ccpSub(joustPosition, desiredLocation);
    joustPosition = desiredLocation;
    //normalize velocity
    
    
    //  CGPoint norm = ccpNormalize(velocity);
    //   joustPosition = ccpMult(norm, joustRadius *2);
    
    //    [self calculateJoustPosition];
    

    [super update:dt];
}


-(void) calculateJoustPosition{
    CGPoint oldNorm = ccpNormalize(joustPosition);
    CGPoint norm = ccpNormalize(velocity);
    CGPoint joining = ccpAdd( ccpMult(oldNorm, 20), ccpMult(norm, 2));
    CGPoint spot = ccpNormalize(joining);
    joustPosition = ccpMult(spot, joustRadius * 2);
}

-(void) calculateJoustPositionB:(CGPoint) touch{
    CGPoint difference = ccpSub(touch, previousTouch);
    CGPoint oldNorm = ccpNormalize(joustPosition);
    CGPoint norm = ccpNormalize(difference);
    CGPoint joining = ccpAdd( ccpMult(oldNorm, 4), ccpMult(norm, 2));
    CGPoint spot = ccpNormalize(joining);
    joustPosition = ccpMult(spot, joustRadius * 2);
}


-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius{
    //knock body
    CGPoint offset = ccpSub([self getWorldPositionOfJoust] , joustPos);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, 400);
    velocity = offset;
    outsideVelocity = offset;
}



@end
