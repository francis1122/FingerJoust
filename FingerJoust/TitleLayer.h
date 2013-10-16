//
//  TitleLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TitleLayer : CCLayerColor {
    int playerOneChoice, playerTwoChoice;
    CCSprite *jousterBoxLeft, *jousterBoxRight;
    
}
-(void) setWinner:(NSString*) winner;
@end
