//
//  IntroLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright Hunter Francis 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameLayer.h"
#import "TitleLayer.h"
#import "JousterF.h"
#import "Player.h"
#import "PlayerManager.h"
#import "CCWarpSprite.h"
#import "Jouster.h"
#import "MathHelper.h"
#import "CCShake.h"
#import "SimpleAudioEngine.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

@synthesize jousterArray;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



//
-(id) init
{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.touchEnabled = YES;
        // create and initialize a Label
        ballLabel = [CCLabelTTF labelWithString:@"Battle" fontName:MAIN_FONT fontSize:128];
        busterLabel = [CCLabelTTF labelWithString:@"Balls" fontName:MAIN_FONT fontSize:128];
        tapToPlayLabel = [CCLabelTTF labelWithString:@"Tap to Play" fontName:MAIN_FONT fontSize:32];
        tapToPlayLabel.position =ccp( winSize.width/2, winSize.height/2 - 300);
        tapToPlayLabel.visible = NO;
        [self addChild:tapToPlayLabel z:10];
        [self addChild:ballLabel z:10];
        [self addChild:busterLabel z:10];
        
        [self scheduleUpdate];
        whiteFlash = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        whiteFlash.opacity = 0;
        [self addChild:whiteFlash];
        [self introAnimation];
        self.jousterArray = [NSMutableArray array];
        for(int i = 0; i < 4; i++){
            Player *player = [[[PlayerManager sharedInstance] playerArray] objectAtIndex:i];
            Jouster *jouster =  [[[JousterF alloc] initWithPlayer:player] autorelease];
            [jouster resetJouster];
            [self.jousterArray addObject:jouster];
            [self addChild:jouster z:1];
            jouster.velocity = ccp(arc4random()%10,arc4random()%10);
            jouster.position = ccp(200 + 150 * i, 200);
        }
	}
	return self;
}

-(void) dealloc{
    [jousterArray release];
    [super dealloc];
}

-(void) introAnimation{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    introAnimation = YES;
    ballLabel.position = ccp(winSize.width/2, winSize.height + 300);
    busterLabel.position = ccp( winSize.width/2, -300);
    
    CCActionInterval *topMove = [CCMoveTo actionWithDuration:1 position:ccp(ballLabel.position.x, winSize.height/2 + 30)];
    CCActionInterval *bottomMove = [CCMoveTo actionWithDuration:1 position:ccp(busterLabel.position.x, winSize.height/2 - 30)];
    
    CCEaseIn *topEase = [CCEaseIn actionWithAction:topMove rate:2];
    CCEaseIn *bottomEase = [CCEaseIn actionWithAction:bottomMove rate:2];
    
    CCActionInterval *topMoveBack = [CCMoveTo actionWithDuration:.15 position:ccp(ballLabel.position.x, winSize.height/2 + 55)];
    CCActionInterval *bottomMoveBack = [CCMoveTo actionWithDuration:.15 position:ccp(busterLabel.position.x, winSize.height/2 - 55)];
    
    CCEaseOut *topEaseBack = [CCEaseOut actionWithAction:topMoveBack rate:2];
    CCEaseOut *bottomEaseBack = [CCEaseOut actionWithAction:bottomMoveBack rate:2];
    
    CCSequence *topSeq = [CCSequence actionOne:topEase two:topEaseBack];
    CCSequence *bottomSeq = [CCSequence actionOne:bottomEase two:bottomEaseBack];
    
    [ballLabel runAction:topSeq];
    [busterLabel runAction:bottomSeq];
    
    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1];
    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
        //white flash
        introAnimation = NO;
        tapToPlayLabel.visible = YES;
        whiteFlash.opacity = 255;
        CCFadeOut *fadeout = [CCFadeOut actionWithDuration:.4];
        [whiteFlash runAction:fadeout];
        SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
        [SAE playEffect:@"wood_hit_metal_heavy_1.mp3" pitch:1.4 pan:0.0 gain:0.8];
    }];
    CCSequence *delay = [CCSequence actionOne:delayAnim two:blockAnim];
    [self runAction:delay];
    
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE setBackgroundMusicVolume:.4];
    [SAE playBackgroundMusic:@"get_off.mp3" loop:YES];
}

-(void) skipIntro{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE playEffect:@"wood_hit_metal_heavy_1.mp3" pitch:1.0 pan:0.0 gain:0.3];
    introAnimation = NO;
    [self stopAllActions];
    [ballLabel stopAllActions];
    [busterLabel stopAllActions];
    ballLabel.position = ccp(ballLabel.position.x, winSize.height/2 + 70);
    busterLabel.position = ccp(busterLabel.position.x, winSize.height/2 - 70);
    
    tapToPlayLabel.visible = YES;
    whiteFlash.opacity = 255;
    CCFadeOut *fadeout = [CCFadeOut actionWithDuration:.4];
    [whiteFlash runAction:fadeout];
    
    tapToPlayLabel.visible = YES;
}


#pragma mark - touch code
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(introAnimation){
        [self skipIntro];
    }else{
        SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
        [SAE stopBackgroundMusic];
        [SAE playEffect:BUTTON_CLICK pitch:0.8 pan:0.0 gain:.6];
        [[CCDirector sharedDirector] replaceScene: [TitleLayer node]];
    }
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(introAnimation){
        [self skipIntro];
    }else{
        [[CCDirector sharedDirector] replaceScene: [TitleLayer node]];
    }
}

-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:0];
}


