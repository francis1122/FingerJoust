//
//  JousterA.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/7/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterA.h"
#import "MathHelper.h"

@implementation JousterA


-(void) resetJouster{
    [super resetJouster];
    self.joustPosition = ccp(1,0);
    previousVelocity = ccp(1,0);
    joustVelocity = ccp(1,0);
}

-(void) update:(ccTime)dt{
    

    
    //update velocity
    self.position = ccpAdd(self.position, ccpMult(self.velocity, dt));
    
    //reduce velocity
    velocity = ccpMult(velocity, .95);
    
    if(player == 1){
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }else{
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }
    
    [self calculateJoustPosition:dt];
    previousVelocity = velocity;
    [self checkBoundaries];
    [super update:dt];
}

-(void) calculateJoustPosition:(ccTime) dt{
    //have the joust position move towards the center of the body
    joustPosition = ccpSub(self.joustPosition, ccpMult(self.velocity, dt));
    //slows down the joust
    joustVelocity = ccpMult(joustVelocity, .98);
    float distance = ccpLength(self.joustPosition);
    distance = distance/.06;
    if(distance < 1){
        joustPosition = ccpAdd(self.joustPosition, joustVelocity);
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
    if(speed >850){
        joustVelocity = ccpNormalize(joustVelocity);
        joustVelocity = ccpMult(joustVelocity, 850);
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
    offset = ccpMult(offset, 1000);
    joustVelocity = offset;
}

@end
