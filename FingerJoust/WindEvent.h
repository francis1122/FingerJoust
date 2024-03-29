//
//  WindEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"
#import "SimpleAudioEngine.h"

@interface WindEvent : HazardEvent{
    float windForce;
    CCParticleSystemQuad *windEffect;
    float angle;
    BOOL warningDone;
    ALuint soundID;
}


-(id) initWithTime:(float) time WithForce:(float) force GameLayer:(GameLayer*)gLayer;

@end
