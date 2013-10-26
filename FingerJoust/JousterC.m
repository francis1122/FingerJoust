//
//  JousterC.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/19/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterC.h"
#import "MathHelper.h"
#import "CCWarpSprite.h"
#import "Player.h"


@implementation JousterC

-(id) initWithPlayer:(Player *) p{
    if(self = [super initWithPlayer:p]){
        self.velocity = CGPointZero;
        waitingForTouch = YES;
        orbitalOffset = 0;
        joustPosition = ccp(1,0);
        velocity = ccp(1,0);
        previousVelocity = ccp(1,0);
    }
    return self;
}

-(void) resetJouster{
    [super resetJouster];
    //offset the growing and shrinking of circle
    if(player.playerNumber == 0){
        aliveTicker = 3.14/4;
    }else if(player.playerNumber == 1){
        aliveTicker = 0;
    }else if(player.playerNumber == 2){
        aliveTicker = 3.14/2;
    }else if(player.playerNumber == 3){
        aliveTicker = 3.14/4 + 3.14/2;
    }
}

-(void) update:(ccTime)dt{
    [super update:dt];
    aliveTicker += dt * 1.3;
    joustRadius = 5 + 17 * (1.1 + cos(aliveTicker));
    
//    jousterInnerSprite.scale = joustRadius/28.0;
    jousterSprite.scale = joustRadius/23.0;
    joustVelocity = CGPointZero;
//    joustPosition = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius);
    //normalize velocity
    
    
    //  CGPoint norm = ccpNormalize(velocity);
    //   joustPosition = ccpMult(norm, joustRadius *2);
    
    //    [self calculateJoustPosition];
    
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
    if(player.playerNumber == 1){
        ccDrawColor4F(1.0f, 0.0f, 0.0f, 1.0f);
    }else{
        ccDrawColor4F(0.0f, 0.0f, 1.0f, 1.0f);
    }
    ccDrawCircle(CGPointZero, bodyRadius, 0, 30, NO);
    //joust
    ccDrawCircle(joustPosition, joustRadius, 0, 30, NO);
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
    offset = ccpMult(offset, 400);
    velocity = offset;
    outsideVelocity = offset;
}

@end
