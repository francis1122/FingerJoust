//
//  Jouster.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CCWarpSprite;
@interface Jouster : CCSprite {
    int player;
    
    CCSprite *jousterSprite;
    CCSprite *jousterInnerSprite;
    
    CCWarpSprite *bodyOuterSprite;
    CCWarpSprite *bodyInnerSprite;
    
    CGPoint previousVelocity;
    CGPoint velocity;
    
    
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
    
}


@property int powerStones;
@property int player;
@property float bodyRadius, joustRadius, orbitalOffset;
@property BOOL waitingForTouch;
@property CGPoint velocity, joustPosition;

-(void) setWorldPositionOfJoust:(CGPoint) pos;
-(CGPoint) getWorldPositionOfJoust;
-(void) resetJouster;
-(void) update:(ccTime)dt;

-(void) engageSuperMode;
-(void) disengateSuperMode;

-(void) calculateJoustPosition:(ccTime) dt;
-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius;
-(void) resetTouch;
-(void) touch:(CGPoint) touch;
-(void) checkBoundaries;
@end
