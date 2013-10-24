//
//  HurricaneEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/23/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"

@interface HurricaneEvent : HazardEvent{
    
}

@property (nonatomic, retain) NSMutableArray *vortexArray;

-(id) initWithTime:(float) time WithHurricaneAmount:(float) hurricaneAmount GameLayer:(GameLayer*)gLayer;

@end