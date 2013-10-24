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

@implementation SpikeEdgeEvent

@synthesize spikeArray;

-(id) initWithTime:(float) time GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        timeSpan = time;
        self.spikeArray = [NSMutableArray array];
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        
        
        CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:0.8];
        CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
            //spawn walls
            float durationMove = .4;
            CCSprite *topSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            topSpike.rotation = -90;
            topSpike.position = ccp(winSize.width/2, winSize.height-30);
            CCMoveTo *topMove = [CCMoveTo actionWithDuration:durationMove position:ccp(winSize.width/2, winSize.height-70)];
            [topSpike runAction:topMove];
            [gameLayer.hazardLayer addChild:topSpike];
            [self.spikeArray addObject:topSpike];
            
            
            CCSprite *bottomSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            bottomSpike.rotation = 90;
            bottomSpike.position = ccp(winSize.width/2, 30);
            CCMoveTo *bottomMove = [CCMoveTo actionWithDuration:durationMove position:ccp(winSize.width/2, 70)];
            [bottomSpike runAction:bottomMove];
            [gameLayer.hazardLayer addChild:bottomSpike];
            [self.spikeArray addObject:bottomSpike];
            
            CCSprite *rightSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            rightSpike.position = ccp(winSize.width - CONTROL_OFFSET + 20, winSize.height/2);
            CCMoveTo *rightMove = [CCMoveTo actionWithDuration:durationMove position:ccp(winSize.width - CONTROL_OFFSET - 20, winSize.height/2)];
            [rightSpike runAction:rightMove];
            [gameLayer.hazardLayer addChild:rightSpike];
            [self.spikeArray addObject:rightSpike];
            
            CCSprite *leftSpike = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];
            leftSpike.rotation = 180;
            leftSpike.position = ccp(CONTROL_OFFSET - 20, winSize.height/2);
            CCMoveTo *leftMove = [CCMoveTo actionWithDuration:durationMove position:ccp(CONTROL_OFFSET + 20, winSize.height/2)];
            [leftSpike runAction:leftMove];
            [gameLayer.hazardLayer addChild:leftSpike];
            [self.spikeArray addObject:leftSpike];
            
            
            
            
        }];
        CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
        [gameLayer runAction:seqAnim];
        
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}


-(void) update:(ccTime) dt{
    [super update:dt];
    if(elapsedTime > 1.2){
        for(Jouster* jouster in gameLayer.jousterArray){
            if(!jouster.isDead){
                [self checkSpikeBoundaries:jouster];
            }
        }
    }
}

-(void) isFinished{
    for(int i =0; i < [self.spikeArray count]; i++){
        CCSprite *spike = [self.spikeArray objectAtIndex:i];
        [spike removeFromParentAndCleanup:YES];
        [self.spikeArray removeObject:spike];
        i--;
    }
}

-(void) onStart{
    
}



-(void) checkSpikeBoundaries:(Jouster*) jouster{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint pos = jouster.position;
    float radius = 60;
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
