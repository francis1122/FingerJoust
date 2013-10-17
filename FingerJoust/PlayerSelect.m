//
//  PlayerSelect.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/17/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "PlayerSelect.h"
#import "Player.h"

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
    
    if(self = [super initWithColor:baop width:size.width/3 height:size.height/2]){

        //set position based on plapyer number
        CGPoint pos = CGPointZero;
        if(self.player.playerNumber == 0){
            pos = ccp(0, size.height/2);
        }else if(self.player.playerNumber == 1){
            pos = ccp(size.width - size.width/3, size.height/2);
        }else if(self.player.playerNumber == 2){
            pos = ccp(size.width - size.width/3, 0);
        }else if(self.player.playerNumber == 3){
            pos = ccp(0, 0);
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
                                                                                  isActiveSprite.visible = YES;
                                                                              }else{
                                                                                  isActiveSprite.visible = NO;
                                                                              }
                                                                          }];
        [playerChoiceMenu addChild:playItem];
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
        
        
    }
    return self;
}

@end
