//
//  JousterD.h
//  FingerJoust
//
//  Created by Hunter Francis on 8/19/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Jouster.h"


#define JOUSTER_JOUSTER_D_SPEED 550

@interface JousterD : Jouster {
}

-(void) checkJoustBoundaries;

@end
