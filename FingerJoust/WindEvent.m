//
//  WindEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "WindEvent.h"
#import "GameLayer.h"
#import "HazardEvent.h"
#import "Jouster.h"
#import "PlayerManager.h"
#import "SimpleAudioEngine.h"

@implementation WindEvent

-(id) initWithTime:(float) time WithForce:(float) force GameLayer:(GameLayer*)gLayer{
    if(self = [super initWithGameLayer:gLayer]){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        
        PlayerManager *PM = [PlayerManager sharedInstance];
        float gameSpeed = [PM getGameSpeedScaler];
        
        CCSprite *warningSign = [CCSprite spriteWithSpriteFrameName:@"windWarningSigns"];
        warningSign.opacity = 95;
        warningSign.position = ccp(winSize.width/2, winSize.height/2);
        [gameLayer addChild:warningSign];
        CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1.4/gameSpeed];
        CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
            [warningSign removeFromParentAndCleanup:YES];
        }];
        CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
        [warningSign runAction:seqAnim];
        
        
        timeSpan = time;
        windForce = force;
        SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
        soundID = [SAE playEffect:@"cold_snowy_blizzard.mp3" pitch:1.0 pan:0.0 gain:.3];

    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}

-(void) update:(ccTime) dt{
    [super update:dt];
    if(warningDone){
        for(Jouster *jouster in gameLayer.jousterArray){
            CGPoint vel = ccp(cos(angle*(M_PI / 180)), sin(angle*(M_PI / 180)));
            vel = ccpMult(vel, windForce);
            jouster.outsideVelocity = ccpAdd(jouster.outsideVelocity, vel);
        }
    }else{
        if(elapsedTime > 1.4){
            CGSize winSize= [[CCDirector sharedDirector] winSize];
            warningDone = YES;
            windEffect = [[[CCParticleSystemQuad alloc] initWithFile: @"WindEffect.plist"] autorelease];
            //setup stats based on 4 different positions
            windEffect.position = ccp(winSize.width/2, winSize.height/2);;
            windEffect.sourcePosition = ccp(0,0);
            windEffect.posVar = ccp(winSize.width/2, winSize.height/2);
            angle = arc4random()%360;
            windEffect.angle = angle;
            
            [gameLayer.hazardLayer addChild:windEffect];
        }
    }
    
}


-(void) isFinished{
    [windEffect stopSystem];
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE stopEffect:soundID];
}

-(void) onStart{
    
}

@end
