//
//  PowerStone.h
//  FingerJoust
//
//  Created by Hunter Francis on 8/31/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PowerStone : CCSprite {
    float bodyRadius;
    float timeAlive;
}
@property float bodyRadius;
@property float timeAlive;

-(void) randomSpot;
@end
