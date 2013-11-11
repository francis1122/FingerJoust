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
#import "Player.h"
#import "PlayerManager.h"



@implementation UILayer

@synthesize roundTimer, displayedTime, timerLabel, victoryArrays, leftPlayer, rightPlayer, isLeftSingle, isRightSingle;

-(id) initWithGameLayer:(GameLayer*) gLayer{
    if(self = [super init]){
        gameLayer = gLayer;
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        PlayerManager *PM = [PlayerManager sharedInstance];
        
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
        
        //set colors
        if([PM isPlayerActive:0] && ![PM isPlayerActive:3]){
            isLeftSingle = YES;
            leftColor = COLOR_PLAYER_ONE_LIGHT;
            leftPlayer = 0;
        }
        
        if([PM isPlayerActive:3] && ![PM isPlayerActive:0]){
            isLeftSingle = YES;
            leftColor = COLOR_PLAYER_FOUR_LIGHT;
            leftPlayer = 3;
        }
        
        if([PM isPlayerActive:1] && ![PM isPlayerActive:2]){
            isRightSingle = YES;
            rightColor = COLOR_PLAYER_TWO_LIGHT;
            rightPlayer = 1;
        }
        
        if([PM isPlayerActive:2] && ![PM isPlayerActive:1]){
            isRightSingle = YES;
            rightColor = COLOR_PLAYER_THREE_LIGHT;
            rightPlayer = 2;
        }
        if(isRightSingle){
            rightLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height];
            [self addChild: rightLayer z:0];
        }
        
        if(isLeftSingle){
            leftLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height];
            [self addChild:leftLayer z:0];
            
        }
        
        
        redLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height/2];
        if(isLeftSingle){
            redLayer.opacity = 0;
        }
        [self addChild: redLayer z:0];
        
        blueLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height/2];
        if(isRightSingle){
            blueLayer.opacity = 0;
        }
        [self addChild:blueLayer];
        
        greenLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height/2];
        if(isRightSingle){
            greenLayer.opacity = 0;
        }
        [self addChild: greenLayer];
        
        blackLayer = [CCLayerColor layerWithColor:COLOR_PLAYER_NON_LIGHT_B4 width:CONTROL_OFFSET height:winSize.height/2];
        if(isLeftSingle){
            blackLayer.opacity = 0;
        }
        [self addChild:blackLayer];
        
        //borders
        if([PM isPlayerActive:0] && [PM isPlayerActive:3]){
            redOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBordersContainer"] autorelease];
        }else{
            redOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"semitouchBorders"] autorelease];
        }
        
        redOverlay.position = ccp(CONTROL_OFFSET/2 - 30, redOverlay.contentSize.height/2 );
        redOverlay.color = COLOR_GAMEBORDER;
        [redLayer addChild:redOverlay];
        
        if([PM isPlayerActive:1] && [PM isPlayerActive:2]){
            blueOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBordersContainer"] autorelease];
        }else{
            blueOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"semitouchBorders"] autorelease];
        }
        
        blueOverlay.scaleX = -1;
        blueOverlay.position = ccp(146, blueOverlay.contentSize.height/2 );
        blueOverlay.color = COLOR_GAMEBORDER;
        [blueLayer addChild:blueOverlay];
        
        
        if([PM isPlayerActive:1] && [PM isPlayerActive:2]){
            greenOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBordersContainer"] autorelease];
        }else{
            greenOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"semitouchBorders"] autorelease];
            greenLayer.scaleY = -1;
        }
        
        greenOverlay.scaleX = -1;
        greenOverlay.position = ccp(146, blueOverlay.contentSize.height/2 );
        greenOverlay.color = COLOR_GAMEBORDER;
        [greenLayer addChild:greenOverlay];
        
        if([PM isPlayerActive:0] && [PM isPlayerActive:3]){
            blackOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBordersContainer"] autorelease];
        blackOverlay.position = ccp(CONTROL_OFFSET/2 - 30, redOverlay.contentSize.height/2 );
        }else{
            blackOverlay = [[[CCSprite alloc] initWithSpriteFrameName:@"semitouchBorders"] autorelease];
        blackOverlay.position = ccp(CONTROL_OFFSET/2 - 30, redOverlay.contentSize.height/2 -1 );
            blackOverlay.scaleY = -1;
        }
        
        blackOverlay.color = COLOR_GAMEBORDER;
        [blackLayer addChild:blackOverlay];
        
        displayedTime = ROUND_TIME;
        roundTimer = ROUND_TIME;
        self.timerLabel = [CCLabelTTF labelWithString:@"20" fontName:MAIN_FONT fontSize:40];
        self.timerLabel.color = ccWHITE;
        timerLabel.position = ccp(topLayer.contentSize.width/2, 30);
        [bottomLayer addChild:timerLabel z:4];
        
        //victory stuff
        //holders for the victory spots
        for(int i = 0; i < 4; i++){
            CCLayerColor *layer = nil;
            for(int j = 0; j < 3; j++){
                CGPoint pos = CGPointZero;
                if(i == 0){
                    pos = ccp( 35 + j*45, 25);
                    layer = bottomLayer;
                }else if(i == 1){
                    pos = ccp(bottomLayer.contentSize.width - 35 - j*45, 25);
                    layer = bottomLayer;
                }else if(i == 2){
                    pos = ccp(bottomLayer.contentSize.width - 35 - j*45, bottomLayer.contentSize.height - 25);
                    layer = topLayer;
                }else if(i == 3){
                    pos = ccp( 35 + j*45, bottomLayer.contentSize.height - 25);
                    layer = topLayer;
                }
                CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"scoreHolder"] autorelease];
                victorySprite.scale = .75;
                victorySprite.color = ccc3(125, 125, 125);
                victorySprite.position = pos;
                [layer addChild:victorySprite z:1];
            }
        }
        self.victoryArrays = [NSMutableArray array];
        for(int i = 0; i < 4; i++){
            CCLayerColor *layer = nil;
            if(i == 0){
                layer = bottomLayer;
            }else if(i == 1){
                layer = bottomLayer;
            }else if(i == 2){
                layer = topLayer;
            }else if(i == 3){
                layer = topLayer;
            }
            NSMutableArray *victoryArray = [NSMutableArray array];
            for(int i = 0; i < 3; i++){
                CCSprite *victorySprite = [[[CCSprite alloc] initWithSpriteFrameName:@"dashedCircleFiller"] autorelease];
                victorySprite.scale = .60;
                victorySprite.visible = NO;
                [layer addChild:victorySprite];
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
        
        [self refreshUI];
    }
    return self;
}

