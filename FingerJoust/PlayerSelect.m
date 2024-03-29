//
//  PlayerSelect.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/17/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "PlayerSelect.h"
#import "Player.h"
#import "PlayerManager.h"
#import "GameLayer.h"
#import "JousterA.h"
#import "Jouster.h"
#import "JousterB.h"
#import "JousterC.h"
#import "JousterD.h"
#import "JousterE.h"
#import "JousterF.h"
#import "CCWarpSprite.h"
#import "SimpleAudioEngine.h"

@implementation PlayerSelect

@synthesize player, isLocked;

-(id) initWithPlayer:(Player *) p{
    CGSize size = [[CCDirector sharedDirector] winSize];
    ccColor4B baop;
    self.player = p;
    if(self.player.playerNumber == 0){
        baop = ccc4(255, 0, 0, 255);
    }else if(self.player.playerNumber == 1){
        baop = ccc4(255, 0, 255, 255);
    }else if(self.player.playerNumber == 2){
        baop = ccc4(255, 255, 0, 255);
    }else if(self.player.playerNumber == 3){
        baop = ccc4(0, 0, 0, 255);
    }
    float width = 315;
    if(self = [super initWithColor:baop width:width height:size.height/2]){
        _touchEnabled = YES;
        _touchMode = NO;
        //active stuff
        isActiveNode = [CCNode node];
        [self addChild:isActiveNode];
        //set position based on plapyer number
        CGPoint pos = CGPointZero;
        if(self.player.playerNumber == 0){
            pos = ccp(-self.contentSize.width, size.height/2);
        }else if(self.player.playerNumber == 1){
            pos = ccp(size.width, size.height/2);
        }else if(self.player.playerNumber == 2){
            pos = ccp(size.width, 0);
        }else if(self.player.playerNumber == 3){
            pos = ccp(-self.contentSize.width, 0);
        }
        self.position = pos;
        
        // unlock the appfor money!!!
        CCSprite *normal = [CCSprite spriteWithSpriteFrameName:@"unlock"];
        CCSprite *selected = [CCSprite spriteWithSpriteFrameName:@"unlock"];
		CCMenuItemSprite *unlockItem = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected block:^(id sender) {
            PlayerManager *PM = [PlayerManager sharedInstance];
            [PM purchaseProduct];
		}];
        
        unlockMenu = [CCMenu menuWithItems:unlockItem, nil];
        unlockMenu.visible = NO;
        [isActiveNode addChild:unlockMenu z:10];
        
        
        lock = [CCSprite spriteWithSpriteFrameName:@"Lock"];
        lock.position = ccp(153, 180);
        lock.visible = NO;
        [isActiveNode addChild:lock z: 12];
        
        //activate button
        playerChoiceMenu = [[[CCMenu alloc] init] autorelease];
        CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:@"closebutton"];
        CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:@"closebutton"];
        selectedSprite.color = COLOR_GAMEBORDER;
        CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                                             selectedSprite:selectedSprite
                                                                      block:^(CCMenuItemSprite *sender){
                                                                          SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
                                                                          [SAE playEffect:BUTTON_CLICK pitch:0.5 pan:0.0 gain:.5];
                                                                          self.player.isActive = NO;
                                                                          [self deactivatePlayer];
                                                                      }];
        [playerChoiceMenu addChild:playItem];
        pos = CGPointZero;
        CGPoint unlockPos;
        float edgeOffset = 60;
        if(self.player.playerNumber == 0){
            pos = ccp(edgeOffset, edgeOffset);
            unlockPos = ccp(150, 120);
        }else if(self.player.playerNumber == 1){
            pos = ccp( width - edgeOffset, edgeOffset);
            unlockPos = ccp(150, 120);
        }else if(self.player.playerNumber == 2){
            pos = ccp(width - edgeOffset, self.contentSize.height - edgeOffset);
            unlockPos = ccp(150, 270);
        }else if(self.player.playerNumber == 3){
            pos = ccp(edgeOffset, self.contentSize.height - edgeOffset);
            unlockPos = ccp(150, 270);
        }
        pos = pos;
        unlockMenu.position = unlockPos;
        playerChoiceMenu.position = pos;
        [self addChild:playerChoiceMenu];
        
        //        isActiveSprite = [CCSprite spriteWithSpriteFrameName:@"JousterOuter"];
        //        if(player.isActive){
        //            isActiveSprite.visible = YES;
        //        }else{
        //            isActiveSprite.visible = NO;
        //        }
        //        isActiveSprite.position = playerChoiceMenu.position;
        //        isActiveSprite.color = ccORANGE;
        //        [self addChild:isActiveSprite];
        //
        

        
        //setup teamplay
        
        normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite.color = ccBLACK;
        teamPlayItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                               selectedSprite:selectedSprite
                                                        block:^(CCMenuItemSprite *sender){
                                                            //cycle between 4 teams
                                                            SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
                                                            [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
                                                            int team = player.team;
                                                            team++;
                                                            if(team > 3){
                                                                team = 0;
                                                            }
                                                            player.team = team;
                                                            [self playerColorChangedToTeam:team];
                                                        }];
        teamPlayMenu = [CCMenu menuWithItems:teamPlayItem, nil];
        
        
        pos = CGPointZero;
        if(self.player.playerNumber == 0){
            pos = ccp(width - edgeOffset,edgeOffset);
        }else if(self.player.playerNumber == 1){
            pos = ccp(edgeOffset, edgeOffset);
        }else if(self.player.playerNumber == 2){
            pos = ccp(edgeOffset, size.height/2 - edgeOffset);
        }else if(self.player.playerNumber == 3){
            pos = ccp(width - edgeOffset, size.height/2 - edgeOffset);
        }
        pos = pos;
        teamPlayMenu.position = pos;
        teamBG = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        teamBG.scale = 1.2;
        teamBG.position = pos;
        [isActiveNode addChild:teamBG];
        
        [isActiveNode addChild:teamPlayMenu z:1];
        
        //character chooser
        normalSprite = [CCSprite spriteWithSpriteFrameName:@"openIndicator"];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:@"openIndicator"];
        selectedSprite.color = ccBLACK;
        CCMenuItemSprite *rotateCharacter = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                                                    selectedSprite:selectedSprite
                                                                             block:^(CCMenuItemSprite *sender){
                                                                                 //cycle between 4 teams
                                                                                 int jousterType = player.jousterType;
                                                                                 SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
                                                                                 [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
                                                                                 jousterType--;
                                                                                 if(jousterType < 0){
                                                                                     jousterType = 4;
                                                                                 }
                                                                                 player.jousterType = jousterType;
                                                                                 [self playerCharacterChangedTo:player.jousterType From:YES];
                                                                                 //sender.color = [self playerColorChangedToTeam:team];
                                                                             }];
        rotateCharacter.rotation = -90;
        
        normalSprite = [CCSprite spriteWithSpriteFrameName:@"openIndicator"];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:@"openIndicator"];
        selectedSprite.color = ccBLACK;
        CCMenuItemSprite *rotatOthereCharacter = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                                                         selectedSprite:selectedSprite
                                                                                  block:^(CCMenuItemSprite *sender){
                                                                                      //cycle between 4 teams
                                                                                      SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
                                                                                      [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
                                                                                      int jousterType = player.jousterType;
                                                                                      jousterType++;
                                                                                      if(jousterType > 4){
                                                                                          jousterType = 0;
                                                                                      }
                                                                                      player.jousterType = jousterType;
                                                                                      [self playerCharacterChangedTo:player.jousterType From:NO];
                                                                                      //                                                                              sender.color = [self playerColorChangedToTeam:team];
                                                                                  }];
        rotatOthereCharacter.rotation = 90;
        CCMenu *jousterMenu = [CCMenu menuWithItems:rotateCharacter, rotatOthereCharacter, nil];
        pos = CGPointZero;
        /*if(self.player.playerNumber == 0){
         pos = ccp(size.width/3 - 50, size.height/2 + 100);
         }else if(self.player.playerNumber == 1){
         pos = ccp(size.width - size.width/3 + 50, size.height/2 + 100);
         }else if(self.player.playerNumber == 2){
         pos = ccp(size.width - size.width/3 + 50, size.height/2 - 100);
         }else if(self.player.playerNumber == 3){
         pos = ccp(size.width/3 - 50, size.height/2 - 100);
         }*/
        pos = ccp(160, 210);
        [jousterMenu alignItemsHorizontallyWithPadding:145];
        jousterMenu.position = pos;
        [isActiveNode addChild:jousterMenu];
        
        characterLabel = [CCLabelTTF labelWithString:@"" fontName:SECOND_FONT fontSize:32];
        if(player.playerNumber == 0){
            characterLabel.position = ccp(170, 300);
        }else if(player.playerNumber == 1){
            characterLabel.position = ccp(170, 300);
        }else{
            characterLabel.position = ccp(170, 80);
        }
        [isActiveNode addChild:characterLabel];
        
        
        tapToJoinLabel = [CCLabelTTF labelWithString:@"Tap To Join" fontName:MAIN_FONT fontSize:32];
        tapToJoinLabel.color = COLOR_GAMEBORDER;
        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:1.0 opacity:255];
        //        CCEaseOut *ease = [CCEaseOut actionWithAction:fadeIn rate:1.0];
        CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:1.0 opacity:80];
        //        CCEaseIn *aa = [CCEaseIn actionWithAction:fadeOut rate:1.0];
        CCSequence *seq = [CCSequence actionOne:fadeIn two:fadeOut];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
        
        [tapToJoinLabel runAction:repeat];
        
        tapToJoinLabel.position = ccp(155, 200);
        [self addChild:tapToJoinLabel];
        
        //border
        border = [[[CCSprite alloc] initWithSpriteFrameName:@"touchBordersContainer"] autorelease];
        if(self.player.playerNumber == 0){
            pos = ccp(border.contentSize.width/2, border.contentSize.height/2);
            border.color = COLOR_GAMEBORDER;
        }else if(self.player.playerNumber == 1){
            pos = ccp(border.contentSize.width/2, border.contentSize.height/2);
            border.scaleX = -1;
            border.color = COLOR_GAMEBORDER;
        }else if(self.player.playerNumber == 2){
            pos = ccp(border.contentSize.width/2, border.contentSize.height/2);
            border.scaleX = -1;
            border.color = COLOR_GAMEBORDER;
        }else if(self.player.playerNumber == 3){
            pos = ccp(border.contentSize.width/2, border.contentSize.height/2);
            border.color = COLOR_GAMEBORDER;
        }
        border.position = pos;
        [self addChild:border];
        
        //setup state of layer
        if([[PlayerManager sharedInstance] isTeamPlay] ){
            teamPlayMenu.visible = YES;
            teamBG.visible = YES;
        }else{
            teamPlayMenu.visible = NO;
            teamBG.visible = NO;
        }
        if(player.isActive){
            [self activatePlayer];
        }else{
            [self deactivatePlayer];
        }
        if([[PlayerManager sharedInstance] isTeamPlay]){
            [self playerColorChangedToTeam:player.team];
        }
        [self playerCharacterChangedTo:player.jousterType From:YES];
        
        
        [self scheduleUpdate];
    }
    return self;
}


