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


@implementation JousterB

-(void) resetJouster{
    [super resetJouster];
    previousVelocity = ccp(1,0);
    joustPosition = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius);
}

-(void) update:(ccTime)dt{


    if(player.playerNumber == 1){
        aliveTicker += dt * 2.8;
    }else{
        aliveTicker += dt * 2.0;
    }

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

- (void) draw{
    /*
    if(player == 1){
        ccDrawColor4F(1.0f, 0.0f, 0.0f, 1.0f);
    }else{
        ccDrawColor4F(0.0f, 0.0f, 1.0f, 1.0f);
    }
    ccDrawCircle(CGPointZero, bodyRadius, 0, 30, NO);
    //joust
    ccDrawCircle(joustPosition, joustRadius, 0, 30, NO);
    */
    [super draw];
}
/*

-(void) touch:(CGPoint) touch{
    if(waitingForTouch){
        previousTouch = touch;
        waitingForTouch = NO;
        return;
    }
    // [self calculateJoustPositionB:touch];
    CGPoint difference = ccpSub(touch, previousTouch);
    //    difference = ccpMult(difference, 2.0);
    difference = ccp(difference.x * 2.9, difference.y *2.0);
    self.velocity = ccpAdd(velocity, difference);
    
    previousTouch = touch;
}*/

-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius{
    //knock body
    CGPoint offset = ccpSub([self getWorldPositionOfJoust] , joustPos);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, 640);
    velocity = offset;
}



@end
