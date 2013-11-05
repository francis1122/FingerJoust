//
//  AboutPanel.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/28/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class TitleLayer;
@interface AboutPanel : CCLayerColor {
    CCMenuItemFont *menuToggle;
    TitleLayer *titleLayer;
    BOOL isActive;    
}
@property (nonatomic, assign) TitleLayer *titleLayer;
@property BOOL isActive;

-(void) resolve;

@end
