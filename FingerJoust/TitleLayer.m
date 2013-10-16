//
//  TitleLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "TitleLayer.h"
#import "GameLayer.h"


@implementation TitleLayer




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
            GameLayer *gLayer = [[GameLayer alloc] initWithPlayerOne:playerOneChoice playerTwo:playerTwoChoice];
            [[CCDirector sharedDirector] replaceScene:gLayer];
            [gLayer release];
		}];
		
        
		
		CCMenu *menu = [CCMenu menuWithItems:playItem, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        [self createChoosePlayerMenus];
        
        
        
    }
    return self;
}

-(void) createChoosePlayerMenus{
    // ask director for the window size

    //player 1 select
    CGSize size = [[CCDirector sharedDirector] winSize];
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
        
        /*CCMenuItem *playItem = [CCMenuItemFont itemWithString: [NSString stringWithFormat:@"%d", i]  block:^(CCMenuItemFont* sender) {
            for(CCMenuItem *m in playerTwoChoiceMenu.children) {
                if (m != sender) {
                    [m unselected];
                    [m setColor:ccGRAY];
                }else{
                    if(!sender.isSelected){
                        [sender selected];
                        [sender setColor:ccRED];
                        playerTwoChoice = sender.tag;
                    }
                }
            }
        }];
         */
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
    
    
    

}



-(void) setWinner:(NSString*) winner{
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:winner fontName:@"Marker Felt" fontSize:128];
    
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height/1.2 );
    
    // add the label as a child to this Layer
    [self addChild: label];
}

@end