-(void) update:(ccTime)dt{
    if(currentJouster){
        [currentJouster update:dt];
        currentJouster.jousterSprite.position = ccpAdd(currentJouster.joustPosition,  ccpMult(ccpAdd(currentJouster.joustVelocity, currentJouster.joustOutsideVelocity), dt));
    }
}


-(void) playerColorChangedToTeam:(int)team{
    if(player.isActive){
        if(team == 0){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_ONE;
            self.color = COLOR_PLAYER_ONE_TITLE_LIGHT;
        }else if(team == 1){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_TWO;
            self.color = COLOR_PLAYER_TWO_TITLE_LIGHT;
        }else if(team == 2){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_THREE;
            self.color = COLOR_PLAYER_THREE_TITLE_LIGHT;
        }else if(team == 3){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_FOUR;
            self.color = COLOR_PLAYER_FOUR_TITLE_LIGHT;
        }
    }else{
        border.color = COLOR_GAMEBORDER;
        teamPlayItem.color = COLOR_PLAYER_NON;
        self.color = COLOR_PLAYER_NON_LIGHT;
    }
    
}

-(void) setBorderColorForPlayer{
    if(player.isActive){
        if(self.player.playerNumber == 0){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_ONE_TITLE_LIGHT;
        }else if(self.player.playerNumber == 1){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_TWO_TITLE_LIGHT;
        }else if(self.player.playerNumber == 2){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_THREE_TITLE_LIGHT;
        }else if(self.player.playerNumber == 3){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_FOUR_TITLE_LIGHT;
        }
    }else{
        border.color = COLOR_GAMEBORDER;
        self.color = COLOR_PLAYER_NON_LIGHT;
    }
}

