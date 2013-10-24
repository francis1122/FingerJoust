//
//  SettingsPanel.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/24/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "SettingsPanel.h"
#import "PlayerManager.h"
#import "GameLayer.h"

@implementation SettingsPanel


-(void) resolve{
		CGSize size = [[CCDirector sharedDirector] winSize];
    menuToggle = [CCMenuItemFont itemWithString:@"Settings" block:^(CCMenuItemFont *sender) {
        if(isActive){
            isActive = NO;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(CONTROL_OFFSET, -self.contentSize.height + 60)];
            [self runAction:moveTo];
        }else{
            isActive = YES;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(CONTROL_OFFSET,0)];
            [self runAction:moveTo];
        }
    }];
    menuToggle.color= ccWHITE;
    [menuToggle setFontName:MAIN_FONT];

    CCMenu *menu = [CCMenu menuWithItems:menuToggle, nil];
    menu.position = ccp(self.contentSize.width/2, self.contentSize.height - 25);
    [self addChild:menu];
    
        PlayerManager *PM = [PlayerManager sharedInstance];
    //event items
    float offset = 70;
    float spacing = 60;
    float xPos = 145;

    windActive = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    [self makeEventSettingsItemFor:@"Wind" AtPosition:ccp(xPos, offset) WithState:PM.windEvent WithActiveSprite:windActive WithCallback:@selector(windCallback:)];
    offset += spacing;
    bombActive = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    [self makeEventSettingsItemFor:@"Bomb" AtPosition:ccp(xPos, offset) WithState:PM.bombEvent WithActiveSprite:bombActive WithCallback:@selector(bombCallback:)];
    offset += spacing;
    missileActive = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    [self makeEventSettingsItemFor:@"Missile" AtPosition:ccp(xPos, offset) WithState:PM.missileEvent WithActiveSprite:missileActive WithCallback:@selector(missileCallback:)];
    offset += spacing;
    hurricaneActive = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    [self makeEventSettingsItemFor:@"Hurricane" AtPosition:ccp(xPos, offset) WithState:PM.hurricaneEvent WithActiveSprite:hurricaneActive WithCallback:@selector(hurricaneCallback:)];
    offset += spacing;
    spikeActive = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    [self makeEventSettingsItemFor:@"Spike" AtPosition:ccp(xPos, offset) WithState:PM.spikeEvent WithActiveSprite:spikeActive WithCallback:@selector(spikeCallback:)];
    offset += spacing;
    
    
    //game speed
    CGPoint position = ccp(xPos, offset);
    int state = PM.gameSpeed;
    gameSpeedActive  = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Speed" fontName:MAIN_FONT fontSize:32];
    [label setFontName:MAIN_FONT];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = position;

    CCMenuItemFont *onItem = [CCMenuItemFont itemWithString:@"Normal" target:self selector:@selector(gameSpeed:)];
    [onItem setFontName:MAIN_FONT];
    onItem.tag = 1;
    CCMenuItemFont *offItem = [CCMenuItemFont itemWithString:@"Slow" target:self selector:@selector(gameSpeed:)];
    [offItem setFontName:MAIN_FONT];
    offItem.tag = 0;
    CCMenuItemFont *alwaysItem = [CCMenuItemFont itemWithString:@"Fast" target:self selector:@selector(gameSpeed:)];
    [alwaysItem setFontName:MAIN_FONT];
    alwaysItem.tag = 2;
    
    CCMenu *menua = [CCMenu menuWithItems:alwaysItem, onItem, offItem, nil];
    menua.position = ccp(position.x + 200, position.y);
    [menua alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        gameSpeedActive.position =  ccp(position.x + 200 + offItem.position.x, position.y);
    }else if(state == 1){
        gameSpeedActive.position =  ccp(position.x + 200 + onItem.position.x, position.y);
    }else if(state == 2){
        gameSpeedActive.position =  ccp(position.x + 200 + alwaysItem.position.x, position.y);
    }
    gameSpeedActive.color = ccORANGE;
    [self addChild:gameSpeedActive];
    [self addChild:menua];
    [self addChild:label];
    offset += spacing;
    

    
    
    
    
    //frequency of items
    position = ccp(xPos, offset);
