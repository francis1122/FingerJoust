//
//  TitleLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "TitleLayer.h"
#import "GameLayer.h"
#import "PlayerManager.h"
#import "Player.h"
#import "PlayerSelect.h"
#import "GameLayer.h"
#import "SettingsPanel.h"
#import "AboutPanel.h"

@implementation TitleLayer


@synthesize playerSelectArray, menu, settingsMenu, aboutMenu;

-(id) init{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
		CGSize size = [[CCDirector sharedDirector] winSize];
        // create and initialize a Label
        //		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Ball Buster" fontName:MAIN_FONT fontSize:64];
        //		label.position =  ccp( size.width /2 , size.height-100 );
        //		[self addChild: label];
        
        logo = [CCSprite spriteWithSpriteFrameName:@"Logo"];
		logo.position =  ccp( size.width/2 + 30, size.height-200 );
        [self addChild:logo];
		// ask director for the window size
        
        
        
		// position the label on the center of the screen
        CCSprite *normal = [CCSprite spriteWithSpriteFrameName:@"play"];
        CCSprite *selected = [CCSprite spriteWithSpriteFrameName:@"play"];
		CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected block:^(id sender) {
            int activeCount = 0;
            NSMutableArray *teamArray  = [NSMutableArray array];
            NSNumber *number = [NSNumber numberWithInt:0];
            [teamArray addObject:number];
            number = [NSNumber numberWithInt:0];
            [teamArray addObject:number];
            //TODO: check for different teams if teamplay is on
            BOOL isTeamPlay = [[PlayerManager sharedInstance] isTeamPlay];
            if(isTeamPlay){
                [teamArray removeAllObjects];
                for(Player *player in [[PlayerManager sharedInstance] playerArray]){
                    if(player.isActive){
                        BOOL alreadyAdded = NO;
                        for(NSNumber *teamNumber in teamArray){
                            if(player.team == [teamNumber integerValue]){
                                alreadyAdded = YES;
                            }
                        }
                        if(!alreadyAdded){
                            NSNumber *newTeamNumber = [NSNumber numberWithInt:player.team];
                            [teamArray addObject:newTeamNumber];
                        }
                    }
                }
            }
            
            for(Player *player in [[PlayerManager sharedInstance] playerArray]){
                if(player.isActive){
                    activeCount++;
                }
            }
            BOOL locked = NO;
            for(PlayerSelect *select in self.playerSelectArray){
                if(select.isLocked){
                    locked = YES;
                }
            }
            //temp code to allow anyone to play any character
            locked = NO;
            if(activeCount > 1 && !locked && [teamArray count] > 1){
                [self animateOut];
            }
		}];
        
        
        normal = [CCSprite spriteWithSpriteFrameName:@"teamPlay"];
        selected = [CCSprite spriteWithSpriteFrameName:@"teamPlay"];
		CCMenuItemSprite *teamPlayToggle = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected block:^(CCMenuItemSprite *sender) {
//        CCMenuItemFont *teamPlayToggle = [CCMenuItemFont itemWithString:@"Team Play Off" block:^(CCMenuItemFont *sender) {
            [PlayerManager sharedInstance].isTeamPlay = ![PlayerManager sharedInstance].isTeamPlay;
            if([PlayerManager sharedInstance].isTeamPlay){
                for(PlayerSelect *selectLayer in self.playerSelectArray){
                    [selectLayer turnOnTeamPlay];
                }
                sender.color = ccBLACK;
  //              [sender setString:@"Team Play On"];
            }else{
                for(PlayerSelect *selectLayer in self.playerSelectArray){
                    [selectLayer turnOffTeamPlay];
                }
                sender.color = ccWHITE;
//                [sender setString:@"Team Play Off"];
            }
		}];
        
		menu = [CCMenu menuWithItems:playItem, teamPlayToggle, nil];
		
        [menu alignItemsVerticallyWithPadding:50];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
        //settings menu
        settingsMenu = [SettingsPanel layerWithColor:COLOR_GAMEBORDER_B4
                                               width:size.width - 2*CONTROL_OFFSET + 4
                                              height:self.contentSize.height - 60];
        settingsMenu.position = ccp(CONTROL_OFFSET, -settingsMenu.contentSize.height + 60);
        settingsMenu.titleLayer = self;
        [settingsMenu resolve];
        [self addChild:settingsMenu z:9];
        
        
        //about panel
        aboutMenu = [AboutPanel layerWithColor:COLOR_GAMEBORDER_B4
                                         width:size.width - 2*CONTROL_OFFSET + 4
                                        height:self.contentSize.height - 60];
        aboutMenu.position = ccp(CONTROL_OFFSET, size.height - 60);
        aboutMenu.titleLayer = self;
        [aboutMenu resolve];
        [self addChild:aboutMenu z:10];
        
		// Add the menu to the layer
		[self addChild:menu];
        
        self.playerSelectArray = [NSMutableArray array];
        //create 4 player select things
        for(Player *player in [PlayerManager sharedInstance].playerArray){
            PlayerSelect *playerSelectLayer = [[[PlayerSelect alloc] initWithPlayer:player] autorelease];
            [self.playerSelectArray addObject:playerSelectLayer];
            [self addChild:playerSelectLayer z:10];
        }
        [self animateIn];
    }
    return self;
}
-(void) settingsSetup{
    
}

-(void) dealloc{
    [playerSelectArray release];
    [super dealloc];
}


