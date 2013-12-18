//
//  JousterE.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterE.h"
#import "Player.h"
#import "CCWarpSprite.h"
#import "MathHelper.h"
#import "SimpleAudioEngine.h"


@implementation JousterE



-(void) resetJouster{
    self.joustPosition = ccp(5,0);
    if(player.playerNumber== 1 || player.playerNumber == 2){
        self.joustPosition = ccp(-5,0);
    }
    previousVelocity = ccp(1,0);
    joustVelocity = ccp(1,0);
    [super resetJouster];
}

-(void) update:(ccTime)dt{
    [super update:dt];
    
    if(player.playerNumber == 1){
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }else{
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }
    [self calculateJoustPosition:dt];
    
    jousterInnerSprite.velocity = joustVelocity;
    jousterSprite.velocity = joustVelocity;
    [jousterSprite update:dt];
    [jousterInnerSprite update:dt];
    if(!self.isDisplay){
        [self checkJoustBoundaries];
    }
    [self checkJoustAndBodyTouching];
}

-(void) checkJoustAndBodyTouching{
    float length = ccpLength(joustPosition);
    if(length < joustRadius + bodyRadius){
        SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
        float soundVariety = .3 + .3/(3+arc4random()%4);
        [SAE playEffect:@"wood_hit_brick_1.mp3" pitch:soundVariety pan:0.0 gain:.3];
        CGPoint awayFromCenter = ccpNormalize(joustPosition);
        joustPosition = ccpMult(awayFromCenter, joustRadius + bodyRadius);

        //collision has happened
        CGPoint newVel = ccpMult(awayFromCenter, 550);
        joustVelocity = newVel;
        joustOutsideVelocity = newVel;
    }
}

-(void) calculateJoustPosition:(ccTime) dt{
    //have the joust position move towards the center of the body
    joustPosition = ccpSub(self.joustPosition, ccpMult(self.velocity, dt));
    joustPosition = ccpSub(self.joustPosition, ccpMult(self.outsideVelocity, dt));
    
    //slows down the joust
    joustVelocity = ccpMult(joustVelocity, .98);
    float distance = ccpLength(self.joustPosition);
    distance = distance/.10;
    if(distance < .05){
        joustPosition = ccpAdd(self.joustPosition,  ccpMult(joustVelocity, dt));
        return;
    }
    
    //vector pointing to joust position
    CGPoint someVec = ccpNormalize(self.joustPosition);
    someVec = ccpNeg(someVec);
    //move the joust towards the body
    //CAN PUT A MAX ON ACCELERATION HERE
    joustVelocity = ccpAdd(joustVelocity, ccpMult( ccpMult(someVec, distance) , dt));
    //make sure velocity isn't too high
    float speed = ccpLength(joustVelocity);
    if(speed > 450){
        joustVelocity = ccpNormalize(joustVelocity);
        joustVelocity = ccpMult(joustVelocity, 450);
    }
    
    //set position of joust according to joust velocity
    joustPosition = ccpAdd(self.joustPosition,  ccpMult(joustVelocity, dt));
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
    //jouster gets knocked away
    CGPoint offset = ccpSub([self getWorldPositionOfJoust] , joustPos);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, 500);
    joustVelocity = offset;
    joustOutsideVelocity = offset;
    
    jousterInactiveTimer = .15;
    isJousterInactive = YES;
}

@end
