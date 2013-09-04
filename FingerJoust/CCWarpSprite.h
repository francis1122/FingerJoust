//
//  CCWarpSprite.h
//  ZooChase
//
//  Created by Hunter Francis on 6/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCWarpSprite : CCSprite {
    BOOL isWarping;
    float lifeTime;
    float springConst;
    
    CGPoint tl_Offset;
    CGPoint bl_Offset;
    CGPoint tr_Offset;
    CGPoint br_Offset;
    

    
}

@property (assign) CGPoint velocity;
@property (assign) BOOL isWarping;
@property (assign) float springConst;
@property (assign)float lifeTime;

-(id)initWithSpriteFrameName:(NSString*)spriteFrameName;

@end
