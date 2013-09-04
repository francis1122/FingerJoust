//
//  MathHelper.h
//  FingerJoust
//
//  Created by Hunter Francis on 8/24/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathHelper : NSObject



+ (CGPoint)normalize:(CGPoint)vector;

+(float) degreeAngleBetween:(CGPoint) p1 and:(CGPoint) p2;
+ (float)radAngleBetween:(CGPoint)p1 and:(CGPoint)p2;

+(BOOL) circleCollisionPositionA:(CGPoint) positionA raidusA:(float) radiusA positionB:(CGPoint) positionB radiusB:(float ) radiusB;

@end