-(void) createChoosePlayerMenus{
    // ask director for the window size
    
    //player 1 select
    /*    CGSize size = [[CCDirector sharedDirector] winSize];
     CCMenu *playerChoiceMenu = [[CCMenu alloc] init];
     for(int i = 0; i < 4 ;i++){
     CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
     CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
     selectedSprite.color = ccRED;
     CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
     selectedSprite:selectedSprite
     block:^(CCMenuItemSprite *sender){
     jousterBoxLeft.position = ccpAdd(playerChoiceMenu.position, sender.position);
     playerOneChoice = sender.tag;
     }];
     playItem.tag = i;
     [playerChoiceMenu addChild:playItem];
     }
     playerChoiceMenu.position = ccp(100,size.height/2 - 50);
     [playerChoiceMenu alignItemsVerticallyWithPadding:15];
     [self addChild:playerChoiceMenu];
     
     
     
     //player 2
     CCMenu *playerTwoChoiceMenu = [[CCMenu alloc] init];
     for(int i = 0; i < 4 ;i++){
     CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
     CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
     selectedSprite.color = ccRED;
     CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:normalSprite
     selectedSprite:selectedSprite
     block:^(CCMenuItemSprite *sender){
     jousterBoxRight.position = ccpAdd(playerTwoChoiceMenu.position, sender.position);
     playerTwoChoice = sender.tag;
     }];
     
     
     playItem.tag = i;
     [playerTwoChoiceMenu addChild:playItem];
     }
     playerTwoChoiceMenu.position = ccp(size.width - 100 ,size.height/2 - 50);
     [playerTwoChoiceMenu alignItemsVerticallyWithPadding:30];
     [self addChild:playerTwoChoiceMenu];
     
     //selector things
     jousterBoxLeft = [CCSprite spriteWithSpriteFrameName:@"JousterOuter"];
     jousterBoxRight = [CCSprite spriteWithSpriteFrameName:@"JousterOuter"];
     jousterBoxLeft.color = ccRED;
     jousterBoxRight.color = ccRED;
     [self addChild:jousterBoxLeft];
     [self addChild:jousterBoxRight];
     */
    
    
    
}



-(void) setWinner:(NSString*) winner{
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"" fontName:MAIN_FONT fontSize:128];
    
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height/1.2 );
    
    // add the label as a child to this Layer
    [self addChild: label];
}

#pragma mark - animations

-(void) animateOut{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    CCMoveTo *settingsMove = [CCMoveTo actionWithDuration:.3 position:ccp(CONTROL_OFFSET, -settingsMenu.contentSize.height)];
    CCMoveTo *aboutMove = [CCMoveTo actionWithDuration:.3 position:ccp(CONTROL_OFFSET, size.height)];
    CCFadeOut *menuFade = [CCFadeOut actionWithDuration:.5];
    CCFadeOut *logoFade = [CCFadeOut actionWithDuration:.5];
    
    [logo runAction:logoFade];
    [menu runAction:menuFade];
    [settingsMenu runAction:settingsMove];
    [aboutMenu runAction:aboutMove];
    
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.3];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        for(PlayerSelect *selectionScreen in self.playerSelectArray){
            [selectionScreen stopAllActions];
            CGPoint pos;
            if(selectionScreen.player.playerNumber == 0){
                pos = ccp(-selectionScreen.contentSize.width, size.height/2);
            }else if(selectionScreen.player.playerNumber == 1){
                pos = ccp(size.width, size.height/2);
            }else if(selectionScreen.player.playerNumber == 2){
                pos = ccp(size.width, 0);
            }else if(selectionScreen.player.playerNumber == 3){
                pos = ccp(-selectionScreen.contentSize.width, 0);
            }
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.8 position:pos];
            CCEaseIn *easeIn = [CCEaseIn actionWithAction:moveTo rate:2];
            [selectionScreen runAction:easeIn];
        }
        
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
    
    
    delay = [CCDelayTime actionWithDuration:1.3];
    block = [CCCallBlock actionWithBlock:^{
        GameLayer *gLayer = [[GameLayer alloc] init];
        [[CCDirector sharedDirector] replaceScene:gLayer];
        [gLayer release];
        
    }];
    seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
    
}

-(void) animateIn{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    for(PlayerSelect *selectionScreen in self.playerSelectArray){
        [selectionScreen stopAllActions];
        float width = 315;
        CGPoint pos = CGPointZero;
        if(selectionScreen.player.playerNumber == 0){
            pos = ccp(-2, size.height/2);
        }else if(selectionScreen.player.playerNumber == 1){
            pos = ccp(size.width - width, size.height/2);
        }else if(selectionScreen.player.playerNumber == 2){
            pos = ccp(size.width - width, 0);
        }else if(selectionScreen.player.playerNumber == 3){
            pos = ccp(-2, 0);
        }
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.8 position:pos];
        CCEaseIn *easeIn = [CCEaseIn actionWithAction:moveTo rate:2];
        [selectionScreen runAction:easeIn];
    }
    
    logo.opacity = 0;
    menu.cascadeOpacityEnabled = YES;
    menu.opacity = 0;
    settingsMenu.position = ccp(CONTROL_OFFSET, -settingsMenu.contentSize.height);
    aboutMenu.position = ccp(CONTROL_OFFSET, size.height);
    //animate to and bottom in
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.9];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        CCMoveTo *settingsMove = [CCMoveTo actionWithDuration:.3 position:ccp(CONTROL_OFFSET -2, -settingsMenu.contentSize.height + 60)];
        CCMoveTo *aboutMove = [CCMoveTo actionWithDuration:.3 position:ccp(CONTROL_OFFSET - 2, size.height - 60)];
        CCFadeIn *menuFade = [CCFadeIn actionWithDuration:.4];
        CCFadeIn *logoFade = [CCFadeIn actionWithDuration:.4];
        
        [logo runAction:logoFade];
        [menu runAction:menuFade];
        [settingsMenu runAction:settingsMove];
        [aboutMenu runAction:aboutMove];
        
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
}


@end
