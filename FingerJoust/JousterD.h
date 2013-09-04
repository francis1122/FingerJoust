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

@interface JousterD : Jouster {
    CGPoint joustVelocity;
}

-(void) checkJoustBoundaries;

@end
