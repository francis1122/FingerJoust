//
//  MissileSprite.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "MissileSprite.h"
#import "GameLayer.h"
#import "Jouster.h"
#import "PlayerManager.h"

@implementation MissileSprite

@synthesize isDone;


-(id) init{
    if(self = [self initWithSpriteFrameName:@"JousterOuter"]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        

    }
    return self;
}

-(void)resolve{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    PlayerManager *PM = [PlayerManager sharedInstance];
    float gameSpeed = [PM getGameSpeedScaler];
    warningSprite = [CCSprite spriteWithSpriteFrameName:@"warning"];
    [self.parent addChild:warningSprite];
    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1.5 * (1/gameSpeed)];
    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
        [warningSprite removeFromParentAndCleanup:YES];
        warningSprite = nil;
    }];
    CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
    [warningSprite runAction:seqAnim];
    
    
    int spot = arc4random()%4;
    CGPoint pos;
    CGPoint warningPos;
    if(spot == 0){
        //left
        pos = ccp(CONTROL_OFFSET - 540, 150 + (arc4random()%((int)winSize.height - 300)) );
        warningPos = ccp(pos.x + 600, pos.y);
        velocity = ccp(400,0);
        warningSprite.rotation = 90;
    }else if(spot == 1){
        //right
        pos = ccp(winSize.width - CONTROL_OFFSET + 540, 150 + (arc4random()%((int)winSize.height - 300)) );
        warningPos = ccp(pos.x - 600, pos.y);
        velocity = ccp(-400,0);
        warningSprite.rotation = -90;
    }else if(spot == 2){
        //top
        pos = ccp( CONTROL_OFFSET + 100 + (arc4random()%((int)winSize.width - 2*CONTROL_OFFSET - 200)) ,-600);
        warningPos = ccp(pos.x , pos.y + 710);
        velocity = ccp(0,400);

    }else if(spot == 3){
        //bottom
        pos = ccp( CONTROL_OFFSET + 100 + (arc4random()%((int)winSize.width - 2*CONTROL_OFFSET - 200)) , winSize.height + 600);
        warningPos = ccp(pos.x , pos.y - 710);
        velocity = ccp(0,-400);
        warningSprite.rotation = 180;
    }
    warningSprite.position = warningPos;
    self.position = pos;
}


-(void) update:(ccTime)dt{
    self.position = ccpAdd(self.position,  ccpMult(velocity, dt));
    ticka++;
    if(warningSprite && ticka%4 == 0){
        ccColor3B col;
        int ran = arc4random()%2;
        if(ran == 0){
            col = ccBLACK;
        }else if(ran == 1){
            col = ccWHITE;
        }
        warningSprite.color = col;
    }
}


-(void) checkBoundaries{
    
}


@end
