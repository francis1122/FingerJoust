//
//  BombSprite.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "BombSprite.h"
#import "GameLayer.h"
#import "PlayerManager.h"


@implementation BombSprite

@synthesize isExploding, velocity;

-(id) init{
    if(self = [super init]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        displayTime = 4;
        count = 4.0;
        velocity = CGPointZero;
        //place bomb on map
        self.position = ccp( CONTROL_OFFSET + 100 + arc4random()%((int)(winSize.width - CONTROL_OFFSET * 2 - 200)),150 + arc4random()%((int)(winSize.height - 300)));
        
        blastRadius = [CCSprite spriteWithSpriteFrameName:@"timerCircle"];
        blastRadius.scale = 1.35;
        bomb = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        bomb.color = ccGRAY;
        countDown = [CCLabelTTF labelWithString:@"4" fontName:MAIN_FONT fontSize:40];
        countDown.color = ccWHITE;

        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];
        CCRotateBy *rotate = [CCRotateBy actionWithDuration:5 * 1/gameSpeed angle:1000];
        CCEaseIn *ease = [CCEaseIn actionWithAction:rotate rate:2.4];
        [blastRadius runAction:ease];
        
        [self addChild:countDown z:1];
        [self addChild:bomb];
        [self addChild:blastRadius];
    }
    return self;
}

-(void) update:(ccTime) dt{
    //update timer
    count -= dt;
    velocity = ccpMult(velocity, 0.975);
    self.position = ccpAdd(self.position, ccpMult(velocity, dt));
    
    if(count < displayTime){
        displayTime --;
        countDown.string = [NSString stringWithFormat:@"%d", displayTime];
    }
    
    if(count < 0){
        self.isExploding = YES;
    }
    
}

@end