-(void) update:(ccTime)dt{
    
    
    //make guys velocity constant
    for(Jouster *jouster in self.jousterArray){
        //normalize
        CGPoint norm = ccpNormalize(jouster.velocity);
        //then multiply
        jouster.velocity = ccpMult(norm, 500);
    }
    
    
    for (int i = 0; i < COLLISION_STEPS; i++) {
        //step body position
        for(Jouster *jousterA in self.jousterArray){
            jousterA.position = ccpAdd(jousterA.position, ccpMult(jousterA.velocity, dt/COLLISION_STEPS));
            
            //check boundaries
            [self checkBoundaries:jousterA];
            
            for(Jouster *jousterB in self.jousterArray){
                if(jousterB.player.playerNumber != jousterA.player.playerNumber && !jousterB.isDead){
                    if( [MathHelper circleCollisionPositionA:jousterA.position raidusA:jousterA.bodyRadius positionB:jousterB.position radiusB:jousterB.bodyRadius]){
                        //do weird math
                        
                        
                        //get normalized vector pointing at enemy
                        CGPoint redToBlue = ccpNormalize(ccpSub(jousterA.position, jousterB.position));
                        CGPoint blueToRed = ccpMult(redToBlue, -1);
                        
                        //multiply normalized vector by bodies velocity
                        CGPoint redRelativeVelocity = ccp(redToBlue.x * jousterA.velocity.x, redToBlue.y * jousterA.velocity.y);
                        CGPoint blueRelativeVelocity = ccp(blueToRed.x * jousterB.velocity.x, blueToRed.y * jousterB.velocity.y);
                        
                        //check if magnitude of that number is high enough to cause stun damage
                        float redMagnitude = ccpLength(redRelativeVelocity);
                        float blueMagnitude = ccpLength(blueRelativeVelocity);
                        
                        //bounce off eachother
                        //get direction
                        CGPoint offset = ccpSub(jousterA.position, jousterB.position);
                        offset = [MathHelper normalize:offset];
                        offset = ccpMult(offset, 1.2);
                        CGPoint redKnock = ccpMult(offset, blueMagnitude + 30);
                        jousterA.velocity = ccpAdd(jousterA.velocity, redKnock);
                        offset = ccpMult(offset, -1);
                        CGPoint blueKnock = ccpMult(offset, redMagnitude + 30);
                        jousterB.velocity = ccpAdd(jousterB.velocity, blueKnock);
                        
                        [self clashEffect:jousterA.position otherPoint:jousterB.position withMagnitude:blueMagnitude + redMagnitude + 500 withStun:NO];
                        
                    }
                }
            }
        }
        
        
    }
}


-(void) checkBoundaries:(Jouster*) jouster{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    
    CGPoint pos = jouster.position;
    float radius = jouster.bodyRadius;
    
    //check north side
    if((pos.y + radius) > winSize.height){
        jouster.position = ccp(jouster.position.x, winSize.height - radius);
        jouster.velocity = ccp(jouster.velocity.x, jouster.velocity.y * -1);
        
        [self clashEffect:ccp(pos.x, winSize.height - 1) otherPoint:ccp(pos.x, winSize.height) withMagnitude:250 withStun:NO];
    }
    
    //check south side
    if( (pos.y - radius) < 0 ){
        jouster.position = ccp(jouster.position.x, radius);
        jouster.velocity = ccp(jouster.velocity.x, jouster.velocity.y * -1);
        
        [self clashEffect:ccp(pos.x, - 1) otherPoint:ccp(pos.x, 0) withMagnitude:250 withStun:NO];
    }
    
    //left side
    if((pos.x - radius) < 0){
        jouster.position = ccp(radius + 20, jouster.position.y);
        jouster.velocity = ccp(jouster.velocity.x * -1, jouster.velocity.y);
        
        [self clashEffect:ccp(0, pos.y) otherPoint:ccp(-1, pos.y) withMagnitude:250 withStun:NO];
    }
    
    
    //right side
    if((pos.x + radius) >  (winSize.width)){
        jouster.position = ccp(winSize.width- radius - 20, jouster.position.y);
        jouster.velocity = ccp(jouster.velocity.x * -1, jouster.velocity.y);
        
        [self clashEffect:ccp(winSize.width, pos.y) otherPoint:ccp(winSize.width - 1, pos.y) withMagnitude:250 withStun:NO];
    }
}


-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2 withMagnitude:(float) magnitude withStun:(BOOL) stun{
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    float soundVariety = .3 + .3/(3+arc4random()%4);
    [SAE playEffect:@"wood_hit_brick_1.mp3" pitch:soundVariety pan:0.0 gain:.3];
    ccColor4F effectColor = ccc4f(1, 1, 1, 1);
    if(stun){
        effectColor = ccc4f(0.0, 0.0, 0, 1);
    }
    //how fast the particles move
    float particleSpeed = magnitude/2;
    
    //collision effect
    CCParticleSystemQuad *collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.startColor = effectColor;
    collisionEffect.endColor = effectColor;
    collisionEffect.speed = particleSpeed;
    collisionEffect.autoRemoveOnFinish = YES;
    CGPoint midPoint = ccpMidpoint(p1, p2);
    float rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation - 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
    
    collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    collisionEffect.startColor = effectColor;
    collisionEffect.endColor = effectColor;
    collisionEffect.speed = particleSpeed;
    midPoint = ccpMidpoint(p1, p2);
    rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation + 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
    [self runAction:[CCShake actionWithDuration:.12f amplitude:ccp(4, 4) dampening:true shakes:0]];
}

@end

