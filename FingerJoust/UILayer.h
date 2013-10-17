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
    CCLayerColor *blueLayer;
    CCLayerColor *redBorderLayer;
    CCLayerColor *blueBorderLayer;
    
    CCSprite *redOverlay;
    CCSprite *blueOverlay;
    CCLayerColor *topLayer;
    CCLayerColor *bottomLayer;
    
    //victory count sprites
    NSMutableArray *victoryArrays;
}

@property float roundTimer;
@property int displayedTime;
@property (nonatomic, assign) CCLabelTTF *timerLabel;
@property (retain, nonatomic) NSMutableArray *victoryArrays;

-(id) initWithGameLayer:(GameLayer*) gLayer;

-(void) animateTouchAreasIn;
-(void) smashTopBottomAlreadyInPlace:(BOOL) inPlace;

#pragma mark - victory point stuff
-(void) refreshVictoryPoint;
@end
