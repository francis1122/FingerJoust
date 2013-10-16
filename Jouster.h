//
//  Jouster.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define JOUSTER_BODY_MAXSPEED 500

@class CCWarpSprite;
@interface Jouster : CCSprite {
    int player;
    
    CCWarpSprite *jousterSprite;
    CCWarpSprite *jousterInnerSprite;
    
    CCWarpSprite *bodyOuterSprite;
    CCWarpSprite *bodyInnerSprite;
    
    CGPoint previousVelocity;
    CGPoint velocity;
    
    CGPoint joustVelocity;
    
    BOOL waitingForTouch;
    CGPoint previousTouch;
    float bodyRadius;
    
    float joustRadius;
    float orbitalOffset;
    
    float aliveTicker;
    CGPoint joustPosition;
    
    
    //powerStones collected
    int powerStones;
    
    //supermode
    BOOL isSuperMode;
    float superModeTimer;
    
    //stun stuff
    BOOL isStunned;
    float stunTimer;
    
    CCParticleSystemQuad *stunParticles;
    CCParticleSystemQuad *motionStreak;
}


@property int powerStones;
@property int player;
@property float bodyRadius, joustRadius, orbitalOffset;
@property BOOL waitingForTouch;
@property CGPoint velocity, joustPosition;
@property CGPoint joustVelocity;

@property (nonatomic, retain) CCParticleSystemQuad *motionStreak;
@property (nonatomic, assign) CCWarpSprite *jousterSprite;

-(void) makeTail;

-(void) setWorldPositionOfJoust:(CGPoint) pos;
-(CGPoint) getWorldPositionOfJoust;
-(void) resetJouster;
-(void) update:(ccTime)dt;

-(void) engageSuperMode;
-(void) disengateSuperMode;
-(void) stunBody;

-(void) checkJoustBoundaries;
-(void) calculateJoustPosition:(ccTime) dt;
-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius;
-(void) resetTouch;
-(void) touch:(CGPoint) touch;
-(void) checkBoundaries;
@end
