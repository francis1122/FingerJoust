//
//  SettingsPanel.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/24/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "SettingsPanel.h"
#import "PlayerManager.h"
#import "TitleLayer.h"
#import "GameLayer.h"
#import "AboutPanel.h"

@implementation SettingsPanel

@synthesize titleLayer, isActive;

-(void) resolve{
		CGSize size = [[CCDirector sharedDirector] winSize];
        menuToggle = [CCMenuItemFont itemWithString:@"Settings" block:^(CCMenuItemFont *sender) {
            //check if about is open
            if(titleLayer.aboutMenu.isActive){
                titleLayer.aboutMenu.isActive = NO;
                titleLayer.menu.enabled = YES;
                CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET, size.height - 60)];
                [titleLayer.aboutMenu runAction:moveTo];
                return;
            }
            
        if(isActive){
            isActive = NO;
                        titleLayer.menu.enabled = YES;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET, -self.contentSize.height + 60)];
            [self runAction:moveTo];
        }else{
            isActive = YES;
                        titleLayer.menu.enabled = NO;
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.35 position:ccp(CONTROL_OFFSET,0)];
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
    float offset = 115;
    float spacing = 65;
    float xPos = 165;
    float fontSize = 24;

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
    
    
 

    
    
    
    
    //frequency of items
    CGPoint position = ccp(xPos, offset);
    int state = PM.frequencyEvent;
    frequencyActive  = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];


    
    CCMenuItemFont *onItem = [CCMenuItemFont itemWithString:@"Normal" target:self selector:@selector(frequencyCallback:)];
    [onItem setFontName:MAIN_FONT];
    onItem.tag = 1;
     CCMenuItemFont* offItem = [CCMenuItemFont itemWithString:@"Low" target:self selector:@selector(frequencyCallback:)];
    [offItem setFontName:MAIN_FONT];
    offItem.tag = 0;
     CCMenuItemFont* alwaysItem = [CCMenuItemFont itemWithString:@"High" target:self selector:@selector(frequencyCallback:)];
    [alwaysItem setFontName:MAIN_FONT];
    alwaysItem.tag = 2;
    
    CCMenuItemFont* neverItem = [CCMenuItemFont itemWithString:@"Never" target:self selector:@selector(frequencyCallback:)];
    [neverItem setFontName:MAIN_FONT];
    neverItem.tag = 3;
    
    onItem.fontSize = fontSize;
    offItem.fontSize = fontSize;
    alwaysItem.fontSize = fontSize;
    neverItem.fontSize = fontSize;
    
    CCMenu *menua = [CCMenu menuWithItems:alwaysItem, onItem, offItem, neverItem, nil];
    menua.position = ccp(position.x + 110, position.y);
    [menua alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        frequencyActive.position =  ccp(position.x + 110 + offItem.position.x, position.y);
    }else if(state == 1){
        frequencyActive.position =  ccp(position.x + 110 + onItem.position.x, position.y);
    }else if(state == 2){
        frequencyActive.position =  ccp(position.x + 110 + alwaysItem.position.x, position.y);
    }else if(state == 3){
        frequencyActive.position =   ccp(position.x + 110 + neverItem.position.x, position.y);
    }
    frequencyActive.color = ccORANGE;
    [self addChild:frequencyActive];
    [self addChild:menua];
    offset += 50;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Frequency" fontName:SECOND_FONT fontSize:fontSize];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = ccp(self.contentSize.width/2, offset) ;
    [self addChild:label];
    
    offset += spacing;
    //game speed
    position = ccp(xPos, offset);
    state = PM.gameSpeed;
    gameSpeedActive  = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
    
    onItem = [CCMenuItemFont itemWithString:@"Normal" target:self selector:@selector(gameSpeed:)];
    [onItem setFontName:MAIN_FONT];
    onItem.tag = 1;
    offItem = [CCMenuItemFont itemWithString:@"Slow" target:self selector:@selector(gameSpeed:)];
    [offItem setFontName:MAIN_FONT];
    offItem.tag = 0;
    alwaysItem = [CCMenuItemFont itemWithString:@"Fast" target:self selector:@selector(gameSpeed:)];
    [alwaysItem setFontName:MAIN_FONT];
    alwaysItem.tag = 2;
    
    onItem.fontSize = fontSize;
    offItem.fontSize = fontSize;
    alwaysItem.fontSize = fontSize;
    
    menua = [CCMenu menuWithItems:alwaysItem, onItem, offItem, nil];
    menua.position = ccp(position.x + 117, position.y);
    [menua alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        gameSpeedActive.position =  ccp(position.x + 117 + offItem.position.x, position.y);
    }else if(state == 1){
        gameSpeedActive.position =  ccp(position.x + 117 + onItem.position.x, position.y);
    }else if(state == 2){
        gameSpeedActive.position =  ccp(position.x + 117 + alwaysItem.position.x, position.y);
    }
    gameSpeedActive.color = ccORANGE;
    [self addChild:gameSpeedActive];
    [self addChild:menua];
    
    offset += 50;
    label = [CCLabelTTF labelWithString:@"Game Speed" fontName:SECOND_FONT fontSize:fontSize];
    [label setHorizontalAlignment:kCCTextAlignmentLeft];
    label.position = ccp(self.contentSize.width/2, offset);
    [self addChild:label];
    
    //locked shit
    if(!PM.isGameUnlocked){
        PM.hurricaneEvent = 0;
        PM.missileEvent = 0;
        PM.spikeEvent = 0;
//        put locks down
        CCSprite *lock = [CCSprite spriteWithSpriteFrameName:@"Lock"];
        lock.position = gameSpeedActive.position;
        [self addChild:lock z:100];
        
        lock = [CCSprite spriteWithSpriteFrameName:@"Lock"];
        lock.position = missileActive.position;
        [self addChild:lock z:100];
        
        lock = [CCSprite spriteWithSpriteFrameName:@"Lock"];
        lock.position = hurricaneActive.position;
        [self addChild:lock z:100];
        
        lock = [CCSprite spriteWithSpriteFrameName:@"Lock"];
        lock.position = spikeActive.position;
        [self addChild:lock z:100];
    }
}


