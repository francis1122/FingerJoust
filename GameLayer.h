//
//  GameLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//#define COLOR_TOUCHAREA ccc3(223,214,195)
//#define COLOR_TOUCHAREA_B4 ccc4(223,214,195,255)
//#define COLOR_GAMEAREA ccc3(25,25,25)
//#define COLOR_GAMEAREA_B4 ccc4(25,25,25,255)

#define COLOR_TOUCHAREA ccc3(195,211,223)
#define COLOR_TOUCHAREA_B4 ccc4(195,211, 223, 255)
#define COLOR_GAMEAREA ccc3(223,214,195)
#define COLOR_GAMEAREA_B4 ccc4(223,214,194,255)

#define COLOR_GAMEBORDER ccc3(60,60,60)
#define COLOR_GAMEBORDER_B4 ccc4(60,60,60,255)


//font names

extern NSString *const MAIN_FONT;
//player colors
#define COLOR_DISABLED ccc4(115, 115,115, 255)

#define COLOR_PLAYER_NON ccc3(155,155,155)
#define COLOR_PLAYER_NON_LIGHT ccc3(211,211,211)
#define COLOR_PLAYER_NON_B4 ccc4(155,155,155, 255)
#define COLOR_PLAYER_NON_LIGHT_B4 ccc4(211,211,211, 255)
#define COLOR_PLAYER_NON_LIGHT_F4 ccc4f(211.0/255.0,211.0/255.0,211.0/255.0, 255.0/255.0)

#define COLOR_PLAYER_ONE ccc3(175,64,64)
#define COLOR_PLAYER_ONE_LIGHT ccc3(175,64,64)
#define COLOR_PLAYER_ONE_B4 ccc4(175,64,64,255)
#define COLOR_PLAYER_ONE_LIGHT_B4 ccc4(175,64,64, 255)
#define COLOR_PLAYER_ONE_LIGHT_F4 ccc4f(175.0/255.0,64.0/255.0,64.0/255.0, 255.0/255.0)

#define COLOR_PLAYER_TWO ccc3(64,175,64)
#define COLOR_PLAYER_TWO_LIGHT ccc3(64,175,64)
#define COLOR_PLAYER_TWO_B4 ccc3(64,175,64 255)
#define COLOR_PLAYER_TWO_LIGHT_B4 ccc4(64,175,64, 255)
#define COLOR_PLAYER_TWO_LIGHT_F4 ccc4f(64.0/255.0,175.0/255.0,64.0/255.0, 255.0/255.0)

#define COLOR_PLAYER_THREE ccc3(64,64,175)
#define COLOR_PLAYER_THREE_LIGHT ccc3(64,64,175)
#define COLOR_PLAYER_THREE_B4 ccc4(64,64,175 255)
#define COLOR_PLAYER_THREE_LIGHT_B4 ccc4(64,64,175, 255)
#define COLOR_PLAYER_THREE_LIGHT_F4 ccc4f(64.0/255.0,64.0/255.0,175.0/255.0, 255.0/255.0)

#define COLOR_PLAYER_FOUR ccc3(175,64,175)
#define COLOR_PLAYER_FOUR_LIGHT ccc3(175,64,175)
#define COLOR_PLAYER_FOUR_B4 ccc4(175,64,175,255)
#define COLOR_PLAYER_FOUR_LIGHT_B4 ccc4(175,64,175,255)
#define COLOR_PLAYER_FOUR_LIGHT_F4 ccc4f(175.0/255.0,64.0/255.0,175.0/255.0,255.0/255.0)


//#define CONTROL_OFFSET 286
//#define CONTROL_OFFSET 312
#define CONTROL_OFFSET 230
#define EXTRA_CONTROL_OFFSET 280
#define MIDDLEBAR_HEIGHT 60

#define STUN_TIME 4.0

#define ROUND_TIME 20
#define VORTEX_DISTANCE 300
#define VORTEX_LIFE 2.0
#define STUN_CONTRAINT 360

#define COLLISION_STEPS 6
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

@class Jouster, PowerStone, SneakyJoystick, UILayer, Player, HazardLayer;
@interface GameLayer : CCLayerColor  {
    UILayer *uiLayer;
    HazardLayer *hazardLayer;
    
    
    NSMutableArray *jousterArray;
    
    CCLabelTTF *blueWinsLabel;
    CCLabelTTF *redWinsLabel;
    
    //power stones display
    CCLabelTTF * bluePowerStonesLabel;
    CCLabelTTF * redPowerStonesLabel;
    
    //powerstone object
    PowerStone * powerStone;
    
    //vortex array
    NSMutableArray *vortexArray;
    NSMutableArray *touchParticleArray;
    
    
    //death clock
    NSString *winner;
    float deathClock;
    

    
    //center sprite
    CCSprite *centerSprite;
    BOOL centerVisible;
    
    //state stuff
    int currentRound;
    int lastWinner;
    
    float timeBeforeNewRoundStarts;
    BOOL didRedWinRound;
    GameState currentState;
    
}

@property int lastWinner;
@property (retain, nonatomic) PowerStone *powerStone;
@property (assign, nonatomic) HazardLayer *hazardLayer;
@property (assign, nonatomic) UILayer *uiLayer;
@property (retain, nonatomic) NSMutableArray *vortexArray, *jousterArray, *touchParticleArray;

-(Jouster*) getJousterWithPlayerNumber:(int) playerNumber;

-(void) spawnVortexAtPoint:(CGPoint) point;
-(Jouster*) createJouster:(int) character WithPlayer:(Player*) player;
-(void) refreshUI;
-(void) resetJousters;
//-(void) spawnPowerStone;
//-(void) spawnVortexAtPoint:(CGPoint)point;

-(void) updateTimer:(ccTime) dt;
-(void) updateVortex:(ccTime)dt;
-(void) incrementWinsForTeam:(int) team;
-(int) getWinsForTeam:(int) team;

-(void) checkClosestJousterToCenter;
-(void) checkBodyOnBodyStun:(Jouster *) jouseterA otherJouster:(Jouster *)jousterB;
//collision stuff
-(void) collisionChecks:(ccTime) dt;
-(void) powerStoneCollisionCheck;
-(BOOL) bodyOnBodyCheck:(Jouster *) jouster;
-(void) jousterOnBodyCheck;
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
-(void) deathEffect:(Jouster*) deadJouster;
-(CCParticleSystemQuad*) vortexEffect:(CGPoint) pt;


@end
