//
//  MissleEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "MissileEvent.h"
#import "MissileSprite.h"
#import "GameLayer.h"
#import "HazardLayer.h"
#import "UILayer.h"
#import "Jouster.h"
#import "MathHelper.h"
#import "PlayerManager.h"

@implementation MissileEvent

@synthesize missileArray;


-(id) initWithTime:(float) time MissileAmount:(int) missileAmount GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        timeSpan = time;
        missilesLeft = missileAmount;
        self.missileArray = [NSMutableArray array];
        int rand= arc4random()%3;
        
        
        if(rand== 0){
            for(int i = 0; i <missileAmount; i++){
                [self createMissile];
            }
        }else if(rand ==1){
            for(int i = 0; i <missileAmount; i++){
                [self createMissile];
            }
            CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:2.5];
            CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
                for(int i = 0; i <missileAmount; i++){
                    [self createMissile];
                }
            }];
            CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
            [gameLayer runAction:seqAnim];
        }else{
            CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:2.5];
            CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
                for(int i = 0; i <missileAmount; i++){
                    [self createMissile];
                }
            }];
            CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
            [gameLayer runAction:seqAnim];
        }
        
    }
    return self;
}

-(void) dealloc{
    [missileArray release];
    [super dealloc];
}

-(void) createMissile{
    MissileSprite *missile = [[[MissileSprite alloc] init] autorelease];
    missile.color = ccBLACK;
    
    [gameLayer.hazardLayer addChild:missile];
    [missileArray addObject:missile];
    [missile resolve];
    
    missilesLeft--;
}


-(void) update:(ccTime) dt{
    [super update:dt];
    [self checkCollisions];
    for(int i = 0; i < self.missileArray.count; i++){
        MissileSprite *missile = [self.missileArray objectAtIndex:i];
        [missile update:dt];
        if(missile.isDone){
            [missile removeFromParentAndCleanup:YES];
            [self.missileArray removeObject:missile];
            i--;
        }
    }
}

-(void) checkCollisions{
    for(MissileSprite *missile in self.missileArray){
        for(Jouster *jouster in gameLayer.jousterArray){
            if(!jouster.isDead && !missile.isDone){
                if( [MathHelper circleCollisionPositionA:jouster.position raidusA:jouster.bodyRadius positionB:missile.position radiusB:20]){
                    //missile hit the thing
                    missile.isDone = YES;
                    jouster.isDead = YES;
                    [gameLayer deathEffect:jouster];
                    [jouster removeFromParentAndCleanup:YES];
                    [jouster update:0.001];
                    [gameLayer.uiLayer refreshUI];
                    
                }
                
                
                if( [MathHelper circleCollisionPositionA:[jouster getWorldPositionOfJoust]  raidusA:[jouster joustRadius] positionB:missile.position radiusB: 20]){
                    //bounce off eachother
                    [jouster joustCollision: missile.position withRadius: 20];
                    [gameLayer clashEffect:[jouster getWorldPositionOfJoust] otherPoint:missile.position withMagnitude:500 withStun:NO];
                    missile.isDone = YES;
                    
                }
            }
        }
    }
}

-(void) isFinished{
    for(int i = 0; i < self.missileArray.count; i++){
        MissileSprite *missile = [self.missileArray objectAtIndex:i];
        [missile removeFromParentAndCleanup:YES];
        [self.missileArray removeObject:missile];
        i--;
    }
}

-(void) onStart{
    
}




@end