-(void) makeEventSettingsItemFor:(NSString*) title AtPosition:(CGPoint) position WithState:(int)state WithActiveSprite:(CCSprite*) activeSprite WithCallback:(SEL) selector{
    float fontSize = 24;
    CCLabelTTF *label =     [CCLabelTTF labelWithString:title fontName:SECOND_FONT fontSize:fontSize dimensions:CGSizeMake(100, 30) hAlignment:kCCTextAlignmentRight];

    label.string = title;
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
    onItem.fontSize = fontSize;
    offItem.fontSize = fontSize;
    alwaysItem.fontSize = fontSize;
    
    CCMenu *menu = [CCMenu menuWithItems:alwaysItem, onItem, offItem, nil];
    menu.position = ccp(position.x + 180, position.y);
    [menu alignItemsHorizontallyWithPadding:20];
    
    if(state == 0){
        activeSprite.position =  ccp(position.x + 180 + offItem.position.x, position.y);
    }else if(state == 1){
        activeSprite.position =  ccp(position.x + 180 + onItem.position.x, position.y);
    }else if(state == 2){
        activeSprite.position =  ccp(position.x + 180 + alwaysItem.position.x, position.y);
    }
    activeSprite.color = ccORANGE;
    activeSprite.scale = .7;
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
    if(PM.isGameUnlocked){
        PM.hurricaneEvent = sender.tag;
        hurricaneActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    }
}

-(void) missileCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    if(PM.isGameUnlocked){
        PM.missileEvent = sender.tag;
        missileActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    }
}

-(void) spikeCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    if(PM.isGameUnlocked){
        PM.spikeEvent = sender.tag;
        spikeActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    }
}

-(void) gameSpeed:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    if(PM.isGameUnlocked){
        PM.gameSpeed = sender.tag;
        gameSpeedActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    }
}

-(void) frequencyCallback:(CCMenuItemFont*) sender{
    PlayerManager *PM = [PlayerManager sharedInstance];
    PM.frequencyEvent = sender.tag;
    frequencyActive.position = ccp(sender.parent.position.x + sender.position.x, sender.parent.position.y);
    
}

@end
