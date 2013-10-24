//
//  HazardEvent.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/22/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;
@interface HazardEvent : NSObject{
    float elapsedTime;
    float timeSpan;
    GameLayer *gameLayer;
}
@property BOOL isDone;

-(id)initWithGameLayer:(GameLayer*)gLayer;
-(void) update:(ccTime) dt;
-(void) isFinished;
-(void) onStart;


@end