-(void) playerCharacterChangedTo:(int) character From:(BOOL) leftSide{
    /*  CCSprite *oldJouster = currentJouster;
     CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:0.3];
     CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
     [oldJouster removeFromParentAndCleanup:YES];
     }];
     CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
     [self runAction:seqAnim];
     CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
     float offset = 60;
     if(leftSide){
     offset = -60;
     }
     CCMoveBy *moveBy = [CCMoveBy actionWithDuration:0.3 position:ccp(offset, 0)];
     CCSpawn *spawn = [CCSpawn actionOne:fadeOut two:moveBy];
     [oldJouster runAction:spawn];
     */
    
    [currentJouster removeFromParentAndCleanup:YES];
    PlayerManager *PM = [PlayerManager sharedInstance];
    BOOL gameUnlock = PM.isGameUnlocked;
    NSString *characterString = @"";
    if(character == 0){
        characterString = @"Spin";
        currentJouster = [[[JousterB alloc] initWithPlayer:self.player] autorelease];
        lock.visible = NO;
        self.isLocked = NO;
        unlockMenu.visible = NO;
    }else if(character == 1){
        characterString = @"Swing";
        currentJouster = [[[JousterA alloc] initWithPlayer:self.player] autorelease];
        lock.visible = NO;
        self.isLocked = NO;
        unlockMenu.visible = NO;
    }else if(character == 2){
        characterString = @"Pop";
        currentJouster = [[[JousterC alloc] initWithPlayer:self.player] autorelease];
        if(gameUnlock){
            lock.visible = NO;
            self.isLocked = NO;
        unlockMenu.visible = NO;
        }else{
            lock.visible = YES;
            self.isLocked = YES;
        unlockMenu.visible = YES;
        }
    }else if(character == 3){
        characterString = @"Bounce";
        currentJouster = [[[JousterE alloc] initWithPlayer:self.player] autorelease];
        if(gameUnlock){
            lock.visible = NO;
            self.isLocked = NO;
        unlockMenu.visible = NO;
        }else{
            lock.visible = YES;
            self.isLocked = YES;
        unlockMenu.visible = YES;
        }
    }else if(character == 4){
        characterString = @"Chump";
        currentJouster = [[[JousterF alloc] initWithPlayer:self.player] autorelease];
        if(gameUnlock){
            lock.visible = NO;
            self.isLocked = NO;
        unlockMenu.visible = NO;
        }else{
            lock.visible = YES;
            self.isLocked = YES;
                    unlockMenu.visible = YES;
        }
    }
    currentJouster.isDisplay = YES;
    [currentJouster resetJouster];
    
    currentJouster.position = ccp(153, 210);
    [isActiveNode addChild: currentJouster z: 3];
    
    [characterLabel setString:characterString];
}

