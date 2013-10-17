//
//  PlayerSelect.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/17/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player;
@interface PlayerSelect : CCLayerColor {
    CCSprite *isActiveSprite;
}

@property (nonatomic, assign) Player *player;

-(id) initWithPlayer:(Player *)p;

@end
