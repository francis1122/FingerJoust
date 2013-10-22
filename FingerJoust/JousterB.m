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
        self.scale = 1.4;
        bodyRadius = bodyRadius * 1.5;
        joustRadius = joustRadius * 1.5;
        maxSpeed = 350;
        
    }
    return self;
}

-(void) resetJouster{
    [super resetJouster];
    previousVelocity = ccp(1,0);
    joustPosition = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius);
}

-(void) update:(ccTime)dt{


    if(player.playerNumber == 1){
        aliveTicker += dt * 4.6;
    }else{
        aliveTicker += dt * 4.6;
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

-(void) touch:(CGPoint) touch{
    if(waitingForTouch){
        previousTouch = touch;
        waitingForTouch = NO;
        return;
    }
    
    CGPoint difference = ccpSub(touch, previousTouch);
    
    if(isSuperMode){
        difference = ccp(difference.x * 5.5, difference.y *4.1);
    }else if(isStunned){
        difference = ccp(difference.x * 2.0, difference.y *1.7);
    }else{
        
        //        difference = ccp(difference.x * 2.7, difference.y *2.2);
        difference = ccp(difference.x * 7, difference.y *7);
        //        difference = ccp(difference.x * 2.0, difference.y *1.6);
        //        difference = ccp(difference.x * 6, difference.y *6);
        
    }
    self.velocity = ccpAdd(velocity, difference);
    previousTouch = touch;
}

-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius{
    //knock body
    CGPoint offset = ccpSub([self getWorldPositionOfJoust] , joustPos);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, 1400);
    velocity = offset;
}



@end
