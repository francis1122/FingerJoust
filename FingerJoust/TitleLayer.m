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

@implementation TitleLayer


@synthesize playerSelectArray;

-(id) init{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
        // create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Ball Buster" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height-100 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        
		CCMenuItem *playItem = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            int activeCount = 0;
            for(Player *player in [[PlayerManager sharedInstance] playerArray]){
                if(player.isActive){
                    activeCount++;
                }
            }
            if(activeCount > 1){
                GameLayer *gLayer = [[GameLayer alloc] init];
                [[CCDirector sharedDirector] replaceScene:gLayer];
                [gLayer release];
            }
		}];

        CCMenuItemFont *teamPlayToggle = [CCMenuItemFont itemWithString:@"Team Play Off" block:^(CCMenuItemFont *sender) {
            [PlayerManager sharedInstance].isTeamPlay = ![PlayerManager sharedInstance].isTeamPlay;
            if([PlayerManager sharedInstance].isTeamPlay){
                for(PlayerSelect *selectLayer in self.playerSelectArray){
                    [selectLayer turnOnTeamPlay];
                }
                [sender setString:@"Team Play On"];
            }else{
                for(PlayerSelect *selectLayer in self.playerSelectArray){
                    [selectLayer turnOffTeamPlay];
                }
                [sender setString:@"Team Play Off"];
            }
		}];
        
		
		CCMenu *menu = [CCMenu menuWithItems:playItem, teamPlayToggle, nil];
		
//		[menu alignItemsHorizontallyWithPadding:20];
        [menu alignItemsVerticallyWithPadding:50];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
        
        
		// Add the menu to the layer
		[self addChild:menu];
        
        self.playerSelectArray = [NSMutableArray array];
        //create 4 player select things
        for(Player *player in [PlayerManager sharedInstance].playerArray){
            PlayerSelect *playerSelectLayer = [[[PlayerSelect alloc] initWithPlayer:player] autorelease];
            [self.playerSelectArray addObject:playerSelectLayer];
            [self addChild:playerSelectLayer];
        }
    }
    
    
    
    
    return self;
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
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"someone" fontName:@"Marker Felt" fontSize:128];
    
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height/1.2 );
    
    // add the label as a child to this Layer
    [self addChild: label];
}

@end
