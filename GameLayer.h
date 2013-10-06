//
//  GameLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define CONTROL_OFFSET 286
#define EXTRA_CONTROL_OFFSET 370

#define ROUND_TIME 20
#define VORTEX_DISTANCE 350
#define STUN_CONTRAINT 340

typedef enum GameState
{   
    GAMEPLAY  = 0,
	ROUND_START 	  = 1,
    ROUND_END  = 2,
    GAME_OVER         = 3,
    GAME_START = 4,
}GameState;

@class Jouster, PowerStone, SneakyJoystick;
@interface GameLayer : CCLayerColor  {
    CCLayerColor *redLayer;
    CCLayerColor *blueLayer;
    CCLayerColor *redBorderLayer;
    CCLayerColor *blueBorderLayer;
    
    Jouster *redJouster;
    Jouster *blueJouster;
    
    CCLabelTTF *blueWinsLabel;
    CCLabelTTF *redWinsLabel;
    
    //power stones display
    CCLabelTTF * bluePowerStonesLabel;
    CCLabelTTF * redPowerStonesLabel;
    
    //powerstone object
    PowerStone * powerStone;
    
    //vortex array
    NSMutableArray *vortexArray;
    
    
    //death clock
    NSString *winner;
    float deathClock;
    
    //round timer
    float roundTimer;
    int displayedTime;
    CCLabelTTF *timerLabel;
    
    //center sprite
    CCSprite *centerSprite;
    
    //state stuff
    int currentRound;
    int blueWins;
    int redWins;
    BOOL didRedWinRound;
    GameState currentState;
}


@property (retain, nonatomic) PowerStone *powerStone;
@property (retain, nonatomic) NSMutableArray *vortexArray;


@property (retain, nonatomic) SneakyJoystick *redJoystick;

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo;
-(void) spawnVortexAtPoint:(CGPoint) point;
-(Jouster*) createJouster:(int) character;
-(void) refreshUI;
-(void) resetJousters;
-(void) spawnPowerStone;
-(void) spawnVortexAtPoint:(CGPoint)point;

-(void) updateTimer:(ccTime) dt;
-(void) updateVortex:(ccTime)dt;

-(void) checkClosestJousterToCenter;
-(void) checkBodyOnBodyStun;
//collision stuff
-(void) powerStoneCollisionCheck;
-(BOOL) bodyOnBodyCheck;
-(void) jousterOnBodyCheck;
-(BOOL) jousterOnJousterCheck;


//state stuff
-(void) gameIntro;
-(void) transitionToStartRound;
-(void) transitionToGamePlay;
-(void) transitionToEndRound;
-(void) transitionToGameOver;


//special effects
-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2;
-(CCParticleSystemQuad*) vortexEffect:(CGPoint) pt;
@end
