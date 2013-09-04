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

#define ROUND_TIME 10

typedef enum GameState
{   
    GAMEPLAY  = 0,
	ROUND_START 	  = 1,
    ROUND_END  = 2,
    GAME_OVER         = 3,
    GAME_START = 4,
}GameState;

@class Jouster, PowerStone;
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

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo;
-(Jouster*) createJouster:(int) character;
-(void) refreshUI;
-(void) resetJousters;
-(void) spawnPowerStone;

-(void) updateTimer:(ccTime) dt;

-(void) checkClosestJousterToCenter;

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

@end