-(void) dealloc{
    [victoryArrays release];
    [super dealloc];
}



-(void) refreshUI{
    for(Jouster *jouster in gameLayer.jousterArray){
        int playerOrTeam;
        if([PlayerManager sharedInstance].isTeamPlay){
            playerOrTeam = jouster.player.team;
            if(!jouster.isDead){
                //figure out what slot
                int playerNumber = jouster.player.playerNumber;
                CCSprite *overlay;
                CCLayerColor *layer;
                if(playerNumber == 0){
                    overlay = redOverlay;
                    layer = redLayer;
                }else if(playerNumber == 1){
                    overlay = blueOverlay;
                    layer = blueLayer;
                }else if(playerNumber == 2){
                    overlay = greenOverlay;
                    layer = greenLayer;
                }else if(playerNumber == 3){
                    overlay = blackOverlay;
                    layer = blackLayer;
                }
                if(isLeftSingle){
                    if(playerNumber == leftPlayer){
                        layer = leftLayer;
                    }
                }
                if(isRightSingle){
                    if(playerNumber == rightPlayer){
                        layer = rightLayer;
                    }
                }

                
                if(playerOrTeam == 0){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_ONE_LIGHT;
                }else if(playerOrTeam == 1){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_TWO_LIGHT;
                }else if(playerOrTeam == 2){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_THREE_LIGHT;
                }else if(playerOrTeam == 3){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_FOUR_LIGHT;
                }
                
            }else{
                //figure out what slot
                int playerNumber = jouster.player.playerNumber;
                CCSprite *overlay;
                CCLayerColor *layer;
                if(playerNumber == 0){
                    overlay = redOverlay;
                    layer = redLayer;
                }else if(playerNumber == 1){
                    overlay = blueOverlay;
                    layer = blueLayer;
                }else if(playerNumber == 2){
                    overlay = greenOverlay;
                    layer = greenLayer;
                }else if(playerNumber == 3){
                    overlay = blackOverlay;
                    layer = blackLayer;
                }
                if(isLeftSingle){
                    if(playerOrTeam == leftPlayer){
                        layer = leftLayer;
                    }
                }
                if(isRightSingle){
                    if(playerOrTeam == rightPlayer){
                        layer = rightLayer;
                    }
                }
                
                if(playerOrTeam == 0){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 1){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 2){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 3){
                    overlay.color = COLOR_GAMEBORDER;
                    layer.color = COLOR_PLAYER_NON_LIGHT;
                }
            }
        }else{
            playerOrTeam = jouster.player.playerNumber;
            if(!jouster.isDead){
                if(playerOrTeam == 0){
                    redOverlay.color = COLOR_GAMEBORDER;
                    redLayer.color = COLOR_PLAYER_ONE_LIGHT;
                }else if(playerOrTeam == 1){
                    blueOverlay.color = COLOR_GAMEBORDER;
                    blueLayer.color = COLOR_PLAYER_TWO_LIGHT;
                }else if(playerOrTeam == 2){
                    greenOverlay.color = COLOR_GAMEBORDER;
                    greenLayer.color = COLOR_PLAYER_THREE_LIGHT;
                }else if(playerOrTeam == 3){
                    blackOverlay.color = COLOR_GAMEBORDER;
                    blackLayer.color = COLOR_PLAYER_FOUR_LIGHT;
                }
                
                if(isLeftSingle){
                    if(playerOrTeam == leftPlayer){
                        leftLayer.color = leftColor;
                    }
                }
                if(isRightSingle){
                    if(playerOrTeam == rightPlayer){
                        rightLayer.color = rightColor;
                    }
                }
                
            }else{
                if(playerOrTeam == 0){
                    redOverlay.color = COLOR_GAMEBORDER;
                    redLayer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 1){
                    blueOverlay.color = COLOR_GAMEBORDER;
                    blueLayer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 2){
                    greenOverlay.color = COLOR_GAMEBORDER;
                    greenLayer.color = COLOR_PLAYER_NON_LIGHT;
                }else if(playerOrTeam == 3){
                    blackOverlay.color = COLOR_GAMEBORDER;
                    blackLayer.color = COLOR_PLAYER_NON_LIGHT;
                }
                
                if(isLeftSingle){
                    if(playerOrTeam == leftPlayer){
                        leftLayer.color = COLOR_PLAYER_NON_LIGHT;
                    }
                }
                if(isRightSingle){
                    if(playerOrTeam == rightPlayer){
                        rightLayer.color = COLOR_PLAYER_NON_LIGHT;
                    }
                }
            }
        }
    }
}


