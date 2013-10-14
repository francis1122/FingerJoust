//
//  JousterD.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/19/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterD.h"
#import "GameLayer.h"
#import "MathHelper.h"


@implementation JousterD

-(id) init{
    if(self = [super init]){
        self.velocity = CGPointZero;
        waitingForTouch = YES;
        bodyRadius = 30;
        joustRadius = 20;
        orbitalOffset = 0;
        player = 1;
        joustPosition = ccp(0,100);
        velocity = ccp(1,0);
        previousVelocity = ccp(1,0);
        joustVelocity = ccp(1, 0);
        joustVelocity = ccpNormalize(joustVelocity);
        joustVelocity = ccpMult(joustVelocity, 10);
        
    }
    return self;
}

-(void) resetJouster{
    [super resetJouster];

    if(player == 1){
    joustPosition = ccp(0,100);
    }else{
    joustPosition = ccp(0,-100);
    }
    previousVelocity = ccp(1,0);
    joustVelocity = ccp(1,0);
}

-(void) update:(ccTime)dt{
    [super update:dt];
    
    if(player == 1){
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }else{
        aliveTicker += dt/2 * (1 + ccpLength(velocity) * .02);
    }
    
    
    [self calculateJoustPosition:dt];
    //joust hit body
    if([self circleCollisionDetectionJousting:self AndBody:self]){
        //bounce joust off body
        //bounce off eachother
        CGPoint offset = ccpSub(self.position, ccpAdd(self.position, joustPosition));
        offset = [self normalize:offset];
        offset = ccpMult(offset, JOUSTER_JOUSTER_D_SPEED);
//        self.velocity = offset;
        offset = ccpMult(offset, -1);
        joustVelocity = offset;
    }

    [self checkJoustBoundaries];
}

-(void) calculateJoustPosition:(ccTime) dt{
    
    //make sure speed is 13
    joustVelocity = ccpNormalize(joustVelocity);
    joustVelocity = ccpMult(joustVelocity, JOUSTER_JOUSTER_D_SPEED);
    
    //    joustPosition = ccpMult( ccp(cos(aliveTicker), sin(aliveTicker)), bodyRadius);
    //    joustPosition =
    //have the joust position move towards the center of the body
/*    
    //slows down the joust
    joustVelocity = ccpMult(joustVelocity, .98);
    float distance = ccpLength(self.joustPosition);
    distance = distance/2.3;
    if(distance < 1){
        joustPosition = ccpAdd(self.joustPosition, joustVelocity);
        return;
    }
    
    //vector pointing to joust position
    CGPoint someVec = ccpNormalize(self.joustPosition);
    someVec = ccpNeg(someVec);
    //move the joust towards the body
    joustVelocity = ccpAdd(joustVelocity, ccpMult( ccpMult(someVec, distance) , dt));
    //make sure velocity isn't too high
    float speed = ccpLength(joustVelocity);
    NSLog(@"speed %f", speed );
    if(speed > 10){
        joustVelocity = ccpNormalize(joustVelocity);
        joustVelocity = ccpMult(joustVelocity, 10);
    }
    
    //set position of joust according to joust velocity
 */
    joustPosition = ccpSub(self.joustPosition, ccpMult(self.velocity, dt));
    joustPosition = ccpAdd(self.joustPosition, ccpMult(joustVelocity, dt));
}



-(BOOL) circleCollisionDetectionJousting:(Jouster *)A AndBody:(Jouster *)B{
    float aRadius = A.joustRadius;
    float bRadius = B.bodyRadius;
    float distanceToMakeCollision = aRadius + bRadius;
    
    
    CGPoint joustPosition = ccp(A.position.x + A.joustPosition.x, A.position.y + A.joustPosition.y);
    CGPoint bodyPosition = B.position;
    double distanceBetweenObjects = sqrt(((joustPosition.x - bodyPosition.x) * (joustPosition.x - bodyPosition.x)) +
                                         ((joustPosition.y - bodyPosition.y) * (joustPosition.y - bodyPosition.y)));
    
    if(distanceBetweenObjects < distanceToMakeCollision){
        return YES;
    }
    
    return NO;
}

- (CGPoint)normalize:(CGPoint)vector {
	float magnitude = sqrt(pow(vector.x,2) + pow(vector.y,2));
	if( magnitude == 0){ return CGPointMake( 0.0, 0.0);}
	return CGPointMake(vector.x / (magnitude), vector.y / (magnitude));
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
}
*/



-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius{
    //jouster gets knocked away
    CGPoint offset = ccpSub([self getWorldPositionOfJoust] , joustPos);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, JOUSTER_JOUSTER_D_SPEED);
    joustVelocity = offset;
}

@end
