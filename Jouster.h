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

@class CCWarpSprite, Player, GameLayer;
@interface Jouster : CCSprite {
    Player *player;
    GameLayer *gameLayer;
    
    CCWarpSprite *jousterSprite;
    CCWarpSprite *jousterInnerSprite;
    
    CCWarpSprite *bodyOuterSprite;
    CCWarpSprite *bodyInnerSprite;
    
    CGPoint previousVelocity;
    CGPoint velocity;
    CGPoint outsideVelocity;
    CGPoint joustVelocity;
    CGPoint joustOutsideVelocity;
    
    BOOL waitingForTouch;
    CGPoint previousTouch;
    float bodyRadius;
    
    float joustRadius;
    float orbitalOffset;
    
    float aliveTicker;
    CGPoint joustPosition;
    
    int wins;
    BOOL isDead;
    
    
    //powerStones collected
    int powerStones;
    
    //supermode
    BOOL isSuperMode;
    float superModeTimer;
    
    //stun stuff
    BOOL isStunned;
    float stunTimer;
    
    float maxSpeed;
    
    CCParticleSystemQuad *stunParticles;
    CCParticleSystemQuad *motionStreak;
    CCParticleSystemQuad *jousterMotionStreak;
}

@property BOOL isDisplay;
@property int powerStones;
@property int wins;
@property float bodyRadius, joustRadius, orbitalOffset;
@property BOOL waitingForTouch, isDead;
@property CGPoint velocity, joustPosition;
@property CGPoint joustVelocity, outsideVelocity;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) Player *player;
@property (nonatomic, retain) CCParticleSystemQuad *motionStreak, *jousterMotionStreak;
@property (nonatomic, assign) CCWarpSprite *jousterSprite;
@property (nonatomic, assign) CCWarpSprite *bodyInnerSprite;
@property CGPoint joustOutsideVelocity;


-(id) initWithPlayer:(Player *) p;
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
-(BOOL) doesTouchDeltaMakeSense:(CGPoint) touch;
-(void) checkBoundaries;
@end