-(void) animateTouchAreasIn{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    redLayer.position = ccp(-redLayer.contentSize.width - 20, winSize.height/2);
    blueLayer.position = ccp(winSize.width + 20, winSize.height/2);
    blackLayer.position = ccp(-redLayer.contentSize.width - 20, 0);
    greenLayer.position = ccp(winSize.width + 20, 0);
    leftLayer.position = ccp(-redLayer.contentSize.width - 20, 0);
    rightLayer.position = ccp(winSize.width + 20, 0);
    
    CCActionInterval *redLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(0, winSize.height/2)];
    CCActionInterval *blueLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width - blueLayer.contentSize.width, winSize.height/2)];
    CCActionInterval *greenLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width - blueLayer.contentSize.width, 0)];
    CCActionInterval *blackLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(0, 0)];
    CCActionInterval *leftLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(0,0)];
    CCActionInterval *rightLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width - blueLayer.contentSize.width,0)];
    
    CCEaseIn *redLayerElastic = [CCEaseIn actionWithAction:redLayerMove rate:3];
    CCEaseIn *blueLayerElastic = [CCEaseIn actionWithAction:blueLayerMove rate:3];
    CCEaseIn *greenLayerElastic = [CCEaseIn actionWithAction:greenLayerMove rate:3];
    CCEaseIn *blackLayerElastic = [CCEaseIn actionWithAction:blackLayerMove rate:3];
    CCEaseIn *leftLayerElastic = [CCEaseIn actionWithAction:leftLayerMove rate:3];
    CCEaseIn *rightLayerElastic = [CCEaseIn actionWithAction:rightLayerMove rate:3];
    
    [redLayer runAction:redLayerElastic];
    [blueLayer runAction:blueLayerElastic];
    [blackLayer runAction:blackLayerElastic];
    [greenLayer runAction:greenLayerElastic];
    if(isLeftSingle){
        [leftLayer runAction:leftLayerElastic];
    }
    if(isRightSingle){
        [rightLayer runAction:rightLayerElastic];
    }
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

