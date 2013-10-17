//
//  UILayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/13/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "UILayer.h"
#import "GameLayer.h"
#import "Jouster.h"



@implementation UILayer

@synthesize roundTimer, displayedTime, timerLabel, victoryArrays;

-(id) initWithGameLayer:(GameLayer*) gLayer{
    if(self = [super init]){
        gameLayer = gLayer;
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
        topLayer = [CCLayerColor layerWithColor:COLOR_GAMEBORDER_B4
                                                        width:winSize.width - 2*CONTROL_OFFSET
                                                       height:winSize.height/2];
        topLayer.position = ccp(CONTROL_OFFSET, -winSize.height/2);
        bottomLayer = [CCLayerColor layerWithColor:COLOR_GAMEBORDER_B4
                                                           width:winSize.width - 2*CONTROL_OFFSET
                                                          height:winSize.height/2];
        bottomLayer.position = ccp(CONTROL_OFFSET, winSize.height);
        [self addChild:topLayer];
        [self addChild:bottomLayer];
        
        redOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBorders"] autorelease];
        redOverlay.color = COLOR_GAMEBORDER;
        redOverlay.position = ccp(redOverlay.contentSize.width/2, winSize.height/2 );
        [self addChild:redOverlay];
        
        blueOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBorders"] autorelease];
        blueOverlay.color = COLOR_GAMEBORDER;
        blueOverlay.scaleX = -1;
        blueOverlay.position = ccp(winSize.width - blueOverlay.contentSize.width/2, winSize.height/2 );
        [self addChild:blueOverlay];

        
        displayedTime = ROUND_TIME;
        roundTimer = ROUND_TIME;
        self.timerLabel = [CCLabelTTF labelWithString:@"20" fontName:@"Marker Felt" fontSize:32];
        timerLabel.position = ccp(winSize.width/2, winSize.height - 20);
        timerLabel.color = ccBLACK;
        [self addChild:timerLabel];
        
        
        //victory stuff
        //holders for the victory spots
        for(int i = 0; i < 4; i++)
        for(int j = 0; j < 3; j++){
            CGPoint pos = CGPointZero;
            if(i == 0){
                pos = ccp(CONTROL_OFFSET + 35 + j*45, winSize.height - 25);
            }else if(i == 1){
                pos = ccp((winSize.width - CONTROL_OFFSET) - 35 - j*45, winSize.height - 25);
            }else if(i == 2){
                pos = ccp((winSize.width - CONTROL_OFFSET) - 35 - j*45, 25);
            }else if(i == 3){
                pos = ccp(CONTROL_OFFSET + 35 + j*45, 25);
            }
            CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"dashedCircle"] autorelease];
            victorySprite.scale = .75;
            victorySprite.color = ccWHITE;
            victorySprite.position = pos;
            [self addChild:victorySprite];
        }
        
        self.victoryArrays = [NSMutableArray array];
        for(int i = 0; i < 4; i++){
            NSMutableArray *victoryArray = [NSMutableArray array];
            for(int i = 0; i < 3; i++){
                CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"dashedCircleFiller"] autorelease];
                victorySprite.scale = .75;
                [self addChild:victorySprite];
                victorySprite.color = ccORANGE;
                [victoryArray addObject:victorySprite];
            }
            [self.victoryArrays addObject:victoryArray];
        }
        //fixes the first round crash
        gameLayer.lastWinner = 20020;
        [self refreshVictoryPoint];
        
        
        /*
        for(int i = 0; i < 3; i++){
            CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"dashedCircle"] autorelease];
            victorySprite.scale = .75;
            victorySprite.color = ccWHITE;
            victorySprite.position = ccp(CONTROL_OFFSET + 35 + i*45, 25);
            [self addChild:victorySprite];
        }
        for(int i = 0; i < 3; i++){
            CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"dashedCircle"] autorelease];
            victorySprite.scale = .75;
            victorySprite.color = ccWHITE;
            victorySprite.position = ccp((winSize.width - CONTROL_OFFSET) - 35 - i*45, 25);
            [self addChild:victorySprite];
        }*/
        
        //[self refreshVictoryPoint];

        
    }
    return self;
}

-(void) dealloc{
    [victoryArrays release];
    [super dealloc];
}


