//
//  BombSprite.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BombSprite : CCSprite {
    CCLabelTTF *countDown;
    CCSprite *bomb;
    CCSprite *blastRadius;
    
    int displayTime;
    float count;
    CGPoint velocity;
}


@property CGPoint velocity;
@property BOOL isExploding;

@end
