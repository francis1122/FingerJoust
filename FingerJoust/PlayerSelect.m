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

@implementation PlayerSelect

@synthesize player;

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
        
        
        
        //activate button
        CCMenu *playerChoiceMenu = [[[CCMenu alloc] init] autorelease];
        CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite.color = ccBLUE;
        CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                                             selectedSprite:selectedSprite
                                                                      block:^(CCMenuItemSprite *sender){
                                                                          self.player.isActive = !self.player.isActive;
                                                                          if(self.player.isActive){
                                                                              [self activatePlayer];
                                                                          }else{
                                                                              [self deactivatePlayer];
                                                                          }
                                                                      }];
        [playerChoiceMenu addChild:playItem];
        pos = CGPointZero;
        float edgeOffset = 60;
        if(self.player.playerNumber == 0){
            pos = ccp(edgeOffset, edgeOffset);
        }else if(self.player.playerNumber == 1){
            pos = ccp( width - edgeOffset, edgeOffset);
        }else if(self.player.playerNumber == 2){
            pos = ccp(width - edgeOffset, self.contentSize.height - edgeOffset);
        }else if(self.player.playerNumber == 3){
            pos = ccp(edgeOffset, self.contentSize.height - edgeOffset);
        }
        pos = pos;
        playerChoiceMenu.position = pos;
        [self addChild:playerChoiceMenu];
        
        
        isActiveSprite = [CCSprite spriteWithSpriteFrameName:@"JousterOuter"];
        if(player.isActive){
            isActiveSprite.visible = YES;
        }else{
            isActiveSprite.visible = NO;
        }
        isActiveSprite.position = playerChoiceMenu.position;
        isActiveSprite.color = ccORANGE;
        [self addChild:isActiveSprite];
        
        
        
        
        //active stuff
        isActiveNode = [CCNode node];
        [self addChild:isActiveNode];
        
        //setup teamplay
        
        normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite.color = ccBLACK;
        teamPlayItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                               selectedSprite:selectedSprite
                                                        block:^(CCMenuItemSprite *sender){
                                                            //cycle between 4 teams
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
        [isActiveNode addChild:teamPlayMenu];
        
        //character chooser
        normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        selectedSprite.color = ccBLACK;
        CCMenuItemSprite *rotateCharacter = [CCMenuItemSprite itemWithNormalSprite:normalSprite
                                                                    selectedSprite:selectedSprite
                                                                             block:^(CCMenuItemSprite *sender){
                                                                                 //cycle between 4 teams
                                                                                 int jousterType = player.jousterType;
                                                                                 jousterType++;
                                                                                 if(jousterType > 4){
                                                                                     jousterType = 0;
                                                                                 }
                                                                                 player.jousterType = jousterType;
                                                                                 [self playerCharacterChangedTo:player.jousterType];
                                                                                 //                                                                              sender.color = [self playerColorChangedToTeam:team];
                                                                             }];
        CCMenu *jousterMenu = [CCMenu menuWithItems:rotateCharacter, nil];
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
        pos = ccp(200, 200);
        jousterMenu.position = pos;
        [isActiveNode addChild:jousterMenu];
        
        characterLabel = [CCLabelTTF labelWithString:@"" fontName:MAIN_FONT fontSize:32];
        characterLabel.position = ccp(200, 100);
        [isActiveNode addChild:characterLabel];
        
        
        
        
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
        }else{
            teamPlayMenu.visible = NO;
        }
        if(player.isActive){
            [self activatePlayer];
        }else{
            [self deactivatePlayer];
        }
        if([[PlayerManager sharedInstance] isTeamPlay]){
            [self playerColorChangedToTeam:player.team];
        }
        [self playerCharacterChangedTo:player.jousterType];
        
    }
    return self;
}


-(void) playerColorChangedToTeam:(int)team{
    if(player.isActive){
        if(team == 0){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_ONE;
            self.color = COLOR_PLAYER_ONE_LIGHT;
        }else if(team == 1){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_TWO;
            self.color = COLOR_PLAYER_TWO_LIGHT;
        }else if(team == 2){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_THREE;
            self.color = COLOR_PLAYER_THREE_LIGHT;
        }else if(team == 3){
            border.color = COLOR_GAMEBORDER;
            teamPlayItem.color = COLOR_PLAYER_FOUR;
            self.color = COLOR_PLAYER_FOUR_LIGHT;
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
            self.color = COLOR_PLAYER_ONE_LIGHT;
        }else if(self.player.playerNumber == 1){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_TWO_LIGHT;
        }else if(self.player.playerNumber == 2){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_THREE_LIGHT;
        }else if(self.player.playerNumber == 3){
            border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_FOUR_LIGHT;
        }
    }else{
        border.color = COLOR_GAMEBORDER;
            self.color = COLOR_PLAYER_NON_LIGHT;
    }
}

-(void) playerCharacterChangedTo:(int) character{
    NSString *characterString = @"";
    if(character == 0){
        characterString = @"Ball and Chain";
    }else if(character == 1){
        characterString = @"Orbit";
    }else if(character == 2){
        characterString = @"Grower";
    }else if(character == 3){
        characterString = @"Bouncer";
    }else if(character == 4){
        characterString = @"Chump";
    }
    [characterLabel setString:characterString];
}

-(void) activatePlayer{
    isActiveNode.visible = YES;
    isActiveSprite.visible = YES;
    if([PlayerManager sharedInstance].isTeamPlay){
        [self playerColorChangedToTeam:player.team];
    }else{
        [self setBorderColorForPlayer];
    }
    
}

-(void) deactivatePlayer{
    isActiveNode.visible = NO;
    isActiveSprite.visible = NO;
    [self setBorderColorForPlayer];
}


-(void) turnOnTeamPlay{
    teamPlayMenu.visible = YES;
    [self playerColorChangedToTeam:player.team];
}


-(void) turnOffTeamPlay{
    teamPlayMenu.visible = NO;
    [self setBorderColorForPlayer];
}

@end
