//
//  HazardEvent.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "HazardEvent.h"

@implementation HazardEvent

@synthesize isDone;


-(id) initWithGameLayer:(GameLayer *)gLayer{
    if(self = [super init]){
        gameLayer = gLayer;
        
        
    }
    return self;
}


-(void) update:(ccTime) dt{
    elapsedTime +=dt;
    if(elapsedTime > timeSpan){
        isDone = YES;
    }
}

-(void) isFinished{
    
    
}

-(void) onStart{
    
}


@end
