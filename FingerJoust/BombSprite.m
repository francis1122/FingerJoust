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
        bomb = [CCSprite spriteWithSpriteFrameName:@"bomb"];
        bomb.color = ccBLACK;
//        bomb.scale = 1.25;
        countDown = [CCLabelTTF labelWithString:@"4" fontName:MAIN_FONT fontSize:32];
        countDown.position = ccp(2,-8);
        countDown.color = ccWHITE;

        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];
        CCRotateBy *rotate = [CCRotateBy actionWithDuration:5 * 1/gameSpeed angle:1000];
        CCEaseIn *ease = [CCEaseIn actionWithAction:rotate rate:2.4];
        [blastRadius runAction:ease];
        
        [self addChild:countDown z:2];
        [self addChild:bomb z:1];
        [self addChild:blastRadius z:1];
        
        
        motionStreak = [[CCParticleSystemQuad alloc] initWithFile: @"MotionStreak.plist"];
        
            [motionStreak setStartColor:ccc4f(1.0, 1.0, 1.0, 1.0)];
            [motionStreak setEndColor:ccc4f(1.0, 1.0, 1.0, 1.0)];
        motionStreak.position = ccp(0,-8);
        
        motionStreak.positionType = kCCPositionTypeFree;
        [self addChild:motionStreak];

        bomb.scale = 0.0;
        CCScaleTo *scale = [CCScaleTo actionWithDuration:.4 scale:1.25];
        [bomb runAction:scale];
        blastRadius.scale = 0.0;
        CCScaleTo *scaleRadius = [CCScaleTo actionWithDuration:.4 scale:1.35];
        [blastRadius runAction:scaleRadius];
        countDown.scale = 0.0;
        CCScaleTo *scaleText = [CCScaleTo actionWithDuration:.4 scale:1];
        [countDown runAction:scaleText];
        
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
