//
//  IntroLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright Hunter Francis 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "GameLayer.h"
#import "TitleLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

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
            ballLabel = [CCLabelTTF labelWithString:@"Ball" fontName:@"Marker Felt" fontSize:128];
            busterLabel = [CCLabelTTF labelWithString:@"Buster" fontName:@"Marker Felt" fontSize:128];
            tapToPlayLabel = [CCLabelTTF labelWithString:@"Tap to Play" fontName:@"Marker Felt" fontSize:32];
            tapToPlayLabel.position =ccp( winSize.width/2, winSize.height/2 - 300);
            tapToPlayLabel.visible = NO;
            [self addChild:tapToPlayLabel];
            [self addChild:ballLabel];
            [self addChild:busterLabel];
            
            
            whiteFlash = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
            whiteFlash.opacity = 0;
            [self addChild:whiteFlash];
            
            [self introAnimation];
	}
	return self;
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
    
    CCActionInterval *topMoveBack = [CCMoveTo actionWithDuration:.15 position:ccp(ballLabel.position.x, winSize.height/2 + 70)];
    CCActionInterval *bottomMoveBack = [CCMoveTo actionWithDuration:.15 position:ccp(busterLabel.position.x, winSize.height/2 - 70)];
    
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
    }];
    CCSequence *delay = [CCSequence actionOne:delayAnim two:blockAnim];
    [self runAction:delay];
}

-(void) skipIntro{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
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

@end
