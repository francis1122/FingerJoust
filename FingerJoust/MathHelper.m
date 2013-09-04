//
//  MathHelper.m
//  FingerJoust
//
//  Created by Hunter Francis on 8/24/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "MathHelper.h"
#import "cocos2d.h"

@implementation MathHelper


/*
-(BOOL) circleCollisionDetectionJoust:(Jouster *)A AndJoust:(Jouster *)B{
    float aRadius = A.joustRadius;
    float bRadius = B.joustRadius;
    float distanceToMakeCollision = aRadius + bRadius;
    
    
    CGPoint joustPosition = ccp(A.position.x + A.joustPosition.x, A.position.y + A.joustPosition.y);
    CGPoint bodyPosition = ccp(B.position.x + B.joustPosition.x, B.position.y + B.joustPosition.y);
    double distanceBetweenObjects = sqrt(((joustPosition.x - bodyPosition.x) * (joustPosition.x - bodyPosition.x)) +
                                         ((joustPosition.y - bodyPosition.y) * (joustPosition.y - bodyPosition.y)));
    
    if(distanceBetweenObjects < distanceToMakeCollision){
        return YES;
    }
    
    return NO;
}

-(BOOL) circleCollisionDetectionJousting:(Jouster *)A AndBody:(Jouster *)B{
    float aRadius = A.joustRadius;
    float bRadius = B.bodyRadius;
    float distanceToMakeCollision = aRadius + bRadius;
    
    
    CGPoint joustPosition = ccp(A.position.x + A.joustPosition.x, A.position.y + A.joustPosition.y);
    CGPoint bodyPosition = B.position;
    double distanceBetweenObjects = sqrt(((joustPosition.x - bodyPosition.x) * (joustPosition.x - bodyPosition.x)) +
                                         ((joustPosition.y - bodyPosition.y) * (joustPosition.y - bodyPosition.y)));
    
    if(distanceBetweenObjects < distanceToMakeCollision){
        return YES;
    }
    
    return NO;
}
*/

+ (CGPoint)normalize:(CGPoint)vector {
	float magnitude = sqrt(pow(vector.x,2) + pow(vector.y,2));
	if( magnitude == 0){ return CGPointMake( 0.0, 0.0);}
	return CGPointMake(vector.x / (magnitude), vector.y / (magnitude));
}

+(float) degreeAngleBetween:(CGPoint) p1 and:(CGPoint) p2{
    float rad = [MathHelper radAngleBetween:p1 and:p2];
    return CC_RADIANS_TO_DEGREES(rad);
}

+ (float)radAngleBetween:(CGPoint)p1 and:(CGPoint)p2 {
	return atan2((p1.y - p2.y), (p1.x-p2.x));
}

+(BOOL) circleCollisionPositionA:(CGPoint) positionA raidusA:(float) radiusA positionB:(CGPoint) positionB radiusB:(float ) radiusB
{

    float distanceToMakeCollision = radiusA + radiusB;
    
    double distanceBetweenObjects = sqrt(((positionA.x - positionB.x) * (positionA.x - positionB.x)) +
                                         ((positionA.y - positionB.y) * (positionA.y - positionB.y)));
    
    if(distanceBetweenObjects < distanceToMakeCollision){
        return YES;
    }
    
    return NO;
    
}





@end
