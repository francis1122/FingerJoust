//
//  UILayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/13/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class GameLayer;
@interface UILayer : CCLayer {
    //round timer
    float roundTimer;
    int displayedTime;
    CCLabelTTF *timerLabel;
    
    GameLayer *gameLayer;
    
    CCLayerColor *redLayer;
    ccColor3B redColor;
    
    CCLayerColor *blueLayer;
    ccColor3B blueColor;
    
    CCLayerColor *greenLayer;
    ccColor3B greenColor;
    
    CCLayerColor *blackLayer;
    ccColor3B blackColor;

    
    CCLayerColor *leftLayer;
    CCLayerColor *rightLayer;
    int leftPlayer;
    int rightPlayer;
    BOOL isLeftSingle;
    BOOL isRightSingle;
    ccColor3B leftColor;
    ccColor3B rightColor;
    
    CCSprite *redOverlay;
    CCSprite *blueOverlay;
    CCSprite *greenOverlay;
    CCSprite *blackOverlay;
    CCLayerColor *topLayer;
    CCLayerColor *bottomLayer;
    
    //victory count sprites
    NSMutableArray *victoryArrays;
}

@property float roundTimer;
@property int displayedTime;
@property (nonatomic, assign) CCLabelTTF *timerLabel;
@property (retain, nonatomic) NSMutableArray *victoryArrays;
@property int leftPlayer, rightPlayer;
@property BOOL isLeftSingle, isRightSingle;

-(id) initWithGameLayer:(GameLayer*) gLayer;
-(void) refreshUI;
-(void) animateTouchAreasIn;
-(void) smashTopBottomAlreadyInPlace:(BOOL) inPlace;
-(void) animateTouchAreasOut;

#pragma mark - victory point stuff
-(void) refreshVictoryPoint;
@end
