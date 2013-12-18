//
//  IntroLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright Hunter Francis 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@class Jouster;
@interface IntroLayer : CCLayerColor
{
    
    BOOL introAnimation;
    CCLabelTTF *ballLabel, *busterLabel, *tapToPlayLabel;
    CCLayerColor *whiteFlash;
    NSMutableArray *jousterArray;
}

@property (nonatomic, retain) NSMutableArray *jousterArray;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) checkBoundaries:(Jouster*) jouster;

@end