-(void) activatePlayer{
    tapToJoinLabel.visible = NO;
    isActiveNode.visible = YES;
    isActiveSprite.visible = YES;
    playerChoiceMenu.visible = YES;
    if([PlayerManager sharedInstance].isTeamPlay){
        [self playerColorChangedToTeam:player.team];
    }else{
        [self setBorderColorForPlayer];
    }
    
}

-(void) deactivatePlayer{
    tapToJoinLabel.visible = YES;
    isActiveNode.visible = NO;
    isActiveSprite.visible = NO;
    playerChoiceMenu.visible = NO;
    [self setBorderColorForPlayer];
}


-(void) turnOnTeamPlay{
    teamPlayMenu.visible = YES;
    teamBG.visible = YES;
    [self playerColorChangedToTeam:player.team];
}


-(void) turnOffTeamPlay{
    teamPlayMenu.visible = NO;
    teamBG.visible = NO;
    [self setBorderColorForPlayer];
}


#pragma mark - touch code
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGRect touchArea =CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
    for(UITouch* touch in touches){
        CGPoint location = [touch locationInView: [touch view]];
        NSLog(@"touch point : %f, %f", location.x, location.y);
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if(CGRectContainsPoint(touchArea, location)){
            if(!player.isActive){
                self.player.isActive = YES;
                [self activatePlayer];
                SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
                [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.3];
            }
        }
    }
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:100];
}


@end
