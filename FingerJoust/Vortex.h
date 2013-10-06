//
//  Vortex.h
//  FingerJoust
//
//  Created by Hunter Francis on 9/4/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Vortex : CCSprite {
    
}

@property float bodyRadius;
@property float timeAlive;
@property (nonatomic, assign) CCParticleSystemQuad* pEffect;

@end
