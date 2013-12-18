//
//  AboutPanel.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/28/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "AboutPanel.h"
#import "GameLayer.h"
#import "SettingsPanel.h"
#import "TitleLayer.h"
#import "PlayerManager.h"
#import "SimpleAudioEngine.h"


@implementation AboutPanel

@synthesize titleLayer, isActive;

-(void) resolve{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    menuToggle = [CCMenuItemFont itemWithString:@"About" block:^(CCMenuItemFont *sender) {
        //check if about is open
        if(titleLayer.settingsMenu.isActive){
            titleLayer.settingsMenu.isActive = NO;
            isActive = NO;
            titleLayer.menu.enabled = YES;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET, -self.contentSize.height + 60)];
            [titleLayer.settingsMenu runAction:moveTo];
            SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
            [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
            return;
        }
        
        if(isActive){
            isActive = NO;
            titleLayer.menu.enabled = YES;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET, size.height - 60)];
            [self runAction:moveTo];
            
            [closeImage runAction: [CCFadeOut actionWithDuration:.35]];
            SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
            [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
            
        }else{
            isActive = YES;
            titleLayer.menu.enabled = NO;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET, size.height - self.contentSize.height)];
            [self runAction:moveTo];
            [closeImage runAction: [CCFadeIn actionWithDuration:.35]];
            SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
            [SAE playEffect:BUTTON_CLICK pitch:0.6 pan:0.0 gain:.2];
        }
    }];

//    NSLog(@"menuActiveArea: %f, %f, %f, %f", menuToggle.activeArea.origin.x, menuToggle.activeArea.origin.y, menuToggle.activeArea.size.width, menuToggle.activeArea.size.height);
    menuToggle.color= ccWHITE;
    [menuToggle setFontName:MAIN_FONT];
    CCMenu *menu = [CCMenu menuWithItems:menuToggle, nil];
    menu.position = ccp(self.contentSize.width/2, 25);
    [self addChild:menu z:1];
    menuToggle.activeArea = CGRectMake(-50, -10, 180, 55);
    
    closeImage = [CCSprite spriteWithSpriteFrameName:@"closebutton"];
    closeImage.opacity = 0;
    closeImage.position = ccp(self.contentSize.width/2 + 60, 22);
    closeImage.scale = .5;
    [self addChild:closeImage z:0];
    
    float offset = 605;
    float spacing = 45;
    float xPos = 170;
    float fontSize = 24;
    float otheroffsetX = 250;

    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Credits" fontName:SECOND_FONT fontSize:fontSize];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = ccp(self.contentSize.width/2, offset);
    [self addChild:label];
    
    offset -= spacing;
    CGPoint position = ccp(xPos, offset);
    label =     [CCLabelTTF labelWithString:@"Game Design" fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(150, 30) hAlignment:kCCTextAlignmentRight];
    [label setHorizontalAlignment:kCCTextAlignmentRight];
    label.position = position;
    [self addChild:label];
    
    position = ccp(xPos + otheroffsetX, offset);
    label = [CCLabelTTF labelWithString:@"Hunter Francis" fontName:MAIN_FONT fontSize:fontSize dimensions:CGSizeMake(240, 30) hAlignment:kCCTextAlignmentLeft];
    label.position = position;
    [self addChild:label];
    
    offset -= spacing;
    
    position = ccp(xPos, offset);
    label =     [CCLabelTTF labelWithString:@"Programming" fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(150, 30) hAlignment:kCCTextAlignmentRight];
    [label setHorizontalAlignment:kCCTextAlignmentRight];
    label.position = position;
    [self addChild:label];
    
    position = ccp(xPos + otheroffsetX, offset);
    label = [CCLabelTTF labelWithString:@"Hunter Francis" fontName:MAIN_FONT fontSize:fontSize dimensions:CGSizeMake(240, 30) hAlignment:kCCTextAlignmentLeft];
    label.position = position;
    [self addChild:label];
    offset -= spacing;
    
    position = ccp(xPos, offset);
    label =     [CCLabelTTF labelWithString:@"Art" fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(150, 30) hAlignment:kCCTextAlignmentRight];
    [label setHorizontalAlignment:kCCTextAlignmentRight];
    label.position = position;
    [self addChild:label];
    
    position = ccp(xPos + otheroffsetX, offset);
    label = [CCLabelTTF labelWithString:@"Hunter Francis" fontName:MAIN_FONT fontSize:fontSize dimensions:CGSizeMake(240, 30) hAlignment:kCCTextAlignmentLeft];
    label.position = position;
    [self addChild:label];
    
    offset -= spacing;
    position = ccp(xPos, offset);
    label =     [CCLabelTTF labelWithString:@"Sound/Music" fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(150, 30) hAlignment:kCCTextAlignmentRight];
    [label setHorizontalAlignment:kCCTextAlignmentRight];
    label.position = position;
    [self addChild:label];
    
    position = ccp(xPos + otheroffsetX, offset);
    label = [CCLabelTTF labelWithString:@"http://www.freesfx.co.uk" fontName:MAIN_FONT fontSize:12 dimensions:CGSizeMake(240, 30) hAlignment:kCCTextAlignmentLeft];
    label.position = position;
    [self addChild:label];
    
    
    BOOL isUnlocked = [[PlayerManager sharedInstance] isGameUnlocked];
    
    offset -= spacing * 4;
    position = ccp(xPos, offset);
    label = [CCLabelTTF labelWithString:@"Unlock the\nfull game\nfor $1.99" fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(150, 200) hAlignment:kCCTextAlignmentRight];
    [label setHorizontalAlignment:kCCTextAlignmentRight];
    label.position = position;
    [self addChild:label];
    
    // unlock the appfor money!!!
    CCSprite *normal = [CCSprite spriteWithSpriteFrameName:@"unlock"];
    CCSprite *selected = [CCSprite spriteWithSpriteFrameName:@"unlock"];
    CCMenuItemSprite *unlockItem = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected block:^(id sender) {
        PlayerManager *PM = [PlayerManager sharedInstance];
        [PM purchaseProduct];
    }];
    position = ccp(xPos + otheroffsetX - 54, offset + 49);
    CCMenu *unlockMenu = [CCMenu menuWithItems:unlockItem, nil];
    unlockMenu.position = position;
    unlockMenu.visible = YES;
    [self addChild:unlockMenu z:10];
    
    if(isUnlocked){
        label.visible = NO;
        unlockMenu.visible = NO;
    }else{
        label.visible = YES;
        unlockMenu.visible = YES;
    }
    
    
    
    
    
    //game speed


}

@end
