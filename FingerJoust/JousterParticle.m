//
//  JousterParticle.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/20/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "JousterParticle.h"


@implementation JousterParticle


-(void) resetSystem
{
	_active = YES;
	_elapsed = 0;
    /*	for(_particleIdx = 0; _particleIdx < _particleCount; ++_particleIdx) {
     tCCParticle *p = &_particles[_particleIdx];
     p->timeToLive = 0;
     }
     */
}

@end
