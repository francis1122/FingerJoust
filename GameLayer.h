//
//  GameLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define COLOR_TOUCHAREA ccc3(223,214,195)
#define COLOR_TOUCHAREA_B4 ccc4(223,214,195,255)
#define COLOR_GAMEAREA ccc3(25,25,25)
#define COLOR_GAMEAREA_B4 ccc4(25,25,25,255)

//#define CONTROL_OFFSET 286
#define CONTROL_OFFSET 312
#define EXTRA_CONTROL_OFFSET 370
#define MIDDLEBAR_HEIGHT 60

#define ROUND_TIME 20
#define VORTEX_DISTANCE 350
#define STUN_CONTRAINT 370

#define COLLISION_STEPS 10
#define TRANSITION_TIME 2.0


#define PLAYER_ONE_COLOR ccORANGE
#define PLAYER_TWO_COLOR ccYELLOW

typedef enum GameState
{   
    GAMEPLAY  = 0,
	ROUND_START 	  = 1,
    ROUND_END  = 2,
    GAME_OVER         = 3,
    GAME_START = 4,
}GameState;

@class Jouster, PowerStone, SneakyJoystick, UILayer;
@interface GameLayer : CCLayerColor  {
    UILayer *uiLayer;
    
    

    
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
    

    
    //center sprite
    CCSprite *centerSprite;
    
    //state stuff
    int currentRound;
    int blueWins;
    int redWins;
    float timeBeforeNewRoundStarts;
    BOOL didRedWinRound;
    GameState currentState;
    
    //victory count sprites
    NSMutableArray *redVictoryArray;
    NSMutableArray *blueVictoryArray;
    CCMotionStreak *streak;
    
    CCParticleSystemQuad *redMotionStreak;
    CCParticleSystemQuad *blueMotionStreak;
}


@property (retain, nonatomic) PowerStone *powerStone;
@property (retain, nonatomic) NSMutableArray *vortexArray;
@property (retain, nonatomic) NSMutableArray *redVictoryArray;
@property (retain, nonatomic) NSMutableArray *blueVictoryArray;


@property (retain, nonatomic) SneakyJoystick *redJoystick;

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo;
-(void) spawnVortexAtPoint:(CGPoint) point;
-(Jouster*) createJouster:(int) character;
-(void) refreshUI;
-(void) resetJousters;
-(void) spawnPowerStone;
//-(void) spawnVortexAtPoint:(CGPoint)point;

-(void) updateTimer:(ccTime) dt;
-(void) updateVortex:(ccTime)dt;

-(void) checkClosestJousterToCenter;
-(void) checkBodyOnBodyStun;
//collision stuff
-(void) collisionChecks:(ccTime) dt;
-(void) powerStoneCollisionCheck;
-(BOOL) bodyOnBodyCheck;
-(BOOL) jousterOnBodyCheck;
-(BOOL) jousterOnJousterCheck;


//state stuff
-(void) gameIntro;
-(void) transitionToStartRound;
-(void) transitionToGamePlay;
-(void) transitionToEndRound;
-(void) transitionToGameOver;


//special effects
//-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2;
-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2 withMagnitude:(float) magnitude withStun:(BOOL) stun;
-(CCParticleSystemQuad*) vortexEffect:(CGPoint) pt;

#pragma mark - victory point stuff
-(void) refreshVictoryPoint;
@end
