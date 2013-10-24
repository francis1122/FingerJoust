//
//  JousterF.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/24/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterF.h"
#import "Player.h"
#import "MathHelper.h"
#import "CCWarpSprite.h"


@implementation JousterF


-(id) initWithPlayer:(Player *) p{
    if(self = [super initWithPlayer:p]){
        joustRadius = .5;
    }
    return self;
}

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
    joustPosition = ccp(0,1);
//    [self calculateJoustPosition:dt];
    
    jousterInnerSprite.velocity = joustVelocity;
    jousterSprite.velocity = joustVelocity;
    [jousterSprite update:dt];
    [jousterInnerSprite update:dt];
}

-(void) checkJoustAndBodyTouching{
    float length = ccpLength(joustPosition);
    if(length < joustRadius + bodyRadius){
        CGPoint awayFromCenter = ccpNormalize(joustPosition);
        joustPosition = ccpMult(awayFromCenter, joustRadius + bodyRadius);
        
        //put
        //collision has happened
        joustVelocity = ccpMult(awayFromCenter, 450);
    }
}

-(void) calculateJoustPosition:(ccTime) dt{
    //have the joust position move towards the center of the body
    joustPosition = ccpSub(self.joustPosition, ccpMult(self.velocity, dt));
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
    offset = ccpMult(offset, 2500);
    joustVelocity = offset;
}

@end
