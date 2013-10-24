//
//  MissileSprite.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MissileSprite : CCSprite {
    CGPoint velocity;
    CCSprite *warningSprite;
    int ticka;
}

@property BOOL isDone;

-(void)resolve;
-(void) update:(ccTime)dt;
-(void) checkBoundaries;

@end
