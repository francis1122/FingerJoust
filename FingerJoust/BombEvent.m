//
//  BombEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "BombEvent.h"
#import "GameLayer.h"
#import "Jouster.h"
#import "BombSprite.h"
#import "MathHelper.h"
#import "HazardLayer.h"

@implementation BombEvent

@synthesize bombArray;

-(id) initWithTime:(float) time WithBombAmount:(float) bombAmount GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        timeSpan = time;
        self.bombArray = [NSMutableArray array];
        
        //add bomb stuff
        for(int i = 0; i < bombAmount; i++){
            BombSprite *bombSprite = [[[BombSprite alloc] init] autorelease];
            [gameLayer.hazardLayer addChild:bombSprite];
            [self.bombArray addObject:bombSprite];
        }
    }
    return self;
}

-(void) dealloc{
    [bombArray release];
    [super dealloc];
}


-(void) update:(ccTime) dt{
    [super update:dt];
    
    for(int i = 0; i < self.bombArray.count; i++){
        //update bomb
        BombSprite *bomb = [self.bombArray objectAtIndex:i];
        [bomb update:dt];
        [self checkBombBoundaries:bomb];
        for(Jouster *jouster in gameLayer.jousterArray){
                //collisions tuff
                if( [MathHelper circleCollisionPositionA:jouster.position raidusA:jouster.bodyRadius positionB:bomb.position radiusB:20]){
                    
                    //
                    
                    //get normalized vector pointing at enemy
                    CGPoint jousterToBomb = ccpNormalize(ccpSub(jouster.position, bomb.position));
                    CGPoint bombToJouster = ccpMult(jousterToBomb, -1);
                    
                    //multiply normalized vector by bodies velocity
                    CGPoint jousterRelativeVelocity = ccp(jousterToBomb.x * jouster.velocity.x, jousterToBomb.y * jouster.velocity.y);
                    CGPoint bombRelativeVelocity = ccp(bombToJouster.x * bomb.velocity.x, bombToJouster.y * bomb.velocity.y);
                    
                    //check if magnitude of that number is high enough to cause stun damage
                    float jousterMagnitude = ccpLength(jousterRelativeVelocity);
                    float bombMagnitude = ccpLength(bombRelativeVelocity);
                    
                    
                    
                    //missile hit the thing
                    CGPoint offset = ccpSub(bomb.position, jouster.position);
                    offset = [MathHelper normalize:offset];
                    CGPoint bombKnock = ccpMult(offset, jousterMagnitude + 400);
                    bomb.velocity = bombKnock;
                    CGPoint jouserKnock = ccpMult(offset, -(bombMagnitude + 300));
                    jouster.velocity = jouserKnock;
                    
                    
                }
            
                if( [MathHelper circleCollisionPositionA:[jouster getWorldPositionOfJoust]  raidusA:[jouster joustRadius] positionB:bomb.position radiusB: 20]){
                    //bounce off eachother
                    [jouster joustCollision:bomb.position withRadius:20];
                    
                    CGPoint offset = ccpSub(bomb.position, [jouster getWorldPositionOfJoust]);
                    offset = [MathHelper normalize:offset];
                    CGPoint redKnock = ccpMult(offset, 700);
                    bomb.velocity = redKnock;

                }
        }
        
        if(bomb.isExploding){
            
            //leave explosion thing for a few seconds
            CCSprite *explosion = [CCSprite spriteWithSpriteFrameName:@"explosion"];
            explosion.position = bomb.position;
            explosion.scale = 1.5;
            [gameLayer.hazardLayer addChild:explosion];
            CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:0.2];
            CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
                [explosion removeFromParentAndCleanup:YES];
            }];
            CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
            [explosion runAction:seqAnim];

            
            //kill things in blast radius
            for(Jouster *jouster in gameLayer.jousterArray){
                if( [MathHelper circleCollisionPositionA:jouster.position raidusA:jouster.bodyRadius positionB:bomb.position radiusB:130]){
                    //missile hit the thing
                    jouster.isDead = YES;
                    [gameLayer deathEffect:jouster];
                    [jouster removeFromParentAndCleanup:YES];
                    [jouster update:0.001];
                    [gameLayer.uiLayer refreshUI];
                    
                    
                    
                }
            }
            [self.bombArray removeObject:bomb];
            [bomb removeFromParentAndCleanup:YES];
            i--;
        }
    }
}


-(void) isFinished{
    for(int i = 0; i < self.bombArray.count; i++){
        //update bomb
        BombSprite *bomb = [self.bombArray objectAtIndex:i];
            [self.bombArray removeObject:bomb];
            [bomb removeFromParentAndCleanup:YES];
            i--;
    }
}

-(void) onStart{
    
}

-(void) checkBombBoundaries:(BombSprite*) bomb{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint pos = bomb.position;
    float radius = 30;
    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        bomb.position = ccp(pos.x, winSize.height - radius - MIDDLEBAR_HEIGHT);
        bomb.velocity = ccp(bomb.velocity.x, bomb.velocity.y * -1);
        [gameLayer clashEffect:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT) withMagnitude:500 withStun:NO];
    }
    
    //check south side
    if( (pos.y - radius) < MIDDLEBAR_HEIGHT ){
        bomb.position  = ccp(pos.x, MIDDLEBAR_HEIGHT + radius);
        bomb.velocity = ccp(bomb.velocity.x, bomb.velocity.y * -1);
        [gameLayer clashEffect:ccp(pos.x, MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, MIDDLEBAR_HEIGHT) withMagnitude:500 withStun:NO];
    }
    
    //left side
    if((pos.x - radius) < CONTROL_OFFSET){
        bomb.position = ccp(CONTROL_OFFSET + radius, pos.y);
        bomb.velocity = ccp(bomb.velocity.x *  -1, bomb.velocity.y);
        [gameLayer clashEffect:ccp(CONTROL_OFFSET, pos.y) otherPoint:ccp(CONTROL_OFFSET - 1, pos.y) withMagnitude:500 withStun:NO];
    }
    
    //right side
    if((pos.x + radius) >  (winSize.width - CONTROL_OFFSET)){
        bomb.position = ccp(winSize.width - CONTROL_OFFSET - radius, pos.y);
        bomb.velocity = ccp(bomb.velocity.x * -1, bomb.velocity.y);
        [gameLayer clashEffect:ccp(winSize.width - CONTROL_OFFSET, pos.y) otherPoint:ccp(winSize.width - CONTROL_OFFSET - 1, pos.y) withMagnitude:500 withStun:NO];
    }
    
}


@end
