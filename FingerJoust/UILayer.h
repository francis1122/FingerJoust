//
//  UILayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/13/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UILayer : CCLayer {
    //round timer
    float roundTimer;
    int displayedTime;
    CCLabelTTF *timerLabel;
    
    
    CCLayerColor *redLayer;
    CCLayerColor *blueLayer;
    CCLayerColor *redBorderLayer;
    CCLayerColor *blueBorderLayer;
    
    CCSprite *redOverlay;
    CCSprite *blueOverlay;
    CCLayerColor *topLayer;
    CCLayerColor *bottomLayer;
}

@property float roundTimer;
@property int displayedTime;
@property (nonatomic, assign) CCLabelTTF *timerLabel;

-(void) animateTouchAreasIn;
-(void) smashTopBottomAlreadyInPlace:(BOOL) inPlace;
@end