-(void) animateTouchAreasOut{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    ///    redLayer.position = ccp(-redLayer.contentSize.width, winSize.height/2);
    //    blueLayer.position = ccp(winSize.width, winSize.height/2);
    //    blackLayer.position = ccp(-redLayer.contentSize.width, 0);
    //    greenLayer.position = ccp(winSize.width, 0);
    
    CCActionInterval *redLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(-redLayer.contentSize.width -30, winSize.height/2)];
    CCActionInterval *blueLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width + 30, winSize.height/2)];
    CCActionInterval *greenLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width + 30, 0)];
    CCActionInterval *blackLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(-redLayer.contentSize.width - 30, 0)];
    CCActionInterval *rightLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(winSize.width + 30, 0)];
    CCActionInterval *leftLayerMove = [CCMoveTo actionWithDuration:1.2 position:ccp(-redLayer.contentSize.width - 30, 0)];
    
    
    CCEaseIn *redLayerElastic = [CCEaseIn actionWithAction:redLayerMove rate:3];
    CCEaseIn *blueLayerElastic = [CCEaseIn actionWithAction:blueLayerMove rate:3];
    CCEaseIn *greenLayerElastic = [CCEaseIn actionWithAction:greenLayerMove rate:3];
    CCEaseIn *blackLayerElastic = [CCEaseIn actionWithAction:blackLayerMove rate:3];
    CCEaseIn *rightLayerElastic = [CCEaseIn actionWithAction:rightLayerMove rate:3];
    CCEaseIn *leftLayerElastic = [CCEaseIn actionWithAction:leftLayerMove rate:3];
    
    [redLayer runAction:redLayerElastic];
    [blueLayer runAction:blueLayerElastic];
    [blackLayer runAction:blackLayerElastic];
    [greenLayer runAction:greenLayerElastic];
    if(isRightSingle){
        [rightLayer runAction:rightLayerElastic];
    }
    if(isLeftSingle){
        [leftLayer runAction:leftLayerElastic];
    }
    
    //top and bottom bars
    
    CCMoveTo *topMove = [CCMoveTo actionWithDuration:0.4 position:ccp(CONTROL_OFFSET, -winSize.height/2)];
    CCMoveTo *bottomMove = [CCMoveTo actionWithDuration:0.4 position:ccp(CONTROL_OFFSET, winSize.height)];
    
    CCEaseIn *topEase = [CCEaseIn actionWithAction:topMove rate:2];
    CCEaseIn *bottomEase = [CCEaseIn actionWithAction:bottomMove rate:2];
    
    [topLayer runAction:topEase];
    [bottomLayer runAction:bottomEase];
    
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
            pos = ccp( 35 + i*45, 25);
        }else if(gameLayer.lastWinner == 1){
            pos = ccp(bottomLayer.contentSize.width - 35 - i*45, 25);
        }else if(gameLayer.lastWinner == 2){
            pos = ccp(bottomLayer.contentSize.width - 35 - i*45, bottomLayer.contentSize.height - 25);
        }else if(gameLayer.lastWinner == 3){
            pos = ccp( 35 + i*45, bottomLayer.contentSize.height - 25);
        }
        
        victorySprite.position = pos;
        Jouster * winningJouster = [gameLayer getJousterWithPlayerNumber:gameLayer.lastWinner];
        int wins = winningJouster.wins;
        if([[PlayerManager sharedInstance] isTeamPlay]){
            wins = [gameLayer getWinsForTeam:gameLayer.lastWinner];
        }
        if(wins != 0){
            if(i < wins){
                victorySprite.visible = YES;
            }else{
                victorySprite.visible = NO;
            }
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
    
    
}


@end
