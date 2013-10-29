//
//  HurricaneEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/23/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HurricaneEvent.h"
#import "Vortex.h"
#import "GameLayer.h"
#import "Jouster.h"
#import "PlayerManager.h"


@implementation HurricaneEvent

@synthesize vortexArray;

-(id) initWithTime:(float) time WithHurricaneAmount:(float) hurricaneAmount GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];

        CCSprite *warningSign = [CCSprite spriteWithSpriteFrameName:@"HurricanearningSigns"];
        warningSign.opacity = 95;
        warningSign.position = ccp(winSize.width/2, winSize.height/2);
        [gameLayer addChild:warningSign];
        CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1.4/gameSpeed];
        CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
            [warningSign removeFromParentAndCleanup:YES];
        }];
        CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
        [warningSign runAction:seqAnim];
        hurricanesAmount = hurricaneAmount;
        self.vortexArray = [NSMutableArray array];
        timeSpan = time;

    }
    return self;
}

-(void) dealloc{
    [vortexArray release];
    [super dealloc];
}


-(void) update:(ccTime) dt{
    [super update:dt];
    
    if(!isWarningDone){
        if(elapsedTime > 1.4){
            isWarningDone = YES;
            for(int i = 0; i < hurricanesAmount; i++){
                [self createVortex];
            }
        }
    }
    

    //take care of vortex affecting the jousters body
    for(Vortex *vortex in self.vortexArray){
        [vortex update:dt];
        vortex.position = ccpAdd(vortex.position, ccpMult(vortex.velocity, dt));
        vortex.pEffect.position = vortex.position;
        vortex.pEffect.duration = timeSpan;
        [self checkHurricanBoundaries:vortex];
        for(Jouster *jouster in gameLayer.jousterArray){
            if(!jouster.isDead){
                //distance
                float redDistance = ccpDistance(vortex.position, jouster.position);
                
                //normalized direction to vortex
                CGPoint redToVortex = ccpNormalize(ccpSub(vortex.position, jouster.position));
                
                float maxDistance = VORTEX_DISTANCE;
                float redPullPower = maxDistance - redDistance;
                redPullPower = redPullPower * redPullPower;
                // adjust the strength of the vortex
                redPullPower = redPullPower/70;
                CGPoint redVortexVel = ccpMult(redToVortex, redPullPower);
                
                //add vortex velocity to jouster's velocity
                jouster.outsideVelocity = ccpAdd(jouster.outsideVelocity,ccpMult(redVortexVel, dt));
            }
        }
        [vortex update:dt];
    }
    
    //delete old vortex
    for(int i = 0; i < self.vortexArray.count; i++ ){
        Vortex *vortex = [self.vortexArray objectAtIndex:i];
        if(vortex.timeAlive > timeSpan * 3){
            [vortex.pEffect stopSystem];
            [vortex removeFromParent];
            [self.vortexArray removeObject:vortex];
            i--;
        }
    }
    
    
}

-(void)createVortex{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    Vortex *vortex = [[[Vortex alloc] init] autorelease];
    
    vortex.position = ccp( CONTROL_OFFSET + 100 + arc4random()%((int)(winSize.width - CONTROL_OFFSET * 2 - 200)),150 + arc4random()%((int)(winSize.height - 300)));
    
    float angle = arc4random()%360;
    CGPoint vel = ccp(cos(angle*(M_PI / 180)), sin(angle*(M_PI / 180)));
    vel = ccpMult(vel, 150);
    vortex.velocity = ccpAdd(vortex.velocity, vel);

    
    [gameLayer addChild:vortex z:0];
    [self.vortexArray addObject:vortex];
    vortex.pEffect = [gameLayer vortexEffect:vortex.position];
    
    [self.vortexArray addObject:vortex];
}

-(void) isFinished{
    //delete old vortex
    for(int i = 0; i < [self.vortexArray count]; i++ ){
        Vortex *vortex = [self.vortexArray objectAtIndex:i];
        [vortex.pEffect stopSystem];
        [vortex removeFromParent];
        [self.vortexArray removeObject:vortex];
        i--;
    }
}

-(void) onStart{
    
}



-(void) checkHurricanBoundaries:(Vortex*) bomb{
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
