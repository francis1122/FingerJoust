//
//  SpikeEdgeEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/23/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "SpikeEdgeEvent.h"
#import "GameLayer.h"
#import "HazardLayer.h"
#import "Jouster.h"
#import "UILayer.h"
#import "PlayerManager.h"

@implementation SpikeEdgeEvent

@synthesize spikeArray;

-(id) initWithTime:(float) time GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        timeSpan = time;
        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];
        self.spikeArray = [NSMutableArray array];
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        
        CCSprite *warningSign = [CCSprite spriteWithSpriteFrameName:@"warningSigns"];
        warningSign.opacity = 95;
        warningSign.position = ccp(winSize.width/2, winSize.height/2);
        [gameLayer addChild:warningSign];
        CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1.4/gameSpeed];
        CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
            [warningSign removeFromParentAndCleanup:YES];
        }];
        CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
        [warningSign runAction:seqAnim];
        
        delayAnim = [CCDelayTime actionWithDuration:1.4 / gameSpeed];
        blockAnim = [CCCallBlock actionWithBlock:^{
            //spawn walls
            float durationMove = .4;
            topSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            topSpike.color = COLOR_GAMEBORDER;
            topSpike.rotation = -90;
            topSpike.position = ccp(winSize.width/2, winSize.height-30);
            CCMoveTo *topMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(winSize.width/2, winSize.height-70)];
            [topSpike runAction:topMove];
            [gameLayer.hazardLayer addChild:topSpike];
            [self.spikeArray addObject:topSpike];
            
            
            bottomSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            bottomSpike.color = COLOR_GAMEBORDER;
            bottomSpike.rotation = 90;
            bottomSpike.position = ccp(winSize.width/2, 30);
            CCMoveTo *bottomMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(winSize.width/2, 70)];
            [bottomSpike runAction:bottomMove];
            [gameLayer.hazardLayer addChild:bottomSpike];
            [self.spikeArray addObject:bottomSpike];
            
            rightSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            rightSpike.color = COLOR_GAMEBORDER;
            rightSpike.position = ccp(winSize.width - CONTROL_OFFSET + 20, winSize.height/2);
            CCMoveTo *rightMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(winSize.width - CONTROL_OFFSET - 20, winSize.height/2)];
            [rightSpike runAction:rightMove];
            [gameLayer.hazardLayer addChild:rightSpike];
            [self.spikeArray addObject:rightSpike];
            
            leftSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            leftSpike.color = COLOR_GAMEBORDER;
            leftSpike.rotation = 180;
            leftSpike.position = ccp(CONTROL_OFFSET - 20, winSize.height/2);
            CCMoveTo *leftMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(CONTROL_OFFSET + 20, winSize.height/2)];
            [leftSpike runAction:leftMove];
            [gameLayer.hazardLayer addChild:leftSpike];
            [self.spikeArray addObject:leftSpike];
            
            
            
            
            
            
            
        }];
        seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
        [gameLayer runAction:seqAnim];
        
        
        
        
        
        
    }
    return self;
}

-(void) dealloc{
    [spikeArray release];
    [super dealloc];
}


-(void) update:(ccTime) dt{
    [super update:dt];
    if(elapsedTime > 1.75 && elapsedTime < (timeSpan - 0.55) ){
        for(Jouster* jouster in gameLayer.jousterArray){
            if(!jouster.isDead){
                [self checkSpikeBoundaries:jouster];
            }
        }
    }
    
    
    if(elapsedTime > (timeSpan - 0.6) && !isRetracting){
        isRetracting = YES;
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];
        if(topSpike){
            float durationMove = .4;
            CCMoveTo *topMove = [CCMoveTo actionWithDuration:durationMove /gameSpeed position:ccp(winSize.width/2, winSize.height-30)];
            [topSpike runAction:topMove];
            
            CCMoveTo *bottomMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(winSize.width/2, 30)];
            [bottomSpike runAction:bottomMove];
            
            CCMoveTo *rightMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(winSize.width - CONTROL_OFFSET + 20, winSize.height/2)];
            [rightSpike runAction:rightMove];
            
            CCMoveTo *leftMove = [CCMoveTo actionWithDuration:durationMove/gameSpeed position:ccp(CONTROL_OFFSET - 20, winSize.height/2)];
            [leftSpike runAction:leftMove];
        }
    }
}

-(void) isFinished{
    for(int i = 0; i < [self.spikeArray count]; i++){
        CCSprite *spike = [self.spikeArray objectAtIndex:i];
//        [spike stopAllActions];
        [spike removeFromParentAndCleanup:YES];
        [self.spikeArray removeObject:spike];
        i--;
    }
    topSpike = nil;
    bottomSpike = nil;
    leftSpike = nil;
    rightSpike = nil;
}

-(void) onStart{
    
}



-(void) checkSpikeBoundaries:(Jouster*) jouster{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint pos = jouster.position;
    float radius = 61;
    BOOL isDead = NO;
    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        isDead = YES;
    }
    
    //check south side
    if( (pos.y - radius) < MIDDLEBAR_HEIGHT ){
        isDead = YES;
    }
    
    //left side
    if((pos.x - radius) < CONTROL_OFFSET){
        isDead = YES;
    }
    
    //right side
    if((pos.x + radius) >  (winSize.width - CONTROL_OFFSET)){
        isDead = YES;
    }
    
    if(isDead){
        //kill jousterB
        jouster.isDead = YES;
        [gameLayer deathEffect:jouster];
        [jouster removeFromParentAndCleanup:YES];
        [jouster update:0.001];
        [gameLayer.uiLayer refreshUI];
    }
}

@end
