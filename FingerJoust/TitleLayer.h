//
//  TitleLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TitleLayer : CCLayerColor {
    CCSprite *jousterBoxLeft, *jousterBoxRight;
    
    NSMutableArray *playerSelectArray;
    
}

@property (nonatomic, retain) NSMutableArray *playerSelectArray;

-(void) setWinner:(NSString*) winner;

-(void) animateOut;
@end
