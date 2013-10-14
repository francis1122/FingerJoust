//
//  UILayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/13/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "UILayer.h"
#import "GameLayer.h"




@implementation UILayer

@synthesize roundTimer, displayedTime, timerLabel;

-(id) init{
    if(self = [super init]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        redLayer = [CCLayerColor layerWithColor:COLOR_TOUCHAREA_B4 width:CONTROL_OFFSET height:winSize.height];
        redLayer.position = ccp(0, 0);
        [self addChild: redLayer];
        blueLayer = [CCLayerColor layerWithColor:COLOR_TOUCHAREA_B4 width:CONTROL_OFFSET height:winSize.height];
        blueLayer.position = ccp(winSize.width - blueLayer.contentSize.width, 0);
        [self addChild:blueLayer];
        
//        redBorderLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:40 height:winSize.height];
  //      redBorderLayer.position = ccp(CONTROL_OFFSET - redBorderLayer.contentSize.width, 0);
  //      [self addChild:redBorderLayer];
      //  blueBorderLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:40 height:winSize.height];
    //    blueBorderLayer.position = ccp(winSize.width - CONTROL_OFFSET, 0);
//        [self addChild:blueBorderLayer];
        
        //top and bottom bar
        topLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)
                                                        width:winSize.width - 2*CONTROL_OFFSET
                                                       height:winSize.height/2];
        topLayer.position = ccp(CONTROL_OFFSET, -winSize.height/2);
        bottomLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)
                                                           width:winSize.width - 2*CONTROL_OFFSET
                                                          height:winSize.height/2];
        bottomLayer.position = ccp(CONTROL_OFFSET, winSize.height);
        [self addChild:topLayer];
        [self addChild:bottomLayer];
        
        redOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBorders"] autorelease];
        redOverlay.position = ccp(redOverlay.contentSize.width/2, winSize.height/2 );
        [self addChild:redOverlay];
        
        blueOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBorders"] autorelease];
        blueOverlay.scaleX = -1;
        blueOverlay.position = ccp(winSize.width - blueOverlay.contentSize.width/2, winSize.height/2 );
        [self addChild:blueOverlay];

        
        displayedTime = ROUND_TIME;
        roundTimer = ROUND_TIME;
        self.timerLabel = [CCLabelTTF labelWithString:@"20" fontName:@"Marker Felt" fontSize:32];
        timerLabel.position = ccp(winSize.width/2, winSize.height - 20);
        timerLabel.color = ccBLACK;
        [self addChild:timerLabel];
        
    }
    return self;
}


-(void) animateTouchAreasIn{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    redLayer.position = ccp(-redLayer.contentSize.width, 0);
    blueLayer.position = ccp(winSize.width, 0);
    redOverlay.position = ccp(-blueOverlay.contentSize.width/2, winSize.height/2);
    blueOverlay.position = ccp(winSize.width + blueOverlay.contentSize.width/2, winSize.height/2 );
    
    CCActionInterval *redMove = [CCMoveTo actionWithDuration:1 position:ccp(redOverlay.contentSize.width/2, winSize.height/2)];
    CCActionInterval *blueMove = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width - blueOverlay.contentSize.width/2, winSize.height/2)];
    CCActionInterval *redLayerMove = [CCMoveTo actionWithDuration:1 position:ccp(0, 0)];
    CCActionInterval *blueLayerMove = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width - blueLayer.contentSize.width, 0)];
    
    CCEaseIn *redElastic = [CCEaseIn actionWithAction:redMove rate:2];
    CCEaseIn *blueElastic = [CCEaseIn actionWithAction:blueMove rate:2];
    CCEaseIn *redLayerElastic = [CCEaseIn actionWithAction:redLayerMove rate:2];
    CCEaseIn *blueLayerElastic = [CCEaseIn actionWithAction:blueLayerMove rate:2];
    
    [redOverlay runAction:redElastic];
    [blueOverlay runAction:blueElastic];
    [redLayer runAction:redLayerElastic];
    [blueLayer runAction:blueLayerElastic];
    
    
}

-(void) smashTopBottomAlreadyInPlace:(BOOL) inPlace{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    if(inPlace){
        topLayer.position = ccp(CONTROL_OFFSET, MIDDLEBAR_HEIGHT - winSize.height/2);
        bottomLayer.position = ccp(CONTROL_OFFSET, winSize.height - MIDDLEBAR_HEIGHT);
    }else{
        topLayer.position = ccp(CONTROL_OFFSET, -winSize.height/2);
        bottomLayer.position = ccp(CONTROL_OFFSET, winSize.height);
    }
    
    CCActionInterval *topMove = [CCMoveTo actionWithDuration:1 position:ccp(topLayer.position.x, 0)];
    CCActionInterval *bottomMove = [CCMoveTo actionWithDuration:1 position:ccp(bottomLayer.position.x, winSize.height/2)];
    
    CCEaseIn *topEase = [CCEaseIn actionWithAction:topMove rate:3];
    CCEaseIn *bottomEase = [CCEaseIn actionWithAction:bottomMove rate:3];
    
    CCActionInterval *topMoveBack = [CCMoveTo actionWithDuration:1 position:ccp(CONTROL_OFFSET, MIDDLEBAR_HEIGHT - winSize.height/2)];
    CCActionInterval *bottomMoveBack = [CCMoveTo actionWithDuration:1 position:ccp(CONTROL_OFFSET, winSize.height - MIDDLEBAR_HEIGHT)];
    
    CCEaseOut *topEaseBack = [CCEaseOut actionWithAction:topMoveBack rate:3];
    CCEaseOut *bottomEaseBack = [CCEaseOut actionWithAction:bottomMoveBack rate:3];
    
    CCSequence *topSeq = [CCSequence actionOne:topEase two:topEaseBack];
    CCSequence *bottomSeq = [CCSequence actionOne:bottomEase two:bottomEaseBack];
    
    [topLayer runAction:topSeq];
    [bottomLayer runAction:bottomSeq];
}

@end