-(void) animateTouchAreasIn{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    redLayer.position = ccp(-redLayer.contentSize.width, 0);
    blueLayer.position = ccp(winSize.width, 0);
    redOverlay.position = ccp(-blueOverlay.contentSize.width/2, winSize.height/2);
    blueOverlay.position = ccp(winSize.width + blueOverlay.contentSize.width/2, winSize.height/2 );
    //
    CCActionInterval *redMove = [CCMoveTo actionWithDuration:1 position:ccp(CONTROL_OFFSET - redOverlay.contentSize.width/2, winSize.height/2)];
    CCActionInterval *blueMove = [CCMoveTo actionWithDuration:1 position:ccp((winSize.width - CONTROL_OFFSET) + blueOverlay.contentSize.width/2, winSize.height/2)];
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
    
    CCEaseIn *topEase = [CCEaseIn actionWithAction:topMove rate:2];
    CCEaseIn *bottomEase = [CCEaseIn actionWithAction:bottomMove rate:2];
    
    CCActionInterval *topMoveBack = [CCMoveTo actionWithDuration:1 position:ccp(CONTROL_OFFSET, MIDDLEBAR_HEIGHT - winSize.height/2)];
    CCActionInterval *bottomMoveBack = [CCMoveTo actionWithDuration:1 position:ccp(CONTROL_OFFSET, winSize.height - MIDDLEBAR_HEIGHT)];
    
    CCEaseIn *topEaseBack = [CCEaseIn actionWithAction:topMoveBack rate:2];
    CCEaseIn *bottomEaseBack = [CCEaseIn actionWithAction:bottomMoveBack rate:2];
    
    CCSequence *topSeq = [CCSequence actionOne:topEase two:topEaseBack];
    CCSequence *bottomSeq = [CCSequence actionOne:bottomEase two:bottomEaseBack];
    
    [topLayer runAction:topSeq];
    [bottomLayer runAction:bottomSeq];
}


#pragma mark - victory point stuff

-(void) refreshVictoryPoint{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    
    //check count
    if(gameLayer.lastWinner <= [victoryArrays count]){

    }else{
        NSLog(@"some error happened");
        return;
    }
    NSMutableArray *victoryArray = [self.victoryArrays objectAtIndex:gameLayer.lastWinner];
    
    
    //red victory
    for(int i = 0; i < victoryArray.count; ++i){
        CCSprite *victorySprite = [victoryArray objectAtIndex:i];
        CGPoint pos = CGPointZero;
        if(gameLayer.lastWinner == 0){
            pos = ccp(CONTROL_OFFSET + 35 + i*45, winSize.height - 25);
        }else if(gameLayer.lastWinner == 1){
            pos = ccp((winSize.width - CONTROL_OFFSET) - 35 - i*45, winSize.height - 25);
        }else if(gameLayer.lastWinner == 2){
            pos = ccp((winSize.width - CONTROL_OFFSET) - 35 - i*45, 25);
        }else if(gameLayer.lastWinner == 3){
            pos = ccp(CONTROL_OFFSET + 35 + i*45, 25);
        }
        
        victorySprite.position = pos;
        Jouster * winningJouster = [gameLayer getJousterWithPlayerNumber:gameLayer.lastWinner];
        int wins = winningJouster.wins;
        if(i < wins){
            victorySprite.visible = YES;
        }else{
            victorySprite.visible = NO;
        }
        //animate new victory patch
        /*if(i == wins - 1){
            victorySprite.position = gameLayer.blueJouster.position;
            CCMoveTo *move = [CCMoveTo actionWithDuration:.7 position:ccp(CONTROL_OFFSET + 34 + i*45, 25)];
            [victorySprite runAction:move];
        }*/
    }
    
    //red victory
    /*for(int i = 0; i < self.blueVictoryArray.count; ++i){
        CCSprite *victorySprite = [self.blueVictoryArray objectAtIndex:i];
        victorySprite.position = ccp((winSize.width - CONTROL_OFFSET) - 36 - i*45, 25);
        if(i < gameLayer.blueWins){
            victorySprite.visible = YES;
        }else{
            victorySprite.visible = NO;
        }
        //animate new victory patch
        if(!gameLayer.didRedWinRound && i == gameLayer.blueWins-1){
            victorySprite.position = gameLayer.redJouster.position;
            CCMoveTo *move = [CCMoveTo actionWithDuration:.7 position:ccp((winSize.width - CONTROL_OFFSET) - 36 - i*45, 25)];
            [victorySprite runAction:move];
        }
    }*/
}


@end