//    state = PM.frequencyEvent;
    frequencyActive  = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    label = [CCLabelTTF labelWithString:@"Frequency" fontName:MAIN_FONT fontSize:32];
    [label setFontName:MAIN_FONT];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = position;

    
    onItem = [CCMenuItemFont itemWithString:@"Normal" target:self selector:@selector(frequencyCallback:)];
    [onItem setFontName:MAIN_FONT];
    onItem.tag = 1;
    offItem = [CCMenuItemFont itemWithString:@"Low" target:self selector:@selector(frequencyCallback:)];
    [offItem setFontName:MAIN_FONT];
    offItem.tag = 0;
    alwaysItem = [CCMenuItemFont itemWithString:@"High" target:self selector:@selector(frequencyCallback:)];
    [alwaysItem setFontName:MAIN_FONT];
    alwaysItem.tag = 2;
    
    menua = [CCMenu menuWithItems:alwaysItem, onItem, offItem, nil];
    menua.position = ccp(position.x + 200, position.y);
    [menua alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        frequencyActive.position =  ccp(position.x + 200 + offItem.position.x, position.y);
    }else if(state == 1){
        frequencyActive.position =  ccp(position.x + 200 + onItem.position.x, position.y);
    }else if(state == 2){
        frequencyActive.position =  ccp(position.x + 200 + alwaysItem.position.x, position.y);
    }
    frequencyActive.color = ccORANGE;
    [self addChild:frequencyActive];
    [self addChild:menua];
    [self addChild:label];

    

}


-(void) makeEventSettingsItemFor:(NSString*) title AtPosition:(CGPoint) position WithState:(int)state WithActiveSprite:(CCSprite*) activeSprite WithCallback:(SEL) selector{
    CCLabelTTF *label = [CCLabelTTF labelWithString:title fontName:MAIN_FONT fontSize:32];
    [label setFontName:MAIN_FONT];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = position;
    
    //three settings
    CCMenuItemFont *onItem = [CCMenuItemFont itemWithString:@"On" target:self selector:selector];
    [onItem setFontName:MAIN_FONT];
    onItem.tag = 1;
    CCMenuItemFont *offItem = [CCMenuItemFont itemWithString:@"Off" target:self selector:selector];
    [offItem setFontName:MAIN_FONT];
    offItem.tag = 0;
    CCMenuItemFont *alwaysItem = [CCMenuItemFont itemWithString:@"Always" target:self selector:selector];
    [alwaysItem setFontName:MAIN_FONT];
    alwaysItem.tag = 2;
    
    CCMenu *menu = [CCMenu menuWithItems:alwaysItem, onItem, offItem, nil];
    menu.position = ccp(position.x + 200, position.y);
    [menu alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        activeSprite.position =  ccp(position.x + 200 + offItem.position.x, position.y);
    }else if(state == 1){
        activeSprite.position =  ccp(position.x + 200 + onItem.position.x, position.y);
    }else if(state == 2){
        activeSprite.position =  ccp(position.x + 200 + alwaysItem.position.x, position.y);
    }
    activeSprite.color = ccORANGE;
    [self addChild:activeSprite];
    [self addChild:menu];
    [self addChild:label];
}

#pragma mark - callbacks

-(void) windCallback:(CCMenuItemFont*) sender{
        PlayerManager *PM = [PlayerManager sharedInstance];
    PM.windEvent = sender.tag;
    windActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) bombCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.bombEvent = sender.tag;
    bombActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) hurricaneCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.hurricaneEvent = sender.tag;
    hurricaneActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) missileCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.missileEvent = sender.tag;
    missileActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) spikeCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.spikeEvent = sender.tag;
    spikeActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) gameSpeed:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.gameSpeed = sender.tag;
    gameSpeedActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
}

-(void) frequencyCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.frequencyEvent = sender.tag;
    frequencyActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    
}

@end
